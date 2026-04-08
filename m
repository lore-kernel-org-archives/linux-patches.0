Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D34D3D411F;
	Wed,  8 Apr 2026 18:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672982; cv=none; b=SokfwqaTNXVBF2nMMqsUNTFkl3Ej6/R9CScXkLpYzeBUzSba9kPgLP0h6NF9womhTCHT8E/YCPk9XgkwQQotRxOaIwHp+pvxcV0bEl+NRzLXc3ZeZKJbridlsCuNV4KpYIJSz4A1N1+jqWkNx24CImH2Y93XU63UPvgm3bg0HC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672982; c=relaxed/simple;
	bh=nf7Ej7nMZDZ8c61h0Fey7ZTWhlLxvH8hxVcOWsoKnLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pzuHuk46E8VP8Sz45/Za4ya7HAw0TcWEU4unAgAwPXfNZTvheFbjbf1jgkSIkbv0NVCTWqO3A5/KgPhjZ2nF0vyZeZ5p/mh0Or8oE/qc4PKilNPh2msxXdK3ShlynkeUV5qDqDV48ieznCyWXFle9meN80GS0qPokvOe2hewjCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cP6ABATq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cP6ABATq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7DBCC19425;
	Wed,  8 Apr 2026 18:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672982;
	bh=nf7Ej7nMZDZ8c61h0Fey7ZTWhlLxvH8hxVcOWsoKnLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cP6ABATqCACWoqB6wnEWy+c3Z+JAZJo915KPXp5GxJAJbKK1d3CUShvBj/NuHuN+K
	 8Ux0tHSFX+jvlmsYYcIeeU03X7+ECxPKWb5lwqalSaw86P0Qw59pXO8B2SSOn3SWQB
	 WTXW0FBrxjacYp98eFBrDo/3bTALI2AGhRuBhhWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 056/277] NFC: pn533: bound the UART receive buffer
Date: Wed,  8 Apr 2026 20:00:41 +0200
Message-ID: <20260408175935.952140650@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



