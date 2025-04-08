Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A4126A090;
	Tue,  8 Apr 2025 12:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115570; cv=none; b=dO4AKFr++3jI6LVsPyy0j7qGS5TaRG6jwemMLHU43VrHOE4WDdyia3M2aGH4+3J0x66jRsRas/F6hALjjfaUTSK7ugewKSp1t9Zhfmf5M6MrMM/5k5/U4poTRmt2zpzs9oJfyTDP9UjGRDxrnRCpAu+/2TkJc9q3qeRlJ/+v77A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115570; c=relaxed/simple;
	bh=TlqaFNNHBkyEmQ3QWcpRHdSORbgTQ11zasOVzznQThY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OYRwMhaqQAwfnUe26DFhxdGaaiX0n5mc7OIArfLwM6qHDyO08l/TWhThmcUKpYQa5TaN/hdnYl7B426NmtH+gVzRLWKxN9bwCfy/LNRmb7A5G8Yk5R0NqbH0ub63RKTGvpTBBA/SAkXz3jgO4HBNrZk/wNNTqck7bAwUX9otASQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Os8c3BoD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Os8c3BoD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1639C4CEE5;
	Tue,  8 Apr 2025 12:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115570;
	bh=TlqaFNNHBkyEmQ3QWcpRHdSORbgTQ11zasOVzznQThY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Os8c3BoDdJHxVW7NZYEtb8A51mOFsRzKKGw6f8yFE7t+pvju7qcWk3lM13bThJPqT
	 h1bjhkMcVWkrjdvFTMmWe1klpBjDHFTRiFsFgHrdq109eQnndvi0IjjT/goQ71iaug
	 N1e9Erov7axjVx70eQm8F9UoO6Lp9yePxNPvwAB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 023/204] ASoC: cs35l41: check the return value from spi_setup()
Date: Tue,  8 Apr 2025 12:49:13 +0200
Message-ID: <20250408104821.003260176@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>

[ Upstream commit ad5a0970f86d82e39ebd06d45a1f7aa48a1316f8 ]

Currently the return value from spi_setup() is not checked for a failure.
It is unlikely it will ever fail in this particular case but it is still
better to add this check for the sake of completeness and correctness. This
is cheap since it is performed once when the device is being probed.

Handle spi_setup() return value.

Found by Linux Verification Center (linuxtesting.org) with Svace.

Fixes: 872fc0b6bde8 ("ASoC: cs35l41: Set the max SPI speed for the whole device")
Signed-off-by: Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>
Link: https://patch.msgid.link/20250304115643.2748-1-v.shevtsov@mt-integration.ru
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l41-spi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs35l41-spi.c b/sound/soc/codecs/cs35l41-spi.c
index 5c8bb24909eb4..bd73944758c6d 100644
--- a/sound/soc/codecs/cs35l41-spi.c
+++ b/sound/soc/codecs/cs35l41-spi.c
@@ -39,7 +39,9 @@ static int cs35l41_spi_probe(struct spi_device *spi)
 		return -ENOMEM;
 
 	spi->max_speed_hz = CS35L41_SPI_MAX_FREQ;
-	spi_setup(spi);
+	ret = spi_setup(spi);
+	if (ret < 0)
+		return ret;
 
 	spi_set_drvdata(spi, cs35l41);
 	cs35l41->regmap = devm_regmap_init_spi(spi, regmap_config);
-- 
2.39.5



