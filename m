Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80A330BB80;
	Tue, 12 May 2026 17:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608649; cv=none; b=Qh5UnCZoWGZsUCOJfpIwtrXFtGZspVhJDfU6ukk7iuLVn4l4tgmnwR/MITgpZHLfKrduydHJU5omHzVAk/1ohyc7NkUwoTiAFdV8PF6YXYhEPb4ehE2K1hy5UM9kspyvzeiDqLMw82iWvZrYj6NZCQqseiHxGqKVFGcCRumRKZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608649; c=relaxed/simple;
	bh=n/Kteih1sVgVHeSOcwgFu+G2QIMlL04HFb4xBg3+J7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BpzyzlbRHEEhytDVvSKugz4TCFZNzXAuDQZrqhqVnZtGouMV7kOmEBnx87TQI1FSAWn38G9/LPYEVctIIgel551Y73QegEwrgr4XIgvkQGocXO3zeqzhEA4UFXwPpFBEUrJFLxtbiLVwPjbQzPi9FKRQ6IVz8k5oiw5Gu8IWyBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gl+KKMzJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gl+KKMzJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E11DC2BCB0;
	Tue, 12 May 2026 17:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608649;
	bh=n/Kteih1sVgVHeSOcwgFu+G2QIMlL04HFb4xBg3+J7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gl+KKMzJJhqUOfVstUa4nCQnB+XMtc9ts8h3D3I0uXobIuj3J+9YVHmSYI553pq8r
	 VMDkiBgAbw3LSNqWoKWRbenlsuqeuiS5FKFA8vl/sV/ZGRw9F2pVKEpJQljS40DGQM
	 6zwy+AdPjUrF/oeeYjb8FrPbKmCHnn3BlKYtGDl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Nicolin Chen <nicolinc@nvidia.com>
Subject: [PATCH 6.18 160/270] iommu/arm-smmu-v3: Add a missing dma_wmb() for hitless STE update
Date: Tue, 12 May 2026 19:39:21 +0200
Message-ID: <20260512173941.815111882@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

From: Nicolin Chen <nicolinc@nvidia.com>

commit 6fabce53f6b9c2419012a9103e1a46d40888cefa upstream.

When writing a new (previously invalid) valid IOPTE to a page table, then
installing the page table into an STE hitlesslessly (e.g. in S2TTB field),
there is a window before an STE invalidation, where the page-table may be
accessed by SMMU but the new IOPTE is still siting in the CPU cache.

This could occur when we allocate an iommu_domain and immediately install
it hitlessly, while there would be no dma_wmb() for the page table memory
prior to the earliest point of HW reading the STE.

Fix it by adding a dma_wmb() prior to updating the STE.

Fixes: 56e1a4cc2588 ("iommu/arm-smmu-v3: Add unit tests for arm_smmu_write_entry")
Cc: stable@vger.kernel.org
Reported-by: Will Deacon <will@kernel.org>
Closes: https://lore.kernel.org/linux-iommu/aXdlnLLFUBwjT0V5@willie-the-truck/
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1236,6 +1236,13 @@ void arm_smmu_write_entry(struct arm_smm
 	__le64 unused_update[NUM_ENTRY_QWORDS];
 	u8 used_qword_diff;
 
+	/*
+	 * Many of the entry structures have pointers to other structures that
+	 * need to have their updates be visible before any writes of the entry
+	 * happen.
+	 */
+	dma_wmb();
+
 	used_qword_diff =
 		arm_smmu_entry_qword_diff(writer, entry, target, unused_update);
 	if (hweight8(used_qword_diff) == 1) {


