Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24E743AD7;
	Tue, 14 May 2024 11:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687248; cv=none; b=mSfqw/tBUt3iqV+/v+n8z2wabfO0i7oI5yasa58HrK8bonkZQc8dDS3btShBYSKRIpQpMMb7xluCPIHGCCIxaUuBlmTK4qIdOtzqSi5y8SOqIDzyAKUrAUjuWpVTrI6Tgv7gC02nQCn5vjAWWa/wy9gTbBXSUGpITE5ObYY8h2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687248; c=relaxed/simple;
	bh=AgfBbWO0/4ZLnqv+NSFHqzncDfTkHVYHQEhHiZKw3Pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KPO+R3UV3QywaU9APYQcMj1gJmHlyJH5Hw2BLec8MlJfOUHF8nwFJqdDdvtHzDQA/akSO9rKthmvh721Lhbw7+brUFwG4C0YfaQsF2+eMGUE/JXcZW9gg1EUAticNbKp1J6HK7yH/s34OpgOxvanox/FYo866EXdvuYRU7WDX/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nsg2qgyF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nsg2qgyF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E917C2BD10;
	Tue, 14 May 2024 11:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687247;
	bh=AgfBbWO0/4ZLnqv+NSFHqzncDfTkHVYHQEhHiZKw3Pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nsg2qgyFLMphP7vb0Q0BTVANQOAoWj70IcG8pIj+9nQZ0Aa6ISVb209gf2JcCNc4R
	 qmARGGSAuxRLGw5m+U1iWoK21ElZme0JWNm3aEuf4BnmzaFR7CLEFIyFfGatDtil3l
	 d7Vz+XuQVZoRkqEMtygmdzjuiv7Wzn6+/Bh4mhQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 031/111] ASoC: meson: axg-card: make links nonatomic
Date: Tue, 14 May 2024 12:19:29 +0200
Message-ID: <20240514100958.310183026@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit e138233e56e9829e65b6293887063a1a3ccb2d68 ]

Non atomic operations need to be performed in the trigger callback
of the TDM interfaces. Those are BEs but what matters is the nonatomic
flag of the FE in the DPCM context. Just set nonatomic for everything so,
at least, it is clear.

Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20211020114217.133153-2-jbrunet@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/meson/axg-card.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/meson/axg-card.c b/sound/soc/meson/axg-card.c
index 2b77010c2c5ce..cbbaa55d92a66 100644
--- a/sound/soc/meson/axg-card.c
+++ b/sound/soc/meson/axg-card.c
@@ -320,6 +320,7 @@ static int axg_card_add_link(struct snd_soc_card *card, struct device_node *np,
 
 	dai_link->cpus = cpu;
 	dai_link->num_cpus = 1;
+	dai_link->nonatomic = true;
 
 	ret = meson_card_parse_dai(card, np, &dai_link->cpus->of_node,
 				   &dai_link->cpus->dai_name);
-- 
2.43.0



