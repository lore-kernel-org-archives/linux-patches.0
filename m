Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE8C2EBB84;
	Tue, 12 May 2026 17:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608014; cv=none; b=aHhdM5wnb7Kz+Zz1cWGMYssHH0CsHd9Hzw5YQ//JpcHllAqdnt2DVhTkRFgv+TIpO80WaUm4Wcvcio8ipGqpEU6OeY3BxeeGUaAfNMlmKU0HuSN86Wx/RdP35UOoIa6Jm7cdCbZzrX0fb8GtsWp1zQTzTWy8cYx26HK7sS1eNg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608014; c=relaxed/simple;
	bh=7sZ8+kkoz+U4MDljfBHHC+MqtQ7jlqaTksmOwbih2NM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ofew6ghBl3uYOclmgUUTb+35gjp9mh4BPGM6giqQ7W0CnUIJlZu4pTecxxhQIJR0pwcDTWkrAT3fJVWtJsBxWionB5Esb3BX3JGHWH1FUf5ojqtUlyZcWUiqy8lihD7u/ENykMoFRzutQ3KIlf8tKa26jjNSupyRncMrKV75u/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CInC+Gch; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CInC+Gch"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79995C2BCFC;
	Tue, 12 May 2026 17:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608014;
	bh=7sZ8+kkoz+U4MDljfBHHC+MqtQ7jlqaTksmOwbih2NM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CInC+GchgJnblal7ignhIRONVCMi56vup5Gh8Xt1hRMHP/pBtIudsDpfuADkip5XP
	 hKOUvawYpSq6qir9zNz73gBcnu/7Mfu759q9OWiN88n0gmePE3ubD5NJd+iw7P1zot
	 FNbparM0ndYMpLZ76E2xJeRsqbe+7QUgNNnZfZtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Nicolin Chen <nicolinc@nvidia.com>
Subject: [PATCH 6.12 123/206] iommu/arm-smmu-v3: Add a missing dma_wmb() for hitless STE update
Date: Tue, 12 May 2026 19:39:35 +0200
Message-ID: <20260512173935.460398160@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1161,6 +1161,13 @@ void arm_smmu_write_entry(struct arm_smm
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


