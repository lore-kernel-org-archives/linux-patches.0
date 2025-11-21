Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBB7330B19;
	Fri, 21 Nov 2025 13:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731104; cv=none; b=K06p/yFSEVqF3Di+szK1QmssjfivqYtPqHhlerkp2fiuyaQIj0UUVmpJax1e1PkfSwTWOmYoxpGyu+9f832MG7JiykuD8NjkY2qk8p71yufFDQO5sqJVgB200AJtNuTp9ooUq0K4hfi36i2BQ1V8xys590pyBlZzoupdNQfuw6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731104; c=relaxed/simple;
	bh=mt3eQw/L6jd2lZN44emRD1FA/RhwHQdG6C1X1p3zizg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wk3z+mE1Mi/jLqTJanGh8U7seYLx1Xid3UywLICy4eQRh00vxhTrLY3GRJQX9Wkk6egynCOkiNc36ZLqXjdE3bhhGJxWtNDWSeXcdrIDi6Kpd/+88/2PTS24NuApxGxtjW+jgjVkRuUQLrUjKQSg0sjBYh1+bxx1lnDnEu7yVYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QPi4szUb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QPi4szUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A04C4CEF1;
	Fri, 21 Nov 2025 13:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731104;
	bh=mt3eQw/L6jd2lZN44emRD1FA/RhwHQdG6C1X1p3zizg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QPi4szUbobEP7/L2if2+wB/wW5FLE3pBOaO42l00U7yPjOSS6sabnmn899TC73PgH
	 RYOMcbV1qurLJjJ8OYh5lXvUBtBVYARc0kyUVpC6GI5FsHQQvl0wkD/kX52IGiWEWn
	 7JweXcD0IhCod8neR7fzatf/vZ0se8VwBgw1EaGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Rainbolt <arainbolt@kfocus.org>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 092/247] cpufreq: intel_pstate: Check IDA only before MSR_IA32_PERF_CTL writes
Date: Fri, 21 Nov 2025 14:10:39 +0100
Message-ID: <20251121130157.894918678@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/intel_pstate.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index fc02a3542f656..99c80249fde88 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -603,9 +603,6 @@ static bool turbo_is_disabled(void)
 {
 	u64 misc_en;
 
-	if (!cpu_feature_enabled(X86_FEATURE_IDA))
-		return true;
-
 	rdmsrq(MSR_IA32_MISC_ENABLE, misc_en);
 
 	return !!(misc_en & MSR_IA32_MISC_ENABLE_TURBO_DISABLE);
@@ -2141,7 +2138,8 @@ static u64 atom_get_val(struct cpudata *cpudata, int pstate)
 	u32 vid;
 
 	val = (u64)pstate << 8;
-	if (READ_ONCE(global.no_turbo) && !READ_ONCE(global.turbo_disabled))
+	if (READ_ONCE(global.no_turbo) && !READ_ONCE(global.turbo_disabled) &&
+	    cpu_feature_enabled(X86_FEATURE_IDA))
 		val |= (u64)1 << 32;
 
 	vid_fp = cpudata->vid.min + mul_fp(
@@ -2306,7 +2304,8 @@ static u64 core_get_val(struct cpudata *cpudata, int pstate)
 	u64 val;
 
 	val = (u64)pstate << 8;
-	if (READ_ONCE(global.no_turbo) && !READ_ONCE(global.turbo_disabled))
+	if (READ_ONCE(global.no_turbo) && !READ_ONCE(global.turbo_disabled) &&
+	    cpu_feature_enabled(X86_FEATURE_IDA))
 		val |= (u64)1 << 32;
 
 	return val;
-- 
2.51.0



