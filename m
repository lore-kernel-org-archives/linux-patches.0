Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C371386B5;
	Tue, 14 May 2024 11:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686240; cv=none; b=nuTFVzcHU6zxPsE8XPAi1ScIdwpmmSgs06qGVajjUk8oIS4l/i9qGxaMLTpSrVlc3AuTdfdJE3oYRkVlqpaDnFmbYA7PTTrDfeIDiLKGbOQg2BMaNjrmLUROtdCRrumcsqu0rVMQDLAHYdsDl59qae0nXCTb5TAjZ7gDZmDOYO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686240; c=relaxed/simple;
	bh=PAhm3VSGhXWmt0QaSA/wT1w1kgnN5/wIwJB6GJQwkug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kBXmHrUSsp32p9uZGc6fHsd8NrYhd5PnUT+wG073+CckufNtteyVwF+GcNqbnClI3M76po8BVg/CKUibPFp/8iLBgkyONBlKSmP0cO/SI3p12Kn1LXPkSV57sMpPMFzW1iPRam3WxW36A6jpbCyunoXc4q/so1ya9Mn7tQCG3WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kQTBuNrm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kQTBuNrm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08D40C32781;
	Tue, 14 May 2024 11:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686240;
	bh=PAhm3VSGhXWmt0QaSA/wT1w1kgnN5/wIwJB6GJQwkug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kQTBuNrmTI92EzWtj7UeEaQjTkQ/OkoSeyDQClGke2yJtqSX+7EwcV779VrIpgJ/K
	 T5E9Yasfmv4K5iYbgw3ozL5oFQDUr3ro586AcoWw6RHTow/Wi55ocJR1HcoaG6VFBB
	 EgsuhzpPXTx0BRu9isegzF297rv/a9KFrehHQu8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 069/236] ASoC: meson: axg-card: make links nonatomic
Date: Tue, 14 May 2024 12:17:11 +0200
Message-ID: <20240514101022.992040030@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



