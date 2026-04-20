Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C9E3368B2;
	Mon, 20 Apr 2026 15:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700220; cv=none; b=hv13RK5digjVd1+gBqW9t75+LSAGD5klgwA7m5frNzq/Tqq2G5m5FGlFoojAdsb+VlfVI1RpuyH1j45P1x9RkkxuAvFFjByFe8+rIqCBjBobF7cgFoz6vA8pV9u+QRa6nfrU0rBBSXNVNib2vwDmUE1mkE82X97jcIsiYzyscGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700220; c=relaxed/simple;
	bh=mVC28yFonY9C1Ph3uylMW+p80j0wsn1lgnmwKO5ULo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lyFbbeYyNob7Yn5Y58LzjDPCXXDuxXP2PeO+mit/tBlBRvNgP2YwvRPWtj9IvQoDoh3PmzDahmagt4HENLpzIY/I8vEgA5IZgCqQUH1vs8/BGKaNoyNjw3QemxRqIAhkvojKWqNIBPpiIoGgHqqVf4tqMbETnL+W61MF1e7ypww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hPbgnUpd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hPbgnUpd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF785C19425;
	Mon, 20 Apr 2026 15:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700220;
	bh=mVC28yFonY9C1Ph3uylMW+p80j0wsn1lgnmwKO5ULo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hPbgnUpdHANB78U9xRAo/hizJ0dOqwJD4I5MVy+edAXIALlHimDt6OHF1WklB1flA
	 l2oBpbat0XKebLTPIduJwwxJPVVQeDimRFCtgh02Pj66IphXiM0hAEMhCw+aPycoe3
	 aW/YUXMpxHxBDCUTdtDCragq/KLJ0ENU09Hm3qFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 088/220] nfc: s3fwrn5: allocate rx skb before consuming bytes
Date: Mon, 20 Apr 2026 17:40:29 +0200
Message-ID: <20260420153937.204583665@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 5c14a19d5b1645cce1cb1252833d70b23635b632 ]

s3fwrn82_uart_read() reports the number of accepted bytes to the serdev
core. The current code consumes bytes into recv_skb and may already
deliver a complete frame before allocating a fresh receive buffer.

If that alloc_skb() fails, the callback returns 0 even though it has
already consumed bytes, and it leaves recv_skb as NULL for the next
receive callback. That breaks the receive_buf() accounting contract and
can also lead to a NULL dereference on the next skb_put_u8().

Allocate the receive skb lazily before consuming the next byte instead.
If allocation fails, return the number of bytes already accepted.

Fixes: 3f52c2cb7e3a ("nfc: s3fwrn5: Support a UART interface")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260402042148.65236-1-pengpeng@iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/s3fwrn5/uart.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/s3fwrn5/uart.c b/drivers/nfc/s3fwrn5/uart.c
index 9c09c10c2a464..4ee481bd7e965 100644
--- a/drivers/nfc/s3fwrn5/uart.c
+++ b/drivers/nfc/s3fwrn5/uart.c
@@ -58,6 +58,12 @@ static size_t s3fwrn82_uart_read(struct serdev_device *serdev,
 	size_t i;
 
 	for (i = 0; i < count; i++) {
+		if (!phy->recv_skb) {
+			phy->recv_skb = alloc_skb(NCI_SKB_BUFF_LEN, GFP_KERNEL);
+			if (!phy->recv_skb)
+				return i;
+		}
+
 		skb_put_u8(phy->recv_skb, *data++);
 
 		if (phy->recv_skb->len < S3FWRN82_NCI_HEADER)
@@ -69,9 +75,7 @@ static size_t s3fwrn82_uart_read(struct serdev_device *serdev,
 
 		s3fwrn5_recv_frame(phy->common.ndev, phy->recv_skb,
 				   phy->common.mode);
-		phy->recv_skb = alloc_skb(NCI_SKB_BUFF_LEN, GFP_KERNEL);
-		if (!phy->recv_skb)
-			return 0;
+		phy->recv_skb = NULL;
 	}
 
 	return i;
-- 
2.53.0



