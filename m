Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED74719FA6C;
	Thu,  6 Jun 2024 14:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683131; cv=none; b=bG8M4+ZMXFDtQq1WDV4XssGMUebpwVA87Et3aFvbM42VrF6XIViV4PwTeC6G2eP6excqaEdd4s8MlZcwTPopyIHJugOwNLy1qf06/fORyILN4Xe6fnfCjU3CfM3kFGtq8SicVCv+x9bsWtskR9h1gNUYsRpxVRdcKegAIZzJedw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683131; c=relaxed/simple;
	bh=PsZOUIIN/jL+vvryDEiGWtzldeAVm8g9nwbGZ7O/hTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fyBvXr+SZFS2QqozL+DHkl0B/dQH38tDiO6YbfiYLLrVSDUN/r19zDyjS6dC3xOz3Ibz+8Ogi5DVU/6frQo1STYrDs9aAvfGRSBJrEcWDJbIna2lYaM2g4bQ1e00ug+Iuwlz6NZts0Kmre5/e3LWDTgp6ir3zkHUxYZcWWqNoqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xLaefbAw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xLaefbAw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C591AC2BD10;
	Thu,  6 Jun 2024 14:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683130;
	bh=PsZOUIIN/jL+vvryDEiGWtzldeAVm8g9nwbGZ7O/hTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xLaefbAw9cte3Ros2upiMdJGK+fayY6QWPP00FDXKHa7x7HedByDFMzJhGT08wKiG
	 GOLxioAsV8ID3AM33v4jJR1qsLPaUdIX9CLReGkzNjPG7Vw7S7iKxEH1mnTVZT5hc+
	 wqlpGqw586GDWHTmZ14c/+c76jVndfFUxXAV5wVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 074/744] ASoC: da7219-aad: fix usage of device_get_named_child_node()
Date: Thu,  6 Jun 2024 15:55:46 +0200
Message-ID: <20240606131734.771918545@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8537c96307a97..9b0c470181706 100644
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



