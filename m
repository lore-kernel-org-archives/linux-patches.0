Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E99B1A6192;
	Tue, 30 Jul 2024 17:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359055; cv=none; b=lWkTDXvKv97EEPkSiBVekps/dfNvknEmaDG62iRWMbhzzX03VdtAtEQ6VTkGz9/l2YheCZdo7spdBxtBHemUrnip9r0vhslD94slpi9CtOZebsmDl3dZdird8EPhDjsjgny+JsrlXLm+HOSZexE5ZhpvbObKVFmANyFFsOUSC7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359055; c=relaxed/simple;
	bh=MIKlL4lf35btrYaQ06hBu7hNMAJj+oIbvPf5qRUyhtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KxPgt/1VTCIfVyyIF75V/2gGNqdQLC8pR0S8JxmCZVCxdg1cXMANjx8Cwn2kfva743Dx4qosR4HAAB/wjcF6FTUiuSe/7PjWe5ovDNAbBzwzojo+u3lUNcNwNXuASYzFUMNf2cxbiwgpdfLThhLtaGmJhwQU0lqur+4WsnIER9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=chvJLGQs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="chvJLGQs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C05E3C32782;
	Tue, 30 Jul 2024 17:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359055;
	bh=MIKlL4lf35btrYaQ06hBu7hNMAJj+oIbvPf5qRUyhtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=chvJLGQs9YiWnuKeP+alqd/x9L0rYWX6NkT/ZakZOPIiYqlG6TNJ/85quXYa9/lxp
	 Lr02pt+rhFGrCWcbUDKtL5JpxbgZiyUQz+wlCUwSf+GYfTSKoj29Vh3NgJX9bAZqyA
	 NGXLVRh1iVXpIHI405XuGFfMXAqR4OroKz8AnkvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 427/809] ASoC: max98088: Check for clk_prepare_enable() error
Date: Tue, 30 Jul 2024 17:45:03 +0200
Message-ID: <20240730151741.563296542@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 1a70579723fde3624a72dfea6e79e55be6e36659 ]

clk_prepare_enable() may fail, so we should better check its return
value and propagate it in the case of error.

Fixes: 62a7fc32a628 ("ASoC: max98088: Add master clock handling")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Link: https://patch.msgid.link/20240628080534.843815-1-nichen@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98088.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/max98088.c b/sound/soc/codecs/max98088.c
index 8b56ee550c09e..8b0645c634620 100644
--- a/sound/soc/codecs/max98088.c
+++ b/sound/soc/codecs/max98088.c
@@ -1318,6 +1318,7 @@ static int max98088_set_bias_level(struct snd_soc_component *component,
                                   enum snd_soc_bias_level level)
 {
 	struct max98088_priv *max98088 = snd_soc_component_get_drvdata(component);
+	int ret;
 
 	switch (level) {
 	case SND_SOC_BIAS_ON:
@@ -1333,10 +1334,13 @@ static int max98088_set_bias_level(struct snd_soc_component *component,
 		 */
 		if (!IS_ERR(max98088->mclk)) {
 			if (snd_soc_component_get_bias_level(component) ==
-			    SND_SOC_BIAS_ON)
+			    SND_SOC_BIAS_ON) {
 				clk_disable_unprepare(max98088->mclk);
-			else
-				clk_prepare_enable(max98088->mclk);
+			} else {
+				ret = clk_prepare_enable(max98088->mclk);
+				if (ret)
+					return ret;
+			}
 		}
 		break;
 
-- 
2.43.0



