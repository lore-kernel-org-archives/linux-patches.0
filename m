Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CCD1DDA36;
	Tue,  8 Oct 2024 12:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390025; cv=none; b=kdPqszfmHOA74B2KSRHn+FcTyqOP/ryOwHP7KThB6TMyHV0b9xP9twyvpc0e0UZcs9/por2gN5yhdVNRPFYCgkbXWLuFJqam36ns2GjGv0ZSfdGTTXGG7rvKYjmuc6qkYoEYNnKFgizTh22n9cu4zZacrocM2UgTHrgjAad64xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390025; c=relaxed/simple;
	bh=sW5xyTa+G1f/0FRJyvGGWVMqY6bam11DHc9bkpFcLDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZNjmxP0o+DXsRlr+0RWGMAtEKc/0OKX6kmRoN9gIgF/wnPpsi0Y0Kbr9uGbfzMzgaB/3YHnSg2CQMQdW8fUGE3a1kT+ClZNALCRkEFzT3d+/mlZki0s5CPuv7LEugnSf/cFepMaCtTw+7o8inQvNxQ0gGIp9rfytUXAAY7wpoUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y+BOaboj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y+BOaboj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C2D8C4CEC7;
	Tue,  8 Oct 2024 12:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390025;
	bh=sW5xyTa+G1f/0FRJyvGGWVMqY6bam11DHc9bkpFcLDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y+BOaboj3rIrTNs5JrPE1LQFtMdy0VEEtT37nRAVtH8fInQMfes2fPBDDIZ3wg7Md
	 m55SNE9SdmhAsyb614ghdA++P4+aaYyus6mMsseFqCfxveHnF4EbFDwtXPppSkIoYP
	 pftcCP+7ZGqOrgMhyqDRf7IsVw/stc8+d3f1105Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 168/482] iommu/vt-d: Always reserve a domain ID for identity setup
Date: Tue,  8 Oct 2024 14:03:51 +0200
Message-ID: <20241008115654.917202632@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 2c13012e09190174614fd6901857a1b8c199e17d ]

We will use a global static identity domain. Reserve a static domain ID
for it.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Link: https://lore.kernel.org/r/20240809055431.36513-4-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index e9bea0305c268..eed67326976d3 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1462,10 +1462,10 @@ static int iommu_init_domains(struct intel_iommu *iommu)
 	 * entry for first-level or pass-through translation modes should
 	 * be programmed with a domain id different from those used for
 	 * second-level or nested translation. We reserve a domain id for
-	 * this purpose.
+	 * this purpose. This domain id is also used for identity domain
+	 * in legacy mode.
 	 */
-	if (sm_supported(iommu))
-		set_bit(FLPT_DEFAULT_DID, iommu->domain_ids);
+	set_bit(FLPT_DEFAULT_DID, iommu->domain_ids);
 
 	return 0;
 }
-- 
2.43.0



