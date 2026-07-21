Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536DA472F8C;
	Tue, 21 Jul 2026 17:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656396; cv=none; b=O1Izfi40k+Lf8dlI38JEdeTQzBZbxag4N6zN9AFEoBmy9AbPiO3ldVQiBZu8sjOf86+87TWpCb7PClKnvfU7FDs6lwXI148dxExH3xf10/iOB8EOowLx1Tf5Ao24mDKwqXUcM49nhOEjPmqdEKmzaYP/M44F4j0rGMMStRnZZts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656396; c=relaxed/simple;
	bh=gJUHCDmP2K/MFGD0ORptTTpMQjLFZzL5bnIArFmt9e0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XLK185Xsb3wKj1/kO1m+nH097wUGdqb0FcJLPyy+84nYrG0CSSyLqOq9FWObxflxvDMqKyAcqfOOHB/3UK66cfZmwzLDbfnwvYznBxazRryLnbNkJocTUwPyVzE4zptA51XfOMvGsL8k8kKXXy1LnudX54FoqyFiZMwadVZXeg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=US2FuSx+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="US2FuSx+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 841C11F00A3A;
	Tue, 21 Jul 2026 17:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656395;
	bh=rIEpMAKeEJqea8BXTTJ+ifjZoqJzZHBySVsKqgRjFAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=US2FuSx+T53xhceGW77ev/vMy0f7MesJxy7PO4rH16qhBRDZKyQ8JILQszhLugWGI
	 AJuWIIec9cO+JLi4Y0e2rprQL5lqpfMvKXAdMoJuJj3GTH40gm6bqYxixlflBtsPpb
	 Psbjqx9b1zWCgW/0+l3oFigM8oSOHD2mAjO4SOsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Wang <hui.wang@canonical.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0369/1611] riscv: cpu_ops: Change return value type of cpu_is_stopped() to bool
Date: Tue, 21 Jul 2026 17:08:05 +0200
Message-ID: <20260721152523.472161693@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Wang <hui.wang@canonical.com>

[ Upstream commit 2b2b207e1162e577cd6208e184d3d3a0fcfa9cca ]

In the original sbi_cpu_is_stopped(), if rc doesn't equal to the
SBI_HSM_STATE_STOPPED, it will return rc to the caller directly. But
there is a hidden problem, the rc could be SBI_HSM_STATE_STARTED, if
so, this function will report cpu stopped while the cpu isn't really
stopped.

Furthermore, from the name of cpu_is_stopped(), it gives a sense the
return value is a bool type, true means the cpu is stopped, conversely
false means the cpu is not stopped.

Here change the return value type to bool and change the callers
accordingly. This could fix the above two issues.

Fixes: f1e58583b9c7c ("RISC-V: Support cpu hotplug")
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Link: https://patch.msgid.link/20260413123515.48423-1-hui.wang@canonical.com
[pjw@kernel.org: cleaned up some of the pr_warn() messages]
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/cpu_ops.h |  2 +-
 arch/riscv/kernel/cpu-hotplug.c  |  4 ++--
 arch/riscv/kernel/cpu_ops_sbi.c  | 11 +++++++----
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/riscv/include/asm/cpu_ops.h b/arch/riscv/include/asm/cpu_ops.h
index 176b570ef98276..065811fca594d9 100644
--- a/arch/riscv/include/asm/cpu_ops.h
+++ b/arch/riscv/include/asm/cpu_ops.h
@@ -24,7 +24,7 @@ struct cpu_operations {
 				     struct task_struct *tidle);
 #ifdef CONFIG_HOTPLUG_CPU
 	void		(*cpu_stop)(void);
-	int		(*cpu_is_stopped)(unsigned int cpu);
+	bool		(*cpu_is_stopped)(unsigned int cpu);
 #endif
 };
 
diff --git a/arch/riscv/kernel/cpu-hotplug.c b/arch/riscv/kernel/cpu-hotplug.c
index 3f50d3dd76c6f2..4570ff4b4e8ad6 100644
--- a/arch/riscv/kernel/cpu-hotplug.c
+++ b/arch/riscv/kernel/cpu-hotplug.c
@@ -58,8 +58,8 @@ void arch_cpuhp_cleanup_dead_cpu(unsigned int cpu)
 	/* Verify from the firmware if the cpu is really stopped*/
 	if (cpu_ops->cpu_is_stopped)
 		ret = cpu_ops->cpu_is_stopped(cpu);
-	if (ret)
-		pr_warn("CPU%u may not have stopped: %d\n", cpu, ret);
+	if (!ret)
+		pr_warn("CPU%u may not have stopped\n", cpu);
 }
 
 /*
diff --git a/arch/riscv/kernel/cpu_ops_sbi.c b/arch/riscv/kernel/cpu_ops_sbi.c
index 87d6559448039c..05b9fe3a35a419 100644
--- a/arch/riscv/kernel/cpu_ops_sbi.c
+++ b/arch/riscv/kernel/cpu_ops_sbi.c
@@ -88,16 +88,19 @@ static void sbi_cpu_stop(void)
 	pr_crit("Unable to stop the cpu %u (%d)\n", smp_processor_id(), ret);
 }
 
-static int sbi_cpu_is_stopped(unsigned int cpuid)
+static bool sbi_cpu_is_stopped(unsigned int cpuid)
 {
 	int rc;
 	unsigned long hartid = cpuid_to_hartid_map(cpuid);
 
 	rc = sbi_hsm_hart_get_status(hartid);
 
-	if (rc == SBI_HSM_STATE_STOPPED)
-		return 0;
-	return rc;
+	if (rc != SBI_HSM_STATE_STOPPED) {
+		pr_warn("HART%lu isn't stopped; status %d\n", hartid, rc);
+		return false;
+	}
+
+	return true;
 }
 #endif
 
-- 
2.53.0



