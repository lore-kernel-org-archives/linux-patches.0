Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86CB20B19
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:56:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BAEBC433C8;
	Wed, 20 Sep 2023 11:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210974;
	bh=1eRRs5MrpOY8nc7Lu0j3x+GS+NqKow5uEZRCgY31twQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a+x79I109jwiGJg3A09aG44UuX6KVFLhy3f2G4EL2XMj3sqjDYi3OMOshSRxsADLp
	 L7dBv1T8ibtZBNoq6HPyd7bnIstjMEc6rmdLYUic3M8rR94TXHNfgDl4TEjW0+3FyN
	 26ecY8m3CqCrxKVX7zviqC/CdxuHM+vG+tkxjW50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?M=C3=A5rten=20Lindahl?= <marten.lindahl@axis.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 061/139] ARM: 9317/1: kexec: Make smp stop calls asynchronous
Date: Wed, 20 Sep 2023 13:29:55 +0200
Message-ID: <20230920112837.972951044@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112835.549467415@linuxfoundation.org>
References: <20230920112835.549467415@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mårten Lindahl <marten.lindahl@axis.com>

[ Upstream commit 8922ba71c969d2a0c01a94372a71477d879470de ]

If a panic is triggered by a hrtimer interrupt all online cpus will be
notified and set offline. But as highlighted by commit 19dbdcb8039c
("smp: Warn on function calls from softirq context") this call should
not be made synchronous with disabled interrupts:

 softdog: Initiating panic
 Kernel panic - not syncing: Software Watchdog Timer expired
 WARNING: CPU: 1 PID: 0 at kernel/smp.c:753 smp_call_function_many_cond
   unwind_backtrace:
     show_stack
     dump_stack_lvl
     __warn
     warn_slowpath_fmt
     smp_call_function_many_cond
     smp_call_function
     crash_smp_send_stop.part.0
     machine_crash_shutdown
     __crash_kexec
     panic
     softdog_fire
     __hrtimer_run_queues
     hrtimer_interrupt

Make the smp call for machine_crash_nonpanic_core() asynchronous.

Signed-off-by: Mårten Lindahl <marten.lindahl@axis.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/machine_kexec.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kernel/machine_kexec.c b/arch/arm/kernel/machine_kexec.c
index f567032a09c0b..6d1938d1b4df7 100644
--- a/arch/arm/kernel/machine_kexec.c
+++ b/arch/arm/kernel/machine_kexec.c
@@ -92,16 +92,28 @@ void machine_crash_nonpanic_core(void *unused)
 	}
 }
 
+static DEFINE_PER_CPU(call_single_data_t, cpu_stop_csd) =
+	CSD_INIT(machine_crash_nonpanic_core, NULL);
+
 void crash_smp_send_stop(void)
 {
 	static int cpus_stopped;
 	unsigned long msecs;
+	call_single_data_t *csd;
+	int cpu, this_cpu = raw_smp_processor_id();
 
 	if (cpus_stopped)
 		return;
 
 	atomic_set(&waiting_for_crash_ipi, num_online_cpus() - 1);
-	smp_call_function(machine_crash_nonpanic_core, NULL, false);
+	for_each_online_cpu(cpu) {
+		if (cpu == this_cpu)
+			continue;
+
+		csd = &per_cpu(cpu_stop_csd, cpu);
+		smp_call_function_single_async(cpu, csd);
+	}
+
 	msecs = 1000; /* Wait at most a second for the other cpus to stop */
 	while ((atomic_read(&waiting_for_crash_ipi) > 0) && msecs) {
 		mdelay(1);
-- 
2.40.1



