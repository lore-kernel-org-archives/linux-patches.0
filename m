Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704184;
	b=xl6MJ5SK7KqPFgGH6SWd5Z1sh+sq2PPidQbRSa1gMHXq5OO4unCrZ5Z7y5OYWEFfnDCj
	 USwQaBph8A94dd+X3WT9Idx+ctBODr0Mpd7LzYMFzi7EqFLO0tPSRi8nP3ALsKI3shgRw
	 a8KTtFLHIHeV/WGAIZRjm98KH8E+lST+0VBQerf6lo1ktdZP20pg8AuG9WRlQyP8Mr6tn
	 6q2Z5G83O3tXFSByFIwf+itYvqr3JNTUMkYp1oYmTrtIJPF6q13XPXkHK4cT0Bbtjl785
	 nz2qTrmQ3VazJ3vcN3IkWKEx7ZTiYNUFzZR4L0C8JDFiirgV0muPIv8oz8XZtiPXB7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704184;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3SiKYEz+Je5PUa1JyTBvuXb2LTQn/CEp+788xbAUHB8=;
	b=BuyXrMOetbxfR/zPaT904kE/XwiTBrGE+Rtd4k8H1vht1mjpJ8oB7gr3T0gt+x+WCiSZ
	 Q/dClO9GWVglojG7DulzVtkunzsUJfRnPVsdJ6R40uxTJ3H4Mf/tx5DCKcQbN9ir5nuIT
	 AEn2XHs1thslBHNpHwBg7y0XzCNYm4U60B1YbXIRfbK3UiCuK+EG6MVS+1Iuw21o/s1b3
	 77h3kFneWo0CRMmE6+PbNoHX+RaeUiDiVIi34BdAhGlhfHVFNjldU/rF2325hwgf5TQn3
	 FxqvcSAyqujsDxQ/g2JoAz6/1lJJQfLNzrrBgB2q+xABDpzfmuriSzn67Jf+NECecHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uc7pnh8t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F68E606A32A;
	Thu, 26 Nov 2026 14:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uc7pnh8t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C331F000CF;
	Thu, 26 Nov 2026 14:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704184;
	bh=3SiKYEz+Je5PUa1JyTBvuXb2LTQn/CEp+788xbAUHB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uc7pnh8tDAIYomrHA8Z937Bf3Fnj4zMsof/ns9wFHhNCdsu4obsMB98x8Z513dVJA
	 Sga7pSnuY5skhhuQWtxA2eW5hJkFPXfxMEZyfGh9SZt/QIJFQkkhAM1Q0zx6/9FVjQ
	 Qjs4wAnP7GS+RowkNAfhQlHg5HbKVGIqN0wTC7Hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongjian Dai <daihongjian@kylinsec.com.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 034/265] spi: pic32-sqi: fail transfer when the BD ring is exhausted
Date: Thu, 26 Nov 2026 15:36:04 +0100
Message-ID: <20261126143607.508263027@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 86ad17597f5fd..0b32714633e9a 100644
--- a/drivers/spi/spi-pic32-sqi.c
+++ b/drivers/spi/spi-pic32-sqi.c
@@ -297,7 +297,7 @@ static int pic32_sqi_one_transfer(struct pic32_sqi *sqi,
 		/* get ring descriptor */
 		rdesc = ring_desc_get(sqi);
 		if (!rdesc)
-			break;
+			return -ENOMEM;
 
 		bd = rdesc->bd;
 
@@ -387,6 +387,7 @@ static int pic32_sqi_one_message(struct spi_master *master,
 		ret = pic32_sqi_one_transfer(sqi, msg, xfer);
 		if (ret) {
 			dev_err(&spi->dev, "xfer %p err\n", xfer);
+			msg->status = ret;
 			goto xfer_out;
 		}
 	}
-- 
2.53.0



