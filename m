Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49CE7466B4B;
	Tue, 16 Jun 2026 16:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628642; cv=none; b=aSM+UITmy3zQWKOBKttuiOd9WRbGlAe6KyNnvDL4MGhyffObdtx2iwj1OpEXyzGA8mBUMSaxqRtQC0IHXHr/HTAbV7/DY5SaaKnGP+Go8/W5rf4MRRPZvqRRPU8vZVK7otMbaKAUrax4jEEiXFyAluI/PcnvcpYG6GOJCZpahYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628642; c=relaxed/simple;
	bh=2yHt6t+x7BzCR8MZjiU+qU0jDGz5O7+DTnfo+RczACM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r3+WciMopAFfG1nXEpWyX15hLi+Gws5LAOzEl1VZ86osTQL1g7GqzYHTuTLtyuUBC0MLqqjSoQmVvjcklAZXCL4LGNb6pRkuFmJE6KQgcDfbmYo/ijJFYAvmNQt29SR9lFzvYwlxoW5DMYcQrmS6cwQaDJD2EqgmV6/UeweSs44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kvh5/8oi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kvh5/8oi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E431F00A3D;
	Tue, 16 Jun 2026 16:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628641;
	bh=nIHo+HT0QVAPFcBd7m06hz22Eb3GMVAllNqOmp06iI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kvh5/8oiBqd+tC8fM9Lzh837SjZfWFnPTQMwUovdmax5GavVF11vZOt1sxHmpaWtK
	 u1AwTV3uHvERwSQ0VU8iMLvZpgbjQPnHNLGQXsAdtPzpbCyxvAlXGqsLPUyT7HXdUy
	 pwYvyyBADgmoTKHxD25ucNN5vP4qptmU2bGHtq64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	linux-kbuild@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.6 134/452] iommu, debugobjects: avoid gcc-16.1 section mismatch warnings
Date: Tue, 16 Jun 2026 20:26:01 +0530
Message-ID: <20260616145124.773030844@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

commit 4c9ad387aa2d6785299722e54224d34764edaeb3 upstream.

gcc-16 has gained some more advanced inter-procedual optimization
techniques that enable it to inline the dummy_tlb_add_page() and
dummy_tlb_flush() function pointers into a specialized version of
__arm_v7s_unmap:

WARNING: modpost: vmlinux: section mismatch in reference: __arm_v7s_unmap+0x2cc (section: .text) -> dummy_tlb_add_page (section: .init.text)
ERROR: modpost: Section mismatches detected.

>From what I can tell, the transformation is correct, as this is only
called when __arm_v7s_unmap() is called from arm_v7s_do_selftests(),
which is also __init. Since __arm_v7s_unmap() however is not __init,
gcc cannot inline the inner function calls directly.

In debug_objects_selftest(), the same thing happens. Both the
caller and the leaf function are __init, but the IPA pulls
it into a non-init one:

WARNING: modpost: vmlinux: section mismatch in reference: lookup_object_or_alloc+0x7c (section: .text.lookup_object_or_alloc) -> is_static_object (section: .init.text)

Marking the affected functions as not "__init" would reliably avoid this
issue but is not a good solution because it removes an otherwise correct
annotation. I tried marking the functions as 'noinline', but that ended
up not covering all the affected configurations.

With some more experimenting, I found that marking these functions as
__attribute__((noipa)) is both logical and reliable.

In order to keep the syntax readable, add a custom macro for this in
include/linux/compiler_attributes.h next to other related macros and
use it to annotate both files.

Link: https://lore.kernel.org/all/abRB6g-48ZX6Yl2r@willie-the-truck/
Cc: Will Deacon <will@kernel.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: linux-kbuild@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Will Deacon <will@kernel.org>
Acked-by: Thomas Gleixner <tglx@kernel.org>
Acked-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/io-pgtable-arm-v7s.c  |   18 ++++++++++++------
 include/linux/compiler_attributes.h |   11 +++++++++++
 lib/debugobjects.c                  |    2 +-
 3 files changed, 24 insertions(+), 7 deletions(-)

--- a/drivers/iommu/io-pgtable-arm-v7s.c
+++ b/drivers/iommu/io-pgtable-arm-v7s.c
@@ -894,21 +894,27 @@ struct io_pgtable_init_fns io_pgtable_ar
 
 static struct io_pgtable_cfg *cfg_cookie __initdata;
 
-static void __init dummy_tlb_flush_all(void *cookie)
+/*
+ * __noipa prevents gcc from turning indirect iommu_flush_ops calls
+ * into direct calls from a specialized __arm_v7s_unmap() that triggers
+ * a build time section mismatch assertion.
+ */
+static __noipa void __init dummy_tlb_flush_all(void *cookie)
 {
 	WARN_ON(cookie != cfg_cookie);
 }
 
-static void __init dummy_tlb_flush(unsigned long iova, size_t size,
-				   size_t granule, void *cookie)
+static __noipa void __init dummy_tlb_flush(unsigned long iova, size_t size,
+					   size_t granule, void *cookie)
 {
 	WARN_ON(cookie != cfg_cookie);
 	WARN_ON(!(size & cfg_cookie->pgsize_bitmap));
 }
 
-static void __init dummy_tlb_add_page(struct iommu_iotlb_gather *gather,
-				      unsigned long iova, size_t granule,
-				      void *cookie)
+static __noipa void __init dummy_tlb_add_page(struct iommu_iotlb_gather *gather,
+					      unsigned long iova,
+					      size_t granule,
+					      void *cookie)
 {
 	dummy_tlb_flush(iova, granule, granule, cookie);
 }
--- a/include/linux/compiler_attributes.h
+++ b/include/linux/compiler_attributes.h
@@ -384,6 +384,17 @@
 #endif
 
 /*
+ * Optional: not supported by clang
+ *
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Attributes.html#index-noipa
+ */
+#if __has_attribute(noipa)
+# define __noipa __attribute__((noipa))
+#else
+# define __noipa
+#endif
+
+/*
  *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-weak-function-attribute
  *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Variable-Attributes.html#index-weak-variable-attribute
  */
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -1076,7 +1076,7 @@ struct self_test {
 
 static __initconst const struct debug_obj_descr descr_type_test;
 
-static bool __init is_static_object(void *addr)
+static __noipa bool __init is_static_object(void *addr)
 {
 	struct self_test *obj = addr;
 


