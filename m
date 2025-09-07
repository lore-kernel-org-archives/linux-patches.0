Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4CD1B4247;
	Sun,  7 Sep 2025 20:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276443; cv=none; b=JvDXD4IBzLuMOIUjmI9Jl19Ue97LcJEj86Ujr2dczcFmCp91IFc4F23H22RUjQrpIIYXPEKCrxtwPARkCK+0T0zJIKLLQPQKSkojV8KlcX36qrjmvO4C6tu3C3otyubg92eVZhgD4qGvy9ff6vdbLc7JYbp8NX/QvT8WlmqbK+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276443; c=relaxed/simple;
	bh=krNL2KbUU2h5RWa7AYAEIHB6MQP+3rf69ZVBwx5BvPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tUkwCbvOaDn2lUb8p8cIgLE5NFAW6a9iRm4WE834uFSgpIC0Be8sNemX7pU+tTVbu6/cdg+6Umo8LksZal8k+5vE2WVtubRbD0wO8l8w2gB4nN03LKGmqh7FihFlMe/ib35wzZNzCWkK35CkOV8ec3u8C5jJxH5PtHdHE8C87ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YXi3yZqB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YXi3yZqB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD60DC4CEF0;
	Sun,  7 Sep 2025 20:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276443;
	bh=krNL2KbUU2h5RWa7AYAEIHB6MQP+3rf69ZVBwx5BvPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YXi3yZqBjvHWKLIX0Vk8w3jpa8KVgpzErUVehHXZGJlISgxziJsx3p3JAp1ZPz5kt
	 u8FR0oc4XxVBlzAS4X+faTFqiSugbf+dWRTEOmbn4p0IzpFVPZP52AfKht1ZSaz5My
	 SIMNr7UMxOcKLwqljSIPdGcQjZhyZ0yRftSwCbdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Xi Ruoyao <xry111@xry111.site>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 104/104] cpufreq: intel_pstate: Check turbo_is_disabled() in store_no_turbo()
Date: Sun,  7 Sep 2025 21:59:01 +0200
Message-ID: <20250907195610.360270641@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7570d6d1ca8c0..3ded51db833d7 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -1255,12 +1255,17 @@ static ssize_t store_no_turbo(struct kobject *a, struct kobj_attribute *b,
 
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
 
@@ -1730,7 +1735,7 @@ static u64 atom_get_val(struct cpudata *cpudata, int pstate)
 	u32 vid;
 
 	val = (u64)pstate << 8;
-	if (READ_ONCE(global.no_turbo) && !global.turbo_disabled)
+	if (READ_ONCE(global.no_turbo) && !READ_ONCE(global.turbo_disabled))
 		val |= (u64)1 << 32;
 
 	vid_fp = cpudata->vid.min + mul_fp(
@@ -1900,7 +1905,7 @@ static u64 core_get_val(struct cpudata *cpudata, int pstate)
 	u64 val;
 
 	val = (u64)pstate << 8;
-	if (READ_ONCE(global.no_turbo) && !global.turbo_disabled)
+	if (READ_ONCE(global.no_turbo) && !READ_ONCE(global.turbo_disabled))
 		val |= (u64)1 << 32;
 
 	return val;
-- 
2.51.0



