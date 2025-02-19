Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716C51A314B;
	Wed, 19 Feb 2025 08:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953871; cv=none; b=UJCVbn8SmTa67l3G1AQMxSBOySP5m/ICNXiJL5J/D+5lqc2FSia63jHPkV85GWATfXAI5KHVslhdCBc7xYTS+vtOgDKmLXpjVYsGNhdEb6tbj+ejVwmRvzOH36ULcb2i1SNp2UN7XbNlXKQfJXrtHIemcqeshbNT1k3JqHLvtms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953871; c=relaxed/simple;
	bh=in0nDfMx4JCYs0WERKxzedNyMDWcHiI0FLiqKpRdbE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f0OcOZsi0o3yjD90o1OigT/a+YyGdBMzuS0pcnRmPhDRq3qJO2qV0p0lXU/Y7ntuuxWQTf6taeSdGs28V6XI/ESmKo2q6BXMo3jhKZMnXw9oDHTDpV4HbVeKMTOADxD2xKM7RqLBLVdh4LSkTjYxfAv+XbQTIb6qmNCd+pREvZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gsbLWuRE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gsbLWuRE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7763C4CEE6;
	Wed, 19 Feb 2025 08:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953871;
	bh=in0nDfMx4JCYs0WERKxzedNyMDWcHiI0FLiqKpRdbE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gsbLWuREaiJhuitUw3P4RYj77HXG1yZX25qz6ehf5ZPRjAl1uvNBh0Ix8IsWMstlV
	 zxdx1JAKtXreG64jrhAQcUf80vvdhgEfC4SVjYiIM7emtdIHMZuBdDbAl4wPOjcLdB
	 iXUJLnAodig8wbU4zNWuoIX29dQeG4FQyNe+22s4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca@lucaweiss.eu>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 024/274] regulator: core: let dt properties override driver init_data
Date: Wed, 19 Feb 2025 09:24:38 +0100
Message-ID: <20250219082610.486772072@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 35e21de48e693af1dcfdbf2dc3d73dcfa3c8f2d9 ]

This reverts commit cd7a38c40b231350a3cd0fd774f4e6bb68c4b411.

When submitting the change above, it was thought that the origin of the
init_data should be a clear choice, from the driver or from DT but not
both.

It turns out some devices, such as qcom-msm8974-lge-nexus5-hammerhead,
relied on the old behaviour to override the init_data provided by the
driver, making it some kind of default if none is provided by the platform.

Using the init_data provided by the driver when it is present broke these
devices so revert the change to fixup the situation and add a comment
to make things a bit more clear

Reported-by: Luca Weiss <luca@lucaweiss.eu>
Closes: https://lore.kernel.org/lkml/5857103.DvuYhMxLoT@lucaweiss.eu
Fixes: cd7a38c40b23 ("regulator: core: do not silently ignore provided init_data")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://patch.msgid.link/20250211-regulator-init-data-fixup-v1-1-5ce1c6cff990@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 61 ++++++++++++++++++----------------------
 1 file changed, 27 insertions(+), 34 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 13d9c3e349682..8524018e89914 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -5643,43 +5643,36 @@ regulator_register(struct device *dev,
 		goto clean;
 	}
 
-	if (config->init_data) {
-		/*
-		 * Providing of_match means the framework is expected to parse
-		 * DT to get the init_data. This would conflict with provided
-		 * init_data, if set. Warn if it happens.
-		 */
-		if (regulator_desc->of_match)
-			dev_warn(dev, "Using provided init data - OF match ignored\n");
+	/*
+	 * DT may override the config->init_data provided if the platform
+	 * needs to do so. If so, config->init_data is completely ignored.
+	 */
+	init_data = regulator_of_get_init_data(dev, regulator_desc, config,
+					       &rdev->dev.of_node);
 
+	/*
+	 * Sometimes not all resources are probed already so we need to take
+	 * that into account. This happens most the time if the ena_gpiod comes
+	 * from a gpio extender or something else.
+	 */
+	if (PTR_ERR(init_data) == -EPROBE_DEFER) {
+		ret = -EPROBE_DEFER;
+		goto clean;
+	}
+
+	/*
+	 * We need to keep track of any GPIO descriptor coming from the
+	 * device tree until we have handled it over to the core. If the
+	 * config that was passed in to this function DOES NOT contain
+	 * a descriptor, and the config after this call DOES contain
+	 * a descriptor, we definitely got one from parsing the device
+	 * tree.
+	 */
+	if (!cfg->ena_gpiod && config->ena_gpiod)
+		dangling_of_gpiod = true;
+	if (!init_data) {
 		init_data = config->init_data;
 		rdev->dev.of_node = of_node_get(config->of_node);
-
-	} else {
-		init_data = regulator_of_get_init_data(dev, regulator_desc,
-						       config,
-						       &rdev->dev.of_node);
-
-		/*
-		 * Sometimes not all resources are probed already so we need to
-		 * take that into account. This happens most the time if the
-		 * ena_gpiod comes from a gpio extender or something else.
-		 */
-		if (PTR_ERR(init_data) == -EPROBE_DEFER) {
-			ret = -EPROBE_DEFER;
-			goto clean;
-		}
-
-		/*
-		 * We need to keep track of any GPIO descriptor coming from the
-		 * device tree until we have handled it over to the core. If the
-		 * config that was passed in to this function DOES NOT contain a
-		 * descriptor, and the config after this call DOES contain a
-		 * descriptor, we definitely got one from parsing the device
-		 * tree.
-		 */
-		if (!cfg->ena_gpiod && config->ena_gpiod)
-			dangling_of_gpiod = true;
 	}
 
 	ww_mutex_init(&rdev->mutex, &regulator_ww_class);
-- 
2.39.5



