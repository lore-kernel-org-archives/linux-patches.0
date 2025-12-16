Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A511035505E;
	Tue, 16 Dec 2025 12:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888515; cv=none; b=Ufq4OgYnEI89zHuv2XwmSa+SAFZg/g8Cje5A+HaUczuZBxjU7L8fOh4xOoxB+iMOX+KUeKUjm0TQNQAMzNUk0+3x6UO/T88jdlIRVaPPSORgA/KWAlix2IO2dFrhqgXDPGnSlNrFt3q+Sg+4of/4qyLBy30+Vpj4hEzYw4QsQBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888515; c=relaxed/simple;
	bh=ehB8ScbVjUdJTw1vCDqlBVftl+zW6+zFKhIwnyB3VHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oO/bjpRmVoAoGY4cpYmhJbOrRWQyKSDUm+X5mvaMk9x1OdS8NO4iPLwck6sj0+W0WyUixto5sAid1WF3w2nKdpTIXnXviwBxND1XAh+PLvaSx5xHX5dYL4EYxAy6G/wU/6FVXZgG4TmpTxyEvzKYByyzRlYidEnOS1QPFHMQWnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lbjNa2/v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lbjNa2/v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22490C4CEF1;
	Tue, 16 Dec 2025 12:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888515;
	bh=ehB8ScbVjUdJTw1vCDqlBVftl+zW6+zFKhIwnyB3VHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lbjNa2/vqHYLhsmlsoswGNCM710kY6tqylbtWwPgU0gea0858JI7+haFLXs5WMwWH
	 f0MN01UKeLRaO56J/sjhIx2O8Mky9ceDtOwCciUl2L0TGIGDVX/L8e/fhBv2p5Ng+a
	 Xj0dRYk4Lk8vSztPQoykzd9jFOu8uP5jr/fS84dw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 556/614] ASoC: ak4458: Disable regulator when error happens
Date: Tue, 16 Dec 2025 12:15:23 +0100
Message-ID: <20251216111421.524694815@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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
index 57cf601d3df35..a6c04dd3de3ed 100644
--- a/sound/soc/codecs/ak4458.c
+++ b/sound/soc/codecs/ak4458.c
@@ -671,7 +671,15 @@ static int ak4458_runtime_resume(struct device *dev)
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
 
 static const struct snd_soc_component_driver soc_codec_dev_ak4458 = {
-- 
2.51.0



