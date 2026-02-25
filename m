Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D0A1D5ABA;
	Wed, 25 Feb 2026 01:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983196; cv=none; b=RkUyulnSxXRCoP/ee/ulrT7j7IZPg+W1vNZcX7hjIpFXMqS8pKT1/RHQ+6kUS1nuBbN1sC2ZYLXFNT+WQWy63oucN950rhTwreHMtVE3bQ5n+hP80FsxvO26Bqa7hORa5WI9/hzN/wq297aLwRxO0rjEQ/nbCWlT+5x9JdM5Rlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983196; c=relaxed/simple;
	bh=Wer5fbjrJemGTZbBlj1lBB81gELNZGweG1cz0Mu5Lgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6TYl8z0GybjA79jFRzNlkH9uUnknIpnxnkvMe1ORF1XCtPN7O5gsP/1zlb53MxtErcpFBg9ejEoMauWeoZkCTOgBGpXHBdy/aGOV2HWZL9uwVXUpx5EeQ/RP+C+Yp0SUX6ktoAOJFYBPIQ33Lh4diujtFdPNDlDe6saKbUs0Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gbqbCHzZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gbqbCHzZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5516C116D0;
	Wed, 25 Feb 2026 01:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983195;
	bh=Wer5fbjrJemGTZbBlj1lBB81gELNZGweG1cz0Mu5Lgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gbqbCHzZ0aYtkrjwiHtjaVE1eECX0QAojtqyDoomP51XjzSvo2aQcOe9Ig2Q1jxXh
	 piDY+3dvBnLKbURb+ekwhqJT1od63YNFollSDFDC3Iye2rMqK9M7wR5AFoIlB5oXVP
	 tfspP7Tao1gvbJBZfGLXAMjmICq1dJ5oryQWDkDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Wei Wang <wei.w.wang@hotmail.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 343/781] iommupt: Do not set C-bit on MMIO backed PTEs
Date: Tue, 24 Feb 2026 17:17:32 -0800
Message-ID: <20260225012408.106090222@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Wang <wei.w.wang@hotmail.com>

[ Upstream commit e2692c4eeaa4bd945b7bae156b4cac55d6a0c730 ]

AMD Secure Memory Encryption (SME) marks individual memory pages as
encrypted by setting the C-bit in page table entries. According to the
AMD APM,any pages corresponding to MMIO addresses must be configured
with the C-bit clear.

The current *_iommu_set_prot() implementation sets the C-bit on all PTEs
in the IOMMU page tables. This is incorrect for PTEs backed by MMIO, and
can break PCIe peer-to-peer communication when IOVA is used. Fix this by
avoiding the C-bit for MMIO-backed mappings.

For amdv2 IOMMU page tables, there is a usage scenario for GVA->GPA
mappings, and for the trusted MMIO in the TEE-IO case, the C-bit will need
to be added to GPA. However, SNP guests do not yet support vIOMMU, and the
trusted MMIO support is not ready in upstream. Adding the C-bit for trusted
MMIO can be considered once those features land.

Fixes: 879ced2bab1b ("iommupt: Add the AMD IOMMU v1 page table format")
Fixes: aef5de756ea8 ("iommupt: Add the x86 64 bit page table format")
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Wei Wang <wei.w.wang@hotmail.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/generic_pt/fmt/amdv1.h  | 3 ++-
 drivers/iommu/generic_pt/fmt/x86_64.h | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/generic_pt/fmt/amdv1.h b/drivers/iommu/generic_pt/fmt/amdv1.h
index aa8e1a8ec95fd..3b2c41d9654d7 100644
--- a/drivers/iommu/generic_pt/fmt/amdv1.h
+++ b/drivers/iommu/generic_pt/fmt/amdv1.h
@@ -354,7 +354,8 @@ static inline int amdv1pt_iommu_set_prot(struct pt_common *common,
 	 * Ideally we'd have an IOMMU_ENCRYPTED flag set by higher levels to
 	 * control this. For now if the tables use sme_set then so do the ptes.
 	 */
-	if (pt_feature(common, PT_FEAT_AMDV1_ENCRYPT_TABLES))
+	if (pt_feature(common, PT_FEAT_AMDV1_ENCRYPT_TABLES) &&
+	    !(iommu_prot & IOMMU_MMIO))
 		pte = __sme_set(pte);
 
 	attrs->descriptor_bits = pte;
diff --git a/drivers/iommu/generic_pt/fmt/x86_64.h b/drivers/iommu/generic_pt/fmt/x86_64.h
index 210748d9d6e8a..ed9a47cbb6e02 100644
--- a/drivers/iommu/generic_pt/fmt/x86_64.h
+++ b/drivers/iommu/generic_pt/fmt/x86_64.h
@@ -227,7 +227,8 @@ static inline int x86_64_pt_iommu_set_prot(struct pt_common *common,
 	 * Ideally we'd have an IOMMU_ENCRYPTED flag set by higher levels to
 	 * control this. For now if the tables use sme_set then so do the ptes.
 	 */
-	if (pt_feature(common, PT_FEAT_X86_64_AMD_ENCRYPT_TABLES))
+	if (pt_feature(common, PT_FEAT_X86_64_AMD_ENCRYPT_TABLES) &&
+	    !(iommu_prot & IOMMU_MMIO))
 		pte = __sme_set(pte);
 
 	attrs->descriptor_bits = pte;
-- 
2.51.0



