Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915DE3D8912;
	Wed,  8 Apr 2026 18:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674456; cv=none; b=Bvtytc5wAuhpiJDReSlGV1nPWsUKVJamAl+Ljuj88fJ8uLVnWvgDuv8KpEpWdpQD/o4x4WJPcTltaLdQYptcHFpGIM4UW6vEK+fcZR9LC0wU83iG7dXoy7BkZO9p1HVG5dV6oSFDRTv8QGJ484lRGBucDH5g5tD5zm7YAFwHPCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674456; c=relaxed/simple;
	bh=0aErxOv7tlpc0rpoB0aHAz+LiFHlLwXixx1igcXP/WQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lyWQ/GCkPdtbVmBMvLQGHggGj2Rl7IRUYR1THqOoygfvQ+VXMOPqWNbDqUPIU9aXrdVE26j9eN606SqQM4ku3/isDBolcl+cPKiI3+/iaVEN7HA5+QOPupwZePZxf/E8Xhz9Tn5NuRxUNS0SRnBRMpnpslteik8teuyQW3NPEMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zmnxHXTQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zmnxHXTQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24899C19421;
	Wed,  8 Apr 2026 18:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674456;
	bh=0aErxOv7tlpc0rpoB0aHAz+LiFHlLwXixx1igcXP/WQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zmnxHXTQnri+lXTkHSheb4Ol6zt/Yqna91D0arVgmq1FVFHFbTUe+OomJ/N/be+km
	 DhoaTZACfdulT027vvIgfafB2W8Ayc45AMJQPdro3CKlKwI0TNLk7UrrMBe6wkKJDZ
	 qLDLFt531r+3OErUkaVkfg3TFQpooiGxSiMc8KHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 072/311] NFC: pn533: bound the UART receive buffer
Date: Wed,  8 Apr 2026 20:01:12 +0200
Message-ID: <20260408175942.103077147@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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
index a081bce61c29f..49c399a571750 100644
--- a/drivers/nfc/pn533/uart.c
+++ b/drivers/nfc/pn533/uart.c
@@ -211,6 +211,9 @@ static size_t pn532_receive_buf(struct serdev_device *serdev,
 
 	timer_delete(&dev->cmd_timeout);
 	for (i = 0; i < count; i++) {
+		if (unlikely(!skb_tailroom(dev->recv_skb)))
+			skb_trim(dev->recv_skb, 0);
+
 		skb_put_u8(dev->recv_skb, *data++);
 		if (!pn532_uart_rx_is_frame(dev->recv_skb))
 			continue;
-- 
2.53.0



