Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67262D6E72;
	Thu, 15 Jan 2026 17:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497733; cv=none; b=NvxM/auyCQBFeHdpTbUKO9h1CEh1UkQBmQSugOMLuk4+2acjxRu3GzU3crWmMijEnrtgdogSUCf7ZROFrmo1H4h8UE6Cc/nLetYl64CKlxRUZN4X1FjxOPjkHXVJsvNDd+xCnSN7yT2MQKulVwAuXLKmPl7GSe6vkCGa5IKwbV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497733; c=relaxed/simple;
	bh=jPmdEjRJ7srLTRJpv60ZGwb26xG8n/Bu/qAfpTNr1jA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+m9SIpdCi7NMrHRceNaWTjILjDeyVbuPBT6ELx2h2XAPy68i3gtsBTFIZ3c6UY+N6HftUnPKNjTLkC3VEX3u6FUy7WP/xMbSMdCVRlVMLWc1FULuyAuMvyYWqtBVIkmbGSXamhj6z1n50p16cqn8NVyMgjEmURpJROWZaWxsz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0/8DpGa2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/8DpGa2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162E2C116D0;
	Thu, 15 Jan 2026 17:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497733;
	bh=jPmdEjRJ7srLTRJpv60ZGwb26xG8n/Bu/qAfpTNr1jA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0/8DpGa2RbUEj6cQMlnSXqcdDGMgbVnIWVnw3+VHlIfLJBfszzXSwtvCkhlXRuzwe
	 0Sx97h7EymMhCq4bckArosX7k7xxYZMwrkCp0w44cABJ5HHB+XxbQCrnExEdnEIn3V
	 Q6WPpUjb8LHdLIQOjWhSV6x4Df6abjLlYrcslaNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 185/554] ASoC: ak4458: Disable regulator when error happens
Date: Thu, 15 Jan 2026 17:44:11 +0100
Message-ID: <20260115164252.958573315@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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
index 29eb78702bf35..1c179df6f0926 100644
--- a/sound/soc/codecs/ak4458.c
+++ b/sound/soc/codecs/ak4458.c
@@ -709,7 +709,15 @@ static int __maybe_unused ak4458_runtime_resume(struct device *dev)
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



