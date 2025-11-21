Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8CB354AFA;
	Fri, 21 Nov 2025 13:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733413; cv=none; b=uX0Uvl6PnDsFw6kOggCLStt/sXNvWGs2sVC6JSxjPGaPmt3BoAo7unglVR6nJ6zkKE9KBvlSTp0S3zGwJn/jEHQNRZWnEdY+GBmapM0+3/D9/r0c4uYXxzr00y/LSa88COVx/Q9vSPfLTWBk0A+8sgKRaBGdZ5HvBgP9OnORUVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733413; c=relaxed/simple;
	bh=0An9qXOFRjTNZSqw6Bb6Ntcok3LbhOW/k1rUIb0H67s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d1B2weMDf44v7yhjmM7rqo0Aj6JccMxyM0Tr4LrDHUTz0eSXWg3G+oNe9hitlTsjeTXjsKt8TVlUo0tuv69SBgPnJno9dDkV3yaZLGp/51ujfSf8KXBJE0OcLnidcWFWtAHvdEq7oShaDB/33EkWIbMH2zjkeWgI04myRs2yq7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VfOx6Etg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VfOx6Etg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8FCBC4CEF1;
	Fri, 21 Nov 2025 13:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733413;
	bh=0An9qXOFRjTNZSqw6Bb6Ntcok3LbhOW/k1rUIb0H67s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VfOx6EtgGW1v/FIjAmKByicNcmuDsI6GJLw8evslWjfuWcxbaWdZmq6qPspVM4gPB
	 L/YPs4DyR/vDHWz5RHkMX5EP3muWRVcT8caOgpZrjxPdivUJKYCrjTG2KqkbiM1h8C
	 tKxB8XsgpfxNOmOBzeXRFKbKKBFNLTg/7Zk9dv/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 426/529] ASoC: cs4271: Fix regulator leak on probe failure
Date: Fri, 21 Nov 2025 14:12:05 +0100
Message-ID: <20251121130246.172936145@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 6b6eddc63ce871897d3a5bc4f8f593e698aef104 ]

The probe function enables regulators at the beginning
but fails to disable them in its error handling path.
If any operation after enabling the regulators fails,
the probe will exit with an error, leaving the regulators
permanently enabled, which could lead to a resource leak.

Add a proper error handling path to call regulator_bulk_disable()
before returning an error.

Fixes: 9a397f473657 ("ASoC: cs4271: add regulator consumer support")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20251105062246.1955-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs4271.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/cs4271.c b/sound/soc/codecs/cs4271.c
index 188b8b43c524f..b7529e2900572 100644
--- a/sound/soc/codecs/cs4271.c
+++ b/sound/soc/codecs/cs4271.c
@@ -594,17 +594,17 @@ static int cs4271_component_probe(struct snd_soc_component *component)
 
 	ret = regcache_sync(cs4271->regmap);
 	if (ret < 0)
-		return ret;
+		goto err_disable_regulator;
 
 	ret = regmap_update_bits(cs4271->regmap, CS4271_MODE2,
 				 CS4271_MODE2_PDN | CS4271_MODE2_CPEN,
 				 CS4271_MODE2_PDN | CS4271_MODE2_CPEN);
 	if (ret < 0)
-		return ret;
+		goto err_disable_regulator;
 	ret = regmap_update_bits(cs4271->regmap, CS4271_MODE2,
 				 CS4271_MODE2_PDN, 0);
 	if (ret < 0)
-		return ret;
+		goto err_disable_regulator;
 	/* Power-up sequence requires 85 uS */
 	udelay(85);
 
@@ -614,6 +614,10 @@ static int cs4271_component_probe(struct snd_soc_component *component)
 				   CS4271_MODE2_MUTECAEQUB);
 
 	return 0;
+
+err_disable_regulator:
+	regulator_bulk_disable(ARRAY_SIZE(cs4271->supplies), cs4271->supplies);
+	return ret;
 }
 
 static void cs4271_component_remove(struct snd_soc_component *component)
-- 
2.51.0



