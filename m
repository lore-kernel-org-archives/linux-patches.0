Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6623B6359;
	Sat, 30 May 2026 17:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162670; cv=none; b=VUA94Hq95MIJrHZqNvJ3nOBNIglBM4usMU3jqQNmnKf4KPeZZBJ90Tqid9+raoCinTvLYu9joZbxxAXhpE9JkjPxDOpZOSbzqIHVQ45Ewu0gB3LuwxOYXP+Pq4ahDreY7miZEQSS21oKGpre5O43Qlc3DTt7PxlleT+4n+sKwoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162670; c=relaxed/simple;
	bh=34IOL2aRnUnuxbJZgro7sYnQEImNnmwGLgMjf0UsXsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bdGjVXjj2cJ4I5lTR2B4gxzhUBmg7xgG1HUfDedMKPgVT27tjsFGzJ8iw3QfxJ9rHHSj5f8+g9JcQ7e37MckmeN2qixXdLEj0hbdwtkGW4b9I43Jr2cqJ+5tzYSfovYS03fOqH8qIEiUVshBu+bUd1e4VdrSxlKhCYXHizJECC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yy4LHziw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yy4LHziw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7332A1F00899;
	Sat, 30 May 2026 17:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162669;
	bh=nf4c6WmzOkMi208xUw0XTGjVshRFFdfhIdMEd+biOZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yy4LHziwk7VtkizS3CTf9Y2UokUMyBBqAHh/wPdmDhqGZL7q81hmV/FZxBnKCMIHm
	 bW7P1tNpqyfZDI/2jTU1BFb66pvsJFjcQgBI2ab2nYHtdE6u15x4vE7x4uIftatxu5
	 jpfeoG4fJZNwGHqAdGSVEbBGkBh0ZT5PqGIP9Zmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 028/776] nfc: s3fwrn5: allocate rx skb before consuming bytes
Date: Sat, 30 May 2026 17:55:42 +0200
Message-ID: <20260530160240.998929103@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 82ea35d748a5d..dde1a87ed1e47 100644
--- a/drivers/nfc/s3fwrn5/uart.c
+++ b/drivers/nfc/s3fwrn5/uart.c
@@ -59,6 +59,12 @@ static int s3fwrn82_uart_read(struct serdev_device *serdev,
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
@@ -70,9 +76,7 @@ static int s3fwrn82_uart_read(struct serdev_device *serdev,
 
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



