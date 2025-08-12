Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D2D2DFA3E;
	Tue, 12 Aug 2025 18:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022726; cv=none; b=VLauCbHxwzjJgQoEYFa9Wsjlt+eV7oqcUqSWlDOZ+FL+LxCUggpNJ8PgYLPmG+oV3nC3OjLlWen9wDQtiNDpUXc2ln4A5JOgo2wPlR+cfyKrIGuDEaKUg6hU4vLgggE0KojnxtFEeSZxj/KPAtkKzN8QV4tzMhIEXvIyruY4cGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022726; c=relaxed/simple;
	bh=K18LIoCdy3RvGZHMpLJ2gEoUf+wyO77U+gWU4IccIv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jrSFqj5MAfoBPNTIvPuxl6nrmCMJysN6siSMCLb3sQYZDwKwjsVmdT2+lhDE/uHBzOMcqM5BOhuZ9GbI5GCejJcfPjCixRt3ZwiVrkeJZ1JSSGZEki1YV8YGHnCn/SD+kI6HqAwsmESheQEbyHbKOF0q9rJ6SST+yiwjeEtwMBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m0T4Q/QL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m0T4Q/QL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE7BC4CEF1;
	Tue, 12 Aug 2025 18:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022726;
	bh=K18LIoCdy3RvGZHMpLJ2gEoUf+wyO77U+gWU4IccIv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m0T4Q/QLdAF2YbXMJPQ7cdeEZclq51LnqY/d6gugvU4vOdxD5TuCU8eLlzJcnCO6H
	 sonZTDeH6hzprmVDIz938u/+kGC6DkUJllnXcNa5BPn4SMMDhmKugCWhwwQi2D6C7s
	 E0Oj0+Z+dnwvGgiKQcUndYRB/HH5UJe7WJpGseyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 213/369] clk: imx95-blk-ctl: Fix synchronous abort
Date: Tue, 12 Aug 2025 19:28:30 +0200
Message-ID: <20250812173022.769490930@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>

[ Upstream commit b08217a257215ed9130fce93d35feba66b49bf0a ]

When enabling runtime PM for clock suppliers that also belong to a power
domain, the following crash is thrown:
error: synchronous external abort: 0000000096000010 [#1] PREEMPT SMP
Workqueue: events_unbound deferred_probe_work_func
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : clk_mux_get_parent+0x60/0x90
lr : clk_core_reparent_orphans_nolock+0x58/0xd8
  Call trace:
   clk_mux_get_parent+0x60/0x90
   clk_core_reparent_orphans_nolock+0x58/0xd8
   of_clk_add_hw_provider.part.0+0x90/0x100
   of_clk_add_hw_provider+0x1c/0x38
   imx95_bc_probe+0x2e0/0x3f0
   platform_probe+0x70/0xd8

Enabling runtime PM without explicitly resuming the device caused
the power domain cut off after clk_register() is called. As a result,
a crash happens when the clock hardware provider is added and attempts
to access the BLK_CTL register.

Fix this by using devm_pm_runtime_enable() instead of pm_runtime_enable()
and getting rid of the pm_runtime_disable() in the cleanup path.

Fixes: 5224b189462f ("clk: imx: add i.MX95 BLK CTL clk driver")
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Link: https://lore.kernel.org/r/20250707-imx95-blk-ctl-7-1-v3-2-c1b676ec13be@nxp.com
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx95-blk-ctl.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/imx/clk-imx95-blk-ctl.c b/drivers/clk/imx/clk-imx95-blk-ctl.c
index 564e9f3f7508..5030e6e60b66 100644
--- a/drivers/clk/imx/clk-imx95-blk-ctl.c
+++ b/drivers/clk/imx/clk-imx95-blk-ctl.c
@@ -323,8 +323,10 @@ static int imx95_bc_probe(struct platform_device *pdev)
 	if (!clk_hw_data)
 		return -ENOMEM;
 
-	if (bc_data->rpm_enabled)
-		pm_runtime_enable(&pdev->dev);
+	if (bc_data->rpm_enabled) {
+		devm_pm_runtime_enable(&pdev->dev);
+		pm_runtime_resume_and_get(&pdev->dev);
+	}
 
 	clk_hw_data->num = bc_data->num_clks;
 	hws = clk_hw_data->hws;
@@ -364,8 +366,10 @@ static int imx95_bc_probe(struct platform_device *pdev)
 		goto cleanup;
 	}
 
-	if (pm_runtime_enabled(bc->dev))
+	if (pm_runtime_enabled(bc->dev)) {
+		pm_runtime_put_sync(&pdev->dev);
 		clk_disable_unprepare(bc->clk_apb);
+	}
 
 	return 0;
 
@@ -376,9 +380,6 @@ static int imx95_bc_probe(struct platform_device *pdev)
 		clk_hw_unregister(hws[i]);
 	}
 
-	if (bc_data->rpm_enabled)
-		pm_runtime_disable(&pdev->dev);
-
 	return ret;
 }
 
-- 
2.39.5



