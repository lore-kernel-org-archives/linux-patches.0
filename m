Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498E3226D17;
	Wed, 30 Jul 2025 09:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869062; cv=none; b=qPuwOo94UELLuFZDTf0QoSIs6iWaILc2UOufqlxX0y1/8zjF9p7CSIIosqxqv2LmK+eQaW8m2tTCmqJDcjJRMJP/9VYppcARqbQOwRbuWUSiiC8NJSdVTYCJmCjJC6VtSuw5n3IRGn+CBr1kRZz31OqA2cFLpshw8Assw/LdbzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869062; c=relaxed/simple;
	bh=xTYTfK3EJcWk8a5sTrQ7K8Z52a0gNrUovwDgBg0+9Vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jbb1twniSxXCIESSmjHR5T8675foAMYqKd3/Ukk5mqBnEs+v6j5PvBbPdeShiLL72IwLU5dYFuULQPWf0tAPa4ArhXs4BG+/3cRBa7Xcsa0fwrq4zq8CvUYvbCSABJ8ogqf/j+BjAQAGS5luX8AdgBL5UJoPn8C4wcZ85r6ibiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O8OD2l21; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O8OD2l21"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE9A3C4CEF5;
	Wed, 30 Jul 2025 09:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869061;
	bh=xTYTfK3EJcWk8a5sTrQ7K8Z52a0gNrUovwDgBg0+9Vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O8OD2l211IPfDzs25NiDX0FQ2xDhKzrVyEL8ZdF1ar/QrLTGJAScYROh8HmpxPhXB
	 ImL3UueufCy5niyKysGGmfydB9OAhathosrKZyNLRbKiDqIKCooMETr5knkhqUlS08
	 qHgM6DKMNxFKygGlt54UCJSAotBkVrwcIDYCAf88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoqing Jiang <guoqing.jiang@canonical.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 26/92] ASoC: mediatek: mt8365-dai-i2s: pass correct size to mt8365_dai_set_priv
Date: Wed, 30 Jul 2025 11:35:34 +0200
Message-ID: <20250730093231.764539949@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guoqing Jiang <guoqing.jiang@canonical.com>

[ Upstream commit 6bea85979d05470e6416a2bb504a9bcd9178304c ]

Given mt8365_dai_set_priv allocate priv_size space to copy priv_data which
means we should pass mt8365_i2s_priv[i] or "struct mtk_afe_i2s_priv"
instead of afe_priv which has the size of "struct mt8365_afe_private".

Otherwise the KASAN complains about.

[   59.389765] BUG: KASAN: global-out-of-bounds in mt8365_dai_set_priv+0xc8/0x168 [snd_soc_mt8365_pcm]
...
[   59.394789] Call trace:
[   59.395167]  dump_backtrace+0xa0/0x128
[   59.395733]  show_stack+0x20/0x38
[   59.396238]  dump_stack_lvl+0xe8/0x148
[   59.396806]  print_report+0x37c/0x5e0
[   59.397358]  kasan_report+0xac/0xf8
[   59.397885]  kasan_check_range+0xe8/0x190
[   59.398485]  asan_memcpy+0x3c/0x98
[   59.399022]  mt8365_dai_set_priv+0xc8/0x168 [snd_soc_mt8365_pcm]
[   59.399928]  mt8365_dai_i2s_register+0x1e8/0x2b0 [snd_soc_mt8365_pcm]
[   59.400893]  mt8365_afe_pcm_dev_probe+0x4d0/0xdf0 [snd_soc_mt8365_pcm]
[   59.401873]  platform_probe+0xcc/0x228
[   59.402442]  really_probe+0x340/0x9e8
[   59.402992]  driver_probe_device+0x16c/0x3f8
[   59.403638]  driver_probe_device+0x64/0x1d8
[   59.404256]  driver_attach+0x1dc/0x4c8
[   59.404840]  bus_for_each_dev+0x100/0x190
[   59.405442]  driver_attach+0x44/0x68
[   59.405980]  bus_add_driver+0x23c/0x500
[   59.406550]  driver_register+0xf8/0x3d0
[   59.407122]  platform_driver_register+0x68/0x98
[   59.407810]  mt8365_afe_pcm_driver_init+0x2c/0xff8 [snd_soc_mt8365_pcm]

Fixes: 402bbb13a195 ("ASoC: mediatek: mt8365: Add I2S DAI support")
Signed-off-by: Guoqing Jiang <guoqing.jiang@canonical.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patch.msgid.link/20250710011806.134507-1-guoqing.jiang@canonical.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8365/mt8365-dai-i2s.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/mediatek/mt8365/mt8365-dai-i2s.c b/sound/soc/mediatek/mt8365/mt8365-dai-i2s.c
index cae51756cead8..cb9beb172ed59 100644
--- a/sound/soc/mediatek/mt8365/mt8365-dai-i2s.c
+++ b/sound/soc/mediatek/mt8365/mt8365-dai-i2s.c
@@ -812,11 +812,10 @@ static const struct snd_soc_dapm_route mtk_dai_i2s_routes[] = {
 static int mt8365_dai_i2s_set_priv(struct mtk_base_afe *afe)
 {
 	int i, ret;
-	struct mt8365_afe_private *afe_priv = afe->platform_priv;
 
 	for (i = 0; i < DAI_I2S_NUM; i++) {
 		ret = mt8365_dai_set_priv(afe, mt8365_i2s_priv[i].id,
-					  sizeof(*afe_priv),
+					  sizeof(mt8365_i2s_priv[i]),
 					  &mt8365_i2s_priv[i]);
 		if (ret)
 			return ret;
-- 
2.39.5



