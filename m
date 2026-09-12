Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C4035201F;
	Sat, 12 Sep 2026 11:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212804; cv=none; b=i3sGGZNjgSCBg6l/3ZEr4rP/XyC7BgCGGGjAO1fZoePtTpExt3VfiMATcbIP/D/JSCVKvEAiZF69oQWxj4CcJK5B8KNtb/lOjKIv/OIuXH+DU/a7bIcTLSwJJk5FqVaNcQfoa4RxmImRBD66ayiLpi0Xx77eA7/Q6LcldEBqC7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212804; c=relaxed/simple;
	bh=Vt3lbSI0C0Fgw9kCzxlwBTxRkl45IDWTkdEmVOMMOJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dkVb+kJ+k6vopIMNZe7kyYV2Oxt5iZgncXsPE4UpXRlG46DpwwrlTfXhKLSuJ+dflh2lIkEhXSc5rhW77pFSA6lrO3TMeyBgvrWQuKNmtuLaWYxh7U82i8bYi2emaxo2A/EZXr3emJelyvmdK0I7KqMDOg9wwMcpLRK8FYC/X+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cX4vV6Xn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cX4vV6Xn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAFCD1F000FF;
	Sat, 12 Sep 2026 11:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212803;
	bh=umHFmgkY95377ASYGSZyKfXE4NITBtyU3LLBvTbPE8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cX4vV6Xnln9Utnd3K1qeSE2x3z2xHPxfzoY4MltYOMV27utpNHkT8bdYgYmSgtLWb
	 FRmayV9n+SwB9vVu/eXBGiesmX1Du6vbmCAFuAywBR3yc2TCXgu3ygfVfHPFMND3KB
	 lb6g/p1Pbwc0QcAvunExOUfCFpL6ehMrIWe9yJaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1509/1518] cpufreq/amd-pstate: Use "epp_default_dc" as default when dynamic_epp is disabled
Date: Sat, 12 Sep 2026 09:01:18 +0200
Message-ID: <20260912065657.702638111@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: K Prateek Nayak <kprateek.nayak@amd.com>

[ Upstream commit caa822d312be54e3fe1a3b52c887e0888e149c12 ]

If "dynamic_epp" is disabled, the driver initialization and the default
EPP selection from sysfs currently sets the EPP based on the power
supply state of the system at that time but there is no power supply
callbacks registered to toggle it when the power supply state changes.

This can lead to faster battery drain on platforms that start off while
being plugged to the wall but later move to battery power since the EPP
stays at AMD_CPPC_EPP_PERFORMANCE.

Use "epp_default_dc" as the default EPP selection when dynamic_epp is
disabled, restoring older behavior. On servers, this defaults to
AMD_CPPC_EPP_PERFORMANCE and on other platforms, it defaults to
AMD_CPPC_EPP_BALANCE_PERFORMANCE.

Fixes: e30ca6dd5345 ("cpufreq/amd-pstate: Add dynamic energy performance preference")
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
Link: https://lore.kernel.org/r/20260508051748.10484-6-kprateek.nayak@amd.com
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index ddfba2e359099..12b8ac0f4204b 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1375,7 +1375,7 @@ static ssize_t store_energy_performance_preference(struct cpufreq_policy *policy
 		if (ret)
 			epp = epp_values[ret];
 		else
-			epp = amd_pstate_get_balanced_epp(policy);
+			epp = cpudata->epp_default_dc;
 	}
 
 	if (epp > 0 && cpudata->policy == CPUFREQ_POLICY_PERFORMANCE) {
@@ -1850,7 +1850,7 @@ static int amd_pstate_epp_cpu_init(struct cpufreq_policy *policy)
 	if (dynamic_epp)
 		ret = amd_pstate_set_dynamic_epp(policy);
 	else
-		ret = amd_pstate_set_epp(policy, amd_pstate_get_balanced_epp(policy));
+		ret = amd_pstate_set_epp(policy, cpudata->epp_default_dc);
 	if (ret)
 		goto free_cpudata1;
 
-- 
2.53.0



