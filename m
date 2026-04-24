Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE733D5643;
	Fri, 24 Apr 2026 13:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037958; cv=none; b=btybJm4sIQWYG51SX+3tLiNO8+Ag7F872yPOZg4i5l6EyjaIXzi1RdfITg19y6fVFvREutXAvgG9kSufH2nSqgbDTtSrnaVFVXULpRR45iXVZFjZrDbb9xIWsfN7nPWRXBedmrKAJVYZIkP51IG34VGCcQ9YViHJBRZI3CYzEWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037958; c=relaxed/simple;
	bh=9khj+Mzxi72nc8AEtVBOGifQsXuMTcTv148EFwbiGEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a2J7Tgx9i7y8YGfQg5YWCpgqdA17rN/PefuSXWwnnYYmQVByHId4H7rRG4FQcn1T3yX4YD9TPi5o7w5pX5su9NvQZk8uUsyiwFJJG4yJ0hsHMmutnmKDujCA9HQ0XjtOQ3b6NFrEN21wQ99phQriamFhAKDZlXQcyE2IKBPtTsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c75stax6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c75stax6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61EF5C19425;
	Fri, 24 Apr 2026 13:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037957;
	bh=9khj+Mzxi72nc8AEtVBOGifQsXuMTcTv148EFwbiGEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c75stax6xDltdfhFzfNvTWukNfzBVWsiL6S4TAP8S4tvz7SkqAVeCjMP0yvSq83Ct
	 4CWFs/4SO1JVFItQmsD2haLEGsoFdrR8uVL8kXbqPpXa+wyr2zscjT1vDuX8VN67bn
	 Acq6paS0UZK6NSvgg1gl0VX00Hkn24JyUhPDRxow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw@amazon.co.uk>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 136/166] KVM: x86: Use __DECLARE_FLEX_ARRAY() for UAPI structures with VLAs
Date: Fri, 24 Apr 2026 15:30:50 +0200
Message-ID: <20260424132601.393048028@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -191,13 +191,13 @@ struct kvm_msrs {
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
@@ -239,7 +239,7 @@ struct kvm_cpuid_entry {
 struct kvm_cpuid {
 	__u32 nent;
 	__u32 padding;
-	struct kvm_cpuid_entry entries[];
+	__DECLARE_FLEX_ARRAY(struct kvm_cpuid_entry, entries);
 };
 
 struct kvm_cpuid_entry2 {
@@ -261,7 +261,7 @@ struct kvm_cpuid_entry2 {
 struct kvm_cpuid2 {
 	__u32 nent;
 	__u32 padding;
-	struct kvm_cpuid_entry2 entries[];
+	__DECLARE_FLEX_ARRAY(struct kvm_cpuid_entry2, entries);
 };
 
 /* for KVM_GET_PIT and KVM_SET_PIT */
@@ -392,7 +392,7 @@ struct kvm_xsave {
 	 * the contents of CPUID leaf 0xD on the host.
 	 */
 	__u32 region[1024];
-	__u32 extra[];
+	__DECLARE_FLEX_ARRAY(__u32, extra);
 };
 
 #define KVM_MAX_XCRS	16
@@ -520,7 +520,7 @@ struct kvm_pmu_event_filter {
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
@@ -643,7 +644,7 @@ struct kvm_clear_dirty_log {
 /* for KVM_SET_SIGNAL_MASK */
 struct kvm_signal_mask {
 	__u32 len;
-	__u8  sigset[];
+	__DECLARE_FLEX_ARRAY(__u8, sigset);
 };
 
 /* for KVM_TPR_ACCESS_REPORTING */
@@ -1256,7 +1257,7 @@ struct kvm_irq_routing_entry {
 struct kvm_irq_routing {
 	__u32 nr;
 	__u32 flags;
-	struct kvm_irq_routing_entry entries[];
+	__DECLARE_FLEX_ARRAY(struct kvm_irq_routing_entry, entries);
 };
 
 #endif
@@ -1377,7 +1378,7 @@ struct kvm_dirty_tlb {
 
 struct kvm_reg_list {
 	__u64 n; /* number of regs */
-	__u64 reg[];
+	__DECLARE_FLEX_ARRAY(__u64, reg);
 };
 
 struct kvm_one_reg {
@@ -2211,7 +2212,7 @@ struct kvm_stats_desc {
 	__u16 size;
 	__u32 offset;
 	__u32 bucket_size;
-	char name[];
+	__DECLARE_FLEX_ARRAY(char, name);
 };
 
 #define KVM_GET_STATS_FD  _IO(KVMIO,  0xce)


