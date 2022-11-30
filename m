Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4724A79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:35:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8212C433C1;
	Wed, 30 Nov 2022 18:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833313;
	bh=AFEZGOAVGXfwZy5s4pOdhmRMRGBns6r4DngWqFm+kNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SlIF+KlP6XtW7bJjMoVHDEjU3xHhXO8Rzal0hAsGK8hepoFmqbSoqinJ8cm4MPK1g
	 YkjM3qW5iMftcGX0kaCxiwEKVNdSzO047niPUg9cZAHxyolXS0cYJakCymoITZw/ja
	 zIemL4oyoOfYl6YlO797yHJu2qA/PP728Bf3hYpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Michael Kelley <mikelley@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 062/206] x86/hyperv: Restore VP assist page after cpu offlining/onlining
Date: Wed, 30 Nov 2022 19:21:54 +0100
Message-Id: <20221130180534.579317229@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit ee6815416380bc069b7dcbdff0682d4c53617527 ]

Commit e5d9b714fe40 ("x86/hyperv: fix root partition faults when writing
to VP assist page MSR") moved 'wrmsrl(HV_X64_MSR_VP_ASSIST_PAGE)' under
'if (*hvp)' condition. This works for root partition as hv_cpu_die()
does memunmap() and sets 'hv_vp_assist_page[cpu]' to NULL but breaks
non-root partitions as hv_cpu_die() doesn't free 'hv_vp_assist_page[cpu]'
for them. This causes VP assist page to remain unset after CPU
offline/online cycle:

$ rdmsr -p 24 0x40000073
  10212f001
$ echo 0 > /sys/devices/system/cpu/cpu24/online
$ echo 1 > /sys/devices/system/cpu/cpu24/online
$ rdmsr -p 24 0x40000073
  0

Fix the issue by always writing to HV_X64_MSR_VP_ASSIST_PAGE in
hv_cpu_init(). Note, checking 'if (!*hvp)', for root partition is
pointless as hv_cpu_die() always sets 'hv_vp_assist_page[cpu]' to
NULL (and it's also NULL initially).

Note: the fact that 'hv_vp_assist_page[cpu]' is reset to NULL may
present a (potential) issue for KVM. While Hyper-V uses
CPUHP_AP_ONLINE_DYN stage in CPU hotplug, KVM uses CPUHP_AP_KVM_STARTING
which comes earlier in CPU teardown sequence. It is theoretically
possible that Enlightened VMCS is still in use. It is unclear if the
issue is real and if using KVM with Hyper-V root partition is even
possible.

While on it, drop the unneeded smp_processor_id() call from hv_cpu_init().

Fixes: e5d9b714fe40 ("x86/hyperv: fix root partition faults when writing to VP assist page MSR")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/20221103190601.399343-1-vkuznets@redhat.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/hyperv/hv_init.c | 54 +++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 28 deletions(-)

diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index b6d48ca5b0f1..762f10cdfb7a 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -45,7 +45,7 @@ EXPORT_SYMBOL_GPL(hv_vp_assist_page);
 static int hv_cpu_init(unsigned int cpu)
 {
 	union hv_vp_assist_msr_contents msr = { 0 };
-	struct hv_vp_assist_page **hvp = &hv_vp_assist_page[smp_processor_id()];
+	struct hv_vp_assist_page **hvp = &hv_vp_assist_page[cpu];
 	int ret;
 
 	ret = hv_common_cpu_init(cpu);
@@ -55,34 +55,32 @@ static int hv_cpu_init(unsigned int cpu)
 	if (!hv_vp_assist_page)
 		return 0;
 
-	if (!*hvp) {
-		if (hv_root_partition) {
-			/*
-			 * For root partition we get the hypervisor provided VP assist
-			 * page, instead of allocating a new page.
-			 */
-			rdmsrl(HV_X64_MSR_VP_ASSIST_PAGE, msr.as_uint64);
-			*hvp = memremap(msr.pfn <<
-					HV_X64_MSR_VP_ASSIST_PAGE_ADDRESS_SHIFT,
-					PAGE_SIZE, MEMREMAP_WB);
-		} else {
-			/*
-			 * The VP assist page is an "overlay" page (see Hyper-V TLFS's
-			 * Section 5.2.1 "GPA Overlay Pages"). Here it must be zeroed
-			 * out to make sure we always write the EOI MSR in
-			 * hv_apic_eoi_write() *after* the EOI optimization is disabled
-			 * in hv_cpu_die(), otherwise a CPU may not be stopped in the
-			 * case of CPU offlining and the VM will hang.
-			 */
+	if (hv_root_partition) {
+		/*
+		 * For root partition we get the hypervisor provided VP assist
+		 * page, instead of allocating a new page.
+		 */
+		rdmsrl(HV_X64_MSR_VP_ASSIST_PAGE, msr.as_uint64);
+		*hvp = memremap(msr.pfn << HV_X64_MSR_VP_ASSIST_PAGE_ADDRESS_SHIFT,
+				PAGE_SIZE, MEMREMAP_WB);
+	} else {
+		/*
+		 * The VP assist page is an "overlay" page (see Hyper-V TLFS's
+		 * Section 5.2.1 "GPA Overlay Pages"). Here it must be zeroed
+		 * out to make sure we always write the EOI MSR in
+		 * hv_apic_eoi_write() *after* the EOI optimization is disabled
+		 * in hv_cpu_die(), otherwise a CPU may not be stopped in the
+		 * case of CPU offlining and the VM will hang.
+		 */
+		if (!*hvp)
 			*hvp = __vmalloc(PAGE_SIZE, GFP_KERNEL | __GFP_ZERO);
-			if (*hvp)
-				msr.pfn = vmalloc_to_pfn(*hvp);
-		}
-		WARN_ON(!(*hvp));
-		if (*hvp) {
-			msr.enable = 1;
-			wrmsrl(HV_X64_MSR_VP_ASSIST_PAGE, msr.as_uint64);
-		}
+		if (*hvp)
+			msr.pfn = vmalloc_to_pfn(*hvp);
+
+	}
+	if (!WARN_ON(!(*hvp))) {
+		msr.enable = 1;
+		wrmsrl(HV_X64_MSR_VP_ASSIST_PAGE, msr.as_uint64);
 	}
 
 	return 0;
-- 
2.35.1



