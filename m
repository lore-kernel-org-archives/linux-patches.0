Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF09D569B
	for <patches@lists.linux.dev>; Thu, 15 Dec 2022 18:12:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3370AC433D2;
	Thu, 15 Dec 2022 18:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1671127920;
	bh=sWDo0iPkrkJrHf9mUBKL2xPVrM+dCIQL6+HAid6XPTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WwfXg0mo8IVe2Brug1QuIWgVw923ajsFnX6zkvvTfcXBwj0SaAnQYOmzwQwzPhw5F
	 Zg6yzUrXNVDPCwSkOGRG+7kbuopJof9PiQWNS+yPr8mJ/v5jmIFlp6jvQwsvUFFAdR
	 a1s605P0QA/ASicnIDhQToHmnJA42UHYl4GYBLn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 09/15] ASoC: ops: Check bounds for second channel in snd_soc_put_volsw_sx()
Date: Thu, 15 Dec 2022 19:10:36 +0100
Message-Id: <20221215172907.393349890@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221215172906.638553794@linuxfoundation.org>
References: <20221215172906.638553794@linuxfoundation.org>
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
index 5fdd96e77ef3..fe93458d864a 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -447,6 +447,12 @@ int snd_soc_put_volsw_sx(struct snd_kcontrol *kcontrol,
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



