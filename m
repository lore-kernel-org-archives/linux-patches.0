Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448C7184535;
	Tue, 30 Jul 2024 16:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355793; cv=none; b=dA1TDdeNB5yPs04J88L15Q5+ikOAcmvv0hNjgPoKcJ5C2x9QBphIz4GPPMnySprCntiMUB4o3lqPlX11eA8KnXkb70gWT991PT4z9bzZXBqTlr/V6f0Ijvz+rfRMCGDjoBP2CFJxj1iITLSGwL7TuYqxJTm8BCWOzT8NVioITt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355793; c=relaxed/simple;
	bh=YTccryd7UbhiKZWcKXu2uFo/wYKpr4WjlL0D8YUDTWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KgAML+ox3eXddu3OW25xhEvFYKRlKhjV6QhG/3gtYjmWW3ykEe4u9jTyok93nTBT0TVbUR4vHtiDRvGqtaX/+oY1j9PSj6HM1NV2Cf3kwK6k6WYaOD+pDRQYrnL1Mcm7SL8KBN1LtC1rk55pUTgln0tCHl2jWyq4jFYFzsDt6hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ybqIZRKo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ybqIZRKo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D0CC32782;
	Tue, 30 Jul 2024 16:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355793;
	bh=YTccryd7UbhiKZWcKXu2uFo/wYKpr4WjlL0D8YUDTWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ybqIZRKo6jsgDMJ80IEml4h7XTloFdSqh/5Tv12pOdGCH+2oA325Y57ZPDxns1U75
	 RNaNMIqBCvxfbbpHdAljeOUdwcHjXT1YOtQWq4iR3vOkecPqPMtscXyr7C+qYamQ9n
	 Mz2VivtSZCTYxXiXy1wKsQNoifg4QL2J7X01Tsmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sibi Sankar <quic_sibis@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 089/809] soc: qcom: icc-bwmon: Fix refcount imbalance seen during bwmon_remove
Date: Tue, 30 Jul 2024 17:39:25 +0200
Message-ID: <20240730151728.152634319@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index fb323b3364db4..ecddb60bd6650 100644
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



