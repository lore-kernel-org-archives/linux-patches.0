Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7856B1172A
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECFD0C433C8;
	Mon, 11 Sep 2023 15:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444744;
	bh=xGRt0e2RR2Yz/tR741zIsj7rZtS0cDr6Aw+SG1lNNeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nRvMYuuXw56wIqJ+bnX0gHqAxEKMyVw8rMrL13SDnjx7vBPud8EaXuSnIiNo1ZcOz
	 9L6AF5q9bmP5re4DzMw1JHshz38+zR6/r1DLvql5mjhAPKslCY8YjYjuE0GwsRZxwj
	 5SVKodPI0HQcDbjRWO9ro+Vbc+US74bb295aPMFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Yong He <zhuangel570@gmail.com>,
	Robert Hoo <robert.hoo.linux@gmail.com>,
	Kai Huang <kai.huang@intel.com>,
	Luiz Capitulino <luizcap@amazon.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 083/600] KVM: x86/mmu: Add "never" option to allow sticky disabling of nx_huge_pages
Date: Mon, 11 Sep 2023 15:41:56 +0200
Message-ID: <20230911134636.064666037@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit 0b210faf337314e4bc88e796218bc70c72a51209 upstream.

Add a "never" option to the nx_huge_pages module param to allow userspace
to do a one-way hard disabling of the mitigation, and don't create the
per-VM recovery threads when the mitigation is hard disabled.  Letting
userspace pinky swear that userspace doesn't want to enable NX mitigation
(without reloading KVM) allows certain use cases to avoid the latency
problems associated with spawning a kthread for each VM.

E.g. in FaaS use cases, the guest kernel is trusted and the host may
create 100+ VMs per logical CPU, which can result in 100ms+ latencies when
a burst of VMs is created.

Reported-by: Li RongQing <lirongqing@baidu.com>
Closes: https://lore.kernel.org/all/1679555884-32544-1-git-send-email-lirongqing@baidu.com
Cc: Yong He <zhuangel570@gmail.com>
Cc: Robert Hoo <robert.hoo.linux@gmail.com>
Cc: Kai Huang <kai.huang@intel.com>
Reviewed-by: Robert Hoo <robert.hoo.linux@gmail.com>
Acked-by: Kai Huang <kai.huang@intel.com>
Tested-by: Luiz Capitulino <luizcap@amazon.com>
Reviewed-by: Li RongQing <lirongqing@baidu.com>
Link: https://lore.kernel.org/r/20230602005859.784190-1-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
[ Resolved a small conflict in arch/x86/kvm/mmu/mmu.c::kvm_mmu_post_init_vm()
  which is due kvm_nx_lpage_recovery_worker() being renamed in upstream
  commit 55c510e26ab6181c132327a8b90c864e6193ce27 ]
Signed-off-by: Luiz Capitulino <luizcap@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |   41 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 36 insertions(+), 5 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -56,6 +56,8 @@
 
 extern bool itlb_multihit_kvm_mitigation;
 
+static bool nx_hugepage_mitigation_hard_disabled;
+
 int __read_mostly nx_huge_pages = -1;
 static uint __read_mostly nx_huge_pages_recovery_period_ms;
 #ifdef CONFIG_PREEMPT_RT
@@ -65,12 +67,13 @@ static uint __read_mostly nx_huge_pages_
 static uint __read_mostly nx_huge_pages_recovery_ratio = 60;
 #endif
 
+static int get_nx_huge_pages(char *buffer, const struct kernel_param *kp);
 static int set_nx_huge_pages(const char *val, const struct kernel_param *kp);
 static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel_param *kp);
 
 static const struct kernel_param_ops nx_huge_pages_ops = {
 	.set = set_nx_huge_pages,
-	.get = param_get_bool,
+	.get = get_nx_huge_pages,
 };
 
 static const struct kernel_param_ops nx_huge_pages_recovery_param_ops = {
@@ -6645,6 +6648,14 @@ static void mmu_destroy_caches(void)
 	kmem_cache_destroy(mmu_page_header_cache);
 }
 
+static int get_nx_huge_pages(char *buffer, const struct kernel_param *kp)
+{
+	if (nx_hugepage_mitigation_hard_disabled)
+		return sprintf(buffer, "never\n");
+
+	return param_get_bool(buffer, kp);
+}
+
 static bool get_nx_auto_mode(void)
 {
 	/* Return true when CPU has the bug, and mitigations are ON */
@@ -6661,15 +6672,29 @@ static int set_nx_huge_pages(const char
 	bool old_val = nx_huge_pages;
 	bool new_val;
 
+	if (nx_hugepage_mitigation_hard_disabled)
+		return -EPERM;
+
 	/* In "auto" mode deploy workaround only if CPU has the bug. */
-	if (sysfs_streq(val, "off"))
+	if (sysfs_streq(val, "off")) {
 		new_val = 0;
-	else if (sysfs_streq(val, "force"))
+	} else if (sysfs_streq(val, "force")) {
 		new_val = 1;
-	else if (sysfs_streq(val, "auto"))
+	} else if (sysfs_streq(val, "auto")) {
 		new_val = get_nx_auto_mode();
-	else if (kstrtobool(val, &new_val) < 0)
+	} else if (sysfs_streq(val, "never")) {
+		new_val = 0;
+
+		mutex_lock(&kvm_lock);
+		if (!list_empty(&vm_list)) {
+			mutex_unlock(&kvm_lock);
+			return -EBUSY;
+		}
+		nx_hugepage_mitigation_hard_disabled = true;
+		mutex_unlock(&kvm_lock);
+	} else if (kstrtobool(val, &new_val) < 0) {
 		return -EINVAL;
+	}
 
 	__set_nx_huge_pages(new_val);
 
@@ -6800,6 +6825,9 @@ static int set_nx_huge_pages_recovery_pa
 	uint old_period, new_period;
 	int err;
 
+	if (nx_hugepage_mitigation_hard_disabled)
+		return -EPERM;
+
 	was_recovery_enabled = calc_nx_huge_pages_recovery_period(&old_period);
 
 	err = param_set_uint(val, kp);
@@ -6923,6 +6951,9 @@ int kvm_mmu_post_init_vm(struct kvm *kvm
 {
 	int err;
 
+	if (nx_hugepage_mitigation_hard_disabled)
+		return 0;
+
 	err = kvm_vm_create_worker_thread(kvm, kvm_nx_lpage_recovery_worker, 0,
 					  "kvm-nx-lpage-recovery",
 					  &kvm->arch.nx_lpage_recovery_thread);


