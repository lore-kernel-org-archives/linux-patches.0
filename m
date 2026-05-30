Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE153264DC;
	Sat, 30 May 2026 16:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159727; cv=none; b=eejOmBEqnOi1W98vVSSPtY0rsotaUGgeed6k+HFyZ5aOQ8gK0XNa722MvK+uUUjF+5jw0QH0z5DELoSO9aFf9Tq/U0akiWUyjIVxzExHEOtrOHV1O/JpcbQga/xaMsEOMFRxkr2V4ep/8ofmG5MFwzveLYcr2OlfizW9OMy4X5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159727; c=relaxed/simple;
	bh=t1AH/+aKbaXktDkZVW/K5dGW6gBdeqgTlSidHpLaH9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e5vGUZZ7mrdMFQ0FTJ7/RhRFWZ6XHJLhfVcBi/IsXEW5KrrueYZZpWYjc1h0Tfj1QG0Stfr2JhOL6bFOdmSwaFWJhISteTdSbZ3X1vK44nFWaFiRDZKwank45uBjRAkUC+RBaS558NxkzSJUA1maIo9yQVeKCAS9eNGpSfqQRzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kt3rWiCC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kt3rWiCC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E1AD1F00893;
	Sat, 30 May 2026 16:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159726;
	bh=sgcJ6qG7d3AOtb13v2xjBJG/hUtFESCb1Yq5EGV/kOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kt3rWiCCbjC/ESDx9cHupYgFxY82HZc2cRyEHjhNCHNiBGbcZY4oTxpOtZR34d0+r
	 vqcAFyYDbQqRXzVZBTSKVt56avi5Pop6mBiDx+8qw7BSC7SiWq3kMJU9GG0Z6/2Ie9
	 J+EuJ/23xRYOCuOlZouLgmPa4Baq48EDRC8PowkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw@amazon.co.uk>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 128/969] KVM: x86: Use __DECLARE_FLEX_ARRAY() for UAPI structures with VLAs
Date: Sat, 30 May 2026 17:54:12 +0200
Message-ID: <20260530160304.103541843@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Woodhouse <dwmw@amazon.co.uk>

[ Upstream commit 2619da73bb2f10d88f7e1087125c40144fdf0987 ]

