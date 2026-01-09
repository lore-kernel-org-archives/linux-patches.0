Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CF233032C;
	Fri,  9 Jan 2026 12:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960067; cv=none; b=cuY3UBX5sWgVGffkFWtMa77XRuW7p8S7q727lB5p2UDA+6QiomKfKUvcou9/5NYUun6vcTV5gLLDPCWRn2y7tDeE6Bq/ZB0kKT+wkT/5OZ9jGncIhRkj+cQMZbf3i2Fzm1T/rOxBpvBsUOgPT+Pz8J3DTCabTq5jMAFzkWQlRlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960067; c=relaxed/simple;
	bh=YkhSEstTa4WQYU4bKv/6zRFgCxQRk/TI5DNAMVNMvJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OtOBljbstOsygotyTwRfD9awhcP/aFCLhnCPqAKUlsUcxH9U2GU7XxlIQsZrNBI4ATdyAoTxKOPzbL+NQQRzBhgoZo+OM2/WSsTSSOi53gyi4oswtQh1E7s46DOjs5jOlGtEJD6GFHymMgG6Mgg5qrjrIV4EnzC0mOnImfarm6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GK0y5jam; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GK0y5jam"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D08C19421;
	Fri,  9 Jan 2026 12:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960067;
	bh=YkhSEstTa4WQYU4bKv/6zRFgCxQRk/TI5DNAMVNMvJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GK0y5jamFX4sDlHur8CDzenPJdLDRV2U68vVMo6eY9UcwjjHNpewI+0VinnoQRM7t
	 69ZTIT9A/VL8jv2pES6SiuBKvvdeDbygb1wER2KTfC2r+mkER0MWT680NttSVyeD6b
	 e3tQpVP9Iu00O8ckd4omIZi52VXe0K/fkVLgp218=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 273/737] ASoC: ak4458: Disable regulator when error happens
Date: Fri,  9 Jan 2026 12:36:52 +0100
Message-ID: <20260109112144.269922724@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit ae585fabb9713a43e358cf606451386757225c95 ]

Disable regulator in runtime resume when error happens to balance
the reference count of regulator.

Fixes: 7e3096e8f823 ("ASoC: ak4458: Add regulator support")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20251203100529.3841203-2-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/ak4458.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/ak4458.c b/sound/soc/codecs/ak4458.c
index 77678f85ad946..ec8771158ab25 100644
--- a/sound/soc/codecs/ak4458.c
+++ b/sound/soc/codecs/ak4458.c
@@ -681,7 +681,15 @@ static int __maybe_unused ak4458_runtime_resume(struct device *dev)
 	regcache_cache_only(ak4458->regmap, false);
 	regcache_mark_dirty(ak4458->regmap);
 
-	return regcache_sync(ak4458->regmap);
+	ret = regcache_sync(ak4458->regmap);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	regcache_cache_only(ak4458->regmap, true);
+	regulator_bulk_disable(ARRAY_SIZE(ak4458->supplies), ak4458->supplies);
+	return ret;
 }
 #endif /* CONFIG_PM */
 
-- 
2.51.0



