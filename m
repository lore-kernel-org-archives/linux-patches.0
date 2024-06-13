Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F01E142911;
	Thu, 13 Jun 2024 11:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278642; cv=none; b=VNcXx2nj6QYGs4z0CKk3rZBl1gKuzXXOM1SmkroXQ6b28ypuko3nLiM1JWxo/gVpywl9Q1LlPpvmwR538PNK341Q6zOntT0hXS2jbQuYtIP+bFtCEpPmzHKUjJJhVRvvrGPOEUghZ/4AJSel0Gyje3ty2JACME2SzoBPbYPkVWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278642; c=relaxed/simple;
	bh=Z2/zGejb/dYNf5qPS1ou0M5ZBQttzYzIxjtEnDPckQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JI7dw8L+b9OaUG3qcqw8zgpSXDV/pePWjDNM12HaReJzNv4xwsfYOqIyFtPaVfB4jYsBOZU03nHYoKZM2ZebbT4S2GYIUX8zflHgTcFL3yklQyDREJ2+dSpEl9eucPxX37SKC17HI7se2OqL+4HTQ4LoFIcH/Y7ifyowK44pG3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wragvhym; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wragvhym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6BCEC2BBFC;
	Thu, 13 Jun 2024 11:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278642;
	bh=Z2/zGejb/dYNf5qPS1ou0M5ZBQttzYzIxjtEnDPckQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wragvhymUJ1QsWDYMjJxcCjakAHMT6U5Lz9MIgK0r+TJL4ks2N+8aqSFmOLq0DUBd
	 DVq797xP5rDVFgLuHPCKgMJQj18nv508C0FwO8RoKcWyVnC8ilK+47K9kp/SILE7A/
	 4qb6AwARXXDHvW20yZ2eTlHMQPHKZOjRwSQhuyaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 013/213] ASoC: da7219-aad: fix usage of device_get_named_child_node()
Date: Thu, 13 Jun 2024 13:31:01 +0200
Message-ID: <20240613113228.498079013@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit e8a6a5ad73acbafd98e8fd3f0cbf6e379771bb76 ]

The documentation for device_get_named_child_node() mentions this
important point:

"
The caller is responsible for calling fwnode_handle_put() on the
returned fwnode pointer.
"

Add fwnode_handle_put() to avoid a leaked reference.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20240426153033.38500-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/da7219-aad.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/da7219-aad.c b/sound/soc/codecs/da7219-aad.c
index e3515ac8b223f..c7c800f8133b6 100644
--- a/sound/soc/codecs/da7219-aad.c
+++ b/sound/soc/codecs/da7219-aad.c
@@ -634,8 +634,10 @@ static struct da7219_aad_pdata *da7219_aad_fw_to_pdata(struct snd_soc_component
 		return NULL;
 
 	aad_pdata = devm_kzalloc(dev, sizeof(*aad_pdata), GFP_KERNEL);
-	if (!aad_pdata)
+	if (!aad_pdata) {
+		fwnode_handle_put(aad_np);
 		return NULL;
+	}
 
 	aad_pdata->irq = i2c->irq;
 
@@ -710,6 +712,8 @@ static struct da7219_aad_pdata *da7219_aad_fw_to_pdata(struct snd_soc_component
 	else
 		aad_pdata->adc_1bit_rpt = DA7219_AAD_ADC_1BIT_RPT_1;
 
+	fwnode_handle_put(aad_np);
+
 	return aad_pdata;
 }
 
-- 
2.43.0



