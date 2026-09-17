Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4527535FA8;
	Thu, 17 Sep 2026 17:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664529; cv=none; b=Dx7bL+bUtg2bJp8Cwzr7+2UFpuHRhCJcJP//0cWF9KREMFdpdSEpjLAVejVlLO7e1euyGY8z6VaWIveXqe4sk5GYm2D9iWMyz6a4zzbDOKR8wxPHrqZiuxwJCgRLxEyLP+FHJu/WrFLg6kbK1joolCpUEWIzs44BKWPq+lpSlZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664529; c=relaxed/simple;
	bh=PYk71ssYIpOrdVN3/kn43OuHCVJ8/wJkEgEvZP+64FA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dnbg1lo44wYxJgji24PbobJ/wSG3MtF85nTv8uX3hCUvFJ5e0J2WusibjSbHDKH6SNeb5apf800SA1hISR3Z0dPn7YMroSzYRCj1MUzaw/ywpAQvKIaO9QRBDm7k3E0y9lK3bqyTB7mLhexARRV+Y+qljd3zquN2MFCRFnilVQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dctnMi+W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dctnMi+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E704C1F000FF;
	Thu, 17 Sep 2026 17:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664528;
	bh=N0EgeF0ATohklC1ejVcl5ZyE91B9AjTETbFueqQRCXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dctnMi+WIPnNg4J84v9IpZNQHWHUZ22PndXOfyeFiOIglZNhPqVx/IftOSyQWAvjt
	 2L0PVepiv9m+hyZCwqE+9qyUDjjZpvDVG/enswRezCXX+gtFW85bzm+Dkmy37NxEZU
	 v3zjOUeVAPeW0R+/w0zjJ771BmaC57i98VezJUKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI Review <sashiko-bot@kernel.org>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0403/1250] ASoC: rockchip: spdif: Restore regcache cache-only mode on sync failure
Date: Thu, 17 Sep 2026 16:03:18 +0100
Message-ID: <20260917151602.950348165@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d365168934dc6..7a15f680de2fe 100644
--- a/sound/soc/rockchip/rockchip_spdif.c
+++ b/sound/soc/rockchip/rockchip_spdif.c
@@ -97,6 +97,7 @@ static int rk_spdif_runtime_resume(struct device *dev)
 
 	ret = regcache_sync(spdif->regmap);
 	if (ret) {
+		regcache_cache_only(spdif->regmap, true);
 		clk_disable_unprepare(spdif->mclk);
 		clk_disable_unprepare(spdif->hclk);
 	}
-- 
2.53.0



