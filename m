Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9433C43ADE
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d/yDCtcW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45C32C433CB;
	Wed, 15 Nov 2023 20:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081878;
	bh=7Q/L44siyJOu7ihsEk6917GBdK6AqvZDqidk9OimFhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d/yDCtcWY2sUTMvb2kYPq2/jU3tXg3s6OcQMEJ8nNicTIK/dtyMtCnM38vtcJ+CA1
	 L98ERnHnNCcGZb4WLhjVUbDNDkGN4jeN3GnNQgKBVKZagvhz5P3iSDXeZu6NkYhs6H
	 voQRPx9K7uSA363b4pd3uo3DkLEXTPKIhzKQpewA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 182/191] x86: Share definition of __is_canonical_address()
Date: Wed, 15 Nov 2023 15:47:37 -0500
Message-ID: <20231115204655.363097631@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115204644.490636297@linuxfoundation.org>
References: <20231115204644.490636297@linuxfoundation.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 1fb85d06ad6754796cd1b920639ca9d8840abefd ]

Reduce code duplication by moving canonical address code to a common header
file.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220131072453.2839535-3-adrian.hunter@intel.com
Stable-dep-of: f79936545fb1 ("x86/sev-es: Allow copy_from_kernel_nofault() in earlier boot")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/pt.c  | 14 ++------------
 arch/x86/include/asm/page.h | 10 ++++++++++
 arch/x86/kvm/emulate.c      |  4 ++--
 arch/x86/kvm/x86.c          |  2 +-
 arch/x86/kvm/x86.h          |  7 +------
 arch/x86/mm/maccess.c       |  7 +------
 6 files changed, 17 insertions(+), 27 deletions(-)

diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index d87421acddc39..5667b8b994e34 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -1360,20 +1360,10 @@ static void pt_addr_filters_fini(struct perf_event *event)
 }
 
 #ifdef CONFIG_X86_64
-static u64 canonical_address(u64 vaddr, u8 vaddr_bits)
-{
-	return ((s64)vaddr << (64 - vaddr_bits)) >> (64 - vaddr_bits);
-}
-
-static u64 is_canonical_address(u64 vaddr, u8 vaddr_bits)
-{
-	return canonical_address(vaddr, vaddr_bits) == vaddr;
-}
-
 /* Clamp to a canonical address greater-than-or-equal-to the address given */
 static u64 clamp_to_ge_canonical_addr(u64 vaddr, u8 vaddr_bits)
 {
-	return is_canonical_address(vaddr, vaddr_bits) ?
+	return __is_canonical_address(vaddr, vaddr_bits) ?
 	       vaddr :
 	       -BIT_ULL(vaddr_bits - 1);
 }
@@ -1381,7 +1371,7 @@ static u64 clamp_to_ge_canonical_addr(u64 vaddr, u8 vaddr_bits)
 /* Clamp to a canonical address less-than-or-equal-to the address given */
 static u64 clamp_to_le_canonical_addr(u64 vaddr, u8 vaddr_bits)
 {
-	return is_canonical_address(vaddr, vaddr_bits) ?
+	return __is_canonical_address(vaddr, vaddr_bits) ?
 	       vaddr :
 	       BIT_ULL(vaddr_bits - 1) - 1;
 }
diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index 7555b48803a8c..ffae5ea9fd4e1 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -71,6 +71,16 @@ static inline void copy_user_page(void *to, void *from, unsigned long vaddr,
 extern bool __virt_addr_valid(unsigned long kaddr);
 #define virt_addr_valid(kaddr)	__virt_addr_valid((unsigned long) (kaddr))
 
+static __always_inline u64 __canonical_address(u64 vaddr, u8 vaddr_bits)
+{
+	return ((s64)vaddr << (64 - vaddr_bits)) >> (64 - vaddr_bits);
+}
+
+static __always_inline u64 __is_canonical_address(u64 vaddr, u8 vaddr_bits)
+{
+	return __canonical_address(vaddr, vaddr_bits) == vaddr;
+}
+
 #endif	/* __ASSEMBLY__ */
 
 #include <asm-generic/memory_model.h>
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 63efccc8f4292..56750febf4604 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -688,7 +688,7 @@ static inline u8 ctxt_virt_addr_bits(struct x86_emulate_ctxt *ctxt)
 static inline bool emul_is_noncanonical_address(u64 la,
 						struct x86_emulate_ctxt *ctxt)
 {
-	return get_canonical(la, ctxt_virt_addr_bits(ctxt)) != la;
+	return !__is_canonical_address(la, ctxt_virt_addr_bits(ctxt));
 }
 
 /*
@@ -738,7 +738,7 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
 	case X86EMUL_MODE_PROT64:
 		*linear = la;
 		va_bits = ctxt_virt_addr_bits(ctxt);
-		if (get_canonical(la, va_bits) != la)
+		if (!__is_canonical_address(la, va_bits))
 			goto bad;
 
 		*max_size = min_t(u64, ~0u, (1ull << va_bits) - la);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9d3015863e581..c2899ff31a068 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1640,7 +1640,7 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 		 * value, and that something deterministic happens if the guest
 		 * invokes 64-bit SYSENTER.
 		 */
-		data = get_canonical(data, vcpu_virt_addr_bits(vcpu));
+		data = __canonical_address(data, vcpu_virt_addr_bits(vcpu));
 	}
 
 	msr.data = data;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 2bff44f1efec8..4037b3cc704e8 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -156,14 +156,9 @@ static inline u8 vcpu_virt_addr_bits(struct kvm_vcpu *vcpu)
 	return kvm_read_cr4_bits(vcpu, X86_CR4_LA57) ? 57 : 48;
 }
 
-static inline u64 get_canonical(u64 la, u8 vaddr_bits)
-{
-	return ((int64_t)la << (64 - vaddr_bits)) >> (64 - vaddr_bits);
-}
-
 static inline bool is_noncanonical_address(u64 la, struct kvm_vcpu *vcpu)
 {
-	return get_canonical(la, vcpu_virt_addr_bits(vcpu)) != la;
+	return !__is_canonical_address(la, vcpu_virt_addr_bits(vcpu));
 }
 
 static inline void vcpu_cache_mmio_info(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/mm/maccess.c b/arch/x86/mm/maccess.c
index 92ec176a72937..5a53c2cc169cc 100644
--- a/arch/x86/mm/maccess.c
+++ b/arch/x86/mm/maccess.c
@@ -4,11 +4,6 @@
 #include <linux/kernel.h>
 
 #ifdef CONFIG_X86_64
-static __always_inline u64 canonical_address(u64 vaddr, u8 vaddr_bits)
-{
-	return ((s64)vaddr << (64 - vaddr_bits)) >> (64 - vaddr_bits);
-}
-
 bool copy_from_kernel_nofault_allowed(const void *unsafe_src, size_t size)
 {
 	unsigned long vaddr = (unsigned long)unsafe_src;
@@ -19,7 +14,7 @@ bool copy_from_kernel_nofault_allowed(const void *unsafe_src, size_t size)
 	 * we also need to include the userspace guard page.
 	 */
 	return vaddr >= TASK_SIZE_MAX + PAGE_SIZE &&
-	       canonical_address(vaddr, boot_cpu_data.x86_virt_bits) == vaddr;
+	       __is_canonical_address(vaddr, boot_cpu_data.x86_virt_bits);
 }
 #else
 bool copy_from_kernel_nofault_allowed(const void *unsafe_src, size_t size)
-- 
2.42.0



