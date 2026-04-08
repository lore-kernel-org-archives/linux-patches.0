Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46A21E5724;
	Wed,  8 Apr 2026 18:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672582; cv=none; b=AG0mMJiBT40PC1rieR6rC6wDPQJ+Xcz7bdFTiXhhJy0topK3MGGwJLLg8BvgGAU9NTyfDVSNSlsovprYT9MEVKd52CLwiTs23hed0X/3tDgUmr3TMvfFm1yy+t28VVs/TFf02t66btQ6j/fA45I1EJLMOCupoPSxVQ9z2irSMUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672582; c=relaxed/simple;
	bh=OVZzY6I3GKHtNmn/VIWLhglHp148Ox/7HJkEVP/1wZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bAo/BzH7WeojsEd3bfL5sSoJbp4z98mv3IHSkf9s/4rGpOgRmwB9pi5F96n+EpG3NL/YU341+zg31B1mL7WffsY2VUSil2jzM5r6cl6Y26+WRuxKPlcINjukzUBr4BU6EHSO9HM6KVBvHgJ3ujZouo99SHOz+uoGuK+oMX2ku5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KGCTt3ev; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KGCTt3ev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B283C19421;
	Wed,  8 Apr 2026 18:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672581;
	bh=OVZzY6I3GKHtNmn/VIWLhglHp148Ox/7HJkEVP/1wZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KGCTt3evrWQUCcN8dmtA1/pbWWmtgC11EZ5YpaNt4fsHsKPTYwU7typmNGzH4lc5L
	 zKOcMu6ZJhQ3ACCAWeIJnAjNpybvO3IoCJrsyTsgo3yWqyMGbgyk0PxqO1lo/H6/Sm
	 1YLr6ZQC3ATR6v8ml/X3l01GBYInS9+J17wvh4P0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/160] NFC: pn533: bound the UART receive buffer
Date: Wed,  8 Apr 2026 20:01:57 +0200
Message-ID: <20260408175914.334369254@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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
index a556acdb947bb..f4afd1156e062 100644
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



