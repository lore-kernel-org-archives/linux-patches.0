Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8E6330D4C;
	Mon, 13 Apr 2026 16:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099421; cv=none; b=E6qXoZdLZghGFyEyh9YBZqY296jC2QqtRc8Vooj1JRNGhHaBo2mq/dB22ox5HQCMJSOh3V1wGcT8QYgu3BqpdtNqUhoDhIORD1bjqHfik7OFiDcJsGK8O/+6e7i1wS5MaWuPAVzAwNS0EA4EUgRmee0kUxpr/gZ+w2E0ZtNfkJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099421; c=relaxed/simple;
	bh=qHtTw5KAWStrBtvtyfpLrtK5ENeh0Pg4IY7FXvn/Lqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XERPCqjeRS99Y2Nlj9h84S+PBwGkot/GK40pd+bG5RepN+P4uzF/c1+JeTjwhodLMBxouUgh46oTPd+TgU8j35xQ3OtvsUumXo15TEA8weQCIjy+FfKloQtKb7r8uVgq+hBwthe+yTVdHqCLIAxCUMk9UKcikIL123Ef6gMrN+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g0zBbiAX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g0zBbiAX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A9D7C2BCAF;
	Mon, 13 Apr 2026 16:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099421;
	bh=qHtTw5KAWStrBtvtyfpLrtK5ENeh0Pg4IY7FXvn/Lqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g0zBbiAXNo/CPLqTDl7NiqSLfYRA7pHQwbXaR8kGo3Lc6ZcAz5DKyKkhmipL0xhQF
	 F7xWvt7QwvJ6r8PerSbooQxNqACund/xUtzKUkL4V6UPllDRseadMOLLJ3s6gmqIUF
	 sALKGMTVdcVLT9Ef4aWsbeNEFMz6Oe0w10p3CqtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 333/491] NFC: pn533: bound the UART receive buffer
Date: Mon, 13 Apr 2026 17:59:38 +0200
Message-ID: <20260413155831.507190201@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 30fe3f5f6494f827d812ff179f295a8e532709d6 ]

pn532_receive_buf() appends every incoming byte to dev->recv_skb and
only resets the buffer after pn532_uart_rx_is_frame() recognizes a
complete frame. A continuous stream of bytes without a valid PN532 frame
header therefore keeps growing the skb until skb_put_u8() hits the tail
limit.

Drop the accumulated partial frame once the fixed receive buffer is full
so malformed UART traffic cannot grow the skb past
PN532_UART_SKB_BUFF_LEN.

Fixes: c656aa4c27b1 ("nfc: pn533: add UART phy driver")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260326142033.82297-1-pengpeng@iscas.ac.cn
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/pn533/uart.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nfc/pn533/uart.c b/drivers/nfc/pn533/uart.c
index e92535ebb5287..7465b4b48c829 100644
--- a/drivers/nfc/pn533/uart.c
+++ b/drivers/nfc/pn533/uart.c
@@ -211,6 +211,9 @@ static int pn532_receive_buf(struct serdev_device *serdev,
 
 	del_timer(&dev->cmd_timeout);
 	for (i = 0; i < count; i++) {
+		if (unlikely(!skb_tailroom(dev->recv_skb)))
+			skb_trim(dev->recv_skb, 0);
+
 		skb_put_u8(dev->recv_skb, *data++);
 		if (!pn532_uart_rx_is_frame(dev->recv_skb))
 			continue;
-- 
2.53.0



