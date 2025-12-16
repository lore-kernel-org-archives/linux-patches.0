Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7EA34FF65;
	Tue, 16 Dec 2025 11:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885685; cv=none; b=Envi8BP4dIH345BFGzdND2SRpefu8TFi9zfWuRaI3NIt34qDu8AXj89TekWpfRSSHLkeLMYzAr4IoOzhi8kt4kVfTHU1SjLhYY1Uunt7e8qfgfSveVyIKpGbp1qA67FRgrn95xNmrX536PFHFqQjAGJq2NZHlCUajtJLSIS7CeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885685; c=relaxed/simple;
	bh=prhJN8ncOUHWzd3QtKZtdQB0bFc1Z7KM+WQ4D5+TlX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bu/mxT34tVq52Yr7PvA5+henjg/1XjpFPgyyBPtsfPxaNSiBkAFDH7zYw0ggClgBxx7iODGSvKd5k6tmb8cnqW/lW6BrRrKXKjN2TKtGcpncrHT9A5+9jSeMz9jgyHglhbk9Z0btUgSMva5PmA06RtA5Wa9DnnhOLfK/IGI4ifg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IgApq2i4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IgApq2i4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FCE9C4CEF1;
	Tue, 16 Dec 2025 11:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885684;
	bh=prhJN8ncOUHWzd3QtKZtdQB0bFc1Z7KM+WQ4D5+TlX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IgApq2i48tK5pACa12Uk1z1vZ3JAb8yciq+OxkXbP/UH0I1glHCLOu7EeC0SvZIMF
	 WMVz+ipJKRCli8+ovjRJ32wL+K2WPpbTz9/giJI60RKtX/9dPnSvMqPxaVCr7Uc3zy
	 T1VhrqSm8LRMiov/MeUJ5xKx7x4Z/W7GeIFNcN1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD) (kernel.org)" <superm1@kernel.org>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 206/507] cpufreq/amd-pstate: Call cppc_set_auto_sel() only for online CPUs
Date: Tue, 16 Dec 2025 12:10:47 +0100
Message-ID: <20251216111352.974125731@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index e4f1933dd7d47..7be26007f1d8e 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1282,7 +1282,7 @@ static int amd_pstate_change_mode_without_dvr_change(int mode)
 	if (cpu_feature_enabled(X86_FEATURE_CPPC) || cppc_state == AMD_PSTATE_ACTIVE)
 		return 0;
 
-	for_each_present_cpu(cpu) {
+	for_each_online_cpu(cpu) {
 		cppc_set_auto_sel(cpu, (cppc_state == AMD_PSTATE_PASSIVE) ? 0 : 1);
 	}
 
-- 
2.51.0



