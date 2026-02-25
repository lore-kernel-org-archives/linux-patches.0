Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2061E2834;
	Wed, 25 Feb 2026 01:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983207; cv=none; b=pPxy6pBo9pxzULv9CtsSAvVoeg4D9UbwrcZXV5a2s2OwSA514k3IE06Xp1t9NNa+5PlhhojENvEHM0moK1X33mElhkqDc/P40/e3lc7yZnOLb7B6Ly7axSL3sIXyXmAEnY56jlSgY7XGqvc/+b0s3s7HASyuiOsTQC3vGrBcjDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983207; c=relaxed/simple;
	bh=bzV+p8Lk3Ie8UHEi1dpOtEorHTXplj1GnrR7eHfx6i0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JCW7N3Q7x3GclwEveSMLskf6C5q7CGbNzJPBwt1nMuYE2H5PeNVPPmTjvGIy88lxoAlqoRJp0JihJ+NCmlGSNjeYiAX5ALCLCUO+qvBrJaVqMaC9Y/TcPvgHSgniYqVIZEqQ+wiasnRKv+J8RsZDpPWPzKulX4GV6AFNqdsrfTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xa+es7ha; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xa+es7ha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC273C116D0;
	Wed, 25 Feb 2026 01:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983207;
	bh=bzV+p8Lk3Ie8UHEi1dpOtEorHTXplj1GnrR7eHfx6i0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xa+es7haUHBhntFzrCrGjgSCHVdz/kLAJKP8NCq1ByM4mDkm80DDc/F/pJf7xwh7d
	 bzAZ+0a8c2mixR5ePhO6RHOtpuWenjHSygdInwGQhrRL0bVFcPxolh6xrCn+qQUX5I
	 9xdbyziWBzc9lW42+HB9aNkiZEm/g6hUIOzQV410=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmytro Maluka <dmaluka@chromium.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 356/781] iommu/vt-d: Clear Present bit before tearing down context entry
Date: Tue, 24 Feb 2026 17:17:45 -0800
Message-ID: <20260225012408.418836418@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit c1e4f1dccbe9d7656d1c6872ebeadb5992d0aaa2 ]

When tearing down a context entry, the current implementation zeros the
entire 128-bit entry using multiple 64-bit writes. This creates a window
where the hardware can fetch a "torn" entry — where some fields are
already zeroed while the 'Present' bit is still set — leading to
unpredictable behavior or spurious faults.

While x86 provides strong write ordering, the compiler may reorder writes
to the two 64-bit halves of the context entry. Even without compiler
reordering, the hardware fetch is not guaranteed to be atomic with
respect to multiple CPU writes.

Align with the "Guidance to Software for Invalidations" in the VT-d spec
(Section 6.5.3.3) by implementing the recommended ownership handshake:

1. Clear only the 'Present' (P) bit of the context entry first to
   signal the transition of ownership from hardware to software.
2. Use dma_wmb() to ensure the cleared bit is visible to the IOMMU.
3. Perform the required cache and context-cache invalidation to ensure
   hardware no longer has cached references to the entry.
4. Fully zero out the entry only after the invalidation is complete.

Also, add a dma_wmb() to context_set_present() to ensure the entry
is fully initialized before the 'Present' bit becomes visible.

Fixes: ba39592764ed2 ("Intel IOMMU: Intel IOMMU driver")
Reported-by: Dmytro Maluka <dmaluka@chromium.org>
Closes: https://lore.kernel.org/all/aTG7gc7I5wExai3S@google.com/
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Dmytro Maluka <dmaluka@chromium.org>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20260120061816.2132558-3-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c |  4 +++-
 drivers/iommu/intel/iommu.h | 21 ++++++++++++++++++++-
 drivers/iommu/intel/pasid.c |  5 ++++-
 3 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 134302fbcd926..c66cc51f9e51e 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1240,10 +1240,12 @@ static void domain_context_clear_one(struct device_domain_info *info, u8 bus, u8
 	}
 
 	did = context_domain_id(context);
-	context_clear_entry(context);
+	context_clear_present(context);
 	__iommu_flush_cache(iommu, context, sizeof(*context));
 	spin_unlock(&iommu->lock);
 	intel_context_flush_no_pasid(info, context, did);
+	context_clear_entry(context);
+	__iommu_flush_cache(iommu, context, sizeof(*context));
 }
 
 int __domain_setup_first_level(struct intel_iommu *iommu, struct device *dev,
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index 25c5e22096d44..599913fb65d59 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -900,7 +900,26 @@ static inline int pfn_level_offset(u64 pfn, int level)
 
 static inline void context_set_present(struct context_entry *context)
 {
-	context->lo |= 1;
+	u64 val;
+
+	dma_wmb();
+	val = READ_ONCE(context->lo) | 1;
+	WRITE_ONCE(context->lo, val);
+}
+
+/*
+ * Clear the Present (P) bit (bit 0) of a context table entry. This initiates
+ * the transition of the entry's ownership from hardware to software. The
+ * caller is responsible for fulfilling the invalidation handshake recommended
+ * by the VT-d spec, Section 6.5.3.3 (Guidance to Software for Invalidations).
+ */
+static inline void context_clear_present(struct context_entry *context)
+{
+	u64 val;
+
+	val = READ_ONCE(context->lo) & GENMASK_ULL(63, 1);
+	WRITE_ONCE(context->lo, val);
+	dma_wmb();
 }
 
 static inline void context_set_fault_enable(struct context_entry *context)
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index b611ad070e729..db535385778bd 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -1024,7 +1024,7 @@ static int device_pasid_table_setup(struct device *dev, u8 bus, u8 devfn)
 	}
 
 	if (context_copied(iommu, bus, devfn)) {
-		context_clear_entry(context);
+		context_clear_present(context);
 		__iommu_flush_cache(iommu, context, sizeof(*context));
 
 		/*
@@ -1044,6 +1044,9 @@ static int device_pasid_table_setup(struct device *dev, u8 bus, u8 devfn)
 		iommu->flush.flush_iotlb(iommu, 0, 0, 0, DMA_TLB_GLOBAL_FLUSH);
 		devtlb_invalidation_with_pasid(iommu, dev, IOMMU_NO_PASID);
 
+		context_clear_entry(context);
+		__iommu_flush_cache(iommu, context, sizeof(*context));
+
 		/*
 		 * At this point, the device is supposed to finish reset at
 		 * its driver probe stage, so no in-flight DMA will exist,
-- 
2.51.0



