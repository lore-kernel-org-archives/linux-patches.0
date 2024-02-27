Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54E413B2B4;
	Tue, 27 Feb 2024 14:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043793; cv=none; b=jaRDqMGECMLC4ZKVs/n0y0x2proWXk1FFCiF+2WIaFv8krAInJb2WfrTfLVA7Gf4oeB7r2zHOoZ8dAZ60iJ8aUYzovQLu+OIiIspqtgsdrPERKJnPI5MW57HwB2OGwUwALhRjwdUCDNM1fUzgBceo1I0qUX0LDH828T2mf7youU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043793; c=relaxed/simple;
	bh=Em3erZVgkOlfoGKtP/1WvnrjhjtpOtyh53iFMCITzbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DMAVOatOTF3+xlGdQ4CYq7M9QBsCyH3R/r3kQjZpAuzdRqhKQ7WYRjWQOjungPSC3bT0XF1slWs79LJWxAwKxzuW/NjPI1rkz/Q2NEPxuvfzhYtlM5yFLN4cX5BSfxbUgVTn+xVl9jBuynQU7dlCrZIVONW/wK+DF5k/FT8KSHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JXaIDrT3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JXaIDrT3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61881C433C7;
	Tue, 27 Feb 2024 14:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043793;
	bh=Em3erZVgkOlfoGKtP/1WvnrjhjtpOtyh53iFMCITzbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JXaIDrT3eh/Z+i5fWMMYR5EQsf5326NuJPMUSakrqU6llRIp6zoTmJ/AX56TrgzX9
	 TXDDD6o1S+U169EgHJXBPWp2T2kzYKFWaMpTTT+Xm5HeBwDqSXy3b/pafoXwqV+WlB
	 NpMAfu/rNGr1MnYa1C+hiVmDWwy/out6JeUalpg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cyril Hrubis <chrubis@suse.cz>,
	Ingo Molnar <mingo@kernel.org>,
	Petr Vorel <pvorel@suse.cz>
Subject: [PATCH 5.4 11/84] sched/rt: Disallow writing invalid values to sched_rt_period_us
Date: Tue, 27 Feb 2024 14:26:38 +0100
Message-ID: <20240227131553.240197193@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131552.864701583@linuxfoundation.org>
References: <20240227131552.864701583@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cyril Hrubis <chrubis@suse.cz>

commit 079be8fc630943d9fc70a97807feb73d169ee3fc upstream.

The validation of the value written to sched_rt_period_us was broken
because:

  - the sysclt_sched_rt_period is declared as unsigned int
  - parsed by proc_do_intvec()
  - the range is asserted after the value parsed by proc_do_intvec()

Because of this negative values written to the file were written into a
unsigned integer that were later on interpreted as large positive
integers which did passed the check:

  if (sysclt_sched_rt_period <= 0)
	return EINVAL;

This commit fixes the parsing by setting explicit range for both
perid_us and runtime_us into the sched_rt_sysctls table and processes
the values with proc_dointvec_minmax() instead.

Alternatively if we wanted to use full range of unsigned int for the
period value we would have to split the proc_handler and use
proc_douintvec() for it however even the
Documentation/scheduller/sched-rt-group.rst describes the range as 1 to
INT_MAX.

As far as I can tell the only problem this causes is that the sysctl
file allows writing negative values which when read back may confuse
userspace.

There is also a LTP test being submitted for these sysctl files at:

  http://patchwork.ozlabs.org/project/ltp/patch/20230901144433.2526-1-chrubis@suse.cz/

Signed-off-by: Cyril Hrubis <chrubis@suse.cz>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20231002115553.3007-2-chrubis@suse.cz
[ pvorel: rebased for 5.4 ]
Reviewed-by: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/rt.c |    5 +----
 kernel/sysctl.c   |    4 ++++
 2 files changed, 5 insertions(+), 4 deletions(-)

--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -2659,9 +2659,6 @@ static int sched_rt_global_constraints(v
 
 static int sched_rt_global_validate(void)
 {
-	if (sysctl_sched_rt_period <= 0)
-		return -EINVAL;
-
 	if ((sysctl_sched_rt_runtime != RUNTIME_INF) &&
 		((sysctl_sched_rt_runtime > sysctl_sched_rt_period) ||
 		 ((u64)sysctl_sched_rt_runtime *
@@ -2693,7 +2690,7 @@ int sched_rt_handler(struct ctl_table *t
 	old_period = sysctl_sched_rt_period;
 	old_runtime = sysctl_sched_rt_runtime;
 
-	ret = proc_dointvec(table, write, buffer, lenp, ppos);
+	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 
 	if (!ret && write) {
 		ret = sched_rt_global_validate();
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -465,6 +465,8 @@ static struct ctl_table kern_table[] = {
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= sched_rt_handler,
+		.extra1		= SYSCTL_ONE,
+		.extra2		= SYSCTL_INT_MAX,
 	},
 	{
 		.procname	= "sched_rt_runtime_us",
@@ -472,6 +474,8 @@ static struct ctl_table kern_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= sched_rt_handler,
+		.extra1		= &neg_one,
+		.extra2		= SYSCTL_INT_MAX,
 	},
 	{
 		.procname	= "sched_rr_timeslice_ms",


