Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931001E2834;
	Wed, 25 Feb 2026 01:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771984021; cv=none; b=qHfZIcGZauswvSrUR7mZlhBCjYG8+/0k44S1xgFaQi05dlGZxhgWVPtoc6zlp4zVUuv8rTwgOSVLwqKHy9strIYm/1jakmkmhAuIHbzRlR/I/3A8dvLpwYCjNIo5np6Fhg5mbfvG+LFyKkYpui/T8AH+ycIgN47j2rDIYLU1Quk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771984021; c=relaxed/simple;
	bh=O42wXtPm91qO8XuC5OIFGcUhuSsPmyBjXxoYTT7KQCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qVo5H1L3eBMUqGGqNIzu+7DAQnjExISG6tmwv+3KI7XpzV/BvmfwMwR9z2X2q19TFU4dK0dyzrHStMJ4I/y7HvH8ykN8eKhGdpGkMXlxR4xGbPFUB8wFeoM6IY7AqEQyoAqUae6/j5R88XQ+6PINFWTZS3QiE3G6AqMX4zNevbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uyKhTHoH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uyKhTHoH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54DA0C116D0;
	Wed, 25 Feb 2026 01:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771984021;
	bh=O42wXtPm91qO8XuC5OIFGcUhuSsPmyBjXxoYTT7KQCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uyKhTHoHoTE7usKig5cxoiRZ70z5Z6zREyPwjxggFyepi24sYavZnNpkPOXGOOWZy
	 MOK4BmR/6z9X1Fer9waswqvriDbin6KxRiMECBectC1UIgw+ArcjZRJkxvzZry92yL
	 lYz51RR8JRYxk6k8tiXR1HMO/smbi4mZGS+fF59k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Dmytro Maluka <dmaluka@chromium.org>,
	Samiullah Khawaja <skhawaja@google.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 267/641] iommu/vt-d: Clear Present bit before tearing down PASID entry
Date: Tue, 24 Feb 2026 17:19:53 -0800
Message-ID: <20260225012355.277163116@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 75ed00055c059dedc47b5daaaa2f8a7a019138ff ]

The Intel VT-d Scalable Mode PASID table entry consists of 512 bits (64
bytes). When tearing down an entry, the current implementation zeros the
entire 64-byte structure immediately using multiple 64-bit writes.

Since the IOMMU hardware may fetch these 64 bytes using multiple
internal transactions (e.g., four 128-bit bursts), updating or zeroing
the entire entry while it is active (P=1) risks a "torn" read. If a
hardware fetch occurs simultaneously with the CPU zeroing the entry, the
hardware could observe an inconsistent state, leading to unpredictable
behavior or spurious faults.

Follow the "Guidance to Software for Invalidations" in the VT-d spec
(Section 6.5.3.3) by implementing the recommended ownership handshake:

1. Clear only the 'Present' (P) bit of the PASID entry.
2. Use a dma_wmb() to ensure the cleared bit is visible to hardware
   before proceeding.
3. Execute the required invalidation sequence (PASID cache, IOTLB, and
   Device-TLB flush) to ensure the hardware has released all cached
   references.
4. Only after the flushes are complete, zero out the remaining fields
   of the PASID entry.

Also, add a dma_wmb() in pasid_set_present() to ensure that all other
fields of the PASID entry are visible to the hardware before the Present
bit is set.

Fixes: 0bbeb01a4faf ("iommu/vt-d: Manage scalalble mode PASID tables")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Dmytro Maluka <dmaluka@chromium.org>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20260120061816.2132558-2-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/pasid.c |  6 +++++-
 drivers/iommu/intel/pasid.h | 14 ++++++++++++++
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 67cbf53d18c8f..f64b5ae306d0f 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -273,7 +273,7 @@ void intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct device *dev,
 
 	did = pasid_get_domain_id(pte);
 	pgtt = pasid_pte_get_pgtt(pte);
-	intel_pasid_clear_entry(dev, pasid, fault_ignore);
+	pasid_clear_present(pte);
 	spin_unlock(&iommu->lock);
 
 	if (!ecap_coherent(iommu->ecap))
@@ -287,6 +287,10 @@ void intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct device *dev,
 		iommu->flush.flush_iotlb(iommu, did, 0, 0, DMA_TLB_DSI_FLUSH);
 
 	devtlb_invalidation_with_pasid(iommu, dev, pasid);
+	intel_pasid_clear_entry(dev, pasid, fault_ignore);
+	if (!ecap_coherent(iommu->ecap))
+		clflush_cache_range(pte, sizeof(*pte));
+
 	if (!fault_ignore)
 		intel_iommu_drain_pasid_prq(dev, pasid);
 }
diff --git a/drivers/iommu/intel/pasid.h b/drivers/iommu/intel/pasid.h
index a771a77d4239c..637373995be80 100644
--- a/drivers/iommu/intel/pasid.h
+++ b/drivers/iommu/intel/pasid.h
@@ -233,9 +233,23 @@ static inline void pasid_set_wpe(struct pasid_entry *pe)
  */
 static inline void pasid_set_present(struct pasid_entry *pe)
 {
+	dma_wmb();
 	pasid_set_bits(&pe->val[0], 1 << 0, 1);
 }
 
+/*
+ * Clear the Present (P) bit (bit 0) of a scalable-mode PASID table entry.
+ * This initiates the transition of the entry's ownership from hardware
+ * to software. The caller is responsible for fulfilling the invalidation
+ * handshake recommended by the VT-d spec, Section 6.5.3.3 (Guidance to
+ * Software for Invalidations).
+ */
+static inline void pasid_clear_present(struct pasid_entry *pe)
+{
+	pasid_set_bits(&pe->val[0], 1 << 0, 0);
+	dma_wmb();
+}
+
 /*
  * Setup Page Walk Snoop bit (Bit 87) of a scalable mode PASID
  * entry.
-- 
2.51.0



