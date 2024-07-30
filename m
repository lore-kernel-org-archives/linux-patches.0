Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E9B188013;
	Tue, 30 Jul 2024 16:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355472; cv=none; b=qGG1bW/5in5+5Gf7HIDypJKdR4J+63UT0XGP7AjeYgVWS/Yf4XoJz+jHEt8zikExLG/zC/s2QjSQgDHhs17uSEacSHUv7ljZ+RD6d/dQ6BikCYSEBt06zNf4yoNchMQ/n+//CCwbrtPhFvXdZ2ifl6iYrt61XpOXMYfbJ1+Kg3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355472; c=relaxed/simple;
	bh=ehAQM6DEs9+R8UTlg32JyyYSPZ7p8BFGXdUCyzz+A8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PzdJTo/ShRfAkJxaqbzNGzcKaTEEH0duHvFsHiLCVm0OxAa14AbJoI6QanWcVAw1JN/i8SaQ0NijpucwS54RV5dtmHdO7PKc06RYtkryle3lMJyOTq2jWqbT2/VTUpyOD/vNzM07IHii6IivbrTCOttFQui8MmX0korTkHixASQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XYWFndhb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XYWFndhb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11F4FC4AF0C;
	Tue, 30 Jul 2024 16:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355472;
	bh=ehAQM6DEs9+R8UTlg32JyyYSPZ7p8BFGXdUCyzz+A8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XYWFndhbIgO4p6tltPiw4qzts1s/2v5UkMIdB5EcKTDX6Fvgx/QuxFYgdteqGl7PF
	 CBt+XUlHJMBSPMVBrFQEAQlWrCKO+EU+ihB5UL6MJL9uQOHVrfTYO+LFAHEyw99s39
	 9ryD+YhW5R1S0Wl+W+Y7ki+bvIZ9tAg9Xni75Dvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sibi Sankar <quic_sibis@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 061/568] soc: qcom: icc-bwmon: Fix refcount imbalance seen during bwmon_remove
Date: Tue, 30 Jul 2024 17:42:48 +0200
Message-ID: <20240730151642.243771107@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Sibi Sankar <quic_sibis@quicinc.com>

[ Upstream commit 24086640ab39396eb1a92d1cb1cd2f31b2677c52 ]

The following warning is seen during bwmon_remove due to refcount
imbalance, fix this by releasing the OPPs after use.

Logs:
WARNING: at drivers/opp/core.c:1640 _opp_table_kref_release+0x150/0x158
Hardware name: Qualcomm Technologies, Inc. X1E80100 CRD (DT)
...
Call trace:
_opp_table_kref_release+0x150/0x158
dev_pm_opp_remove_table+0x100/0x1b4
devm_pm_opp_of_table_release+0x10/0x1c
devm_action_release+0x14/0x20
devres_release_all+0xa4/0x104
device_unbind_cleanup+0x18/0x60
device_release_driver_internal+0x1ec/0x228
driver_detach+0x50/0x98
bus_remove_driver+0x6c/0xbc
driver_unregister+0x30/0x60
platform_driver_unregister+0x14/0x20
bwmon_driver_exit+0x18/0x524 [icc_bwmon]
__arm64_sys_delete_module+0x184/0x264
invoke_syscall+0x48/0x118
el0_svc_common.constprop.0+0xc8/0xe8
do_el0_svc+0x20/0x2c
el0_svc+0x34/0xdc
el0t_64_sync_handler+0x13c/0x158
el0t_64_sync+0x190/0x194
--[ end trace 0000000000000000 ]---

Fixes: 0276f69f13e2 ("soc: qcom: icc-bwmon: Set default thresholds dynamically")
Fixes: b9c2ae6cac40 ("soc: qcom: icc-bwmon: Add bandwidth monitoring driver")
Signed-off-by: Sibi Sankar <quic_sibis@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240613164506.982068-1-quic_sibis@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/icc-bwmon.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/icc-bwmon.c b/drivers/soc/qcom/icc-bwmon.c
index adf2d523f103c..59ef8d739e93b 100644
--- a/drivers/soc/qcom/icc-bwmon.c
+++ b/drivers/soc/qcom/icc-bwmon.c
@@ -565,7 +565,7 @@ static void bwmon_start(struct icc_bwmon *bwmon)
 	int window;
 
 	/* No need to check for errors, as this must have succeeded before. */
-	dev_pm_opp_find_bw_ceil(bwmon->dev, &bw_low, 0);
+	dev_pm_opp_put(dev_pm_opp_find_bw_ceil(bwmon->dev, &bw_low, 0));
 
 	bwmon_clear_counters(bwmon, true);
 
@@ -772,11 +772,13 @@ static int bwmon_probe(struct platform_device *pdev)
 	opp = dev_pm_opp_find_bw_floor(dev, &bwmon->max_bw_kbps, 0);
 	if (IS_ERR(opp))
 		return dev_err_probe(dev, PTR_ERR(opp), "failed to find max peak bandwidth\n");
+	dev_pm_opp_put(opp);
 
 	bwmon->min_bw_kbps = 0;
 	opp = dev_pm_opp_find_bw_ceil(dev, &bwmon->min_bw_kbps, 0);
 	if (IS_ERR(opp))
 		return dev_err_probe(dev, PTR_ERR(opp), "failed to find min peak bandwidth\n");
+	dev_pm_opp_put(opp);
 
 	bwmon->dev = dev;
 
-- 
2.43.0



