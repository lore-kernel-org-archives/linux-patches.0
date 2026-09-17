Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6636A4D1799;
	Thu, 17 Sep 2026 18:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668049; cv=none; b=e1XtJ+tXW/YAYevfAnZAiQ0ao6Tz+GGOGHx8OJxcVsXcVCo6KZxmWUazz/r/YdgQoTQQ3WaQUOLjSVXzNIrc/w+bpwGlcLIIS8EE/BRvkom78IqHDoEpSBH6AOAttBASvX6oOyGqnd8l5m7+DLmncmlTARdYe0fsLplTXMfxkzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668049; c=relaxed/simple;
	bh=U2rbGxbFQtfOPIw5bjqxqEjN6OLN6RrTe5k/f/dyeuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q4LgjSRxyxYZUpCwch87uvAcMWEja4qXPURiCeeIRyo9HAllVXwk7hKzezDU+8+FdH1z8BDta2c29z7/Kghj9BOKFiMzRJ1J2icVlr9lbjFUpp3TPampx4Ugx/hdd8LQJMDl+lJKcebLvihysOh48srBIstaA8eTt/dIQLPUbC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JT1HTQhg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JT1HTQhg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD1B11F000FF;
	Thu, 17 Sep 2026 18:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668048;
	bh=PH9aHrPiEajXaVBfzPI8O0lCfL6tVWJFaiexBwc5a4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JT1HTQhgIGDCcfYjtdo1Vcjp6kvDTi6+E3i9AXgYnv0VLFYDcNuNinzGwG7dezBF/
	 ouDvpRZx5JYXDISMpdi/o4pN5SEQdlK4/tDp0v+jss8jWZOaZPcErvUzO5pQA6Mz8z
	 vIbYIoziiG9vId0iAmL53NU+mAFIPJyKS30ePvmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI Review <sashiko-bot@kernel.org>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0297/1102] ASoC: rockchip: spdif: Restore regcache cache-only mode on sync failure
Date: Thu, 17 Sep 2026 16:04:00 +0100
Message-ID: <20260917151547.074850741@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 3546e9aa691ac981e4734fedd1646d0180784893 ]

If regcache_sync() fails during runtime resume, the driver disables the
clocks and returns an error. However, the regmap cache-only mode is left
disabled.
Restore cache-only mode in the error path so subsequent register accesses
continue to use the cache while the device is inactive.

Reported-by: Sashiko AI Review <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260522103713.6C09D1F000E9@smtp.kernel.org/
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260602101608.45137-5-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rockchip_spdif.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/rockchip/rockchip_spdif.c b/sound/soc/rockchip/rockchip_spdif.c
index d87c0e4f6f91c..0b3f0f81a7832 100644
--- a/sound/soc/rockchip/rockchip_spdif.c
+++ b/sound/soc/rockchip/rockchip_spdif.c
@@ -97,6 +97,7 @@ static int __maybe_unused rk_spdif_runtime_resume(struct device *dev)
 
 	ret = regcache_sync(spdif->regmap);
 	if (ret) {
+		regcache_cache_only(spdif->regmap, true);
 		clk_disable_unprepare(spdif->mclk);
 		clk_disable_unprepare(spdif->hclk);
 	}
-- 
2.53.0



