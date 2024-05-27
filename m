Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58BE7155C81;
	Mon, 27 May 2024 19:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837745; cv=none; b=TkikJo+cHkTxxJZj5A5m1/E+8bHVBipHyoBqRhQIPgS9eGQIfkQljtc9ZiFXG5osPNIrUnm4uMMv1UfZksKH5nrl2BMeBnDYe4FQxxRY/3P+tAVSUCkQoB49Qsp89pnfBzFZWe2AZHH66xMFGvfUs6mPKQqbQ21jU8yuh41gx2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837745; c=relaxed/simple;
	bh=VSgWEWHfeHBVkD5SMsj18lmAh7TElLKou2vcVSXee14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eWHGSVywIgNK8NSUxRTk/P4BsF1w05IztrcSyc1u2bhi1qb9Ex/t8CtExB3DGAjgp/BUJDEkQ+1Is6d5h9LfILiuQ62Ar0KEEk5YM50LtFxK41MgwuAYiy45wLjO0VjtOIuOI0RGYjCfESYJLtO2dcyRY0CWdGdFL+VjbATKehY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rzC0GjCg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rzC0GjCg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A09C2BBFC;
	Mon, 27 May 2024 19:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837745;
	bh=VSgWEWHfeHBVkD5SMsj18lmAh7TElLKou2vcVSXee14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rzC0GjCgHi3bk6SuBlDGSbhIsRSmu/d+GKLN8Pa6EAkOllC+9AYFHN4rbNLzntloK
	 R+HtGpxel76LHPzRrq///71tUJL7KgiL3TGpWlLLY58CwDJTi8402Ni+EgSgEuKA1t
	 JouO7VEdx0RF9+F/nLYT8DVeM08y4aJyRXnSzVrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 088/493] ASoC: da7219-aad: fix usage of device_get_named_child_node()
Date: Mon, 27 May 2024 20:51:30 +0200
Message-ID: <20240527185633.239047019@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 6bc068cdcbe2a..15e5e3eb592b3 100644
--- a/sound/soc/codecs/da7219-aad.c
+++ b/sound/soc/codecs/da7219-aad.c
@@ -671,8 +671,10 @@ static struct da7219_aad_pdata *da7219_aad_fw_to_pdata(struct device *dev)
 		return NULL;
 
 	aad_pdata = devm_kzalloc(dev, sizeof(*aad_pdata), GFP_KERNEL);
-	if (!aad_pdata)
+	if (!aad_pdata) {
+		fwnode_handle_put(aad_np);
 		return NULL;
+	}
 
 	aad_pdata->irq = i2c->irq;
 
@@ -753,6 +755,8 @@ static struct da7219_aad_pdata *da7219_aad_fw_to_pdata(struct device *dev)
 	else
 		aad_pdata->adc_1bit_rpt = DA7219_AAD_ADC_1BIT_RPT_1;
 
+	fwnode_handle_put(aad_np);
+
 	return aad_pdata;
 }
 
-- 
2.43.0



