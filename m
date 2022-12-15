Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF415692
	for <patches@lists.linux.dev>; Thu, 15 Dec 2022 18:10:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E096C433F2;
	Thu, 15 Dec 2022 18:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1671127858;
	bh=ZaQD/WVS9g1OcjcjJYZXkfWsF/I/ER9r62lK5f8TOd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vMjRmroxIi/Zcrs0s4YM/VTC7uFg3TndWskzM6gS8ieYN//N2tzV8HWM1GVA5q9Qj
	 GaaPNebp9mc6GBQY8GmQK3b3IRTH2zn208CqF9pgQ/iHATJQxooQjz1FojnwJt9ykR
	 0tVvenKTq+5P3R8cIyLr8+YUy5yuiNVdlZEUAHp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 6/9] ASoC: ops: Check bounds for second channel in snd_soc_put_volsw_sx()
Date: Thu, 15 Dec 2022 19:10:33 +0100
Message-Id: <20221215172905.693906724@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221215172905.468656378@linuxfoundation.org>
References: <20221215172905.468656378@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 97eea946b93961fffd29448dcda7398d0d51c4b2 ]

The bounds checks in snd_soc_put_volsw_sx() are only being applied to the
first channel, meaning it is possible to write out of bounds values to the
second channel in stereo controls. Add appropriate checks.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20220511134137.169575-2-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-ops.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
index 2faf95d4bb75..fbd46a737652 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -460,6 +460,12 @@ int snd_soc_put_volsw_sx(struct snd_kcontrol *kcontrol,
 	if (snd_soc_volsw_is_stereo(mc)) {
 		val_mask = mask << rshift;
 		val2 = (ucontrol->value.integer.value[1] + min) & mask;
+
+		if (mc->platform_max && val2 > mc->platform_max)
+			return -EINVAL;
+		if (val2 > max)
+			return -EINVAL;
+
 		val2 = val2 << rshift;
 
 		err = snd_soc_component_update_bits(component, reg2, val_mask,
-- 
2.35.1



