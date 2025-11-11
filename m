Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0442ED17A;
	Tue, 11 Nov 2025 01:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825075; cv=none; b=XFO6OQzHS4zof6h2wryY4PfI6VYwdbG77iOKhvaUn3qOM9mD9BAOaXCMUD2tO+fs4w8yZMG2s/SvO+yi33vNos5oc4OzRZwsbeKQ5xQtxniG4Ie80e8Wu2OepalflWc9Yb+nQrly9NxSUVZUej2BF2IaAZBo+TivOEZqU+57pCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825075; c=relaxed/simple;
	bh=cssEvAyJnjQqbUG90ogGV+vZDzC2VXVtH6AEw8A7hJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eq3ZQdLHxJTzMoTi66XBWUlVyhUms3m6uEfJak9zgDF1ze4QxfrsHGpRoedR15IHkwnaroxj4MuybWPf9AHSkA3gNdy6ls7UmuX1yNiVDciMeE03SmdoHm0YwePEIbaBi71EhWzDtoyM497F2irM9/IfmWiU0AXgS+zZCG4s8fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=loAf+EWi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="loAf+EWi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9BCC116B1;
	Tue, 11 Nov 2025 01:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825075;
	bh=cssEvAyJnjQqbUG90ogGV+vZDzC2VXVtH6AEw8A7hJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=loAf+EWilwwtTpheFF1PHK3D2795NIF66HG0kFMCwp24V43mWFlhWE39/u0a/yeGa
	 5bmGzuTgE0/gYuQJr0tmes1GZFTHly3gntWm0MG84NqNHbKlTk03PGHQHZZEkeY9YC
	 0Px7hU0svboyeKIFGEDuw9Y5quhl7dA+Jie/xX18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Moysan <olivier.moysan@foss.st.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 649/849] ASoC: stm32: sai: manage context in set_sysclk callback
Date: Tue, 11 Nov 2025 09:43:39 +0900
Message-ID: <20251111004552.117372565@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 463a2b7d023b9..0ae1eae2a59e2 100644
--- a/sound/soc/stm/stm32_sai_sub.c
+++ b/sound/soc/stm/stm32_sai_sub.c
@@ -672,6 +672,14 @@ static int stm32_sai_set_sysclk(struct snd_soc_dai *cpu_dai,
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



