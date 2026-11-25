Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621067;
	b=mrxDdURdxDPGIy93nwNkCz+XvEWYdzDlba9icBqCtDdes8mp9viqVQUUrCZgRJ6fcB0x
	 QrZguKnDYBxLyTVJM/oDFsPVrcQzFXG4/EerOF6mDwxugQaL+CPsYcsenGe1Flfhc1KO2
	 d3sjSuDRADF/lU63LZprH3kddJaMzsrtiqA4Z6hbwbsH0nck3eK7dl/o3cJrO0euDIxcj
	 TMQhmsoAWusPfJ3Z60+r+fXA5laQJL6hClfwSEGbohzs7GEVZ+Kbzuha34ZF6EW2pILua
	 JhtHE6Z4ALHbMMV9KDqx6BFZrC50hDUyj4iqLoEtydxw0DJTJzlV2ySeimmjJ0tmXWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621067;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+U/jXPM32gVaqRMOuQyuCR3ZVZOR4JJdL1Q4rgsMlds=;
	b=2YcT8C06geJR1hgBAlbq5uglrdAI4ZtYVMYT+rqKws8rqIFVFcs8692bdeOT4b4ZzSol
	 VAQ9Kq4Sw+3QF3jT3uXKHwrw6M+YAhJBUUlsCMUVKhYTLF9H/cjTG4EA/CSq9fT5tLUyv
	 r2oq3iA9GLLO2OZi9Ca7v595yLdJrWP65QhxAzlUXgwebrb5cNSBOP2Y80cZUpO80hHLI
	 XiD/MlqAH4BIw3gNR854Y7qcq8rTnQLQbh16LzRdYXLGcK861HhNM10ufD2kfPmA8AaFA
	 OVlwBtxj6dzV1M5kePrtsGitPUPKODeGjPao0918+sPtUfisHux5ws7Nx8WNi9X0Iow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AaGcE2RZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0B8606A321;
	Wed, 25 Nov 2026 15:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AaGcE2RZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0F91F000C6;
	Wed, 25 Nov 2026 15:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621067;
	bh=+U/jXPM32gVaqRMOuQyuCR3ZVZOR4JJdL1Q4rgsMlds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AaGcE2RZHkaiHpamG9m28XJt/1gPstMJDnYJR3b6iUPvKNScdd2l5XZvTu7b46fWA
	 DszF0YI7YPvlO5Inl54nZBukzknWOZh3Oam6VexREGhtr70T77/OQJrff/Iiv+L+U9
	 oXak3pS8gmBgTu1f3cC9xWTay1TvRVhkAE7O/YVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongjian Dai <daihongjian@kylinsec.com.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 108/990] spi: pic32-sqi: fail transfer when the BD ring is exhausted
Date: Wed, 25 Nov 2026 15:24:35 +0100
Message-ID: <20261125143824.620332192@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongjian Dai <daihongjian@kylinsec.com.cn>

[ Upstream commit 2066970324a1439e5a2e08c4599098367f8f82cc ]

pic32_sqi_one_transfer() silently stopped programming buffer descriptors
when ring_desc_get() returned NULL and still returned success. The caller
then marked the last programmed descriptor as the end of the list and
started the DMA engine, so the hardware transferred only a prefix of the
requested data while the message completed with status 0.

The ring holds PESQI_BD_COUNT (256) descriptors of at most
PESQI_BD_BUF_LEN_MAX (256) bytes each, so messages larger than 64 KiB (or
with enough SG entries) can exhaust it. Since the driver sets no
max_message_size/max_transfer_size, the SPI core does not prevent this.

Return -ENOMEM instead, and set msg->status so the failure reaches the
caller rather than being silently truncated.

Fixes: 3270ac230f66 ("spi: pic32-sqi: add SPI driver for PIC32 SQI controller.")
Signed-off-by: Hongjian Dai <daihongjian@kylinsec.com.cn>
Link: https://patch.msgid.link/F5276982A630220B+20261017075545.95854-1-daihongjian@kylinsec.com.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-pic32-sqi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-pic32-sqi.c b/drivers/spi/spi-pic32-sqi.c
index a6b5a0ed99c9e..6061e425d09c5 100644
--- a/drivers/spi/spi-pic32-sqi.c
+++ b/drivers/spi/spi-pic32-sqi.c
@@ -297,7 +297,7 @@ static int pic32_sqi_one_transfer(struct pic32_sqi *sqi,
 		/* get ring descriptor */
 		rdesc = ring_desc_get(sqi);
 		if (!rdesc)
-			break;
+			return -ENOMEM;
 
 		bd = rdesc->bd;
 
@@ -387,6 +387,7 @@ static int pic32_sqi_one_message(struct spi_controller *host,
 		ret = pic32_sqi_one_transfer(sqi, msg, xfer);
 		if (ret) {
 			dev_err(&spi->dev, "xfer %p err\n", xfer);
+			msg->status = ret;
 			goto xfer_out;
 		}
 	}
-- 
2.53.0



