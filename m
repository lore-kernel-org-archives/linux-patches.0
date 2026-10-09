Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9BD4DA9AF;
	Fri,  9 Oct 2026 14:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555751; cv=none; b=jB33a/dNSVXQqvmOze6XE5ROUm6SNhstiQJdJ12Arawtd+YP3MbwQtXL6MJQdim1lZUpMfl2QL3K+46JAwDSXm1cKKe7MTD+ZeX3TJXOt636T5QYT64NhmV4UfwNF9yrHvG9sK4FYBny52F2d2friGX1IAHJPLej/lVDtKCn4yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555751; c=relaxed/simple;
	bh=bia2TJn+M64csfz0KFyKx+LX2U6sCP1Bn6QURbMB23A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dJ8/MxMizFfbLDf6q3o67rNtBYCGVDXiCef1u4+yIoD34PtwbeN+JGpXC1j7SJylXDIKLQ64LoyJCtxY4PxbB//9zELMAB/04k9pIRio/AwvjBkERGBZaaXjhsYifzhxAMws0tyPqTOkwowP3oICbAzreYfTAbOFEP+v2TjaC/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zd1s3zHK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zd1s3zHK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55BBE1F000FF;
	Fri,  9 Oct 2026 14:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555749;
	bh=dfMgwfCj7ll5XIK3k2b0LqUZRdSxrUpBXaoXKHjkrKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zd1s3zHKqk+8G39cbH8IiWI1Q7I9yKmbjqB8Icyise9XZEQy82/7AkP2wOhtvumBF
	 4AFyahf8eBMT8bFQPilKat1PyzGV/GDZSdBSTVLOFVcvyZypDDCyn9S1fxWFXbNFYi
	 s7pVTE2VxJPdtBBfBlwigaXdmFpX2g3cbRyJrPZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgios Karantzas <gck.kara@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 072/403] wifi: ath9k_htc: bound TX aggregation to MAX_TX_BUF_SIZE
Date: Fri,  9 Oct 2026 16:07:13 +0200
Message-ID: <20261009140953.779729639@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Georgios Karantzas <gck.kara@gmail.com>

[ Upstream commit aeaca27c1db3106967ffbb2b517d98c835f6d500 ]

__hif_usb_tx() dequeues up to MAX_TX_AGGR_NUM (20) frames into a
single tx_buf of MAX_TX_BUF_SIZE (32768) bytes, limiting the batch
by record count but never by cumulative byte length.

With large frames (MTU 2304), 20 aggregated frames of 2292 bytes
each exceed the allocation (20 * 2296 = 45920 bytes), so the
memcpy() in the loop writes up to 13152 bytes past tx_buf->buf
before usb_submit_urb().

Peek the queue head and stop before copying any record that would
cross MAX_TX_BUF_SIZE, then dispatch the current batch. Leftover
skbs remain queued and are drained on the next URB completion.

The byte bound changes the loop's exit semantics: it can now exit
before i == tx_skb_cnt - 1. Stock only finalized tx_buf->len on
that last index (len += offset), so an early break would submit a
URB holding only the last record's length while every dequeued skb
is freed on completion, silently dropping frames. Make tx_buf->len
a running total and advance tx_buf->offset per record instead; the
stride round_up(nskb->len + 4, 4) is identical to the stock stride
when the loop runs to completion.

Tested on hardware with an MTU 2304 flood: the loop stops at
record 15 (len = 32144, offset = 32144, within 32768), no
oversized URB is submitted, and MTU 1500 pings pass 20/20.

Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
Signed-off-by: Georgios Karantzas <gck.kara@gmail.com>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Link: https://patch.msgid.link/20260911001143.4507-1-gck.kara@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index c15219257499f..bafa82da24416 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -14,6 +14,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <linux/math.h>
 #include <linux/unaligned.h>
 #include "htc.h"
 
@@ -328,11 +329,14 @@ static int __hif_usb_tx(struct hif_device_usb *hif_dev)
 	tx_skb_cnt = min_t(u16, hif_dev->tx.tx_skb_cnt, MAX_TX_AGGR_NUM);
 
 	for (i = 0; i < tx_skb_cnt; i++) {
-		nskb = __skb_dequeue(&hif_dev->tx.tx_skb_queue);
+		nskb = skb_peek(&hif_dev->tx.tx_skb_queue);
+		if (!nskb)
+			break;
 
-		/* Should never be NULL */
-		BUG_ON(!nskb);
+		if (tx_buf->offset + nskb->len + 4 > MAX_TX_BUF_SIZE)
+			break;
 
+		nskb = __skb_dequeue(&hif_dev->tx.tx_skb_queue);
 		hif_dev->tx.tx_skb_cnt--;
 
 		buf = tx_buf->buf;
@@ -342,13 +346,8 @@ static int __hif_usb_tx(struct hif_device_usb *hif_dev)
 		*hdr++ = cpu_to_le16(ATH_USB_TX_STREAM_MODE_TAG);
 		buf += 4;
 		memcpy(buf, nskb->data, nskb->len);
-		tx_buf->len = nskb->len + 4;
-
-		if (i < (tx_skb_cnt - 1))
-			tx_buf->offset += (((tx_buf->len - 1) / 4) + 1) * 4;
-
-		if (i == (tx_skb_cnt - 1))
-			tx_buf->len += tx_buf->offset;
+		tx_buf->len = tx_buf->offset + nskb->len + 4;
+		tx_buf->offset += round_up(nskb->len + 4, 4);
 
 		__skb_queue_tail(&tx_buf->skb_queue, nskb);
 		TX_STAT_INC(hif_dev, skb_queued);
-- 
2.53.0



