Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A8A20C004;
	Wed,  5 Mar 2025 18:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197829; cv=none; b=nM+7WRmhGCelYzIG6Z2Fd8hG8ReUNbaTfqiuHENelsCGj0Upo1pk3L6DDGdrw8ZRC0ZidF2QWvkCXISopnekDWqUimfiPrECRl+DBYNK8D8UR9l9y5LHmxx4VU4KVO1uw9DzpsqCvniT5Mso1Z5eXyxtM0SY5eCV7YPi6TpbTcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197829; c=relaxed/simple;
	bh=Dihy9Wqy9GHisFwpuOgSSJlCbBsRyrjdZcLe4sdYq0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJ3aNmznH0YzCainQErUp6cpaYhxzmFgzzF8K8AOAGj6qbUR0oIgXWICzSXvc5uE1QVYyjSLilTN1hMu3i84c9PNdgeziNjGXGD2VYvtYsPegG5dBrLD6FMLDJwV7G69av4Tenz2id49alKtZKC6ngl4HhzCjyvedDXH5PLTgrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mdKkMIgh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mdKkMIgh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CECA4C4CEE9;
	Wed,  5 Mar 2025 18:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197829;
	bh=Dihy9Wqy9GHisFwpuOgSSJlCbBsRyrjdZcLe4sdYq0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mdKkMIghnXgz73RCV9MJk91lkQoPxGAnt4wfbu1cBMgge93QEe0mIVLaUZD1m1mP+
	 ANAn+cGUAsHTG0ZmMrfAgnx2op07OdC5fNZqafdOJuhVQTaJhItKrjlFWdPrsa0Ubl
	 g9q7XL98M8WqxH0nftqyzc8q0bsKX0gZp8q0jlBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.6 115/142] x86/microcode: Get rid of the schedule work indirection
Date: Wed,  5 Mar 2025 18:48:54 +0100
Message-ID: <20250305174504.949541181@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 2e1997335ceb6fc819862804f51d4fe83593c138 upstream

Scheduling work on all CPUs to collect the microcode information is just
another extra step for no value. Let the CPU hotplug callback registration
do it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20231017211723.354748138@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/core.c |   29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -481,8 +481,16 @@ static struct syscore_ops mc_syscore_ops
 
 static int mc_cpu_online(unsigned int cpu)
 {
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 	struct device *dev = get_cpu_device(cpu);
 
+	memset(uci, 0, sizeof(*uci));
+
+	microcode_ops->collect_cpu_info(cpu, &uci->cpu_sig);
+	cpu_data(cpu).microcode = uci->cpu_sig.rev;
+	if (!cpu)
+		boot_cpu_data.microcode = uci->cpu_sig.rev;
+
 	if (sysfs_create_group(&dev->kobj, &mc_attr_group))
 		pr_err("Failed to create group for CPU%d\n", cpu);
 	return 0;
@@ -503,20 +511,6 @@ static int mc_cpu_down_prep(unsigned int
 	return 0;
 }
 
-static void setup_online_cpu(struct work_struct *work)
-{
-	int cpu = smp_processor_id();
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-
-	memset(uci, 0, sizeof(*uci));
-
-	microcode_ops->collect_cpu_info(cpu, &uci->cpu_sig);
-	cpu_data(cpu).microcode = uci->cpu_sig.rev;
-	if (!cpu)
-		boot_cpu_data.microcode = uci->cpu_sig.rev;
-	mc_cpu_online(cpu);
-}
-
 static struct attribute *cpu_root_microcode_attrs[] = {
 #ifdef CONFIG_MICROCODE_LATE_LOADING
 	&dev_attr_reload.attr,
@@ -562,12 +556,9 @@ static int __init microcode_init(void)
 		}
 	}
 
-	/* Do per-CPU setup */
-	schedule_on_each_cpu(setup_online_cpu);
-
 	register_syscore_ops(&mc_syscore_ops);
-	cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN, "x86/microcode:online",
-				  mc_cpu_online, mc_cpu_down_prep);
+	cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "x86/microcode:online",
+			  mc_cpu_online, mc_cpu_down_prep);
 
 	pr_info("Microcode Update Driver: v%s.", DRIVER_VERSION);
 


