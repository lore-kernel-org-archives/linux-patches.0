Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035E9343D9D;
	Tue, 12 May 2026 18:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609435; cv=none; b=u8U4NBduJjfr9Fg5ig+m0r5HR+AJ3wzBiY5c5QCxiBWOmR/7kV7bzmun37FOPgRi6QEazettO1mgT2LCO695bpURfF/GQYAVUu6XEDACn6ETkQG3SQb7f4n5gzemKYsiQtXSVYviHrSncbNLqs4E2EpTE9o/6A/qRfvRTCcOJHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609435; c=relaxed/simple;
	bh=alQxcSr+KOWnjA8HXp2Fv8rfbfld5z+W6ailyvwI2XU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jRLUHQKak794s2dk2rCDRWX+hglGqeW21ouP8Kj4bza41RJQ8ZSjMCnFTaRW9YwlPG5etUoV9undYiTA1z/T5UJaUkfYTG59zLqOOeEfN00RaewR0R3mEckTp4Beyhkpc4NjhpTOQs8FZnvssmbjGTv5fyxuxRnhpGH78gVzMMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MYCzWyk1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MYCzWyk1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA61C2BCF5;
	Tue, 12 May 2026 18:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609434;
	bh=alQxcSr+KOWnjA8HXp2Fv8rfbfld5z+W6ailyvwI2XU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MYCzWyk1MJB37CsHC+rfqJwazyGeEArjQB8UgvgAo2xyCNWuBbxtEQSB1ncVWjO5P
	 ovOw25P3ikLUiu8+YYsXF6hwh9+D+ajgGmvR8cEQvRO7Xs4VdmFtuVOe5XIAuRdLJd
	 DpmYsQhVQNmMYjMJ8A8GXdutMB+tq1OE3FlnIHBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Nicolin Chen <nicolinc@nvidia.com>
Subject: [PATCH 7.0 193/307] iommu/arm-smmu-v3: Add a missing dma_wmb() for hitless STE update
Date: Tue, 12 May 2026 19:39:48 +0200
Message-ID: <20260512173944.189984419@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


