Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA07314532D;
	Tue, 27 Feb 2024 13:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041610; cv=none; b=ZmfGF5NWowZYYKcA+F6ZJFC4SaV2odsg0TjcxLs9BgGHp3e1jJqSFvx1XJ6tBwym3k5IYH3ex/kmnoIBUkZFo8m39Z7wYFNJ0QVLZ9lw6bUsXWCAs4d7MfE6VuF0Erz+LqE/cEGzsbQwKAokV/RGkTZSZnDR8MC4hzSq0lBi9lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041610; c=relaxed/simple;
	bh=Ux27qv4run7Vn004bCaIc5+9bs/99OlFQznwcq5T3ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pMrsAd83Tb6A5Hpxeg/qMkHbr7d1/B0VJIUzEsv/T6wiW6mwcjSOQQMGn88VucoHpt9IZoZJ9cyjdClL5NrpsIdIc7sqZdX25PVf3HU438ZNARP45nwuf+868c7QIDxLf2cLAnUa4hgBi0099kh2J5xmfQWdQcQyncildE/AJr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AAwL3s5g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AAwL3s5g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B9DDC433F1;
	Tue, 27 Feb 2024 13:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041610;
	bh=Ux27qv4run7Vn004bCaIc5+9bs/99OlFQznwcq5T3ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AAwL3s5gkLIMGJ+3xsaIkfiNlBg5jExbZoaRsT0H+rxi3DGCNURC9gpGqHElxKQns
	 YIJRbO429HeS+3YfFGDkd4HGP5CKLvc7vuPhDGgRSVbOLsHjJK/yC4iIje6BqBxYNJ
	 NVbB/AJtHvwdsYWSr39IThNCgwBUi+AFdPxx0Nro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cyril Hrubis <chrubis@suse.cz>,
	Ingo Molnar <mingo@kernel.org>,
	Mahmoud Adam <mngyadam@amazon.com>,
	Petr Vorel <pvorel@suse.cz>
Subject: [PATCH 6.6 001/299] sched/rt: Disallow writing invalid values to sched_rt_period_us
Date: Tue, 27 Feb 2024 14:21:52 +0100
Message-ID: <20240227131625.897283185@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Mahmoud Adam <mngyadam@amazon.com>
Signed-off-by: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/rt.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -37,6 +37,8 @@ static struct ctl_table sched_rt_sysctls
 		.maxlen         = sizeof(unsigned int),
 		.mode           = 0644,
 		.proc_handler   = sched_rt_handler,
+		.extra1         = SYSCTL_ONE,
+		.extra2         = SYSCTL_INT_MAX,
 	},
 	{
 		.procname       = "sched_rt_runtime_us",
@@ -44,6 +46,8 @@ static struct ctl_table sched_rt_sysctls
 		.maxlen         = sizeof(int),
 		.mode           = 0644,
 		.proc_handler   = sched_rt_handler,
+		.extra1         = SYSCTL_NEG_ONE,
+		.extra2         = SYSCTL_INT_MAX,
 	},
 	{
 		.procname       = "sched_rr_timeslice_ms",
@@ -2989,9 +2993,6 @@ static int sched_rt_global_constraints(v
 #ifdef CONFIG_SYSCTL
 static int sched_rt_global_validate(void)
 {
-	if (sysctl_sched_rt_period <= 0)
-		return -EINVAL;
-
 	if ((sysctl_sched_rt_runtime != RUNTIME_INF) &&
 		((sysctl_sched_rt_runtime > sysctl_sched_rt_period) ||
 		 ((u64)sysctl_sched_rt_runtime *
@@ -3022,7 +3023,7 @@ static int sched_rt_handler(struct ctl_t
 	old_period = sysctl_sched_rt_period;
 	old_runtime = sysctl_sched_rt_runtime;
 
-	ret = proc_dointvec(table, write, buffer, lenp, ppos);
+	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 
 	if (!ret && write) {
 		ret = sched_rt_global_validate();


