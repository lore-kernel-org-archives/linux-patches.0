Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A818913DBB3;
	Tue, 27 Feb 2024 13:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041311; cv=none; b=oK9KGRjIxeyz/EEaDG9ZeEUdJUGmn+FdmDMGISIZIoTIBE3YVG4bp+jo6yY1Z3dyQodZ2jdSrhMn9pjdwCXAKAK9ZMhIo7Xgh2ssL+amw4oF+ErERnX24DWYu1kpb92FU3I4XyUjXi8G8CT9tNWrNyIw29fh+0tvHZTpVuAHVAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041311; c=relaxed/simple;
	bh=p8m+iCoT+Bua/UK+9m/weYSYsSB9P5VDc/nW4nTX+TM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bx3DGJPaIOdw04I1x8uUbKMRTDoFcOBZm/hbsj6tPFgHnsxhLnLSkdFWe6xF0L6Nx6Ek2hgUXpZvru2Z3ahKJ5PLU5Xjx0Au62lo0VU9xVzmmsgyyjcO6Rg6L8c2W3LunS+zu842pbjMw9Rq/JrKPOQuEJ3DTQREv2iqrKPCoHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f7Uhlaro; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f7Uhlaro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 374A2C433C7;
	Tue, 27 Feb 2024 13:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041311;
	bh=p8m+iCoT+Bua/UK+9m/weYSYsSB9P5VDc/nW4nTX+TM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f7UhlaroKqh7wVatPTJ3DCOOxbz54mUBfOKxj8iAACaFuBKYyGFZKnclaqMGhO2qY
	 aprtVgfuvIxIdO2RFMe2fa5jsxH63Ipb03rOlYLpC4b4hfzikIBCfvOxZ33F9UxBeK
	 QaL7WwksIzZK+fH/NQMcGpS3tzH3/vHFUuUwhA4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Liu <yi.l.liu@intel.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 294/334] iommu/vt-d: Set SSADE when attaching to a parent with dirty tracking
Date: Tue, 27 Feb 2024 14:22:32 +0100
Message-ID: <20240227131640.527814065@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Liu <yi.l.liu@intel.com>

[ Upstream commit 1f0198fce68340e0da2d438f4ea9fc20d2c958da ]

Should set the SSADE (Second Stage Access/Dirty bit Enable) bit of the
pasid entry when attaching a device to a nested domain if its parent
has already enabled dirty tracking.

Fixes: 111bf85c68f6 ("iommu/vt-d: Add helper to setup pasid nested translation")
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Link: https://lore.kernel.org/r/20240208091414.28133-1-yi.l.liu@intel.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/pasid.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 9f8f389ff255c..6e102cbbde845 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -925,6 +925,8 @@ int intel_pasid_setup_nested(struct intel_iommu *iommu, struct device *dev,
 	pasid_set_domain_id(pte, did);
 	pasid_set_address_width(pte, s2_domain->agaw);
 	pasid_set_page_snoop(pte, !!ecap_smpwc(iommu->ecap));
+	if (s2_domain->dirty_tracking)
+		pasid_set_ssade(pte);
 	pasid_set_translation_type(pte, PASID_ENTRY_PGTT_NESTED);
 	pasid_set_present(pte);
 	spin_unlock(&iommu->lock);
-- 
2.43.0



