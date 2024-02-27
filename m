Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273A113A25D;
	Tue, 27 Feb 2024 13:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041455; cv=none; b=OlTlCO3wt+xhUobU98P/6rqIyPkB+lRXs740U7OxgDbeXBR+VxptmC2f9xlRvgw1ByxfZFebG8pBYoeFljTjh+yPJAJnrNsj0oqiUu7U6E3H2oVwg6WYrY1jFwqKiHNfMfbc6gG2KcKVMprPzDdsqkdsRtkyHTcLRWiH3AyCGGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041455; c=relaxed/simple;
	bh=OOrHrfRxqmMlCzcTN7kRrxUYyDdGYgK9kZmkiAH1cOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nfE21zgz2jqVlQkSKWLVEnUS621iGSao/0E6dEgOj/cEoFIQUXC4lio8q4Jm5LeN6yXLwOf2eONO1jmy/AYizJ8ETsF05ikybviF0+pxKs4qJAzY0dVF82GBhe0a5I1IKatv10yH9VQVJC0RGbr43v5vWwO/wlxl3EoRg5EL9TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CtOM72AU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CtOM72AU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F9D5C433F1;
	Tue, 27 Feb 2024 13:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041455;
	bh=OOrHrfRxqmMlCzcTN7kRrxUYyDdGYgK9kZmkiAH1cOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CtOM72AU/i9INvo+OWWDhRpnjuX3lQbnTXQBZQ3YKrlvrcSW/SMTwPkBX4+ggNyaw
	 YaudurBlJyysvhJiT72GAmwzCMdfKbLdVmTO5eqkrdN0y0ughlWwk9BasTyif0yHAR
	 kLVsZu1DuSg529/bjdMniDBxWG3ZWXLXYbv174Ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cyril Hrubis <chrubis@suse.cz>,
	Ingo Molnar <mingo@kernel.org>,
	Petr Vorel <pvorel@suse.cz>
Subject: [PATCH 4.19 11/52] sched/rt: Disallow writing invalid values to sched_rt_period_us
Date: Tue, 27 Feb 2024 14:25:58 +0100
Message-ID: <20240227131548.904890318@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131548.514622258@linuxfoundation.org>
References: <20240227131548.514622258@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cyril Hrubis <chrubis@suse.cz>

[ Upstream commit 079be8fc630943d9fc70a97807feb73d169ee3fc ]

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
[ pvorel: rebased for 4.19 ]
Reviewed-by: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/rt.c |    5 +----
 kernel/sysctl.c   |    5 +++++
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -2658,9 +2658,6 @@ static int sched_rt_global_constraints(v
 
 static int sched_rt_global_validate(void)
 {
-	if (sysctl_sched_rt_period <= 0)
-		return -EINVAL;
-
 	if ((sysctl_sched_rt_runtime != RUNTIME_INF) &&
 		(sysctl_sched_rt_runtime > sysctl_sched_rt_period))
 		return -EINVAL;
@@ -2690,7 +2687,7 @@ int sched_rt_handler(struct ctl_table *t
 	old_period = sysctl_sched_rt_period;
 	old_runtime = sysctl_sched_rt_runtime;
 
-	ret = proc_dointvec(table, write, buffer, lenp, ppos);
+	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 
 	if (!ret && write) {
 		ret = sched_rt_global_validate();
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -127,6 +127,7 @@ static int zero;
 static int __maybe_unused one = 1;
 static int __maybe_unused two = 2;
 static int __maybe_unused four = 4;
+static int int_max = INT_MAX;
 static unsigned long zero_ul;
 static unsigned long one_ul = 1;
 static unsigned long long_max = LONG_MAX;
@@ -464,6 +465,8 @@ static struct ctl_table kern_table[] = {
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= sched_rt_handler,
+		.extra1		= &one,
+		.extra2		= &int_max,
 	},
 	{
 		.procname	= "sched_rt_runtime_us",
@@ -471,6 +474,8 @@ static struct ctl_table kern_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= sched_rt_handler,
+		.extra1		= &neg_one,
+		.extra2		= &int_max,
 	},
 	{
 		.procname	= "sched_rr_timeslice_ms",


