Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185EB15749F;
	Tue,  9 Jul 2024 11:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524548; cv=none; b=M3o6YIankjeSAoIS/RFDC0+EwW7oHMGBXaEhrXi+5PNs6j8/f8iggIniWnNKXDV02q7rt0Zi4ajhz0s0wYgdcAhq4t6f4A+aKRIShVDK7p1/A5vPWXBBoYYEbCXHoDR8mkr2n+DR+06Fkeo86qRAkDnYOkF4aTYUms0PZc+9yhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524548; c=relaxed/simple;
	bh=rc7MPIZKgQJNaVlEIdCbCOnUdc1Ezd/xvHPRDlODS/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HLFHowy/S+Lpzkceth5lxkBWWHw3XjtcuQ6ZyAEWFcBUPxTqRMcOOjP3CBPPhc5RXfg7JAzVts7XnBOMpX2FGuf4UL3jLPp7zDTTAdII68jKDbugIF6YflBZcvn5p5B+3ajLViSaQb5DbqAW6Xw3XoLLFM6N97a4sot3sFrKwGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sxvRQbSp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sxvRQbSp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53097C32786;
	Tue,  9 Jul 2024 11:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524547;
	bh=rc7MPIZKgQJNaVlEIdCbCOnUdc1Ezd/xvHPRDlODS/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sxvRQbSptLEMRwACdfPTmGfAzD3KXz7jYTnMAvkzszpTe7t3ON7EW1mfO5PXz0nOG
	 GI3wNc0tNfdqW44dbMOjSRby0acdW9ku/uUhVJN5ph8HCYYqOYOZmpUWs84CmWLDpJ
	 rpuegwXRq5QCo3Uu4NkhfCocglYCxMKkwEvMrCN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Shirisha Ganta <shirisha@linux.ibm.com>,
	Mahesh Salgaonkar <mahesh@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 004/102] powerpc: Avoid nmi_enter/nmi_exit in real mode interrupt.
Date: Tue,  9 Jul 2024 13:09:27 +0200
Message-ID: <20240709110651.531382767@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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

From: Mahesh Salgaonkar <mahesh@linux.ibm.com>

[ Upstream commit 0db880fc865ffb522141ced4bfa66c12ab1fbb70 ]

nmi_enter()/nmi_exit() touches per cpu variables which can lead to kernel
crash when invoked during real mode interrupt handling (e.g. early HMI/MCE
interrupt handler) if percpu allocation comes from vmalloc area.

Early HMI/MCE handlers are called through DEFINE_INTERRUPT_HANDLER_NMI()
wrapper which invokes nmi_enter/nmi_exit calls. We don't see any issue when
percpu allocation is from the embedded first chunk. However with
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK enabled there are chances where percpu
allocation can come from the vmalloc area.

With kernel command line "percpu_alloc=page" we can force percpu allocation
to come from vmalloc area and can see kernel crash in machine_check_early:

[    1.215714] NIP [c000000000e49eb4] rcu_nmi_enter+0x24/0x110
[    1.215717] LR [c0000000000461a0] machine_check_early+0xf0/0x2c0
[    1.215719] --- interrupt: 200
[    1.215720] [c000000fffd73180] [0000000000000000] 0x0 (unreliable)
[    1.215722] [c000000fffd731b0] [0000000000000000] 0x0
[    1.215724] [c000000fffd73210] [c000000000008364] machine_check_early_common+0x134/0x1f8

Fix this by avoiding use of nmi_enter()/nmi_exit() in real mode if percpu
first chunk is not embedded.

Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Tested-by: Shirisha Ganta <shirisha@linux.ibm.com>
Signed-off-by: Mahesh Salgaonkar <mahesh@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240410043006.81577-1-mahesh@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/interrupt.h | 10 ++++++++++
 arch/powerpc/include/asm/percpu.h    | 10 ++++++++++
 arch/powerpc/kernel/setup_64.c       |  2 ++
 3 files changed, 22 insertions(+)

diff --git a/arch/powerpc/include/asm/interrupt.h b/arch/powerpc/include/asm/interrupt.h
index 6d8492b6e2b83..4999de47b4a38 100644
--- a/arch/powerpc/include/asm/interrupt.h
+++ b/arch/powerpc/include/asm/interrupt.h
@@ -355,6 +355,14 @@ static inline void interrupt_nmi_enter_prepare(struct pt_regs *regs, struct inte
 	if (IS_ENABLED(CONFIG_KASAN))
 		return;
 
+	/*
+	 * Likewise, do not use it in real mode if percpu first chunk is not
+	 * embedded. With CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK enabled there
+	 * are chances where percpu allocation can come from vmalloc area.
+	 */
+	if (percpu_first_chunk_is_paged)
+		return;
+
 	/* Otherwise, it should be safe to call it */
 	nmi_enter();
 }
@@ -370,6 +378,8 @@ static inline void interrupt_nmi_exit_prepare(struct pt_regs *regs, struct inter
 		// no nmi_exit for a pseries hash guest taking a real mode exception
 	} else if (IS_ENABLED(CONFIG_KASAN)) {
 		// no nmi_exit for KASAN in real mode
+	} else if (percpu_first_chunk_is_paged) {
+		// no nmi_exit if percpu first chunk is not embedded
 	} else {
 		nmi_exit();
 	}
diff --git a/arch/powerpc/include/asm/percpu.h b/arch/powerpc/include/asm/percpu.h
index 8e5b7d0b851c6..634970ce13c6b 100644
--- a/arch/powerpc/include/asm/percpu.h
+++ b/arch/powerpc/include/asm/percpu.h
@@ -15,6 +15,16 @@
 #endif /* CONFIG_SMP */
 #endif /* __powerpc64__ */
 
+#if defined(CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK) && defined(CONFIG_SMP)
+#include <linux/jump_label.h>
+DECLARE_STATIC_KEY_FALSE(__percpu_first_chunk_is_paged);
+
+#define percpu_first_chunk_is_paged	\
+		(static_key_enabled(&__percpu_first_chunk_is_paged.key))
+#else
+#define percpu_first_chunk_is_paged	false
+#endif /* CONFIG_PPC64 && CONFIG_SMP */
+
 #include <asm-generic/percpu.h>
 
 #include <asm/paca.h>
diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index b2e0d3ce4261c..7662265f24337 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -834,6 +834,7 @@ static __init int pcpu_cpu_to_node(int cpu)
 
 unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
 EXPORT_SYMBOL(__per_cpu_offset);
+DEFINE_STATIC_KEY_FALSE(__percpu_first_chunk_is_paged);
 
 void __init setup_per_cpu_areas(void)
 {
@@ -876,6 +877,7 @@ void __init setup_per_cpu_areas(void)
 	if (rc < 0)
 		panic("cannot initialize percpu area (err=%d)", rc);
 
+	static_key_enable(&__percpu_first_chunk_is_paged.key);
 	delta = (unsigned long)pcpu_base_addr - (unsigned long)__per_cpu_start;
 	for_each_possible_cpu(cpu) {
                 __per_cpu_offset[cpu] = delta + pcpu_unit_offsets[cpu];
-- 
2.43.0



