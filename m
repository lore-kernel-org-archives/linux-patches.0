Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5013819D89D;
	Thu, 15 Aug 2024 14:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732978; cv=none; b=GBDwLKQuHL7G6Pr+FxBDvWJqgbKmrLYZXgWHVjLv2hGQ7H2tO1ZxhrH6GWPHfy9PDNatMgDYOUEIiPgtxmwdRT048m9f+tQnSU2cCLvf8Y3V4nZonYvLIpaA9Ywp5osiSgsDaFnbpzTyfvOnUIF/DbeKhUkJt03OvfAMgl6qU+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732978; c=relaxed/simple;
	bh=KN1mNFjO9FLxhEmwvziHsx3l/y4ghnMwhO/Dr45u7l8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rkG/vpDWSF46tQcbZph2FoQt4l4ISFjNIdUHT/F2sBLKiiRaX1SLh01RvuoUU0TzISif4werV7qhXXBxG9iO8qynb+kIOjA1RhnMze2KcM1g+w1d8UB05uU1dqp5k/aCueam/WIyOt+FnhWvWwcC/hbnC44D+vL3v/P0d2cwj7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vi/FH+gU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vi/FH+gU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41798C32786;
	Thu, 15 Aug 2024 14:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732978;
	bh=KN1mNFjO9FLxhEmwvziHsx3l/y4ghnMwhO/Dr45u7l8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vi/FH+gU80bRxkvf/HwoPxPThuX+lIEjICoJcsInLQfIPO9gmuxI4FNMBMYOC7U9T
	 t7y32Mjd8CRwEMOSH8WSQ0STEhA7VUSHLYq8FvumqnXUyGOO1cHcHgdEVJmm2NnYJh
	 4P/AOVC9sGUw+y13ZFJdFQGLwXtctayJtxZG50Vs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Shirisha Ganta <shirisha@linux.ibm.com>,
	Mahesh Salgaonkar <mahesh@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Jinjie Ruan <ruanjinjie@huawei.com>
Subject: [PATCH 5.10 344/352] powerpc: Avoid nmi_enter/nmi_exit in real mode interrupt.
Date: Thu, 15 Aug 2024 15:26:50 +0200
Message-ID: <20240815131932.763970286@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

From: Mahesh Salgaonkar <mahesh@linux.ibm.com>

commit 0db880fc865ffb522141ced4bfa66c12ab1fbb70 upstream.

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
[ Conflicts in arch/powerpc/include/asm/interrupt.h
  because machine_check_early() and machine_check_exception()
  has been refactored. ]
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/percpu.h |   10 ++++++++++
 arch/powerpc/kernel/mce.c         |   14 +++++++++++---
 arch/powerpc/kernel/setup_64.c    |    2 ++
 arch/powerpc/kernel/traps.c       |    8 +++++++-
 4 files changed, 30 insertions(+), 4 deletions(-)

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
--- a/arch/powerpc/kernel/mce.c
+++ b/arch/powerpc/kernel/mce.c
@@ -594,8 +594,15 @@ long notrace machine_check_early(struct
 	u8 ftrace_enabled = this_cpu_get_ftrace_enabled();
 
 	this_cpu_set_ftrace_enabled(0);
-	/* Do not use nmi_enter/exit for pseries hpte guest */
-	if (radix_enabled() || !firmware_has_feature(FW_FEATURE_LPAR))
+	/*
+	 * Do not use nmi_enter/exit for pseries hpte guest
+	 *
+	 * Likewise, do not use it in real mode if percpu first chunk is not
+	 * embedded. With CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK enabled there
+	 * are chances where percpu allocation can come from vmalloc area.
+	 */
+	if ((radix_enabled() || !firmware_has_feature(FW_FEATURE_LPAR)) &&
+	    !percpu_first_chunk_is_paged)
 		nmi_enter();
 
 	hv_nmi_check_nonrecoverable(regs);
@@ -606,7 +613,8 @@ long notrace machine_check_early(struct
 	if (ppc_md.machine_check_early)
 		handled = ppc_md.machine_check_early(regs);
 
-	if (radix_enabled() || !firmware_has_feature(FW_FEATURE_LPAR))
+	if ((radix_enabled() || !firmware_has_feature(FW_FEATURE_LPAR)) &&
+	    !percpu_first_chunk_is_paged)
 		nmi_exit();
 
 	this_cpu_set_ftrace_enabled(ftrace_enabled);
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -824,6 +824,7 @@ static int pcpu_cpu_distance(unsigned in
 
 unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
 EXPORT_SYMBOL(__per_cpu_offset);
+DEFINE_STATIC_KEY_FALSE(__percpu_first_chunk_is_paged);
 
 static void __init pcpu_populate_pte(unsigned long addr)
 {
@@ -903,6 +904,7 @@ void __init setup_per_cpu_areas(void)
 	if (rc < 0)
 		panic("cannot initialize percpu area (err=%d)", rc);
 
+	static_key_enable(&__percpu_first_chunk_is_paged.key);
 	delta = (unsigned long)pcpu_base_addr - (unsigned long)__per_cpu_start;
 	for_each_possible_cpu(cpu) {
                 __per_cpu_offset[cpu] = delta + pcpu_unit_offsets[cpu];
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -835,8 +835,14 @@ void machine_check_exception(struct pt_r
 	 * This is silly. The BOOK3S_64 should just call a different function
 	 * rather than expecting semantics to magically change. Something
 	 * like 'non_nmi_machine_check_exception()', perhaps?
+	 *
+	 * Do not use nmi_enter/exit in real mode if percpu first chunk is
+	 * not embedded. With CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK enabled
+	 * there are chances where percpu allocation can come from
+	 * vmalloc area.
 	 */
-	const bool nmi = !IS_ENABLED(CONFIG_PPC_BOOK3S_64);
+	const bool nmi = !IS_ENABLED(CONFIG_PPC_BOOK3S_64) &&
+			 !percpu_first_chunk_is_paged;
 
 	if (nmi) nmi_enter();
 


