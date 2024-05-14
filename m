Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9AAC12BF3D;
	Tue, 14 May 2024 10:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682461; cv=none; b=k9Zqpae2aUVgAfHSf5iAfHOpy/HG7PEHoDhojoCVPdeqBqum1kPKjfvz5v3QM3Pk0OH+CuvFvF1MutrPsTTrC70FBR6Fapjrmje1Jo/hluMarbJTy1KvUBb97P4h2GipMh3vJFdcQhkz1tw3XmeSIAyZQH+Z08XfXuXjjaoE0bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682461; c=relaxed/simple;
	bh=Jw1lCKW6H9y41u6Sp0CmPUDPBjqjW4tbqJKz91vzBgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ATFEbykdo0l8oJCW9b8fiFILaB0x6Us2z9KbTmuTotsJ7m9XfKcdceH1QP8DHU+dw55u5BTrk7bmQDo7dyaHVvt3yKrQ3cgQY857xO+W72Bs8st/ocf78H1uBhvYN99Ewy2z80mLMjLMtzMoTDKgcagBhnnFoGG9xTHFa+hv5CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ya70bkMs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ya70bkMs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E360C2BD10;
	Tue, 14 May 2024 10:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682461;
	bh=Jw1lCKW6H9y41u6Sp0CmPUDPBjqjW4tbqJKz91vzBgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ya70bkMsWzgPUg8kEP7oMEtE0j3uf8BM6LPsEZOjdzd+Atk1wnpsAnCIbw4X/O4hk
	 Ct6hkJfmYnE6wgTqbSQywmYoaiMsxzO5HOtzN6oQC0fr7V3ZXyp3qAEXNJgcluSch/
	 fzw38l7m++S6KRxe+6903Ap9sdGOH0p/lP2a45Yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 065/336] ASoC: meson: axg-card: make links nonatomic
Date: Tue, 14 May 2024 12:14:29 +0200
Message-ID: <20240514101041.061487253@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit dcba52ace7d4c12e2c8c273eff55ea03a84c8baf ]

Non atomic operations need to be performed in the trigger callback
of the TDM interfaces. Those are BEs but what matters is the nonatomic
flag of the FE in the DPCM context. Just set nonatomic for everything so,
at least, what is done is clear.

Fixes: 7864a79f37b5 ("ASoC: meson: add axg sound card support")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20240426152946.3078805-3-jbrunet@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/meson/axg-card.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/meson/axg-card.c b/sound/soc/meson/axg-card.c
index 3180aa4d3a157..8c5605c1e34e8 100644
--- a/sound/soc/meson/axg-card.c
+++ b/sound/soc/meson/axg-card.c
@@ -318,6 +318,7 @@ static int axg_card_add_link(struct snd_soc_card *card, struct device_node *np,
 
 	dai_link->cpus = cpu;
 	dai_link->num_cpus = 1;
+	dai_link->nonatomic = true;
 
 	ret = meson_card_parse_dai(card, np, dai_link->cpus);
 	if (ret)
-- 
2.43.0



