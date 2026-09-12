Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC52235358;
	Sat, 12 Sep 2026 07:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199596; cv=none; b=HKwsr/rqgxxpTFxaxhFWJHeIMypVeCg8i/7dCbCKzb5oyMTCIKPLqDfXSF8Un3QvUO5UeRjlOKIm26oAJnnHRA0DZYTTCvp5bnD7jzgtJdrDOBxh9oy+q+oMVboFMHuqciZWibbzP4Us0TNhTXnCAATvsqtQP0+DknDnnZMpDig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199596; c=relaxed/simple;
	bh=A6R6yybH04A9MaTYhSLMPQZA2dp1QntMQzARV0O2Z/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r7NgYHRfAxs2krArQ8aFOy7kSVDy1ViX14MAT23vu97z0RGkkLumUwe9C+wxHzuqo8EtyeJZwJJMDUzp8MrJgFNI91tzG1fSNHXArrGZtOQQUWB1Kv1tfwHuPESnNyugnzgy60W/Hn+fMiESQzsXLmRcxxZq3e4fj081ea+nbkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VCjlc6vG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VCjlc6vG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E473C1F000FF;
	Sat, 12 Sep 2026 07:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199594;
	bh=lGfYi/LWG/yrRhwAa5Y/5EGXYkjms5czQsoiLFxD3AQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VCjlc6vGYZzt6bvsdNtjpRWVlxCjCYrsmXB5Ma8JGHt5Xr2/cXVETA5IoNSULODKB
	 Btg5vx/ZHb0v3rpaX0mtIBLF4T15TnD5XtSx7GscPBdQpAcDDp9Bj/sb6pycQCjcn0
	 tj4QK0tNl7wOCja6djuvM/55UYxj05zzJbIMNarE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Marco Scardovi <scardracs@disroot.org>,
	K Prateek Nayak <kprateek.anayk@amd.com>,
	Mario Limonciello <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0617/1815] cpufreq/amd-pstate: Fix EPP return type and handle errors during initialization
Date: Sat, 12 Sep 2026 08:39:27 +0200
Message-ID: <20260912065703.365786840@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Scardovi <scardracs@disroot.org>

[ Upstream commit 57476909c3000a04e84a1d6018d63ba1b2aa20ab ]

Currently, the EPP getter helper functions (msr_get_epp, shmem_get_epp, and
the static call wrapper amd_pstate_get_epp) return u8 or s16. This makes it
difficult to correctly propagate negative error values returned by the
underlying MSR read or CPPC helpers (such as rdmsrq_on_cpu or
cppc_get_epp_perf).

Modify the return type of these functions to int, allowing them to return
negative error codes properly.

Additionally, in amd_pstate_epp_cpu_init(), fetch the firmware-programmed
default EPP value and validate it before assigning it to the EPP variables.
If amd_pstate_get_epp() returns an error code, propagate the error and abort
the CPU initialization to prevent subsequent configuration failures.

Fixes: 555bbe67a622 ("cpufreq/amd-pstate: Convert all perf values to u8")
Assisted-by: Antigravity:gemini-3.5-flash
Reviewed-by: K Prateek Nayak <kprateek.nayak@amd.com>
Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Signed-off-by: Marco Scardovi <scardracs@disroot.org>
Reviewed-by: K Prateek Nayak <kprateek.anayk@amd.com>
Link: https://lore.kernel.org/r/20260609073042.81275-2-scardracs@disroot.org
Signed-off-by: Mario Limonciello <superm1@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 3a6b4b224a66d..477c17398fc2b 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -199,7 +199,7 @@ static inline int get_mode_idx_from_str(const char *str, size_t size)
 
 static DEFINE_MUTEX(amd_pstate_driver_lock);
 
-static u8 msr_get_epp(struct amd_cpudata *cpudata)
+static int msr_get_epp(struct amd_cpudata *cpudata)
 {
 	u64 value;
 	int ret;
@@ -215,12 +215,12 @@ static u8 msr_get_epp(struct amd_cpudata *cpudata)
 
 DEFINE_STATIC_CALL(amd_pstate_get_epp, msr_get_epp);
 
-static inline s16 amd_pstate_get_epp(struct amd_cpudata *cpudata)
+static inline int amd_pstate_get_epp(struct amd_cpudata *cpudata)
 {
 	return static_call(amd_pstate_get_epp)(cpudata);
 }
 
-static u8 shmem_get_epp(struct amd_cpudata *cpudata)
+static int shmem_get_epp(struct amd_cpudata *cpudata)
 {
 	u64 epp;
 	int ret;
@@ -1876,6 +1876,7 @@ static int amd_pstate_epp_cpu_init(struct cpufreq_policy *policy)
 	struct amd_cpudata *cpudata;
 	union perf_cached perf;
 	struct device *dev;
+	int default_epp;
 	int ret;
 
 	/*
@@ -1924,6 +1925,13 @@ static int amd_pstate_epp_cpu_init(struct cpufreq_policy *policy)
 
 	policy->boost_supported = READ_ONCE(cpudata->boost_supported);
 
+	/* Fetch the firmware programmed default EPP value */
+	default_epp = amd_pstate_get_epp(cpudata);
+	if (default_epp < 0) {
+		ret = default_epp;
+		goto free_cpudata1;
+	}
+
 	/*
 	 * Set the policy to provide a valid fallback value in case
 	 * the default cpufreq governor is neither powersave nor performance.
@@ -1931,7 +1939,7 @@ static int amd_pstate_epp_cpu_init(struct cpufreq_policy *policy)
 	if (amd_pstate_acpi_pm_profile_server() ||
 	    amd_pstate_acpi_pm_profile_undefined()) {
 		policy->policy = CPUFREQ_POLICY_PERFORMANCE;
-		cpudata->epp_default_ac = cpudata->epp_default_dc = amd_pstate_get_epp(cpudata);
+		cpudata->epp_default_ac = cpudata->epp_default_dc = default_epp;
 		cpudata->current_profile = PLATFORM_PROFILE_PERFORMANCE;
 	} else {
 		policy->policy = CPUFREQ_POLICY_POWERSAVE;
-- 
2.53.0



