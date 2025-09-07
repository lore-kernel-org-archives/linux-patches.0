Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14860D528;
	Sun,  7 Sep 2025 20:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276817; cv=none; b=fGZ94Kbu56nzGpkDMHduhzozswih3a6WbX7INv7nzSjHXwLr5PcP0NUq7ksafBF/rm7ucMfSgT4USI8dO2kELb2sVChGCl2mwUqw9TNKsnW3qSlkLtSLNwPKEtWpulcvYEuvt9wuceDMLp5eQLNH4aQOU7nnFXfbron/fvdpk5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276817; c=relaxed/simple;
	bh=de9RJlHZKonUIZ3IIz/xoxOBiuPAqVbXc2V89eD91Dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lX9t6V8I/E7GPQJoRJWPT7M/4gWo5BI0oNQzfdKNmQPNOfnL499AI6vjlvUQtvvTMxyxThqTFsve+2f8seYqCqRdmM9+L/XtDKY1RXSrlmQe5Kj68ITg+rufT3/AouwSiegzVMQBaQGN47upv49JiGpEt+dM/r6r9LMOFgpRQQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=blPYhW+E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="blPYhW+E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C618C4CEF0;
	Sun,  7 Sep 2025 20:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276817;
	bh=de9RJlHZKonUIZ3IIz/xoxOBiuPAqVbXc2V89eD91Dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=blPYhW+EA+CghQvE7lJy68c4AByiaCLBR1ilbyYHbE/k8hPWxOjLyd9mk8ci1U/E+
	 PMNKdkpSfaV1fDjeB3Gxy3aXz38EPuYdrNPkzPDxdynEmHq4pqrAoNgf+ndeaeCzvE
	 dXpJc1Xq7sgnvW1xw0/m+TDlcUrhjdLwxeRlu/Qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Xi Ruoyao <xry111@xry111.site>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 119/121] cpufreq: intel_pstate: Check turbo_is_disabled() in store_no_turbo()
Date: Sun,  7 Sep 2025 21:59:15 +0200
Message-ID: <20250907195612.904297654@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 350cbb5d2f676bff22c49e5e81764c3b8da342a9 ]

After recent changes in intel_pstate, global.turbo_disabled is only set
at the initialization time and never changed.  However, it turns out
that on some systems the "turbo disabled" bit in MSR_IA32_MISC_ENABLE,
the initial state of which is reflected by global.turbo_disabled, can be
flipped later and there should be a way to take that into account (other
than checking that MSR every time the driver runs which is costly and
useless overhead on the vast majority of systems).

For this purpose, notice that before the changes in question,
store_no_turbo() contained a turbo_is_disabled() check that was used
for updating global.turbo_disabled if the "turbo disabled" bit in
MSR_IA32_MISC_ENABLE had been flipped and that functionality can be
restored.  Then, users will be able to reset global.turbo_disabled
by writing 0 to no_turbo which used to work before on systems with
flipping "turbo disabled" bit.

This guarantees the driver state to remain in sync, but READ_ONCE()
annotations need to be added in two places where global.turbo_disabled
is accessed locklessly, so modify the driver to make that happen.

Fixes: 0940f1a8011f ("cpufreq: intel_pstate: Do not update global.turbo_disabled after initialization")
Closes: https://lore.kernel.org/linux-pm/bf3ebf1571a4788e97daf861eb493c12d42639a3.camel@xry111.site
Suggested-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Reported-by: Xi Ruoyao <xry111@xry111.site>
Tested-by: Xi Ruoyao <xry111@xry111.site>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/intel_pstate.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 05aae7e6da157..ed782c0b48af2 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -1288,12 +1288,17 @@ static ssize_t store_no_turbo(struct kobject *a, struct kobj_attribute *b,
 
 	no_turbo = !!clamp_t(int, input, 0, 1);
 
-	if (no_turbo == global.no_turbo)
-		goto unlock_driver;
-
-	if (global.turbo_disabled) {
-		pr_notice_once("Turbo disabled by BIOS or unavailable on processor\n");
+	WRITE_ONCE(global.turbo_disabled, turbo_is_disabled());
+	if (global.turbo_disabled && !no_turbo) {
+		pr_notice("Turbo disabled by BIOS or unavailable on processor\n");
 		count = -EPERM;
+		if (global.no_turbo)
+			goto unlock_driver;
+		else
+			no_turbo = 1;
+	}
+
+	if (no_turbo == global.no_turbo) {
 		goto unlock_driver;
 	}
 
@@ -1766,7 +1771,7 @@ static u64 atom_get_val(struct cpudata *cpudata, int pstate)
 	u32 vid;
 
 	val = (u64)pstate << 8;
-	if (READ_ONCE(global.no_turbo) && !global.turbo_disabled)
+	if (READ_ONCE(global.no_turbo) && !READ_ONCE(global.turbo_disabled))
 		val |= (u64)1 << 32;
 
 	vid_fp = cpudata->vid.min + mul_fp(
@@ -1931,7 +1936,7 @@ static u64 core_get_val(struct cpudata *cpudata, int pstate)
 	u64 val;
 
 	val = (u64)pstate << 8;
-	if (READ_ONCE(global.no_turbo) && !global.turbo_disabled)
+	if (READ_ONCE(global.no_turbo) && !READ_ONCE(global.turbo_disabled))
 		val |= (u64)1 << 32;
 
 	return val;
-- 
2.51.0



