Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086A3449EC3
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301195; cv=none; b=VhpTYdJIEe11fWHQp3YrUMeNZPc4O0XACeDdXxVnHtmiq8/2tAONlozMoL+7T5cERpajpuoYhJMClYNQ2RAH7jAWUKwNL8s4Ol75HR2GDPTb29qtCNF9//O2vKUwMYl+xEIEGy2aRxcOsNE2A54SLg+mCKEbqnaqSJU1rAEn9Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301195; c=relaxed/simple;
	bh=kJIa65djiJ+H74aDYxuovkWIyg9lxC8OkP4c3FTL02w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RZb/ByV0guYSU6yUuITqOmXvrlytBgQki6RjSNlNmeUUHJTb2yLWDYS9YH0eWh7G8EXxJrsQfEVVEoXa74OIbfn78gsT92NRY0/U+HSvuDI1ykZUbhI14TZ2qDPDH62tPpdLNMe/3WylBhyoTX8ktaTYA611NAq7awSTYhzwSR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SCiEM2/K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SCiEM2/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A781C19424;
	Sat, 28 Feb 2026 17:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301194;
	bh=kJIa65djiJ+H74aDYxuovkWIyg9lxC8OkP4c3FTL02w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SCiEM2/KGEPe45l22Xhh83AKeyAcIedqSpW7KZjleaVFljyCDYKawRTJIz/Afr0Kr
	 BP8oENhGlkI8eTdb5gpUc9b7Xb+2X0W72rl3EfrttF/xPSn1R1QcoqMc6ohGSwhy5x
	 LvCDNZ2KovWSw7Lc8MQFj2jJ/siakuYD21EvI3UGwOb/8hWUew83PKwYEMcxJ4Btms
	 4Bovcr37RCcv3XUpe8RfiKMpBeFnE5d0XuO7W7b1sKqjXCvgJ7DPGgLp9Aad5a53/E
	 o07gVarqizZYdarzbqXW0I8+1mzMOI6Ub+ZtX7DNBS2qqMgaRGoL8F4+Er699AWpC9
	 jJao+a/j8m/YA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 366/752] thermal: int340x: Fix sysfs group leak on DLVR registration failure
Date: Sat, 28 Feb 2026 12:41:17 -0500
Message-ID: <20260228174750.1542406-366-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>

[ Upstream commit 15176b818e048ccf6ef4b96db34eda7b7e98938a ]

When DLVR sysfs group creation fails in proc_thermal_rfim_add(),
the function returns immediately without cleaning up the FIVR group
that may have been created earlier.

Add proper error unwinding to remove the FIVR group before returning
failure.

Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/LV3PR11MB876881B77D32A2854AD2908EF563A@LV3PR11MB8768.namprd11.prod.outlook.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../thermal/intel/int340x_thermal/processor_thermal_rfim.c   | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
index 1f3d22b659dbe..635bc8fded1e9 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
@@ -451,8 +451,11 @@ int proc_thermal_rfim_add(struct pci_dev *pdev, struct proc_thermal_device *proc
 			break;
 		}
 		ret = sysfs_create_group(&pdev->dev.kobj, &dlvr_attribute_group);
-		if (ret)
+		if (ret) {
+			if (proc_priv->mmio_feature_mask & PROC_THERMAL_FEATURE_FIVR)
+				sysfs_remove_group(&pdev->dev.kobj, &fivr_attribute_group);
 			return ret;
+		}
 	}
 
 	if (proc_priv->mmio_feature_mask & PROC_THERMAL_FEATURE_DVFS) {
-- 
2.51.0

