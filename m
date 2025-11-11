Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE72265CC5;
	Tue, 11 Nov 2025 01:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824370; cv=none; b=EiUeNO+xBQTdavLsG3nKNvVmKUPg5Ziu/attvsXoP3emYtjY0yBV5J9cNeSve3kLeszdz0RN/rNgLMMxZqnYag5kJxIJHhEPY9EaeLHnxP/eUckIIQhQ3wLz+L2d6Tg0+IrNNneHwRodPor0fV1cotMry1MVQcZkH0K9uXWNDNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824370; c=relaxed/simple;
	bh=Upkt8ggdWs5N4yFV8u7QiHwa+JH3aTtbbGLP3ujbL5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gAM/UDHHYSjIUE7IHobDLB8xtyhQfhoIO/U5VfplqjS2PNRePq26qZH4CJbXJ6to3Yo4BEClBSDWKWx5ilRl6DZIeQD9udU9cssRL+2TumblAfj/MyL3hPxSRyuTCWXwIVsXHuBoT9hbzhZzOkb2L3k4joYLq85gYRTzHHDu0K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hBWsIU5M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hBWsIU5M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C73C116D0;
	Tue, 11 Nov 2025 01:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824370;
	bh=Upkt8ggdWs5N4yFV8u7QiHwa+JH3aTtbbGLP3ujbL5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hBWsIU5Mg51zAEA2WXLHaObWJIWwEKHcA2Ng+1aC7o+7yY0Nnu77w/hYxawl735mR
	 49kjAULM9gU7bcqgKGEz+JHl4DnD5KKcW7arxK9mDR3YG2S+7Sez5zEn3RrRe7Wnr4
	 kH6z1Bt/g1SHqGIfucP/RzQuceXRhPYZ/etNX1qg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Moysan <olivier.moysan@foss.st.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 430/565] ASoC: stm32: sai: manage context in set_sysclk callback
Date: Tue, 11 Nov 2025 09:44:46 +0900
Message-ID: <20251111004536.545753585@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5828f9dd866e4..5938d6361e1ec 100644
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



