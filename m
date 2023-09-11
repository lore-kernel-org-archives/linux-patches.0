Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684381170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:58:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45C9C433C7;
	Mon, 11 Sep 2023 13:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440693;
	bh=x7sA8oM5gAdYD95GkvZ0vU5qq572CMBVI01wDoIs0Po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mDWppOOANTqrnpm8TPXI8qjzb4Mz9oHh7T2ccTiKr54vb/9pIiZy+l4RLzIr0oYA6
	 eVHnN488bs+lWi7MBcJzV4pbbLNBqv3tRjprtu5tNlwfq3R6n9mwldc9R+v9FsUA0q
	 uqycuhVyhK1ClhD5kIBMYNCfRpknI0km9MhBMenk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	kernel test robot <lkp@intel.com>,
	Michal Hocko <mhocko@suse.com>,
	Petr Mladek <pmladek@suse.com>,
	Lecopzer Chen <lecopzer.chen@mediatek.com>,
	Pingfan Liu <kernelfans@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 152/739] watchdog/hardlockup: avoid large stack frames in watchdog_hardlockup_check()
Date: Mon, 11 Sep 2023 15:39:11 +0200
Message-ID: <20230911134655.379252397@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 1f38c86bb29f4548b8df01b47a313518e6ed2dfe ]

After commit 77c12fc95980 ("watchdog/hardlockup: add a "cpu" param to
watchdog_hardlockup_check()") we started storing a `struct cpumask` on the
stack in watchdog_hardlockup_check().  On systems with CONFIG_NR_CPUS set
to 8192 this takes up 1K on the stack.  That triggers warnings with
`CONFIG_FRAME_WARN` set to 1024.

We'll use the new trigger_allbutcpu_cpu_backtrace() to avoid needing to
use a CPU mask at all.

Link: https://lkml.kernel.org/r/20230804065935.v4.2.I501ab68cb926ee33a7c87e063d207abf09b9943c@changeid
Fixes: 77c12fc95980 ("watchdog/hardlockup: add a "cpu" param to watchdog_hardlockup_check()")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202307310955.pLZDhpnl-lkp@intel.com
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Lecopzer Chen <lecopzer.chen@mediatek.com>
Cc: Pingfan Liu <kernelfans@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/watchdog.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 085d7a78f62f0..d145305d95fe8 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -151,9 +151,6 @@ void watchdog_hardlockup_check(unsigned int cpu, struct pt_regs *regs)
 	 */
 	if (is_hardlockup(cpu)) {
 		unsigned int this_cpu = smp_processor_id();
-		struct cpumask backtrace_mask;
-
-		cpumask_copy(&backtrace_mask, cpu_online_mask);
 
 		/* Only print hardlockups once. */
 		if (per_cpu(watchdog_hardlockup_warned, cpu))
@@ -167,10 +164,8 @@ void watchdog_hardlockup_check(unsigned int cpu, struct pt_regs *regs)
 				show_regs(regs);
 			else
 				dump_stack();
-			cpumask_clear_cpu(cpu, &backtrace_mask);
 		} else {
-			if (trigger_single_cpu_backtrace(cpu))
-				cpumask_clear_cpu(cpu, &backtrace_mask);
+			trigger_single_cpu_backtrace(cpu);
 		}
 
 		/*
@@ -179,7 +174,7 @@ void watchdog_hardlockup_check(unsigned int cpu, struct pt_regs *regs)
 		 */
 		if (sysctl_hardlockup_all_cpu_backtrace &&
 		    !test_and_set_bit(0, &watchdog_hardlockup_all_cpu_dumped))
-			trigger_cpumask_backtrace(&backtrace_mask);
+			trigger_allbutcpu_cpu_backtrace(cpu);
 
 		if (hardlockup_panic)
 			nmi_panic(regs, "Hard LOCKUP");
-- 
2.40.1