Commit 94dfc73e7cf4 ("treewide: uapi: Replace zero-length arrays with
flexible-array members") broke the userspace API for C++.

These structures ending in VLAs are typically a *header*, which can be
followed by an arbitrary number of entries. Userspace typically creates
a larger structure with some non-zero number of entries, for example in
QEMU's kvm_arch_get_supported_msr_feature():

    struct {
        struct kvm_msrs info;
        struct kvm_msr_entry entries[1];
    } msr_data = {};

While that works in C, it fails in C++ with an error like:
 flexible array member 'kvm_msrs::entries' not at end of 'struct msr_data'

Fix this by using __DECLARE_FLEX_ARRAY() for the VLA, which uses [0]
for C++ compilation.

Fixes: 94dfc73e7cf4 ("treewide: uapi: Replace zero-length arrays with flexible-array members")
Cc: stable@vger.kernel.org
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Link: https://patch.msgid.link/3abaf6aefd6e5efeff3b860ac38421d9dec908db.camel@infradead.org
[sean: tag for stable@]
Signed-off-by: Sean Christopherson <seanjc@google.com>
[ applied `__DECLARE_FLEX_ARRAY(char, name)` change directly instead of inside missing `#ifdef __KERNEL__` else branch ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/uapi/asm/kvm.h |   12 ++++++------
 include/uapi/linux/kvm.h        |   11 ++++++-----
 2 files changed, 12 insertions(+), 11 deletions(-)

--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -198,13 +198,13 @@ struct kvm_msrs {
 	__u32 nmsrs; /* number of msrs in entries */
 	__u32 pad;
 
-	struct kvm_msr_entry entries[];
+	__DECLARE_FLEX_ARRAY(struct kvm_msr_entry, entries);
 };
 
 /* for KVM_GET_MSR_INDEX_LIST */
 struct kvm_msr_list {
 	__u32 nmsrs; /* number of msrs in entries */
-	__u32 indices[];
+	__DECLARE_FLEX_ARRAY(__u32, indices);
 };
 
 /* Maximum size of any access bitmap in bytes */
@@ -241,7 +241,7 @@ struct kvm_cpuid_entry {
 struct kvm_cpuid {
 	__u32 nent;
 	__u32 padding;
-	struct kvm_cpuid_entry entries[];
+	__DECLARE_FLEX_ARRAY(struct kvm_cpuid_entry, entries);
 };
 
 struct kvm_cpuid_entry2 {
@@ -263,7 +263,7 @@ struct kvm_cpuid_entry2 {
 struct kvm_cpuid2 {
 	__u32 nent;
 	__u32 padding;
-	struct kvm_cpuid_entry2 entries[];
+	__DECLARE_FLEX_ARRAY(struct kvm_cpuid_entry2, entries);
 };
 
 /* for KVM_GET_PIT and KVM_SET_PIT */
@@ -394,7 +394,7 @@ struct kvm_xsave {
 	 * the contents of CPUID leaf 0xD on the host.
 	 */
 	__u32 region[1024];
-	__u32 extra[];
+	__DECLARE_FLEX_ARRAY(__u32, extra);
 };
 
 #define KVM_MAX_XCRS	16
@@ -522,7 +522,7 @@ struct kvm_pmu_event_filter {
 	__u32 fixed_counter_bitmap;
 	__u32 flags;
 	__u32 pad[4];
-	__u64 events[];
+	__DECLARE_FLEX_ARRAY(__u64, events);
 };
 
 #define KVM_PMU_EVENT_ALLOW 0
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -11,6 +11,7 @@
 #include <linux/const.h>
 #include <linux/types.h>
 #include <linux/compiler.h>
+#include <linux/stddef.h>
 #include <linux/ioctl.h>
 #include <asm/kvm.h>
 
@@ -556,7 +557,7 @@ struct kvm_coalesced_mmio {
 
 struct kvm_coalesced_mmio_ring {
 	__u32 first, last;
-	struct kvm_coalesced_mmio coalesced_mmio[];
+	__DECLARE_FLEX_ARRAY(struct kvm_coalesced_mmio, coalesced_mmio);
 };
 
 #define KVM_COALESCED_MMIO_MAX \
@@ -635,7 +636,7 @@ struct kvm_clear_dirty_log {
 /* for KVM_SET_SIGNAL_MASK */
 struct kvm_signal_mask {
 	__u32 len;
-	__u8  sigset[];
+	__DECLARE_FLEX_ARRAY(__u8, sigset);
 };
 
 /* for KVM_TPR_ACCESS_REPORTING */
@@ -1242,7 +1243,7 @@ struct kvm_irq_routing_entry {
 struct kvm_irq_routing {
 	__u32 nr;
 	__u32 flags;
-	struct kvm_irq_routing_entry entries[];
+	__DECLARE_FLEX_ARRAY(struct kvm_irq_routing_entry, entries);
 };
 
 #endif
@@ -1362,7 +1363,7 @@ struct kvm_dirty_tlb {
 
 struct kvm_reg_list {
 	__u64 n; /* number of regs */
-	__u64 reg[];
+	__DECLARE_FLEX_ARRAY(__u64, reg);
 };
 
 struct kvm_one_reg {
@@ -2183,7 +2184,7 @@ struct kvm_stats_desc {
 	__u16 size;
 	__u32 offset;
 	__u32 bucket_size;
-	char name[];
+	__DECLARE_FLEX_ARRAY(char, name);
 };
 
 #define KVM_GET_STATS_FD  _IO(KVMIO,  0xce)


