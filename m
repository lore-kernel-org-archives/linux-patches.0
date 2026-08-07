Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11FB2D12ED;
	Fri,  7 Aug 2026 15:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115756; cv=none; b=KSAjxB98rJpNPhvEfn/HrMN5gIGnrv/tPEyMUBKB5W3nSBYXicwR3h/ccUkbb6833iRs/arDZwy2vYIFFJv+6Ces7fxNcm2xG0i+goRXFVYkqbHLFf6euxIOeCxdUWK5LerCmLu7qZTKnQ4M3r8SCGIOqk8Fzk96FnKLyCl1fno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115756; c=relaxed/simple;
	bh=oL8mFNlgOMGzXgRF4PuGLA6nTHL0QiFwtn0/GiJNjcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zxc835530X6AvywjZKSH1Hqm4LkeRPrag4eTvRkckPEK7+XlqALxEankdyshT46xUmVbbf3rTjiww/UaFINlZ0bL1pfJdMQSvcptY9rTIXF8SKloGrRVwmA+7clng3GTMxUdirs9JInJt4bLvjJDseR8Ye5HK+hwVzXf0Nirqmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zVjqGnef; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zVjqGnef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B1641F00A3A;
	Fri,  7 Aug 2026 15:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115755;
	bh=Rz7PH6jfXN6DP2WquBG9ze0RZS06HIhtc6rFFx45mQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zVjqGnefof+qIIrsGHNmLBQyHzhhxdLa9Zh4bnj9wY9rQPQtIivT3xwFhGqpVReuP
	 9BRyAlJTSAJmcW/81MxhwO1OcKRrCoaFYmh7lE8L+v/cJEIa2ecVSi+zK4adzI3Wby
	 0F+abod6zImb2fdCd5zR1jluFPWLBGNeqDVAE44A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Arvind Yadav <arvind.yadav@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 381/396] drm/xe/bo: Add purgeable bo state tracking and field madv to xe_bo
Date: Fri,  7 Aug 2026 16:39:01 +0200
Message-ID: <20260807143432.496835121@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arvind Yadav <arvind.yadav@intel.com>

[ Upstream commit b67427f939ccf038a658badb02dd948c7b516248 ]

Add infrastructure for tracking purgeable state of buffer objects.
This includes:

Introduce enum xe_madv_purgeable_state with three states:
   - XE_MADV_PURGEABLE_WILLNEED (0): BO is needed and should not be
     purged. This is the default state for all BOs.

   - XE_MADV_PURGEABLE_DONTNEED (1): BO is not currently needed and
     can be purged by the kernel under memory pressure to reclaim
     resources. Only non-shared BOs can be marked as DONTNEED.

   - XE_MADV_PURGEABLE_PURGED (2): BO has been purged by the kernel.
     Accessing a purged BO results in error. Follows i915 semantics
     where once purged, the BO remains permanently invalid ("once
     purged, always purged").

Add madv_purgeable field to struct xe_bo for state tracking
  of purgeable state across concurrent access paths

Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Arvind Yadav <arvind.yadav@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20260326130843.3545241-3-arvind.yadav@intel.com
Stable-dep-of: 7bc597ce74ba ("drm/xe/vm: Fix BO prefetch with CONSULT_MEM_ADVISE_PREF_LOC")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_bo.h       |   56 +++++++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/xe/xe_bo_types.h |    6 ++++
 2 files changed, 62 insertions(+)

--- a/drivers/gpu/drm/xe/xe_bo.h
+++ b/drivers/gpu/drm/xe/xe_bo.h
@@ -84,6 +84,28 @@
 
 #define XE_PCI_BARRIER_MMAP_OFFSET	(0x50 << XE_PTE_SHIFT)
 
+/**
+ * enum xe_madv_purgeable_state - Buffer object purgeable state enumeration
+ *
+ * This enum defines the possible purgeable states for a buffer object,
+ * allowing userspace to provide memory usage hints to the kernel for
+ * better memory management under pressure.
+ *
+ * @XE_MADV_PURGEABLE_WILLNEED: The buffer object is needed and should not be purged.
+ * This is the default state.
+ * @XE_MADV_PURGEABLE_DONTNEED: The buffer object is not currently needed and can be
+ * purged by the kernel under memory pressure.
+ * @XE_MADV_PURGEABLE_PURGED: The buffer object has been purged by the kernel.
+ *
+ * Accessing a purged buffer will result in an error. Per i915 semantics,
+ * once purged, a BO remains permanently invalid and must be destroyed and recreated.
+ */
+enum xe_madv_purgeable_state {
+	XE_MADV_PURGEABLE_WILLNEED,
+	XE_MADV_PURGEABLE_DONTNEED,
+	XE_MADV_PURGEABLE_PURGED,
+};
+
 struct sg_table;
 
 struct xe_bo *xe_bo_alloc(void);
@@ -213,6 +235,40 @@ static inline bool xe_bo_is_protected(co
 	return bo->pxp_key_instance;
 }
 
+/**
+ * xe_bo_is_purged() - Check if buffer object has been purged
+ * @bo: The buffer object to check
+ *
+ * Checks if the buffer object's backing store has been discarded by the
+ * kernel due to memory pressure after being marked as purgeable (DONTNEED).
+ * Once purged, the BO cannot be restored and any attempt to use it will fail.
+ *
+ * Context: Caller must hold the BO's dma-resv lock
+ * Return: true if the BO has been purged, false otherwise
+ */
+static inline bool xe_bo_is_purged(struct xe_bo *bo)
+{
+	xe_bo_assert_held(bo);
+	return bo->madv_purgeable == XE_MADV_PURGEABLE_PURGED;
+}
+
+/**
+ * xe_bo_madv_is_dontneed() - Check if BO is marked as DONTNEED
+ * @bo: The buffer object to check
+ *
+ * Checks if userspace has marked this BO as DONTNEED (i.e., its contents
+ * are not currently needed and can be discarded under memory pressure).
+ * This is used internally to decide whether a BO is eligible for purging.
+ *
+ * Context: Caller must hold the BO's dma-resv lock
+ * Return: true if the BO is marked DONTNEED, false otherwise
+ */
+static inline bool xe_bo_madv_is_dontneed(struct xe_bo *bo)
+{
+	xe_bo_assert_held(bo);
+	return bo->madv_purgeable == XE_MADV_PURGEABLE_DONTNEED;
+}
+
 static inline void xe_bo_unpin_map_no_vm(struct xe_bo *bo)
 {
 	if (likely(bo)) {
--- a/drivers/gpu/drm/xe/xe_bo_types.h
+++ b/drivers/gpu/drm/xe/xe_bo_types.h
@@ -110,6 +110,12 @@ struct xe_bo {
 	 * from default
 	 */
 	u64 min_align;
+
+	/**
+	 * @madv_purgeable: user space advise on BO purgeability, protected
+	 * by BO's dma-resv lock.
+	 */
+	u32 madv_purgeable;
 };
 
 #endif


