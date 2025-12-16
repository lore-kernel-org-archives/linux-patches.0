Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1986342160;
	Tue, 16 Dec 2025 11:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884370; cv=none; b=oACeN1IohI0DiX9SrgSjYfuP7iaoasZKZFvHbeJ1Dvzy4YW5F8riPPLZcTvTQAG6MXH/i2V1ilcRUHHM8l7DoQSy7SS7Sd5lymeXMysnT43UX1zPjYM1/sZ3DGxi3sfBlL2PRFoJhIs6+3qNOyjs/9zFrvNUhyLiPiTl5WXWuNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884370; c=relaxed/simple;
	bh=9iKfnQApDnCqt/e96wmK52dd9KVtkD+MiQ2m+1fnJKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMMr7avA6NcJjvV8hMnbunYuulhAJzQ2tkyzkZYlD1eIYNhFWhdbf4IzDNmpVoPz0fsqIWmDAIerA+36LJSUyxlDsT5Qz/YyTqnE1ANShBM7VZ+Rjx3G0g8bkM2bven+kDKsV9Fxj5vtrJJJ2B9axJMXXENpH+dlq8pr/Yauwl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MNxmQcvR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MNxmQcvR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6945AC4CEF1;
	Tue, 16 Dec 2025 11:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884369;
	bh=9iKfnQApDnCqt/e96wmK52dd9KVtkD+MiQ2m+1fnJKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MNxmQcvRVFapB4KqOLq2r6YJgTETm95+F4xSIGR9e9Z7STbFtMAsOcVha1M0Skayw
	 tVZFqapOIzGsVZRDbE/Cwcm0lghYgQVnxVxIU7Rr6zkThhKqOoOEYT6kL/doQ/apkS
	 MXiRoJK1jbFPjWHrlTg+PbzNQsgMXako44qlGSLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD) (kernel.org)" <superm1@kernel.org>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 139/354] cpufreq/amd-pstate: Call cppc_set_auto_sel() only for online CPUs
Date: Tue, 16 Dec 2025 12:11:46 +0100
Message-ID: <20251216111325.954155102@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gautham R. Shenoy <gautham.shenoy@amd.com>

[ Upstream commit bb31fef0d03ed17d587b40e3458786be408fb9df ]

amd_pstate_change_mode_without_dvr_change() calls cppc_set_auto_sel()
for all the present CPUs.

However, this callpath eventually calls cppc_set_reg_val() which
accesses the per-cpu cpc_desc_ptr object. This object is initialized
only for online CPUs via acpi_soft_cpu_online() -->
__acpi_processor_start() --> acpi_cppc_processor_probe().

Hence, restrict calling cppc_set_auto_sel() to only the online CPUs.

Fixes: 3ca7bc818d8c ("cpufreq: amd-pstate: Add guided mode control support via sysfs")
Suggested-by: Mario Limonciello (AMD) (kernel.org) <superm1@kernel.org>
Signed-off-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 62dbc5701e993..c0e073b0425ec 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1221,7 +1221,7 @@ static int amd_pstate_change_mode_without_dvr_change(int mode)
 	if (cpu_feature_enabled(X86_FEATURE_CPPC) || cppc_state == AMD_PSTATE_ACTIVE)
 		return 0;
 
-	for_each_present_cpu(cpu) {
+	for_each_online_cpu(cpu) {
 		cppc_set_auto_sel(cpu, (cppc_state == AMD_PSTATE_PASSIVE) ? 0 : 1);
 	}
 
-- 
2.51.0



