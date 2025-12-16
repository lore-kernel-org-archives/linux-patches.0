Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E948345732;
	Tue, 16 Dec 2025 12:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887586; cv=none; b=raxeeyO8J7Oi/Yrp/eghldwZAGMOUzGRUGnyp58v5f81XK3BFyM+NirmNjkAWCyfLuoCSnlAfpeR9oupKz4bcdD9YanS6mIlXt2mXXkKXhSzQZQlEi4SG2uOnOltXXYMw5TUkDdpoXujQ5fhkkDYQW2t+wdd4vJKwG7uiQC5wa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887586; c=relaxed/simple;
	bh=EF/UC+FEQrVBKXJVbcLHi9Omcfj4c2kGYFM0lVv7q/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QIe4fYYmZY13KcOZYwFcbS7tzZJwV53mJO6uALj3Zt8qsPSYe2JSSnYp7vqqrF/SY1wqDWFFJrJquDSVyMXkgkOGDA4fGaWfVsdoZGPL5GYGOri6OKf6q+sH0t4hYkU3tfRIVF/xpMdaBifk3Opi6o7vtb/UBvfkr7oOIZ+PNXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=02/+Fxng; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="02/+Fxng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82FDAC4CEF1;
	Tue, 16 Dec 2025 12:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887585;
	bh=EF/UC+FEQrVBKXJVbcLHi9Omcfj4c2kGYFM0lVv7q/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=02/+Fxngn7ebNzsLtLukithFlZRQsQz7estJYp7TozzZwW+iDukVYLjfh9uTiU1MM
	 6Z/uKxtR66B/vlHypfztIy/6w4GHZJek49pEwPESicECWrndcrJFcZVGPoIC496CjP
	 CF2kbtYYBsMeJ8V7swmVG7vjo4ikk7BhAhMkAPAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD) (kernel.org)" <superm1@kernel.org>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 243/614] cpufreq/amd-pstate: Call cppc_set_auto_sel() only for online CPUs
Date: Tue, 16 Dec 2025 12:10:10 +0100
Message-ID: <20251216111410.170664363@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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
index b44f0f7a5ba1c..602e4fa81d6c5 100644
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



