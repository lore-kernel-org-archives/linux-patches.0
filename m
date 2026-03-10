Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED32A2D978B;
	Tue, 10 Mar 2026 11:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141086; cv=none; b=rBuPOjR+V03+N4+k7fdOWzAVvHbkTCuuphZb7J6vowsw+Y801BxoDFPZrltrB3gGlgA/AOh3KgywIhgpnJPe44W9fItDI5dmF5LQyxTt7snMjAp5jmB48iG5Pb5dMTdNGn0NuddFnoz8aDhXcbm+x+LU+euAycH/H4b2BHg7mTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141086; c=relaxed/simple;
	bh=TOB66ADbYOW0D6QGNyfHFRUs/DkcqeEQ0i71djPOefo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o8angs4wyjDtW/mQPaWZRuxLPry5X1fOxnu3sjhYPKxWKAIQ/PwjP4jnlLlxkWCi/Q5ZZcRcBl7FGqu8duY1w0N6lBdqKv26UUawsaK++z86xQKWZ2WYfd8myP+nMjbqsPFDCnIgMVaAWLfwBNAnC9Q/NvyOYF+c71wZ6o4G5vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HvC3fCj0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HvC3fCj0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B127C19423;
	Tue, 10 Mar 2026 11:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141085;
	bh=TOB66ADbYOW0D6QGNyfHFRUs/DkcqeEQ0i71djPOefo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HvC3fCj0RxrmUOspux7k2K4nlqk1Ne+s/CwivvLXRmoxvsPa5zoMpCHbALwz7x6ds
	 DpPsgzawq7LRvGBTVJY4+aDLVQc4zNnlGogt/yp+0fR8V1Cv3M0ConHfIFvCROCFm2
	 tqEykxg7cH4w3H9JK5xuJFrJMW4TJCJaTcWczqGQHLvSxNCVfaYRDqQEeqeIXtjFam
	 Svdv+5nBRIG0n4JdbLSrVjvq1h1jclYbJMU5k9kqp7kdWf1IKOQrlx3IlDAb3HpKwr
	 rB+iieHi9f2duChHAGo+Pv2PGQ7DETRFFT+4R46zKKJWkkIcOy3KctRSCxvj6YUqLD
	 G0u2qBI5/T1vw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alain Volmat <alain.volmat@foss.st.com>,
	Antonio Quartulli <antonio@mandelbit.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 086/311] spi: stm32: fix missing pointer assignment in case of dma chaining
Date: Tue, 10 Mar 2026 07:02:13 -0400
Message-ID: <d952700fa2ac7a310fc2e6a0036ba1fa5c04d147.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Alain Volmat <alain.volmat@foss.st.com>

[ Upstream commit e96493229a6399e902062213c6381162464cdd50 ]

Commit c4f2c05ab029 ("spi: stm32: fix pointer-to-pointer variables usage")
introduced a regression since dma descriptors generated as part of the
stm32_spi_prepare_rx_dma_mdma_chaining function are not well propagated
to the caller function, leading to mdma-dma chaining being no more
functional.

Fixes: c4f2c05ab029 ("spi: stm32: fix pointer-to-pointer variables usage")
Signed-off-by: Alain Volmat <alain.volmat@foss.st.com>
Acked-by: Antonio Quartulli <antonio@mandelbit.com>
Link: https://patch.msgid.link/20260224-spi-stm32-chaining-fix-v1-1-5da7a4851b66@foss.st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-stm32.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/spi/spi-stm32.c b/drivers/spi/spi-stm32.c
index 80986bd251d29..7a6ee93be9bd4 100644
--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -1570,6 +1570,9 @@ static int stm32_spi_prepare_rx_dma_mdma_chaining(struct stm32_spi *spi,
 		return -EINVAL;
 	}
 
+	*rx_mdma_desc = _mdma_desc;
+	*rx_dma_desc = _dma_desc;
+
 	return 0;
 }
 
-- 
2.51.0

