Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062446;
	b=KKKbhgh7TtrVpCTzeefRhhIJDLhz6014zfIv64kuQ5ut7yQmVdBq483BSr4u1Q06mBsw
	 0keyww1vrVk5Az1P8b5O69MlJ10o5JxQ87CJMebkKg0zYW54VKNHU9xo2LEKZstxAteS1
	 o/EDaXOKziot3wMze+6oGSds22gdZsMetsygb8F5YuuEMeTMrkIvUVakwvR6f8JGfW2VV
	 r3HFS/oj0AtAu7QoaxuwJf+wKL4q5iZSwtSixb3+RYTsj98ZGRCIVj6/5tttanw7JPQya
	 GXBvS47C765ugJs/3PWEzZW2/JwR4K1uETZ1cYwYuC2vO5jcepECCBLCAsUyms6L4lQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062446;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cuf46SzhNRxdYKcTKDjSrU23cNlroeC6TTfPNhh9/f8=;
	b=vPOJ5pAZOUOR6QjqX4BWN5ujv1GEV0gTymYlSlzY9wIa3AjxUGFjr1n7zxfcehxqKWvF
	 oGfKCrhXBwNejpH8Dsh2FiBqYGmK0R+poNIMyXnVEk2nHex/Q6/Ve5r45cXACipcg42jZ
	 NY4lH/qNTVLxS4hObAKC8vtx507rUdKuXs77Yc1qILcftgM5XsD/wvH/TG+Z8s5rYqhSc
	 8/JX1UcBSgsb6zq1nByXwN7B1SCDIuJk1DiAuW9NQgcgSAqO3Ehy56GVgpA3W/ontdxTI
	 QfCV4b14wnSXsbdjbu0xqhh0PyS0+qUGA/SrGHH/UlyRnxJUqsUqZQkWWpW5cacxb5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="r5bYf/Zo";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84095606D81D;
	Sat,  7 Nov 2026 14:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r5bYf/Zo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E38D21F0089F;
	Sat,  7 Nov 2026 14:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062446;
	bh=Cuf46SzhNRxdYKcTKDjSrU23cNlroeC6TTfPNhh9/f8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r5bYf/ZouCHrIpa6ogq42Qk8D+3MslNYOsbFXlPSLZLiBYWINYmTB3mNd7Q3TP47w
	 8nht9WpnubJgl5oAYr6NPbBoFQiZXX7d/0M+ge7r41gxLqCQ2mtUnx8esQq9pC0cZ8
	 t56taGbz8jZ5NaFzQnM0CmdnQe4lB7iPaIAceUKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weibin Liu <liuwb@xiaopeng.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1354/1536] spi: ch341: handle transfers without a TX or RX buffer
Date: Sat,  7 Nov 2026 08:56:10 -0500
Message-ID: <20261107135035.859149755@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weibin Liu <liuwb@xiaopeng.com>

[ Upstream commit 84182c48999f856c3865e4a537c244f9569c9f6c ]

ch341_transfer_one() unconditionally copies from trans->tx_buf into the
TX packet and hands trans->rx_buf to usb_bulk_msg() for the readback.

The SPI core allows half-duplex transfers where either of the buffers
is NULL, so a transfer without TX data crashes the kernel on the memcpy
and a transfer without RX data makes usb_bulk_msg() store the received
data at address 0.

The CH341A clocks data in both directions on every transfer; there is
no mode to disable a direction. Set SPI_CONTROLLER_MUST_TX and
SPI_CONTROLLER_MUST_RX so the SPI core fills in dummy buffers for
half-duplex transfers.

Fixes: 8846739f52af ("spi: add ch341a usb2spi driver")
Cc: stable@vger.kernel.org # 6.11+
Signed-off-by: Weibin Liu <liuwb@xiaopeng.com>
Link: https://patch.msgid.link/20261013054339.77477-1-liuwb@xiaopeng.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-ch341.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/spi/spi-ch341.c b/drivers/spi/spi-ch341.c
index 3eaa8f176f63a..170240a0dde89 100644
--- a/drivers/spi/spi-ch341.c
+++ b/drivers/spi/spi-ch341.c
@@ -189,6 +189,12 @@ static int ch341_probe(struct usb_interface *intf,
 	ctrl->transfer_one = ch341_transfer_one;
 	ctrl->set_cs = ch341_set_cs;
 	ctrl->auto_runtime_pm = false;
+	/*
+	 * The CH341A SPI_STREAM command clocks data in both directions on
+	 * every transfer, so the driver always needs a TX and an RX buffer;
+	 * let the SPI core supply dummy buffers for half-duplex transfers.
+	 */
+	ctrl->flags = SPI_CONTROLLER_MUST_TX | SPI_CONTROLLER_MUST_RX;
 
 	usb_set_intfdata(intf, ch341);
 
-- 
2.53.0



