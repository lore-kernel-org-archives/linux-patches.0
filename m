Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055312;
	b=pmyoDdBEsSF2ah1WWDH1/x9LmQN/sNoQl8hlFzPJHUzzwrLM092fhpjK1pq7iv3C6nft
	 V8W2hsCcpxOMYbEWocZ4ySTiYSfZdGWOf1ALOS+Q8/HUUZeKKis66+Uutu4vmXFWzNX4i
	 emlwNjc2kmfsKwtqXNKrrLEGpXIH1m39dP0LVBfyXsKN6ZtMfPFNyx2zZkGHw/MYYfl90
	 Y6xqiXxNh/HDnmz0lD6qh1Ra+jVV0qoxziv9RvwC3BYAgT1nmZijc1PN9NJT9wGTKFez3
	 Q+1RNR+5EF7gB/D8TvgMp8ewMmuL+vaxMWnPVjiLdI8Pj3hA963dD5d1sgXw02ojmJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055312;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bMOx9v72lfoWaHluZsKKyH4qUZZiayazTvXcD5fuI34=;
	b=1zNo5LRXI42XvfYPtpRyeC56Ux547NukB9QJIn+syGomI4OYZgrNv45talqmBKGgC1Ai
	 iLwkjK/SKd0NBCv1VErsMMCWdWYbqdzQi30EErnU61C0TouNWItR25nf6gKslg7677/4v
	 YxdlVd4F3M1bs6xXi+nCB8ZNO8yfDG23/YPmF9EZEBkPfdUcDuzxyKKV74BfOSIotQRo0
	 wxmbIBcC+BH+iMpdb4VEyUlNUDU8sGU7ksEx9L9uYWFtuG13T/aV9aBe2JR5lRNXjtn6p
	 m3IL5oTNJJuDsUOAKP5EkG/NkRxTaa3ERkPTj93PBDW2SIuT8dKxKilPOX34EvAYxhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YShYlnvx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F75606A330;
	Thu, 19 Nov 2026 02:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YShYlnvx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2103E1F000C4;
	Thu, 19 Nov 2026 02:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055312;
	bh=bMOx9v72lfoWaHluZsKKyH4qUZZiayazTvXcD5fuI34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YShYlnvxIS//nEjUH1+xgBGADFSFqPpo4ospuU/UZicCXvRIrMPaSQS6uE6oneQST
	 6r334TpbfNshE/9+8coqqCI4aXwWKs25KXQBDUvkMuudYYfsziL7S9bH9l001dqqEQ
	 nSqgUUDevWX89mPlCpciaT2/jce11Nbkzv7+2FmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zongmin Zhou <zhouzongmin@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1585/2214] serial: sifive: fix off-by-one in console port bounds check
Date: Wed, 18 Nov 2026 15:54:21 +0100
Message-ID: <20261118150115.410276109@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zongmin Zhou <zhouzongmin@kylinos.cn>

[ Upstream commit bf961847813d9edcb5a9c089714069428d141fa9 ]

sifive_serial_console_ports[] is sized SIFIVE_SERIAL_MAX_PORTS (8), so
valid indices are 0..7. The bounds check in sifive_serial_probe() uses
"id > SIFIVE_SERIAL_MAX_PORTS", which lets id == 8 pass and causes an
out-of-bounds write in __ssp_add_console_port() through
sifive_serial_console_ports[ssp->port.line].

Fix the check to use >= instead, matching the check already used in
sifive_serial_console_setup().

Fixes: 45c054d0815b ("tty: serial: add driver for the SiFive UART")
Signed-off-by: Zongmin Zhou <zhouzongmin@kylinos.cn>
Link: https://patch.msgid.link/20260827014524.19375-1-min_halo@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sifive.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/sifive.c b/drivers/tty/serial/sifive.c
index 493bde7b8e398..a3ab203304bfb 100644
--- a/drivers/tty/serial/sifive.c
+++ b/drivers/tty/serial/sifive.c
@@ -975,7 +975,7 @@ static int sifive_serial_probe(struct platform_device *pdev)
 	}
 
 #ifdef CONFIG_SERIAL_SIFIVE_CONSOLE
-	if (id > SIFIVE_SERIAL_MAX_PORTS) {
+	if (id >= SIFIVE_SERIAL_MAX_PORTS) {
 		dev_err(&pdev->dev, "too many UARTs (%d)\n", id);
 		return -EINVAL;
 	}
-- 
2.53.0



