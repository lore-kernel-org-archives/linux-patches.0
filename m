Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD8B4C7F;
	Mon, 23 Jun 2025 13:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685326; cv=none; b=NfAAH8cRRo25ayAArye7lsyauW2t9N5CqOjHnMXuT0alhuugpSWn8NJh0u/6yWFVqyrOKiYeDd7v7S3DdLEu4Yq5b3ilsshnSybrn/zr71sixxGSedk2M3koWwqArEIPJuAz3o/9OW+Cbc5N1HUUt5s6q3g2Hj6J954j1mHjGNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685326; c=relaxed/simple;
	bh=fWfvtNRN/40MFh9AJzq3nmsxBKzDGGDuXr4N+8HNkfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IgdhC4SlAQ9LJCeZseMG/672gmjCfmHH+RV5SMyulDCA71vuifmhu8kW2o9GlLEvty1gJ3eNCHY+kTbVfDQsCCfX2Q8jzgTaseciykq7N0IqLFJmDELYyloHWUwpIhc3ngViwUcYbLPSMLEE4VuJjt7zugp5nfYUbcOfumvXihU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sPX70ZDn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sPX70ZDn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D469BC4CEEA;
	Mon, 23 Jun 2025 13:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685326;
	bh=fWfvtNRN/40MFh9AJzq3nmsxBKzDGGDuXr4N+8HNkfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sPX70ZDnpZLc7MwtD6Arowa4YNk487i7n+94PMNWZ44tdgsC5xRF0oTe7c/10usS5
	 gDsYgtO033mIL2HnwxHG8BotQB2ET5pvycErwMHDXXJRgodxjfO5qO8GMFzN+osGAu
	 MU5/578izVzhfnEuQa2ptnxfwSMrc9NExwcz4vFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Dhruva Gole <d-gole@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 225/592] pmdomain: core: Reset genpd->states to avoid freeing invalid data
Date: Mon, 23 Jun 2025 15:03:03 +0200
Message-ID: <20250623130705.642850605@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit 99012014c902cd9ad85fd288d8a107f33a69855e ]

If genpd_alloc_data() allocates data for the default power-states for the
genpd, let's make sure to also reset the pointer in the error path. This
makes sure a genpd provider driver doesn't end up trying to free the data
again, but using an invalid pointer.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Dhruva Gole <d-gole@ti.com>
Link: https://lore.kernel.org/r/20250402120613.1116711-1-ulf.hansson@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pmdomain/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pmdomain/core.c b/drivers/pmdomain/core.c
index d6c1ddb807b20..7a3bad106e175 100644
--- a/drivers/pmdomain/core.c
+++ b/drivers/pmdomain/core.c
@@ -2229,8 +2229,10 @@ static int genpd_alloc_data(struct generic_pm_domain *genpd)
 	return 0;
 put:
 	put_device(&genpd->dev);
-	if (genpd->free_states == genpd_free_default_power_state)
+	if (genpd->free_states == genpd_free_default_power_state) {
 		kfree(genpd->states);
+		genpd->states = NULL;
+	}
 free:
 	if (genpd_is_cpu_domain(genpd))
 		free_cpumask_var(genpd->cpus);
-- 
2.39.5



