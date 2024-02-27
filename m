Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A6313F016;
	Tue, 27 Feb 2024 14:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042496; cv=none; b=thSNBcmh4U6AsHGYcTt3Zxi6isDn6SaebGi0Um1NeSsYGQm+J7UM4mkulEcJplbWxMQnLrQ2a+d2AmfkPL6S4pO+Ne0y5k0TbvdU5uR9hlRNz1m/d/9XW/Ft7MKxa3HvUno83L7V/CKvQAcf4BX/E47U5L69GBzwPU5ber4vvk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042496; c=relaxed/simple;
	bh=sCPe3jem4zAF1vX3hfaSq/k5KIFQAVFAhR3rwW2xFD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YmBNPFjrzKAROZ+aXVgVXP5Dhi9OpCDXStU7oYrfAKJQt7GeLJPlZI8SkRAYkh1OPsdBdaHzMdPgztslTPKq+UY8VWcQ0VQi0gczkxi02y5scl2R3OKBmRnsv6uok9hzZ2BkVbgfX8bXxNeRT1aXVcQyRbfKBYdTcxzEtpz5/88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fdBvD11J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fdBvD11J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8530AC433C7;
	Tue, 27 Feb 2024 14:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042495;
	bh=sCPe3jem4zAF1vX3hfaSq/k5KIFQAVFAhR3rwW2xFD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fdBvD11JE1Td9oTaqPfOg8XlBvenBWrnGc9pOgJ1+4vFW6xl8W+/pgkWQ/LvssVBG
	 TmSce1/bh7HP8eCvU7Dq9nmDxGXTSy/YWWyQCEBg8emaBsk+dWfELTzeCVbLUEa/ux
	 B4rJGbX6bmrusDFkhoG92k7tCBgkZ6syQ4u9qNZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cyril Hrubis <chrubis@suse.cz>,
	Ingo Molnar <mingo@kernel.org>,
	Petr Vorel <pvorel@suse.cz>
Subject: [PATCH 5.15 017/245] sched/rt: Disallow writing invalid values to sched_rt_period_us
Date: Tue, 27 Feb 2024 14:23:25 +0100
Message-ID: <20240227131615.676827553@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ pvorel: rebased for 5.15, 5.10 ]
Reviewed-by: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/rt.c |    5 +----
 kernel/sysctl.c   |    4 ++++
 2 files changed, 5 insertions(+), 4 deletions(-)

--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -2806,9 +2806,6 @@ static int sched_rt_global_constraints(v
 
 static int sched_rt_global_validate(void)
 {
-	if (sysctl_sched_rt_period <= 0)
-		return -EINVAL;
-
 	if ((sysctl_sched_rt_runtime != RUNTIME_INF) &&
 		((sysctl_sched_rt_runtime > sysctl_sched_rt_period) ||
 		 ((u64)sysctl_sched_rt_runtime *
@@ -2839,7 +2836,7 @@ int sched_rt_handler(struct ctl_table *t
 	old_period = sysctl_sched_rt_period;
 	old_runtime = sysctl_sched_rt_runtime;
 
-	ret = proc_dointvec(table, write, buffer, lenp, ppos);
+	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 
 	if (!ret && write) {
 		ret = sched_rt_global_validate();
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1821,6 +1821,8 @@ static struct ctl_table kern_table[] = {
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= sched_rt_handler,
+		.extra1		= SYSCTL_ONE,
+		.extra2		= SYSCTL_INT_MAX,
 	},
 	{
 		.procname	= "sched_rt_runtime_us",
@@ -1828,6 +1830,8 @@ static struct ctl_table kern_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= sched_rt_handler,
+		.extra1		= SYSCTL_NEG_ONE,
+		.extra2		= SYSCTL_INT_MAX,
 	},
 	{
 		.procname	= "sched_deadline_period_max_us",


