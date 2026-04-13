Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B682C2472A2;
	Mon, 13 Apr 2026 16:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096882; cv=none; b=bcOZmkOAh6xLdkGnD9YGCxip5ywci5BViKuiqq7kGnxEReV2buuSDOCRKSkQ/tOqL6b1uuIy6pbfbUDcuu0Ai06jiJi1D3JREuWVhL5SHDLzkWLswWzajPmMBkdPGgxyVclW97ZIE/Yw7l9KDLK+JhEjp5CSQAocwsPixb1SVQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096882; c=relaxed/simple;
	bh=P/e7KeKJ+lQAbJCClnvVdlYV/GkK5W7gR3EH5WVWZL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ItFWrha2lpNfqQag9DWsSoYrQmwIvKtAy3/xRBf4GWge0AN5elMFVLwo1KGjrXjwFVPBJVj2WFYy4y1jX1yBEEK0ywcQmn+JbOzy9uGDebz7jV7IcDGQVUJ07HWyt9d6LXDfqwhYd8ZGa7hKtEC9DII0UHVfmt8dV1CHrEOkGZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y0mjXWP5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y0mjXWP5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C7AEC2BCAF;
	Mon, 13 Apr 2026 16:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096882;
	bh=P/e7KeKJ+lQAbJCClnvVdlYV/GkK5W7gR3EH5WVWZL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y0mjXWP5IFrFxUncvSJbIn+l27uCUQEawHavtpWjsxMJr07sUkkUcPcjpoYH0khWT
	 EABf3fRL7j475OU2Qb4PrLzAgkSNsqI97nwRIzO6cSTEV67Kl84/cr5WnL7D1qmsxY
	 Ip+ipu0mgZmSk/aYToSUx+zhKYpurWSNfPvIPJaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 28/50] nfc: pn533: allocate rx skb before consuming bytes
Date: Mon, 13 Apr 2026 18:00:55 +0200
Message-ID: <20260413155725.563011774@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155724.497323914@linuxfoundation.org>
References: <20260413155724.497323914@linuxfoundation.org>
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

commit c71ba669b570c7b3f86ec875be222ea11dacb352 upstream.

pn532_receive_buf() reports the number of accepted bytes to the serdev
core. The current code consumes bytes into recv_skb and may already hand
a complete frame to pn533_recv_frame() before allocating a fresh receive
buffer.

If that alloc_skb() fails, the callback returns 0 even though it has
already consumed bytes, and it leaves recv_skb as NULL for the next
receive callback. That breaks the receive_buf() accounting contract and
can also lead to a NULL dereference on the next skb_put_u8().

Allocate the receive skb lazily before consuming the next byte instead.
If allocation fails, return the number of bytes already accepted.

Fixes: c656aa4c27b1 ("nfc: pn533: add UART phy driver")
Cc: stable@vger.kernel.org
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260405094003.3-pn533-v2-pengpeng@iscas.ac.cn
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nfc/pn533/uart.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/nfc/pn533/uart.c
+++ b/drivers/nfc/pn533/uart.c
@@ -211,6 +211,13 @@ static int pn532_receive_buf(struct serd
 
 	del_timer(&dev->cmd_timeout);
 	for (i = 0; i < count; i++) {
+		if (!dev->recv_skb) {
+			dev->recv_skb = alloc_skb(PN532_UART_SKB_BUFF_LEN,
+						  GFP_KERNEL);
+			if (!dev->recv_skb)
+				return i;
+		}
+
 		if (unlikely(!skb_tailroom(dev->recv_skb)))
 			skb_trim(dev->recv_skb, 0);
 
@@ -219,9 +226,7 @@ static int pn532_receive_buf(struct serd
 			continue;
 
 		pn533_recv_frame(dev->priv, dev->recv_skb, 0);
-		dev->recv_skb = alloc_skb(PN532_UART_SKB_BUFF_LEN, GFP_KERNEL);
-		if (!dev->recv_skb)
-			return 0;
+		dev->recv_skb = NULL;
 	}
 
 	return i;


