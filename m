Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2744F93B3;
	Thu, 17 Sep 2026 17:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667903; cv=none; b=n6ko9VUj3+6kitAVVuBAzd8SprCNRZTLgmyj0i4tlbU1qW9xUOayANyyuvL8nVLHgdgv8U9w6ifYmynvMVhGSuA4n1EYQQpNaQ0ydNwbU4m5omNIlJ8wajJUrmWg8jR/ux6JozOaxG1mvCA9sAvpyFlgRJFu/D39d1f+Aej0sfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667903; c=relaxed/simple;
	bh=e29NB1pL/EysM6ni+YTtRgtadXIrVkEb/Yn5oHxnSP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nI2VMFZ30XxK6MMyLlHxf1+3gMmXmb+Vu2hRomJCyeHV6VGrqRAPISHADcKFq/q274HI0e4Nc8o8fXrZfTHsNUq6c2KoFzq/P2LySEoVbOGJhn4tpjJWHPy6dtbkccwnQnwc1M42ND5ttq+13o3q3Kg5xyIYzEfKaDFNecl6HNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WIrLymzT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WIrLymzT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B5D1F000FF;
	Thu, 17 Sep 2026 17:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667902;
	bh=Bc8phNn1Y8kCATMSwvb7hMBV3o7L5MZbgwdw9RCq5lQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WIrLymzTehfscLWVm/zQoBjRSmhmwZzTRgrtf5E8jzLLVxjrIN44kKkCZiqfNpX/l
	 Ts8WB+BPi3/pDvyTW8apLq5hjQeoC7KxNzBl0voc1kk7rxM+3Im4GSa5PALpVSmhzX
	 wrf1jgpMN5lnqtJO7gS4c78Q7SUJoTjyxIFX8rp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tuo Li <islituo@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0246/1102] ASoC: mediatek: mt8365-afe-pcm: fix possible NULL-pointer dereferences in mt8365_afe_suspend()
Date: Thu, 17 Sep 2026 16:03:09 +0100
Message-ID: <20260917151545.770312324@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Tuo Li <islituo@gmail.com>

[ Upstream commit b8948ac26efc395264a47f9a743889065adb5cff ]

mt8365_afe_suspend() allocates the register backup buffer with
devm_kcalloc(), but does not check for allocation failure before using the
returned pointer. This may lead to a NULL pointer dereference when
accessing afe->reg_back_up[i].

Add the missing NULL check and return -ENOMEM on allocation failure after
disabling the main clock.

Also propagate the return value of mt8365_afe_suspend() in
mt8365_afe_dev_runtime_suspend() so that the suspended state is not updated
when suspend fails.

Signed-off-by: Tuo Li <islituo@gmail.com>
Link: https://patch.msgid.link/20260528064107.470824-1-islituo@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8365/mt8365-afe-pcm.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/sound/soc/mediatek/mt8365/mt8365-afe-pcm.c b/sound/soc/mediatek/mt8365/mt8365-afe-pcm.c
index 743b465721441..23cfcf7160e3d 100644
--- a/sound/soc/mediatek/mt8365/mt8365-afe-pcm.c
+++ b/sound/soc/mediatek/mt8365/mt8365-afe-pcm.c
@@ -1975,10 +1975,15 @@ static int __maybe_unused mt8365_afe_suspend(struct device *dev)
 
 	mt8365_afe_enable_main_clk(afe);
 
-	if (!afe->reg_back_up)
+	if (!afe->reg_back_up) {
 		afe->reg_back_up =
 			devm_kcalloc(dev, afe->reg_back_up_list_num,
 				     sizeof(unsigned int), GFP_KERNEL);
+		if (!afe->reg_back_up) {
+			mt8365_afe_disable_main_clk(afe);
+			return -ENOMEM;
+		}
+	}
 
 	for (i = 0; i < afe->reg_back_up_list_num; i++)
 		regmap_read(regmap, afe->reg_back_up_list[i],
@@ -2012,11 +2017,15 @@ static int __maybe_unused mt8365_afe_resume(struct device *dev)
 static int __maybe_unused mt8365_afe_dev_runtime_suspend(struct device *dev)
 {
 	struct mtk_base_afe *afe = dev_get_drvdata(dev);
+	int ret;
 
 	if (pm_runtime_status_suspended(dev) || afe->suspended)
 		return 0;
 
-	mt8365_afe_suspend(dev);
+	ret = mt8365_afe_suspend(dev);
+	if (ret)
+		return ret;
+
 	afe->suspended = true;
 	return 0;
 }
-- 
2.53.0



