Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9BE13AA4C;
	Tue, 27 Feb 2024 14:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044040; cv=none; b=AKujoiFXHpBEFVb6mFeHXID5dluVt4q10w8c6JrK/9dORaWxMdIUN9nhXZlzH+MKyGtxPXKHO1LVOQuI36oCZDHQjP2XKm6+wY8PoigdMLhg0HJSW9FfZ1E4qbxklxMnX7V6NmvIoOHdIdxV6U+pUCj1EjY4KN+or4Io1FZgoJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044040; c=relaxed/simple;
	bh=PArotD1YPAv3ucFifxlwhHZG6vqSH5woFd0XByBIm5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kYuVv0J3Ph5oNFxKozKQH30rP2oaP6B2PNt0gjD7o5j8o0h3zCWDzhnB3jAPOdi2DC4f3ImoOoJWBH99LjZGCD2Uq8rO7pRoF0vpRPjkQqsLu9MUg0gPAUXKwW6YSQpmNeQgECwGqZ6luur+4WTblhd4JSKfOiJD5nH9HFEe6/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jv+BM+NB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jv+BM+NB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12778C433F1;
	Tue, 27 Feb 2024 14:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044039;
	bh=PArotD1YPAv3ucFifxlwhHZG6vqSH5woFd0XByBIm5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jv+BM+NBwz6poggHzO0NrY3blSmoQsHTeM/77/rGEAZ9ds392cnu4kqhwf6WdC8Je
	 B5UDQsQeMlgrBG9/Wi4GmEOcbxHgHibq67syekkNkS51A/NhlS60YQMOpk4/ipCCTA
	 kZtjum9VlBBNuTmrcdfom+hLjA437V/ANTlwyKPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cyril Hrubis <chrubis@suse.cz>,
	Ingo Molnar <mingo@kernel.org>,
	Petr Vorel <pvorel@suse.cz>
Subject: [PATCH 5.10 011/122] sched/rt: Disallow writing invalid values to sched_rt_period_us
Date: Tue, 27 Feb 2024 14:26:12 +0100
Message-ID: <20240227131559.076952635@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2727,9 +2727,6 @@ static int sched_rt_global_constraints(v
 
 static int sched_rt_global_validate(void)
 {
-	if (sysctl_sched_rt_period <= 0)
-		return -EINVAL;
-
 	if ((sysctl_sched_rt_runtime != RUNTIME_INF) &&
 		((sysctl_sched_rt_runtime > sysctl_sched_rt_period) ||
 		 ((u64)sysctl_sched_rt_runtime *
@@ -2760,7 +2757,7 @@ int sched_rt_handler(struct ctl_table *t
 	old_period = sysctl_sched_rt_period;
 	old_runtime = sysctl_sched_rt_runtime;
 
-	ret = proc_dointvec(table, write, buffer, lenp, ppos);
+	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 
 	if (!ret && write) {
 		ret = sched_rt_global_validate();
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1859,6 +1859,8 @@ static struct ctl_table kern_table[] = {
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= sched_rt_handler,
+		.extra1		= SYSCTL_ONE,
+		.extra2		= SYSCTL_INT_MAX,
 	},
 	{
 		.procname	= "sched_rt_runtime_us",
@@ -1866,6 +1868,8 @@ static struct ctl_table kern_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= sched_rt_handler,
+		.extra1		= SYSCTL_NEG_ONE,
+		.extra2		= SYSCTL_INT_MAX,
 	},
 	{
 		.procname	= "sched_deadline_period_max_us",


