Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66ACF4DDB5A;
	Thu, 17 Sep 2026 17:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667761; cv=none; b=mr8AZd6xxVr1xSwu0MMadgwgNP3y/0yI8CQXlZ2lWbDV9tQebRDki+62nX9eMVFu4R7pPRBF1jbQC1tpyarvxbjSGbDvcQxiGCYfkpksFSwWlyS3iJEu7J6wsgL6gdU72juyCIuCI/GG6NIfanqAV+NPi6rkbr0yH7Qetvp4yjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667761; c=relaxed/simple;
	bh=AjS9icPhzBYuK1AOll6IiqOxa1eBfvEPTLQkcBP3eis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cI0FCCMZFI01yq3RF31rAzdClf/LacRHTgu3mCnBaAc9kj3cA4nLmd4O7e39whra7axxXMZO2yEt/4EPaHFuhLAItczdsdOC/akpL3d29ErgocKR3ol9N0ZhEWMb0z1gyltRbXmke4G9xz2jBzVQE5LCPrsXH/8FnUoYabSM8Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pk3TDPjD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pk3TDPjD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A38361F000FF;
	Thu, 17 Sep 2026 17:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667760;
	bh=k1Z/Q1TYSMUezGzY6RBwBhDxWMKPySwpYSbSIxXojkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pk3TDPjDnbFSDKN0wI0BEgPl78EV0PM70nXnuZuENw3qzFpt6MfDVedE14lF4tvXr
	 WOxbhNmtlzXEo0b7/w8eD2GspaBKJfqyM0ioHZLZJwh5YTjtaquwSk+4Y8PWrJR+1Z
	 atcAENWWlIYyyrC865zDUqU3LUqRPCxRGX1wPq3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0199/1102] ASoC: codecs: pcm3168a: Drop CONFIG_PM-conditional preproc directive
Date: Thu, 17 Sep 2026 16:02:22 +0100
Message-ID: <20260917151544.569065607@linuxfoundation.org>
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

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit eb7107264da8545ba7381a76818bae553e1fd1e4 ]

Revert changes done in commit 489db5d94150 ("ASoC: pcm3168a:
Don't disable pcm3168a when CONFIG_PM defined") and add
pm_runtime_status_suspended() check.

The suspended-check addresses regulator's "unbalanced disables"
warning during driver removal even when CONFIG_PM is enabled.

Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20260525201801.1336936-4-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/pcm3168a.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/sound/soc/codecs/pcm3168a.c b/sound/soc/codecs/pcm3168a.c
index 6cbb8d0535b02..ad1564e7d8faa 100644
--- a/sound/soc/codecs/pcm3168a.c
+++ b/sound/soc/codecs/pcm3168a.c
@@ -819,15 +819,6 @@ int pcm3168a_probe(struct device *dev, struct regmap *regmap)
 }
 EXPORT_SYMBOL_GPL(pcm3168a_probe);
 
-static void pcm3168a_disable(struct device *dev)
-{
-	struct pcm3168a_priv *pcm3168a = dev_get_drvdata(dev);
-
-	regulator_bulk_disable(ARRAY_SIZE(pcm3168a->supplies),
-			       pcm3168a->supplies);
-	clk_disable_unprepare(pcm3168a->scki);
-}
-
 void pcm3168a_remove(struct device *dev)
 {
 	struct pcm3168a_priv *pcm3168a = dev_get_drvdata(dev);
@@ -839,10 +830,12 @@ void pcm3168a_remove(struct device *dev)
 	 * The asserted level of GPIO_ACTIVE_LOW is LOW.
 	 */
 	gpiod_set_value_cansleep(pcm3168a->gpio_rst, 1);
+
 	pm_runtime_disable(dev);
-#ifndef CONFIG_PM
-	pcm3168a_disable(dev);
-#endif
+	if (!pm_runtime_status_suspended(dev)) {
+		regulator_bulk_disable(ARRAY_SIZE(pcm3168a->supplies), pcm3168a->supplies);
+		clk_disable_unprepare(pcm3168a->scki);
+	}
 }
 EXPORT_SYMBOL_GPL(pcm3168a_remove);
 
@@ -898,7 +891,8 @@ static int pcm3168a_rt_suspend(struct device *dev)
 
 	regcache_cache_only(pcm3168a->regmap, true);
 
-	pcm3168a_disable(dev);
+	regulator_bulk_disable(ARRAY_SIZE(pcm3168a->supplies), pcm3168a->supplies);
+	clk_disable_unprepare(pcm3168a->scki);
 
 	return 0;
 }
-- 
2.53.0



