Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026604;
	b=jBFrIvFcmxuByWhjf6BfYgnps/XDmWLL3utgBB+m12cj75So7fBBT44Zm/MJl57F3wnr
	 kvNeC9BOZBjRkHvtCAZUeaZxk66jf/WqEs8r4fVYcTdbS9CLGnVpNbKkG7mBL/8DIDtcb
	 faloLnbKg/FhsAG98XgjEg+mkXrtw6TFbfKhhp/pFUTMVihk4gv79ENZ/w6AJO+r9ecj9
	 PpERqy/ATtQdYHB0Hh+Vpk1HCwwvfATRhpBqiV/pVe11KJH4NMM0x5FyMiHyQo3f091jy
	 hStRfdrKli19LU2zAS46sZkllzBRZyEBueRLcqnMPucxarkdDtifDv5tvMauQf+uEUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026604;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=EPNAIjSmurFqmuw1I8MvdXE/XSE6XSiqS+CfvEYB6xM=;
	b=TH2zlZv2sG8J1MddFXjf8+Ynb53ez+Ys7baKnhbKKxguSxkyrOd0GwPzKkXyGlnpAErn
	 viZmoU5lCTTzgzjJ6vcuNe9utjgqK+TucVoMS02C3SO0vRnRs+cDNrWTovmvlt0mI1Tih
	 S0KRemP5PvC4cAnBjVInQWe+tv/h/LKDghyzFA7vUYBhnEKkT1Gfka30DNM9DEvsEs7vo
	 cfsruBzqpxxYJgTP2nPXsGlV4w7iL0ZG3/zoE7fnS79Sn8V85BLWHU0RfW/lAcSgA+/jG
	 r3xxfo2UA6e8DeZEFcZ88+isZZsNwOaSDkc87sZ93+pptygOAVynVS75c6T2oLS1h/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VPQJu7Yz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43521606A333;
	Wed, 18 Nov 2026 18:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VPQJu7Yz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EC871F000C4;
	Wed, 18 Nov 2026 18:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026604;
	bh=EPNAIjSmurFqmuw1I8MvdXE/XSE6XSiqS+CfvEYB6xM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VPQJu7Yz1Njf/2pjF2TSkHGXUf4KgKSw51pmtmDjBCBPFHjv+tWBY0Nzjc41pXhCm
	 Izj9r9OvmN7ERZKXgeOKkOHaamhoLERfK9Z4MCIxbi+53O5/Q/KumfhjMWw5SpbFYP
	 D3w/O2S78M3JlJCvHykD11ZoWP9x75XxBV7wiRXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Santos <Jonathan.Santos@analog.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1467/2151] spi: axi-spi-engine: fix stale SYNC IRQ pending in trigger_enable
Date: Wed, 18 Nov 2026 15:53:22 +0100
Message-ID: <20261118150215.334635286@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Santos <Jonathan.Santos@analog.com>

[ Upstream commit 18febc10a3538b9baa2f6e4481b434f20fdbd93c ]

spi_engine_trigger_enable() sends SYNC(1) and polls SYNC_ID, it never
clears the INT_PENDING[SYNC] bit afterward. This leaves a stale pending
interrupt that can fire spuriously when INT_SYNC is later enabled.

Simillarly to the fix on spi_engine_setup(), clear INT_PENDING[SYNC]
after polling the SYNC_ID.

Fixes: 8fc13b822c74 ("spi: axi-spi-engine: don't repeat mode config for offload")
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Jonathan Santos <Jonathan.Santos@analog.com>
Link: https://patch.msgid.link/8d3f421e07b6114aae55f964825dba6ac9151cf5.1791361360.git.Jonathan.Santos@analog.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-axi-spi-engine.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-axi-spi-engine.c b/drivers/spi/spi-axi-spi-engine.c
index 6a2128459f559..47928e956dd4d 100644
--- a/drivers/spi/spi-axi-spi-engine.c
+++ b/drivers/spi/spi-axi-spi-engine.c
@@ -914,7 +914,13 @@ static int spi_engine_trigger_enable(struct spi_offload *offload)
 		spi_engine->base + SPI_ENGINE_REG_CMD_FIFO);
 
 	ret = readl_relaxed_poll_timeout(spi_engine->base + SPI_ENGINE_REG_SYNC_ID,
-					 reg, reg == 1, 1, 1000);
+					 reg, reg == 1, 1, 1 * USEC_PER_MSEC);
+
+	/* Clear the stale SYNC pending bit so it doesn't fire when the IRQ is later enabled */
+	writel_relaxed(SPI_ENGINE_INT_SYNC, spi_engine->base + SPI_ENGINE_REG_INT_PENDING);
+	/* Read back to flush posted write. */
+	readl_relaxed(spi_engine->base + SPI_ENGINE_REG_INT_PENDING);
+
 	if (ret)
 		return ret;
 
-- 
2.53.0



