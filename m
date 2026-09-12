Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F8D25B0AA;
	Sat, 12 Sep 2026 10:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207795; cv=none; b=LZoCT9QfIdzh4bRgyusIiwnzqxnM9gSP+UMj5WCr9MM8lLYrVRDj3wGOr9OFfyvECaSI1ZGCGf4HbGNqepqR2HzGFx1T7smEW2NXGxUmyNjawNsSGF5DkTtOY4QsVFbGDxX/WlyBRRm1elHQKcjdbY9qk3FlT0OkSZzZNjJJiPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207795; c=relaxed/simple;
	bh=kv4MNUfelVbzz54cMM2Z293zkbzDCTW/l+fVNVB6NfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vy+6LjAT+cW8Ix6aPSrqnHpp1ipar23ZOR4T+wMpBhjbs5RbbL9lVuPNz70trWlx8BzTFp5MTD2Z45kVgJGaXOCJHXH5cvPYcjSSOj7OpInzr317BasEnqz56Q3032/cUHjM/pmuBNZUDuDHk0IsZDHbkSepnta+qvJYov/HohM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZK9sOtEG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZK9sOtEG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9480C1F000FF;
	Sat, 12 Sep 2026 10:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207794;
	bh=7KJT7JtO0kR9+umE1a8rV1WDvlWNV8Ubhvb9Gw7mF3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZK9sOtEGmvTIe3skSrq7xxYkRF85YKhWZNDq2oLePuEhAHJGzOuHab6nW28vln+M4
	 LUqYojTc46+INOU6RT7Iz69VeaHZDt/QaUq8MYlijM9kTKMn7rF9YTxx6VTLQ9LLiY
	 NnzjaLGHxI5RaOb5B0GvzSFg5VHnvY+TvR/CuWAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0486/1518] x86/bugs: Dont use cpu-type matching in cpu_vuln_blacklist
Date: Sat, 12 Sep 2026 08:44:15 +0200
Message-ID: <20260912065634.441976412@linuxfoundation.org>
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

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

[ Upstream commit a4c714fe9746bf5a434bb798b26ebba278b798c1 ]

Thomas Gleixner pointed out that cpu-type is a per-CPU property while hybrid
is a system property; conflating the two in the CPU matching infrastructure is
wrong. Currently, on a hybrid system x86_match_cpu() matches any cpu-type.
This works if the intent is to find the possibility of a cpu-type in a system.
But fails if matching for the cpu-type of a given CPU.

Borislav posted a cleanup here:

  https://lore.kernel.org/all/20260703193222.GFakgORjvxwnZTPRnI@fat_crate.local

To make way for the cleanup stop matching cpu-type in cpu_vuln_blacklist.
RFDS is the only user, so drop the VULNBL_INTEL_TYPE entries and fold their
RFDS bit into the base Alder Lake (0x97) and Raptor Lake (0xB7) blacklist
entries. For now open-code cpu-type check in vulnerable_to_rfds(). In the
future, if more vulnerabilities need cpu-type matching a helper can be added.

No functional change intended.

Fixes: 722fa0dba74f ("x86/rfds: Exclude P-only parts from the RFDS affected list")
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://patch.msgid.link/20260708-cpu-type-vuln-v1-1-85c1d3c704db@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/common.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 6cf7c2d0dc59c..3ffeadad02447 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1210,9 +1210,6 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
 #define VULNBL_INTEL_STEPS(vfm, max_stepping, issues)		   \
 	X86_MATCH_VFM_STEPS(vfm, X86_STEP_MIN, max_stepping, issues)
 
-#define VULNBL_INTEL_TYPE(vfm, cpu_type, issues)	\
-	X86_MATCH_VFM_CPU_TYPE(vfm, INTEL_CPU_TYPE_##cpu_type, issues)
-
 #define VULNBL_AMD(family, blacklist)		\
 	VULNBL(AMD, family, X86_MODEL_ANY, blacklist)
 
@@ -1275,11 +1272,9 @@ static const struct x86_cpu_id cpu_vuln_blacklist[] __initconst = {
 	VULNBL_INTEL_STEPS(INTEL_TIGERLAKE,	     X86_STEP_MAX,	GDS | ITS | ITS_NATIVE_ONLY),
 	VULNBL_INTEL_STEPS(INTEL_LAKEFIELD,	     X86_STEP_MAX,	MMIO | MMIO_SBDS | RETBLEED),
 	VULNBL_INTEL_STEPS(INTEL_ROCKETLAKE,	     X86_STEP_MAX,	MMIO | RETBLEED | GDS | ITS | ITS_NATIVE_ONLY),
-	VULNBL_INTEL_TYPE(INTEL_ALDERLAKE,		     ATOM,	RFDS | VMSCAPE),
-	VULNBL_INTEL_STEPS(INTEL_ALDERLAKE,	     X86_STEP_MAX,	VMSCAPE),
+	VULNBL_INTEL_STEPS(INTEL_ALDERLAKE,	     X86_STEP_MAX,	RFDS | VMSCAPE),
 	VULNBL_INTEL_STEPS(INTEL_ALDERLAKE_L,	     X86_STEP_MAX,	RFDS | VMSCAPE),
-	VULNBL_INTEL_TYPE(INTEL_RAPTORLAKE,		     ATOM,	RFDS | VMSCAPE),
-	VULNBL_INTEL_STEPS(INTEL_RAPTORLAKE,	     X86_STEP_MAX,	VMSCAPE),
+	VULNBL_INTEL_STEPS(INTEL_RAPTORLAKE,	     X86_STEP_MAX,	RFDS | VMSCAPE),
 	VULNBL_INTEL_STEPS(INTEL_RAPTORLAKE_P,	     X86_STEP_MAX,	RFDS | VMSCAPE),
 	VULNBL_INTEL_STEPS(INTEL_RAPTORLAKE_S,	     X86_STEP_MAX,	RFDS | VMSCAPE),
 	VULNBL_INTEL_STEPS(INTEL_METEORLAKE_L,	     X86_STEP_MAX,	VMSCAPE),
@@ -1347,7 +1342,21 @@ static bool __init vulnerable_to_rfds(u64 x86_arch_cap_msr)
 		return true;
 
 	/* Only consult the blacklist when there is no enumeration: */
-	return cpu_matches(cpu_vuln_blacklist, RFDS);
+	if (!cpu_matches(cpu_vuln_blacklist, RFDS))
+		return false;
+
+	/*
+	 * ADL and RPL are affected only if they have Atom CPUs. Hybrids have
+	 * both Core and Atom CPUs. Mark unaffected when Atom CPUs are not
+	 * present.
+	 */
+	if ((boot_cpu_data.x86_model == 0x97 ||
+	     boot_cpu_data.x86_model == 0xB7) &&
+	     boot_cpu_data.topo.intel_type != INTEL_CPU_TYPE_ATOM &&
+	     !boot_cpu_has(X86_FEATURE_HYBRID_CPU))
+		return false;
+
+	return true;
 }
 
 static bool __init vulnerable_to_its(u64 x86_arch_cap_msr)
-- 
2.53.0



