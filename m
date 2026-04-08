Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F1045BE3;
	Wed,  8 Apr 2026 18:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672105; cv=none; b=R0nhCvLB5m/6FORZBcT547VIgJW1Ung7QKyEX7WMwKgbOO2AaDojsg98lIH3pGTpuOJ0PX1eqJqUBSlKeDhEMzjI3GfaquF8KIS2ox6MNtNm/ajN6czyQ56YT1iilvPAZAsaaLIkdg75taIg4av9RD/bNONUfOkM3Jdl4J2seFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672105; c=relaxed/simple;
	bh=yZ6pygGsWDq7pB/danmuMt+VB+YIAN5Q2+XHNM9LCm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ka09NtIJNVeOdd9zLVF1CnYHCtArwJF4Rhi8FZlCDHt+GYvDleLhcjsSgSmkuMgv7ikYxFvX/phDO8legQ3fLAaay94Ei8fhQD9ONiQLsmkQgPJDZbRgnRASYkiXtumNNn4ph5nudN3lrPTwcrcZcizUQXwSBSc8suSFMO3IVqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oTFdkfrf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oTFdkfrf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63289C19421;
	Wed,  8 Apr 2026 18:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672105;
	bh=yZ6pygGsWDq7pB/danmuMt+VB+YIAN5Q2+XHNM9LCm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oTFdkfrfogFUIG04vTlggCTsVbSMWLpee4TisuWHMH/1ujkBI1nMJ7xJ9KTYXl11o
	 vYsH2os2nOGdOjaYtMe5QBKY9iql5UkjrkhkXFD8gPnVlD0S9oNnS94DQZJ/eBqjSi
	 GzdwyxZfr6DG6F0flwi2RnFgqnpQCRPDokif5x1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 159/312] NFC: pn533: bound the UART receive buffer
Date: Wed,  8 Apr 2026 20:01:16 +0200
Message-ID: <20260408175939.704218160@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 07596bf5f7d6d..026d5ef825b59 100644
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



