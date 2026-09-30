Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C60E522EEB;
	Wed, 30 Sep 2026 17:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790987; cv=none; b=e5MY+THJFqZHs6Vn0Ii8/LtoAgwkjp4ot227SbgKuuIPdlRgl9laPK7zVk544b1yaCa6YTkHhYbqOxuUPNgu04Afw3uZTKovPKdRKsWGP0QY7GxlZUt4uhvaxMBkg/VQahQXagaoJ1cXw0vdMegcuIXLwngq5pu8N0iGJL2pn7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790987; c=relaxed/simple;
	bh=bL3TaRXrV3ZFFWQWtoZHvez6OCkE3jx1vcVwSCrgF+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YeirUn9rXDCplHoCACEMfscaHn6/DGbasyb1/DdCdptJtMz0UFwbv2cVOYlieG6iXoosJITXZZSSokP/5x03xpk8+2TzLWOirXFMecmFcUzNdP6WznMXn6WVwNYArxjLBzYdehVrVacFrKp0LxDldBQy6oH2c+uwXr5dPVbr+GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EwMGO4p7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EwMGO4p7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A34B51F000FF;
	Wed, 30 Sep 2026 17:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790986;
	bh=EQNAK8JAIqnnB7q9skIk3aPYM+IEctBit9/jPso3xGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EwMGO4p78CrLzSJFwbySMvdf5fYf8zP02GiW7nlBMRv92b1HDjjFDQ9Zq/iI0ZoOC
	 eUPziY1q/DNvllhN/RGK/J2CzTxKvm5tYBIYsavHX+GWQWAWlvwkuCnaisH83ugF0F
	 o4wnlWg4s9grDTqZkP0QOjh/DatOzuTH/UeeguHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI Review <sashiko-bot@kernel.org>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 145/752] ASoC: rockchip: spdif: Restore regcache cache-only mode on sync failure
Date: Wed, 30 Sep 2026 17:20:15 +0200
Message-ID: <20260930152401.318991075@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 09a25d84fee6f..3c6d7852496ca 100644
--- a/sound/soc/rockchip/rockchip_spdif.c
+++ b/sound/soc/rockchip/rockchip_spdif.c
@@ -98,6 +98,7 @@ static int __maybe_unused rk_spdif_runtime_resume(struct device *dev)
 
 	ret = regcache_sync(spdif->regmap);
 	if (ret) {
+		regcache_cache_only(spdif->regmap, true);
 		clk_disable_unprepare(spdif->mclk);
 		clk_disable_unprepare(spdif->hclk);
 	}
-- 
2.53.0



