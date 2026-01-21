Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0358E3D3015;
	Wed, 21 Jan 2026 18:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020523; cv=none; b=DVg5c/W76VQx6nTcOdbbwXrb427FVwBUHXuR51gLcAp2HTthsnxPHsbFTFmMq0v7zNdr1ceHPCXe8/WI0nXx68PWrCLzVmFuDobs4ZdDKTMCF/hUoYYVIYFYQCVIijJujLMGsz5FZun3nJbXGceXvyEx/9vqXs1HoJ8jTb0Wix0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020523; c=relaxed/simple;
	bh=IY14L3QjcVMyipdtgX9FxaSX6OVRy+CZDEK8evfi9YM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nxIZvXKL7YwWB++Zc94eFNBCKMXOxxc8BiOVJH7JpUMFfAYpY02L7SWerfY12Fum4Qgs3D39fJVh5oNJN6rY1R6rMkAqGjK5QBEOE7MuiTsag1G6zDTZD0bLgF9W+QfcdtuY+RnxJWHjAUl0OFHSXKH7xDguquP9O4S5ZYQQTsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qgqn1/zD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qgqn1/zD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5298DC4CEF1;
	Wed, 21 Jan 2026 18:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020522;
	bh=IY14L3QjcVMyipdtgX9FxaSX6OVRy+CZDEK8evfi9YM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qgqn1/zDWwBekQvaOmYW72hMjim9mumF3XqZsJGPzjq9Iu4peZvLvWK+2LgMjhTu8
	 C1WCDIclNoscxDflctfxILK3AVfTdqT94ph5iJHm9Psf05sD+P/5AzDYpzmy5HB2XT
	 PaMiLlPUksg5d1sImJIws+v+5tHcPixFJGjFvDYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	David Hildenbrand <david@redhat.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Alistair Popple <apopple@nvidia.com>,
	Andy Lutomirski <luto@kernel.org>,
	Borislav Betkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	Jann Horn <jannh@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <joro@8bytes.org>,
	Liam Howlett <liam.howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Robin Murohy <robin.murphy@arm.com>,
	Thomas Gleinxer <tglx@linutronix.de>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	Yi Lai <yi1.lai@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 184/198] mm: add a ptdesc flag to mark kernel page tables
Date: Wed, 21 Jan 2026 19:16:52 +0100
Message-ID: <20260121181425.174313705@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Hansen <dave.hansen@linux.intel.com>

commit 27bfafac65d87c58639f5d7af1353ec1e7886963 upstream.

The page tables used to map the kernel and userspace often have very
different handling rules.  There are frequently *_kernel() variants of
functions just for kernel page tables.  That's not great and has lead to
code duplication.

Instead of having completely separate call paths, allow a 'ptdesc' to be
marked as being for kernel mappings.  Introduce helpers to set and clear
this status.

Note: this uses the PG_referenced bit.  Page flags are a great fit for
this since it is truly a single bit of information.  Use PG_referenced
itself because it's a fairly benign flag (as opposed to things like
PG_lock).  It's also (according to Willy) unlikely to go away any time
soon.

PG_referenced is not in PAGE_FLAGS_CHECK_AT_FREE.  It does not need to be
cleared before freeing the page, and pages coming out of the allocator
should have it cleared.  Regardless, introduce an API to clear it anyway.
Having symmetry in the API makes it easier to change the underlying
implementation later, like if there was a need to move to a
PAGE_FLAGS_CHECK_AT_FREE bit.

Link: https://lkml.kernel.org/r/20251022082635.2462433-3-baolu.lu@linux.intel.com
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robin Murohy <robin.murphy@arm.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vasant Hegde <vasant.hegde@amd.com>
Cc: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mm.h |   41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2947,6 +2947,7 @@ static inline pmd_t *pmd_alloc(struct mm
 #endif /* CONFIG_MMU */
 
 enum pt_flags {
+	PT_kernel = PG_referenced,
 	PT_reserved = PG_reserved,
 	/* High bits are used for zone/node/section */
 };
@@ -2973,6 +2974,46 @@ static inline bool pagetable_is_reserved
 }
 
 /**
+ * ptdesc_set_kernel - Mark a ptdesc used to map the kernel
+ * @ptdesc: The ptdesc to be marked
+ *
+ * Kernel page tables often need special handling. Set a flag so that
+ * the handling code knows this ptdesc will not be used for userspace.
+ */
+static inline void ptdesc_set_kernel(struct ptdesc *ptdesc)
+{
+	set_bit(PT_kernel, &ptdesc->pt_flags.f);
+}
+
+/**
+ * ptdesc_clear_kernel - Mark a ptdesc as no longer used to map the kernel
+ * @ptdesc: The ptdesc to be unmarked
+ *
+ * Use when the ptdesc is no longer used to map the kernel and no longer
+ * needs special handling.
+ */
+static inline void ptdesc_clear_kernel(struct ptdesc *ptdesc)
+{
+	/*
+	 * Note: the 'PG_referenced' bit does not strictly need to be
+	 * cleared before freeing the page. But this is nice for
+	 * symmetry.
+	 */
+	clear_bit(PT_kernel, &ptdesc->pt_flags.f);
+}
+
+/**
+ * ptdesc_test_kernel - Check if a ptdesc is used to map the kernel
+ * @ptdesc: The ptdesc being tested
+ *
+ * Call to tell if the ptdesc used to map the kernel.
+ */
+static inline bool ptdesc_test_kernel(const struct ptdesc *ptdesc)
+{
+	return test_bit(PT_kernel, &ptdesc->pt_flags.f);
+}
+
+/**
  * pagetable_alloc - Allocate pagetables
  * @gfp:    GFP flags
  * @order:  desired pagetable order


