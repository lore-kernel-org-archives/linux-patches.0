Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D701A01AD;
	Thu,  6 Jun 2024 14:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683173; cv=none; b=qULw4arO4KIbR63ahBgmo2td2u9TIUuGd3ewb/CkwTExypXKhRdBawFLXwiBWsqcZ7R38ks5HJFUWCKRTKEPRLED21GiLyOaiAsIJPBW9ORLgSM/3GZY5LYrL1npxjemEpiHnWdzIyQgkEGEoDIGDj3f5S6fPQnTg2h1sn/CNXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683173; c=relaxed/simple;
	bh=vuy3jwbK7GVBZZPyePvdNsDtFMwNnzJtLLYYJcPMhk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=COczzK29gdwsXYMeEI1jycZDJNYPenJwmDvNo4pou/wjyML8AH3cep0q58TI3qai398Xjk8BsMEZaTTBCv4kovtvp8XK7vVBL3fty9MwJAeea8JmBD9LTjdv4xunRmVZ9nnrfmpNRgDCn30UNpDoYkN7tnxf9LnEFnGYFeQ6Pk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eibXeZv8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eibXeZv8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE11C32786;
	Thu,  6 Jun 2024 14:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683172;
	bh=vuy3jwbK7GVBZZPyePvdNsDtFMwNnzJtLLYYJcPMhk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eibXeZv8ddZmlB+HHCjynUcLCUHUrhRvIWg1LZfMTsBth8JZZCoSzAqtG8mjfZ9jp
	 PMGxHs28DYlRu4IqMmcvFRxG4B2PtHOLJyxDtr5qkr9Ovvi7/sTfIk7i9w9PJKB/fS
	 zqckpvxtSaqtD/wkPEAP62qz/FL6wyE0Ry+OM3b4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Phil Auld <pauld@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 038/473] sched/isolation: Fix boot crash when maxcpus < first housekeeping CPU
Date: Thu,  6 Jun 2024 15:59:27 +0200
Message-ID: <20240606131701.147856658@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

[ Upstream commit 257bf89d84121280904800acd25cc2c444c717ae ]

housekeeping_setup() checks cpumask_intersects(present, online) to ensure
that the kernel will have at least one housekeeping CPU after smp_init(),
but this doesn't work if the maxcpus= kernel parameter limits the number of
processors available after bootup.

For example, a kernel with "maxcpus=2 nohz_full=0-2" parameters crashes at
boot time on a virtual machine with 4 CPUs.

Change housekeeping_setup() to use cpumask_first_and() and check that the
returned CPU number is valid and less than setup_max_cpus.

Another corner case is "nohz_full=0" on a machine with a single CPU or with
the maxcpus=1 kernel argument. In this case non_housekeeping_mask is empty
and tick_nohz_full_setup() makes no sense. And indeed, the kernel hits the
WARN_ON(tick_nohz_full_running) in tick_sched_do_timer().

And how should the kernel interpret the "nohz_full=" parameter? It should
be silently ignored, but currently cpulist_parse() happily returns the
empty cpumask and this leads to the same problem.

Change housekeeping_setup() to check cpumask_empty(non_housekeeping_mask)
and do nothing in this case.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Phil Auld <pauld@redhat.com>
Acked-by: Frederic Weisbecker <frederic@kernel.org>
Link: https://lore.kernel.org/r/20240413141746.GA10008@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/isolation.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 373d42c707bc5..82e2f7fc7c267 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -109,6 +109,7 @@ static void __init housekeeping_setup_type(enum hk_type type,
 static int __init housekeeping_setup(char *str, unsigned long flags)
 {
 	cpumask_var_t non_housekeeping_mask, housekeeping_staging;
+	unsigned int first_cpu;
 	int err = 0;
 
 	if ((flags & HK_FLAG_TICK) && !(housekeeping.flags & HK_FLAG_TICK)) {
@@ -129,7 +130,8 @@ static int __init housekeeping_setup(char *str, unsigned long flags)
 	cpumask_andnot(housekeeping_staging,
 		       cpu_possible_mask, non_housekeeping_mask);
 
-	if (!cpumask_intersects(cpu_present_mask, housekeeping_staging)) {
+	first_cpu = cpumask_first_and(cpu_present_mask, housekeeping_staging);
+	if (first_cpu >= nr_cpu_ids || first_cpu >= setup_max_cpus) {
 		__cpumask_set_cpu(smp_processor_id(), housekeeping_staging);
 		__cpumask_clear_cpu(smp_processor_id(), non_housekeeping_mask);
 		if (!housekeeping.flags) {
@@ -138,6 +140,9 @@ static int __init housekeeping_setup(char *str, unsigned long flags)
 		}
 	}
 
+	if (cpumask_empty(non_housekeeping_mask))
+		goto free_housekeeping_staging;
+
 	if (!housekeeping.flags) {
 		/* First setup call ("nohz_full=" or "isolcpus=") */
 		enum hk_type type;
-- 
2.43.0



