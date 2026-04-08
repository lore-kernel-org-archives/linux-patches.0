Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BDF53D8906;
	Wed,  8 Apr 2026 18:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673720; cv=none; b=GcJt2rMa9U5sgfybOWOL6r42+uF5fWR3SkadaWHnibJYkur3T5MNFyiPJ0IeLigN6oDKfABWHXHOaCj1QwcXAdnJTPTL/0p7Py/4VsgE0ExYETVf632hVIAyCj7APYmCXCtRPdOVWu4jyFiXvug/LRi2ta7pG1qWBRa6G4mLvBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673720; c=relaxed/simple;
	bh=HjP1qNAgJArGwuBMlebeuxn2EtLGbkwa7q/Askn8RRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PlVw1vEDxr2Hj3c4mZAYoeVb9l5S1Zk9MDL+Y+HUXSm54ZJM8SetGCH4c/Ijs9qAdZzni2vlsGrg8gWaebNQ33LW6lI8vDYF1mvRiedKRY70ydcH+nMDqVbxZDEVdPttyCZAd1Yo8GiUQ1E7QYzpNZpvpQ+vNqwv9CjVY5oaexo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S5bM+2ZX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S5bM+2ZX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7065EC19421;
	Wed,  8 Apr 2026 18:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673719;
	bh=HjP1qNAgJArGwuBMlebeuxn2EtLGbkwa7q/Askn8RRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S5bM+2ZXmN+/lRKN/pwSXscxy6R8BBnt2EbuvsTC6sYMifJUlJqc7JCdLODzlH95c
	 +03v+iEc0XN3HCPK1GqFNeIhIvtQj8VAlQJWWCM3+/eocM5vhwnIeQg6Fg+gzmVSNk
	 m4WkkwjiviYhIil7/PSvy7FyrZIdpTY66XmadUhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 063/242] NFC: pn533: bound the UART receive buffer
Date: Wed,  8 Apr 2026 20:01:43 +0200
Message-ID: <20260408175929.439357331@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index cfbbe0713317f..1393f83f3149b 100644
--- a/drivers/nfc/pn533/uart.c
+++ b/drivers/nfc/pn533/uart.c
@@ -211,6 +211,9 @@ static size_t pn532_receive_buf(struct serdev_device *serdev,
 
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



