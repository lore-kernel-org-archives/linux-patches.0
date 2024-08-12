Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBED186E5E;
	Mon, 12 Aug 2024 16:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480568; cv=none; b=UCGKzL/7h0mU9KxpjRyXgCOlCZYM0rk+gY4KtuORgsNEvWvA6QXoqE8ThMT2IYVxseaUpL+e5cAD4iq+FBNnDOB7UKffj+6pJkMJK8GNcTE7ltf7+LD5Akua1ZSO+lW/0K4q4g+8xVKviMbKW01igCChpE2+N6WSBza6U05346o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480568; c=relaxed/simple;
	bh=larPktUZuJ13/XWMvfyiyQmWOnANMizyrfPOUok3dZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZL0AQd3y/uJV6hvhacAuMLNdc3DcMTHKYfEhS7iZSs0GEjfHlM9XIjQt4S2201uSYjrObzEAMdo+ynbgsZADvzSNWFGj5goUVxFZhtzZqfV3X0LDNqBrEZZRv8sXT6If3FL7uZ2Ez8odpYbh6/gqmAO/mw1bana+fPWnQ2zOQWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xBtqw7Ks; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xBtqw7Ks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D33AC32782;
	Mon, 12 Aug 2024 16:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480567;
	bh=larPktUZuJ13/XWMvfyiyQmWOnANMizyrfPOUok3dZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xBtqw7Ks0DjWIkvEYs+UJ6dWZoG0pg6FRiPr/BZF59JQwYdiBUG85dlISbmBXpl0N
	 EXvovgrZOIV6PaGeIg6K32SsGNeIalTqOw+OxHGQmyrPEZSUp7jzdPbin08tcGVE+D
	 UqN9khL9HiF5acMhtOETQbZBu1lhVP8K+HnrAsaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prem Nath Dey <prem.nath.dey@intel.com>,
	Xiaoping Zhou <xiaoping.zhou@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Chen Yu <yu.c.chen@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.10 236/263] x86/paravirt: Fix incorrect virt spinlock setting on bare metal
Date: Mon, 12 Aug 2024 18:03:57 +0200
Message-ID: <20240812160155.569531968@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Yu <yu.c.chen@intel.com>

commit e639222a51196c69c70b49b67098ce2f9919ed08 upstream.

The kernel can change spinlock behavior when running as a guest. But this
guest-friendly behavior causes performance problems on bare metal.

The kernel uses a static key to switch between the two modes.

In theory, the static key is enabled by default (run in guest mode) and
should be disabled for bare metal (and in some guests that want native
behavior or paravirt spinlock).

A performance drop is reported when running encode/decode workload and
BenchSEE cache sub-workload.

Bisect points to commit ce0a1b608bfc ("x86/paravirt: Silence unused
native_pv_lock_init() function warning"). When CONFIG_PARAVIRT_SPINLOCKS is
disabled the virt_spin_lock_key is incorrectly set to true on bare
metal. The qspinlock degenerates to test-and-set spinlock, which decreases
the performance on bare metal.

Set the default value of virt_spin_lock_key to false. If booting in a VM,
enable this key. Later during the VM initialization, if other
high-efficient spinlock is preferred (e.g. paravirt-spinlock), or the user
wants the native qspinlock (via nopvspin boot commandline), the
virt_spin_lock_key is disabled accordingly.

This results in the following decision matrix:

X86_FEATURE_HYPERVISOR         Y    Y       Y     N
CONFIG_PARAVIRT_SPINLOCKS      Y    Y       N     Y/N
PV spinlock                    Y    N       N     Y/N

virt_spin_lock_key             N    Y/N     Y     N

Fixes: ce0a1b608bfc ("x86/paravirt: Silence unused native_pv_lock_init() function warning")
Reported-by: Prem Nath Dey <prem.nath.dey@intel.com>
Reported-by: Xiaoping Zhou <xiaoping.zhou@intel.com>
Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
Suggested-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Suggested-by: Nikolay Borisov <nik.borisov@suse.com>
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20240806112207.29792-1-yu.c.chen@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/qspinlock.h |   12 +++++++-----
 arch/x86/kernel/paravirt.c       |    7 +++----
 2 files changed, 10 insertions(+), 9 deletions(-)

--- a/arch/x86/include/asm/qspinlock.h
+++ b/arch/x86/include/asm/qspinlock.h
@@ -66,13 +66,15 @@ static inline bool vcpu_is_preempted(lon
 
 #ifdef CONFIG_PARAVIRT
 /*
- * virt_spin_lock_key - enables (by default) the virt_spin_lock() hijack.
+ * virt_spin_lock_key - disables by default the virt_spin_lock() hijack.
  *
- * Native (and PV wanting native due to vCPU pinning) should disable this key.
- * It is done in this backwards fashion to only have a single direction change,
- * which removes ordering between native_pv_spin_init() and HV setup.
+ * Native (and PV wanting native due to vCPU pinning) should keep this key
+ * disabled. Native does not touch the key.
+ *
+ * When in a guest then native_pv_lock_init() enables the key first and
+ * KVM/XEN might conditionally disable it later in the boot process again.
  */
-DECLARE_STATIC_KEY_TRUE(virt_spin_lock_key);
+DECLARE_STATIC_KEY_FALSE(virt_spin_lock_key);
 
 /*
  * Shortcut for the queued_spin_lock_slowpath() function that allows
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -51,13 +51,12 @@ DEFINE_ASM_FUNC(pv_native_irq_enable, "s
 DEFINE_ASM_FUNC(pv_native_read_cr2, "mov %cr2, %rax", .noinstr.text);
 #endif
 
-DEFINE_STATIC_KEY_TRUE(virt_spin_lock_key);
+DEFINE_STATIC_KEY_FALSE(virt_spin_lock_key);
 
 void __init native_pv_lock_init(void)
 {
-	if (IS_ENABLED(CONFIG_PARAVIRT_SPINLOCKS) &&
-	    !boot_cpu_has(X86_FEATURE_HYPERVISOR))
-		static_branch_disable(&virt_spin_lock_key);
+	if (boot_cpu_has(X86_FEATURE_HYPERVISOR))
+		static_branch_enable(&virt_spin_lock_key);
 }
 
 static void native_tlb_remove_table(struct mmu_gather *tlb, void *table)


