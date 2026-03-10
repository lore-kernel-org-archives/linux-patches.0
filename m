Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433A7389116;
	Tue, 10 Mar 2026 11:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141942; cv=none; b=TazN3nPNK9GtP/fMAUHknzYnGxlHNNS0P6A0t7sp/D5uO/N3qt3maN5Sgf7XOEXxyg7ag1yPdY5wzysIT0wDN3iOQuWOrY6hkS8OYpIR1MSk9ZjEtaptHj+21g2joUummC/gfXujtDyts9EPyLpCFo08v58lHxB7Lj7BnBSTU9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141942; c=relaxed/simple;
	bh=TOB66ADbYOW0D6QGNyfHFRUs/DkcqeEQ0i71djPOefo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DcwAj/DStalaiRabAcPiv5Tf4eU4qL9Q21ZiQulXo/HTvbOd9rrNIUa37jMQYlcL4ujJnRvIf7Vur8M/J4jg4qCNAa94xZZo69oFiXWoVF7lMoVCFOC9z+3Q3Q+jhnFc/LlINUBF7NtPKEhGNsSynGUwRZgGSFWMagWN4VqQ17k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FM1bpjch; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FM1bpjch"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 754E6C19423;
	Tue, 10 Mar 2026 11:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141942;
	bh=TOB66ADbYOW0D6QGNyfHFRUs/DkcqeEQ0i71djPOefo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FM1bpjchyrGL6pYMrheYYFuoM/OCl/mbMhExTY/Q+W+1NK2lsYavs2pV99BoTZcY1
	 HGamGHwDGOs+v4Nk8iIlSBQqV3o3b3X3GJObYLgDpoP3C00z2kxUBVAIMuL/8Vaagk
	 meqGvBSRg7vgKv3jo19r7fEUJnc9QrsX+qzU+zEPxmmugiwHoS5UKyR1FxKV6Q4pkL
	 0bJqoFeNg+J6ItQbRt4Czu+UXfPhXeuaiGTPMk1aVLi1c8WPq2gWs09e8/hkrc3anr
	 97Ks9fwgh8quEHLpvCaUDEP6tWs2qBH4MuJ0jEgymacKftsHlhSwmynVt+rmZExPNz
	 oevCaR6xG63Kg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alain Volmat <alain.volmat@foss.st.com>,
	Antonio Quartulli <antonio@mandelbit.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 066/314] spi: stm32: fix missing pointer assignment in case of dma chaining
Date: Tue, 10 Mar 2026 07:15:25 -0400
Message-ID: <989b22bbe9b32527a6799d787a5cd10024971a74.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
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

