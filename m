Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D37719A288;
	Fri, 24 Apr 2026 13:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037706; cv=none; b=rxktvQaRtL3mttBExqeStycY6UTemfPWPXIdKRju++ppjfs9gI4PBAflu8TkNA1kDiQEQyd2865mGOry/gC/97aam2A1e1owk9piap+4HDRvGByhGVClyUQbDI64sSfbWXVKowpLUw8BoPL2Dj/Bh1Hhpv+1/LPmXx1fvL6JO78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037706; c=relaxed/simple;
	bh=KoF8XT0+f1LGzu2bwiblmnFYtmMrZ+QRrfW3OyeqpQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tFWsTuRSaYGb4D6rdjizqNx2qxj0WNJ5CQFjD3+93FAzNBvYEpkdCvtOVOUb21IsfQvhppa53cB8U5rznYxi93Ni9ZlschE999jVYPvCwWieChhmlIkuX+ETMKNFbkY0fJCZkRXuseDh4rAvs+z8vYmKCvWRoJ+par/VLkhvCAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X0d3uI1q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X0d3uI1q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFF8DC19425;
	Fri, 24 Apr 2026 13:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037706;
	bh=KoF8XT0+f1LGzu2bwiblmnFYtmMrZ+QRrfW3OyeqpQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X0d3uI1q6zfS1AdNrXx+Q6d7g6LtEsHuoLY75i67KyRm6guciT1HpmuneMj8FJz74
	 DXXa17t/9M17UvC7nOvz+ceE+AQ0NkO9obZqc2RXh3onOYHuAk30oGtjBva85YBQEC
	 CxCxHf0W2wel85I4I1QLhbNeFTZYxB2nysCifP2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 038/166] nfc: s3fwrn5: allocate rx skb before consuming bytes
Date: Fri, 24 Apr 2026 15:29:12 +0200
Message-ID: <20260424132540.839549794@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



