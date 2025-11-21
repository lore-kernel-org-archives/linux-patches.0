Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5939F242D7D;
	Fri, 21 Nov 2025 13:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732998; cv=none; b=kWEVorocQqt9WeV6Be/gJJXN+fvG6QdWj7LImyrhd4DV7vawRlo5FDThTaxCKdnkK33zwdMPbUx5mUdelC1bvEAl1Twg00gTsJr3RkGs6WpBkEpx4uqgig+09DdjSZgBCr4e5fQ2U9ieR51RppITw3Q499EmufD/jHPFT9M3fCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732998; c=relaxed/simple;
	bh=BM/+/LNwAOBlZeJnyIcqCAvj82m76dc/c1xXLieo6ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rmgPAYjkB/VAgTTne1XahoM5JFMg7BZzvwCjACAh79AcwHoHb44itwTIuEJ6psBgQDHuBvCRWOxBl407Q5yia7AlXW8ggaO4bDD2gF2Cqyu83fVlEPA89u5qZ3vU++xfITsXaJD5/WvORpMTXcp7dbslREMtMpoIrz4mXnb47Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J2SujUdw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J2SujUdw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6090C116C6;
	Fri, 21 Nov 2025 13:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732998;
	bh=BM/+/LNwAOBlZeJnyIcqCAvj82m76dc/c1xXLieo6ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J2SujUdw24oX6eGWCRhgaimDpH/bBjXUzxISv+Nm1dADKBd07ZpgVirmF5oqoAIuI
	 Bb4e+TAPT0qxRcjzlWz0UB8ev/USc2GKkskaCtl4xNT49LurxNofgKUu0uMeAl1gEe
	 Qs/8o5iX80NhveEcNHKBOX3nt+tqZHPrpTzuvd9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Moysan <olivier.moysan@foss.st.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 282/529] ASoC: stm32: sai: manage context in set_sysclk callback
Date: Fri, 21 Nov 2025 14:09:41 +0100
Message-ID: <20251121130241.063951769@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olivier Moysan <olivier.moysan@foss.st.com>

[ Upstream commit 27fa1a8b2803dfd88c39f03b0969c55f667cdc43 ]

The mclk direction now needs to be specified in endpoint node with
"system-clock-direction-out" property. However some calls to the
set_sysclk callback, related to CPU DAI clock, result in unbalanced
calls to clock API.
The set_sysclk callback in STM32 SAI driver is intended only for mclk
management. So it is relevant to ensure that calls to set_sysclk are
related to mclk only.
Since the master clock is handled only at runtime, skip the calls to
set_sysclk in the initialization phase.

Signed-off-by: Olivier Moysan <olivier.moysan@foss.st.com>
Link: https://patch.msgid.link/20250916123118.84175-1-olivier.moysan@foss.st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/stm/stm32_sai_sub.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/soc/stm/stm32_sai_sub.c b/sound/soc/stm/stm32_sai_sub.c
index dcbcd1a59a3aa..351e96163406b 100644
--- a/sound/soc/stm/stm32_sai_sub.c
+++ b/sound/soc/stm/stm32_sai_sub.c
@@ -551,6 +551,14 @@ static int stm32_sai_set_sysclk(struct snd_soc_dai *cpu_dai,
 	struct stm32_sai_sub_data *sai = snd_soc_dai_get_drvdata(cpu_dai);
 	int ret;
 
+	/*
+	 * The mclk rate is determined at runtime from the audio stream rate.
+	 * Skip calls to the set_sysclk callback that are not relevant during the
+	 * initialization phase.
+	 */
+	if (!snd_soc_card_is_instantiated(cpu_dai->component->card))
+		return 0;
+
 	if (dir == SND_SOC_CLOCK_OUT && sai->sai_mclk) {
 		ret = stm32_sai_sub_reg_up(sai, STM_SAI_CR1_REGX,
 					   SAI_XCR1_NODIV,
-- 
2.51.0



