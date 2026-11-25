Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624114;
	b=c89IAvxQb4z2cXftE+MeaxjJkilQxZrWKZjDTHrgLkSrqTbHTaDhgpWf6S3wWBYuGMul
	 ePsWhpqh6W1LBxcRpddgKLzeNYqjM2nVnNdYJaZ/d+uR3EiUeEowbvMsZ9hRQQr26xdRX
	 qV4ZlTxOihhfXy6QqnzXAcQtLyGh027LHcwo8IHQM+UymqyJ6tdngN803txgo2ohnA8nf
	 1+jqW8Q2EknHGz8dktGf+65FmdyGA84ElB2tJWDf5wctyXw9O+vlAbozoMuTKb8s+iWUr
	 v3uv/6ugjld1fxVqroFTi/JbkFpqHQaEKPHJMMbtIFCA4kqQUXa1WJ54/AxghWx/n2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624114;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aJVIJo177x4OtDMFCNoqXgr5XPtUpTotXfxM9cJky58=;
	b=zASpY3257HLDq6BOso1opYoUZzafjhuiHv4FhAlh4I9ofq6GyACW5/wVZO4UFeGv231l
	 MJFgEJe5/GVrbspFeJvgRwd1GjG3IkXzvNQIHHXilaCChK6pMZU5otX/C6na+vCSb3iCs
	 8fpanJ2YVLNw2BaODYAYR2NhEeomESjUJ8bLy8TJ/844fn3cHIafqp6Nw5vphA7BFQcPY
	 pSI5HSu7aEpe8mqqup5bAvLKaKrxOa910fZ1jSlUrZ1ufX7ii4QywJ1oRX+BkZk7JsKXj
	 7Gjvepgu17xewH95+V7IwMEA8lw7XTUMUAa823uE5r3iRvTFeTytI7vxcmpmo5ZOySQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AMenWqRY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92FFE606A32C;
	Wed, 25 Nov 2026 16:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AMenWqRY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E07081F000CA;
	Wed, 25 Nov 2026 16:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624114;
	bh=aJVIJo177x4OtDMFCNoqXgr5XPtUpTotXfxM9cJky58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AMenWqRYM9pYC4lxqypr/ANjYyTiYkCSUqun0ald1yfYJ3GppncbtLwseT6AahDpP
	 jzf4jflUjADk/gCGZ6rl/IP+ecsdIqrbboEagoCz+Om7ngG8QVrcMsttBdqAlSpvQj
	 Q974gg2qhVcnMyNpQuuguiN29FXfLpsAMpmo25qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongjian Dai <daihongjian@kylinsec.com.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 091/816] spi: pic32-sqi: fail transfer when the BD ring is exhausted
Date: Wed, 25 Nov 2026 15:27:19 +0100
Message-ID: <20261125143851.329548835@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
index 569d1e55c8ca9..3cb7e407bf717 100644
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



