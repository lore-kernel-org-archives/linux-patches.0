Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DAC011727
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:31:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC908C433C8;
	Mon, 11 Sep 2023 14:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442670;
	bh=tb2j1k7zerH0AWen6UDR+cygguifIjYF+V1o7XAqtTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nzzhjheF7QtNBGumRZMpxOIbEo27/WohIMFHVVUBnr4AE0iBuXeZyBfrTIE7S35Es
	 vLLIu1quzjNttY/A9gEtv3F46TJXkXS2t8VSKWf9dBbyOQdfkNYQ/Y2/ZgQ40gvUaI
	 +GW3EthXcsNEDyU88Hpu2Mr6tz6fEE+a061hS53E=
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
Subject: [PATCH 6.4 089/737] KVM: x86/mmu: Add "never" option to allow sticky disabling of nx_huge_pages
Date: Mon, 11 Sep 2023 15:39:08 +0200
Message-ID: <20230911134652.987795475@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luiz Capitulino <luizcap@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |   41 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 36 insertions(+), 5 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -58,6 +58,8 @@
 
 extern bool itlb_multihit_kvm_mitigation;
 
+static bool nx_hugepage_mitigation_hard_disabled;
+
 int __read_mostly nx_huge_pages = -1;
 static uint __read_mostly nx_huge_pages_recovery_period_ms;
 #ifdef CONFIG_PREEMPT_RT
@@ -67,12 +69,13 @@ static uint __read_mostly nx_huge_pages_
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
@@ -6844,6 +6847,14 @@ static void mmu_destroy_caches(void)
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
@@ -6860,15 +6871,29 @@ static int set_nx_huge_pages(const char
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
 
@@ -7006,6 +7031,9 @@ static int set_nx_huge_pages_recovery_pa
 	uint old_period, new_period;
 	int err;
 
+	if (nx_hugepage_mitigation_hard_disabled)
+		return -EPERM;
+
 	was_recovery_enabled = calc_nx_huge_pages_recovery_period(&old_period);
 
 	err = param_set_uint(val, kp);
@@ -7164,6 +7192,9 @@ int kvm_mmu_post_init_vm(struct kvm *kvm
 {
 	int err;
 
+	if (nx_hugepage_mitigation_hard_disabled)
+		return 0;
+
 	err = kvm_vm_create_worker_thread(kvm, kvm_nx_huge_page_recovery_worker, 0,
 					  "kvm-nx-lpage-recovery",
 					  &kvm->arch.nx_huge_page_recovery_thread);


