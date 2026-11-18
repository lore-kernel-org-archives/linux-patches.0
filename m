Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020021;
	b=37E1Xo5ywndR0ROm85kg9v/Wz4xJrXxTwMKGdQtAjiw7hksubfISRSN32+7j4kR1SZse
	 iuUASEVQsreS6HxXoWGHK1fWjxUHavQSu6ZpkYO4/dJ/0+ixcC3953GGcq0IWK88Dfn8g
	 AUeR12aFwaiwX1+QSFuiDt62nXAPn7tIf92JjsKIRlugSEI7hkEjX+auTd8yqDyLzN9w/
	 SldRdHGd/EsYsEowxCVUJdr+pbpvYAjFJfocuP+s7TLyEn86sLTztrgdwVipXoJWoaZVQ
	 eHt1l7krSMVH4alrAQBI5him7YSz1dMnTbulsfOTmytJdsVhp6VALVOK6EoR7T+J6TQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020021;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=M5bZp5DS4LRaB/q7woM6OzuACgelwu8w3k0SgZ7r0Yg=;
	b=Sxjj/0EjUVnwLYWw7MGMu2nKhRjiLiPt7EbQu7fq+BTvk9YrG/cUpKbIfdxOecjuR784
	 4d9Ps+K5iwJ9ZmvTm+2rZ/F+m+FDv5qeY5tvLGFLMMu1AAlET+j20Ac8vxNIUnnmCMCXs
	 aLsEYZZ03TOFcSPm6TVzaUo4eVwJqWVIuGZ07xF2/GtZHwvAxNzYWkzea4BsnPqfxsDm/
	 5azOMcPALcYnE1qSuShZeJBeZiL0R836CPMBR1j/YvPz1XmjxDFr8Eo3Aa7dMxTTV4BAm
	 tdsn4VJ04UeRgTYb0/0+daxloZPOm0CZDP9oEw0jB+GFpskH/lWNmNAWFG5It9KW5zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=knv9yeo9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37AC8606A32C;
	Wed, 18 Nov 2026 16:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=knv9yeo9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A801F000C8;
	Wed, 18 Nov 2026 16:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020021;
	bh=M5bZp5DS4LRaB/q7woM6OzuACgelwu8w3k0SgZ7r0Yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=knv9yeo9MBc918L7hNCYCEitwWacDDiMuY56pA4bHVE9KgdhsLFXDBCxNA4FdGOCx
	 LnlA5/bAE5mP3uIkatEA/ssFd7Ps8O33tsvrQghHMDxgqUA/+e3CU7MDjEJ1cx55+u
	 nJ8VyNvLch7QLwawYWYneKW+xtwsb4LyKdZnYJ7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Santos <Jonathan.Santos@analog.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1804/2651] spi: axi-spi-engine: fix stale SYNC IRQ pending in trigger_enable
Date: Wed, 18 Nov 2026 15:50:44 +0100
Message-ID: <20261118150352.218217686@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 87c05cb064ccf..ead5b295e680a 100644
--- a/drivers/spi/spi-axi-spi-engine.c
+++ b/drivers/spi/spi-axi-spi-engine.c
@@ -1036,7 +1036,13 @@ static int spi_engine_trigger_enable(struct spi_offload *offload)
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



