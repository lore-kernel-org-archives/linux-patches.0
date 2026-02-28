Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699EC375AAD
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301649; cv=none; b=ZnKhnM1HlA4CmyvTgbV+zEi2lfapXDAalNOpuIWX+AYLZmd+ovjTpktUaMU4yyCIPUo8wcTsRJusfZpAJds0/MrMALTfXftGZVIOD221LNANRSrevF4Ukz+CK4BWYFYOLgx0O+SZmnuxRVdxYVo8eRw/Wai/fQTHRoeent2INv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301649; c=relaxed/simple;
	bh=qzKJjKyOh4TZoIJsg3eo3WN6eNQ/KskyGs2H9BjRxOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V2UjpK2U+Pzd7ziIndCVW9Eo8On4DN9AFmYj71gms8losTYdREnpSliT/PFCt35cpeTuVk/46tomLc+OUemsFZBJ1LpO9zrPYBUZJboHl9vQGxSghgz5Ega25Y/+wqxjQu11B9dVwG4BcW8RwNMcqQOsXdJ3p6l8OKGT93yJRzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G+POeuj3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G+POeuj3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D062EC19425;
	Sat, 28 Feb 2026 18:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301649;
	bh=qzKJjKyOh4TZoIJsg3eo3WN6eNQ/KskyGs2H9BjRxOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G+POeuj397tf5R8Js4mrHixcPDGf2j0q8MfOCctO2/L2Az6GodNsdaJtsyCHiNE24
	 QWtRc1vEYhHezpUR/s0ba0WFNZRNhfiv8/gStRh1Enr7QUlyyht1LUxLf7wrcttVnA
	 9yU8G72AdaQhDPzP62viDgZFZFSj4Xwv89yTcEZ4OXHQE3nm7Wnz3rgfhDqFb3MqNI
	 GPS4LcthhzWNe2Qp4WIheZIYit+5lbSbv8/3Gzct7ZGJ7YxhSRERw2aDlXadQ2miVV
	 sOMmDOyOByoM+W8xsbHswC1X/OQcRpzsvYnITjFXJWFpNHfowOOWuGWIARSdVUCC94
	 kNxu6CeuwOy2g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Yaxiong Tian <tianyaxiong@kylinos.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 045/385] cpufreq: intel_pstate: Enable asym capacity only when CPU SMT is not possible
Date: Sat, 28 Feb 2026 12:54:27 -0500
Message-ID: <20260228180011.1568201-45-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Yaxiong Tian <tianyaxiong@kylinos.cn>

[ Upstream commit 1fedbb589448bee9f20bb2ed9c850d1d2cf9963c ]

According to the description in the intel_pstate.rst documentation,
Capacity-Aware Scheduling and Energy-Aware Scheduling are only
supported on a hybrid processor without SMT. Previously, the system
used sched_smt_active() for judgment, which is not a strict condition
because users can switch it on or off via /sys at any time.

This could lead to incorrect driver settings in certain scenarios.
For example, on a CPU that supports SMT, a user can disable SMT
via the nosmt parameter to enable asym capacity, and then re-enable
SMT via /sys. In such cases, some settings in the driver would no
longer be correct.

To address this issue, replace sched_smt_active() with cpu_smt_possible(),
and only enable asym capacity when CPU SMT is not possible.

Fixes: 929ebc93ccaa ("cpufreq: intel_pstate: Set asymmetric CPU capacity on hybrid systems")
Signed-off-by: Yaxiong Tian <tianyaxiong@kylinos.cn>
[ rjw: Subject and changelog edits ]
Link: https://patch.msgid.link/20260203024852.301066-1-tianyaxiong@kylinos.cn
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/intel_pstate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 9d8cb44c26c70..f8f9ff2b73ea0 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -1058,7 +1058,7 @@ static void hybrid_init_cpu_capacity_scaling(bool refresh)
 	 * the capacity of SMT threads is not deterministic even approximately,
 	 * do not do that when SMT is in use.
 	 */
-	if (hwp_is_hybrid && !sched_smt_active() && arch_enable_hybrid_capacity_scale()) {
+	if (hwp_is_hybrid && !cpu_smt_possible() && arch_enable_hybrid_capacity_scale()) {
 		hybrid_refresh_cpu_capacity_scaling();
 		/*
 		 * Disabling ITMT causes sched domains to be rebuilt to disable asym
-- 
2.51.0

