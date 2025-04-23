Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85FCB27FD56;
	Wed, 23 Apr 2025 14:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419803; cv=none; b=hmiZC8oEAJfEeeU/dWZqiRwyQ9Qj/OABIl+Q7AU9QBB2DlvfcPeRtFTBjdsr23zu6LKUk+eaBeGVrifdll6V/KSbE7bOdzJYXIG1Y0nJcO8FwldiUHxeTGK/sYY9tAMieXoqT9G+g9D5TDfRFM0OYQNqONdZR+8sknLMa9rNil4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419803; c=relaxed/simple;
	bh=1r3+SoOvafKAaonbWGzDKLWN+fHFqAEAbDoz5rq+DIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AC6gEs3hxQxy8IBrkUW/Csm+k4g+u05LaN36+VPlYObasqubWfZlLfPNRnIe5A+XlK7wgVbPcKUupZaqwb2x3brFZMXYz+wWpn+yR0IFnRg5xxRLWBENSXD893TXG3PDYMX2CbGMsip5tHj026Pnxko9BZJGyAVCl9fZEiHzG4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f5kY0v/s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f5kY0v/s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0172C4CEE2;
	Wed, 23 Apr 2025 14:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419803;
	bh=1r3+SoOvafKAaonbWGzDKLWN+fHFqAEAbDoz5rq+DIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f5kY0v/suOiILJgfn+1iinE52v8uaJ/SdjmLmq5VdQEFCdA3MDJzkB1ubu9rPiFz7
	 M+4S6fUO0HXaDs9viwOaAccgKUls7K2+8CQ1/+s0bZNBsotU17E9BbzOX2hgLG1C9N
	 ps3x+Eh8NSgzTg7TLJ0w8vPQICGzdV3ipT5lRwH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borislav Petkov <bp@alien8.de>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 029/241] xen: fix multicall debug feature
Date: Wed, 23 Apr 2025 16:41:33 +0200
Message-ID: <20250423142621.710372803@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 715ad3e0ec2b13c27335749f27a5c9f0c0e84064 ]

Initializing a percpu variable with the address of a struct tagged as
.initdata is breaking the build with CONFIG_SECTION_MISMATCH_WARN_ONLY
not set to "y".

Fix that by using an access function instead returning the .initdata
struct address if the percpu space of the struct hasn't been
allocated yet.

Fixes: 368990a7fe30 ("xen: fix multicall debug data referencing")
Reported-by: Borislav Petkov <bp@alien8.de>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Acked-by: "Borislav Petkov (AMD)" <bp@alien8.de>
Tested-by: "Borislav Petkov (AMD)" <bp@alien8.de>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20250327190602.26015-1-jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/multicalls.c | 26 ++++++++++++++------------
 arch/x86/xen/smp_pv.c     |  1 -
 arch/x86/xen/xen-ops.h    |  3 ---
 3 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/arch/x86/xen/multicalls.c b/arch/x86/xen/multicalls.c
index 10c660fae8b30..7237d56a9d3f0 100644
--- a/arch/x86/xen/multicalls.c
+++ b/arch/x86/xen/multicalls.c
@@ -54,14 +54,20 @@ struct mc_debug_data {
 
 static DEFINE_PER_CPU(struct mc_buffer, mc_buffer);
 static struct mc_debug_data mc_debug_data_early __initdata;
-static DEFINE_PER_CPU(struct mc_debug_data *, mc_debug_data) =
-	&mc_debug_data_early;
 static struct mc_debug_data __percpu *mc_debug_data_ptr;
 DEFINE_PER_CPU(unsigned long, xen_mc_irq_flags);
 
 static struct static_key mc_debug __ro_after_init;
 static bool mc_debug_enabled __initdata;
 
+static struct mc_debug_data * __ref get_mc_debug(void)
+{
+	if (!mc_debug_data_ptr)
+		return &mc_debug_data_early;
+
+	return this_cpu_ptr(mc_debug_data_ptr);
+}
+
 static int __init xen_parse_mc_debug(char *arg)
 {
 	mc_debug_enabled = true;
@@ -71,20 +77,16 @@ static int __init xen_parse_mc_debug(char *arg)
 }
 early_param("xen_mc_debug", xen_parse_mc_debug);
 
-void mc_percpu_init(unsigned int cpu)
-{
-	per_cpu(mc_debug_data, cpu) = per_cpu_ptr(mc_debug_data_ptr, cpu);
-}
-
 static int __init mc_debug_enable(void)
 {
 	unsigned long flags;
+	struct mc_debug_data __percpu *mcdb;
 
 	if (!mc_debug_enabled)
 		return 0;
 
-	mc_debug_data_ptr = alloc_percpu(struct mc_debug_data);
-	if (!mc_debug_data_ptr) {
+	mcdb = alloc_percpu(struct mc_debug_data);
+	if (!mcdb) {
 		pr_err("xen_mc_debug inactive\n");
 		static_key_slow_dec(&mc_debug);
 		return -ENOMEM;
@@ -93,7 +95,7 @@ static int __init mc_debug_enable(void)
 	/* Be careful when switching to percpu debug data. */
 	local_irq_save(flags);
 	xen_mc_flush();
-	mc_percpu_init(0);
+	mc_debug_data_ptr = mcdb;
 	local_irq_restore(flags);
 
 	pr_info("xen_mc_debug active\n");
@@ -155,7 +157,7 @@ void xen_mc_flush(void)
 	trace_xen_mc_flush(b->mcidx, b->argidx, b->cbidx);
 
 	if (static_key_false(&mc_debug)) {
-		mcdb = __this_cpu_read(mc_debug_data);
+		mcdb = get_mc_debug();
 		memcpy(mcdb->entries, b->entries,
 		       b->mcidx * sizeof(struct multicall_entry));
 	}
@@ -235,7 +237,7 @@ struct multicall_space __xen_mc_entry(size_t args)
 
 	ret.mc = &b->entries[b->mcidx];
 	if (static_key_false(&mc_debug)) {
-		struct mc_debug_data *mcdb = __this_cpu_read(mc_debug_data);
+		struct mc_debug_data *mcdb = get_mc_debug();
 
 		mcdb->caller[b->mcidx] = __builtin_return_address(0);
 		mcdb->argsz[b->mcidx] = args;
diff --git a/arch/x86/xen/smp_pv.c b/arch/x86/xen/smp_pv.c
index 6863d3da7decf..7ea57f728b89d 100644
--- a/arch/x86/xen/smp_pv.c
+++ b/arch/x86/xen/smp_pv.c
@@ -305,7 +305,6 @@ static int xen_pv_kick_ap(unsigned int cpu, struct task_struct *idle)
 		return rc;
 
 	xen_pmu_init(cpu);
-	mc_percpu_init(cpu);
 
 	/*
 	 * Why is this a BUG? If the hypercall fails then everything can be
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 63c13a2ccf556..25e318ef27d6b 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -261,9 +261,6 @@ void xen_mc_callback(void (*fn)(void *), void *data);
  */
 struct multicall_space xen_mc_extend_args(unsigned long op, size_t arg_size);
 
-/* Do percpu data initialization for multicalls. */
-void mc_percpu_init(unsigned int cpu);
-
 extern bool is_xen_pmu;
 
 irqreturn_t xen_pmu_irq_handler(int irq, void *dev_id);
-- 
2.39.5



