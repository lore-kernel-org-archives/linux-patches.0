Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E49033D50F;
	Fri,  9 Jan 2026 11:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959103; cv=none; b=b4pu0Uph1eVAU1HJTo+lt1pnOWKCXh59k5IWjUXwjb43fDWNcQjbRq1FRJJ8aV1g6f+TFnJOFVjucbS+GNcTvMJZzh7KDQj96lvPGMhqLLT9O8p5RgV6bezkb192K+HvdQxFKtMyvd/BciXcWejNJZcbgmYfn729y1TP3h0MaPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959103; c=relaxed/simple;
	bh=VuNbK6IddF/rdbWqXWLyR3Ta+ijLfxVsqBq/ESkywKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WbnnTiK5CSoZ989Q6+Sp6ZMIxbPIBKjHpQIeWIA4+JvSdB9XZUA9/VWHYIXTuf4PLErKs/iO3FLYzDiLORI+b+qNuKU6VFtRXghSH3UgmK9DAkMpF8RT6xElGbJ+9//Q5o0AttFcfH063Etid4/rPEfTse7vWBt4Ol0aWakAshk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yAwOrY1z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yAwOrY1z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D7D8C4CEF1;
	Fri,  9 Jan 2026 11:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959102;
	bh=VuNbK6IddF/rdbWqXWLyR3Ta+ijLfxVsqBq/ESkywKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yAwOrY1zbmZL7ab0ojyUnQMsEMdi+AACrt8FsreO2Y2x2JRZvT5MzT9g8U+eyR7Pr
	 dhpFzXol9qmIxdjevDn6ygokHHJbim9yNSW6YSHbeRNVRHwNUiTr/Mi6N5z1vTJOLf
	 cicd7/T4ZCOrMA0ezLJ5SI8bYyGuuPoq37urIC6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Rainbolt <arainbolt@kfocus.org>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Richa Bharti <richa.bharti@siemens.com>
Subject: [PATCH 6.12 09/16] cpufreq: intel_pstate: Check IDA only before MSR_IA32_PERF_CTL writes
Date: Fri,  9 Jan 2026 12:43:50 +0100
Message-ID: <20260109111951.774773967@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109111951.415522519@linuxfoundation.org>
References: <20260109111951.415522519@linuxfoundation.org>
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

From: Richa Bharti <richa.bharti@siemens.com>

[ Upstream commit 4b747cc628d8f500d56cf1338280eacc66362ff3 ]

Commit ac4e04d9e378 ("cpufreq: intel_pstate: Unchecked MSR aceess in
legacy mode") introduced a check for feature X86_FEATURE_IDA to verify
turbo mode support. Although this is the correct way to check for turbo
mode support, it causes issues on some platforms that disable turbo
during OS boot, but enable it later [1]. Before adding this feature
check, users were able to get turbo mode frequencies by writing 0 to
/sys/devices/system/cpu/intel_pstate/no_turbo post-boot.

To restore the old behavior on the affected systems while still
addressing the unchecked MSR issue on some Skylake-X systems, check
X86_FEATURE_IDA only immediately before updates of MSR_IA32_PERF_CTL
that may involve setting the Turbo Engage Bit (bit 32).

Fixes: ac4e04d9e378 ("cpufreq: intel_pstate: Unchecked MSR aceess in legacy mode")
Reported-by: Aaron Rainbolt <arainbolt@kfocus.org>
Closes: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2122531 [1]
Tested-by: Aaron Rainbolt <arainbolt@kfocus.org>
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
[ rjw: Subject adjustment, changelog edits ]
Link: https://patch.msgid.link/20251111010840.141490-1-srinivas.pandruvada@linux.intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[ richa: Backport to 6.12.y with context adjustments ]
Signed-off-by: Richa Bharti <richa.bharti@siemens.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/intel_pstate.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -600,9 +600,6 @@ static bool turbo_is_disabled(void)
 {
 	u64 misc_en;
 
-	if (!cpu_feature_enabled(X86_FEATURE_IDA))
-		return true;
-
 	rdmsrl(MSR_IA32_MISC_ENABLE, misc_en);
 
 	return !!(misc_en & MSR_IA32_MISC_ENABLE_TURBO_DISABLE);
@@ -2018,7 +2015,8 @@ static u64 atom_get_val(struct cpudata *
 	u32 vid;
 
 	val = (u64)pstate << 8;
-	if (READ_ONCE(global.no_turbo) && !READ_ONCE(global.turbo_disabled))
+	if (READ_ONCE(global.no_turbo) && !READ_ONCE(global.turbo_disabled) &&
+	    cpu_feature_enabled(X86_FEATURE_IDA))
 		val |= (u64)1 << 32;
 
 	vid_fp = cpudata->vid.min + mul_fp(
@@ -2183,7 +2181,8 @@ static u64 core_get_val(struct cpudata *
 	u64 val;
 
 	val = (u64)pstate << 8;
-	if (READ_ONCE(global.no_turbo) && !READ_ONCE(global.turbo_disabled))
+	if (READ_ONCE(global.no_turbo) && !READ_ONCE(global.turbo_disabled) &&
+	    cpu_feature_enabled(X86_FEATURE_IDA))
 		val |= (u64)1 << 32;
 
 	return val;


