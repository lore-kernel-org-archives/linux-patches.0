Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D97F2DB785;
	Wed, 30 Sep 2026 18:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794454; cv=none; b=SKokfXk3WrprrGui9+wL3BPsEu5iKxLUG3kEwhlDBakSX7iybcZcdi5Zk7/h7o4q5ewPrnuS2jo0sYYcJJSBmCv2U0I2fvSDY9w0Lsj3MWiQNRzne52nmLraEgP+rxKtECUqPUSEIlYpvO5DBoTPtRzUCUkhp0eVNduoc6kkOAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794454; c=relaxed/simple;
	bh=motB3TlBTFB9uWgAIZ7NL75zrU8ZHcq9JFtsw+fj7HI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZyCJGy1uWZQJ1KfaGhvRy1W3vMhZm0z1DeyzvZRz+Kzw3fFXljMFLc/Q1RN7BLJTcMhq//SsxegJQdZcfqF+BNkH50IQ/VoUt/gwT82pWo6A1G7fOAh0P4l4epSPlkUh6t/JDEKDZqipXuhomegmPf6S18Zhy5BT8D5xxTU2eNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TA1ccrVg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TA1ccrVg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 314631F000FF;
	Wed, 30 Sep 2026 18:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794452;
	bh=xjSv39X+O8NZ70v4aCzupAjYhI1o76CGu527scJ+FXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TA1ccrVgeEXLmQCx51W/CSTcL8bDkTf09Mnej3mLTBFXb1TwYiLET4fSZYhhSfoj8
	 3UXHtWvjfxBFT04fghdCacDlfHZF4xYUFTds9pN/5PNUVAbka0RbLkaQBxXzMnrTxs
	 VXj76kOUXM0lI+jK5KdEWOi5khHehnSy8Q6nbGaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI Review <sashiko-bot@kernel.org>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0216/1193] ASoC: rockchip: spdif: Restore regcache cache-only mode on sync failure
Date: Wed, 30 Sep 2026 17:15:00 +0200
Message-ID: <20260930152439.000455777@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1a24b78e9e02a..4d873c31fc031 100644
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



