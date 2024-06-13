Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BAF144D1E;
	Thu, 13 Jun 2024 12:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280735; cv=none; b=NECbd4TYMqwsALEmS7xI3UodAvr8IanKV8dCeNNBu04vv6dtYQrpUM3878zHdyv/w6tqB6WE9MEYNmJgjjwwUvfn+1PIvCD/moWBWiw/rX5NflydoKkYv3VTFqcUPBXx+zKCIsNr+JUO5Gy9MrSuOwCSt34yxPAEwmNMQ0oecZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280735; c=relaxed/simple;
	bh=bY1C6hJqmpgTyE4Pw3q9cpHK8nSAnq1/Tkth79ecqUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EBm/s9FG3xLwXa1Qy1BzRHVQ8UU0S5MZFxKyooCnirKPfEp0k6/j9Hnmsq/mP6DE429SIEwbxkdLUEBqO831I6EvkOMhee8o7d4SmIlMxOAYgEZRoi/dzufXGHDPJv7j3B/qdh78I4YVH2tJOhJGEwOUQmQXsX26ot81XfcKgn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J1yU959K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J1yU959K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C938C2BBFC;
	Thu, 13 Jun 2024 12:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280735;
	bh=bY1C6hJqmpgTyE4Pw3q9cpHK8nSAnq1/Tkth79ecqUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J1yU959KnGdeyYhvHfmGiRSQ/B+am8lY+KQVAGOCP/TN3bXOeWM4bViHvqJvbjDmV
	 zMEhrlFul9Gpy9qanwkjHk5vCcShfUI53a1+oROWaiVFq/i8N+29aeCPggYoOXelVg
	 BInvUB9BrASvHY7LGOneDnCkuGMVknHZy+go2T4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 017/317] ASoC: da7219-aad: fix usage of device_get_named_child_node()
Date: Thu, 13 Jun 2024 13:30:35 +0200
Message-ID: <20240613113248.207656172@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b6030709b6b6d..2fb26dd84bc72 100644
--- a/sound/soc/codecs/da7219-aad.c
+++ b/sound/soc/codecs/da7219-aad.c
@@ -629,8 +629,10 @@ static struct da7219_aad_pdata *da7219_aad_fw_to_pdata(struct device *dev)
 		return NULL;
 
 	aad_pdata = devm_kzalloc(dev, sizeof(*aad_pdata), GFP_KERNEL);
-	if (!aad_pdata)
+	if (!aad_pdata) {
+		fwnode_handle_put(aad_np);
 		return NULL;
+	}
 
 	aad_pdata->irq = i2c->irq;
 
@@ -705,6 +707,8 @@ static struct da7219_aad_pdata *da7219_aad_fw_to_pdata(struct device *dev)
 	else
 		aad_pdata->adc_1bit_rpt = DA7219_AAD_ADC_1BIT_RPT_1;
 
+	fwnode_handle_put(aad_np);
+
 	return aad_pdata;
 }
 
-- 
2.43.0



