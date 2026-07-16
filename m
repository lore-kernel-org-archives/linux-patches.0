Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8430622301;
	Thu, 16 Jul 2026 13:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210099; cv=none; b=Z1DDbmsxGrtVThqsz+8qRHnYnAFTOXnd5usStCHJS/75DqNW/H87YzQhbyfyIvG+oAciVs27l7yq/unOlQPiXlkObH/vG9sFF+stPtSUO1X0ljxKZCh4TDI4z7R/AEF2wG2kj/vY1XMol5/lvhbLoD6GZkOQSI2EgkZBNP54rf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210099; c=relaxed/simple;
	bh=/wiWA/0kF/QJZaJOpec4hjcFxnCuHRn3cHTUIFMIJ4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pK0rH0Yk4IFQ9GH51H/2M+bOLzg0QnqaJRhS7AiLeanC74XNy7mMCAeEHOHoohwowyVPn8HlV7UeqSVYFDAW1Fc/G1vMa67gwfRs7cixHe1XP5+/pWoDc880kHhvbYC8CL1o6ZOiCHl96iuGE9qh91wcIkMbA9Lfj+aiJxkHJjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gTgTpnEv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gTgTpnEv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA3A91F000E9;
	Thu, 16 Jul 2026 13:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210098;
	bh=nm8Uef3AyOOMq3HoOJ/HarzqYZVOUAjwVstoXYo3Q/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gTgTpnEvF8wSBQKCfuFKuKSO1izQYCHGwx0HbaMs4JjzbVRoqp9oUWhUuNISEPnRs
	 05a8td02rtB9ZNowR4CcefnHdCgjKREwPWqu5a5OklFKzGVr/ZFQdJ4+eCGXlMAhek
	 A5BFESkggcv8KYmfGetmj/mDNKiQiLjKXYZ9yQKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH 7.1 436/518] iommufd: Set veventq_depth upper bound
Date: Thu, 16 Jul 2026 15:31:44 +0200
Message-ID: <20260716133057.383860683@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <nicolinc@nvidia.com>

commit 6ebf2eb46fbd5b40393ff8fbb847ba96925beaff upstream.

iommufd_veventq_alloc() accepts any !0 veventq_depth from userspace, with
an upper bound at U32_MAX.

This leaves a vulnerability where userspace can allocate excessively large
queues to exhaust kernel memory reserves.

Cap the veventq_depth (maximum number of entries) to 1 << 19, matching the
maximum number of entries in the SMMUv3 EVTQ (the largest use case today).

Fixes: e36ba5ab808e ("iommufd: Add IOMMUFD_OBJ_VEVENTQ and IOMMUFD_CMD_VEVENTQ_ALLOC")
Link: https://patch.msgid.link/r/8426cbaa5e8294472ec7f076ef427cc473be5985.1779408671.git.nicolinc@nvidia.com
Cc: stable@vger.kernel.org
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/eventq.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/iommu/iommufd/eventq.c
+++ b/drivers/iommu/iommufd/eventq.c
@@ -473,6 +473,9 @@ int iommufd_fault_iopf_handler(struct io
 static const struct file_operations iommufd_veventq_fops =
 	INIT_EVENTQ_FOPS(iommufd_veventq_fops_read, NULL);
 
+/* An arbitrary upper bound for veventq_depth that fits all existing HWs */
+#define VEVENTQ_MAX_DEPTH (1U << 19)
+
 int iommufd_veventq_alloc(struct iommufd_ucmd *ucmd)
 {
 	struct iommu_veventq_alloc *cmd = ucmd->cmd;
@@ -484,7 +487,7 @@ int iommufd_veventq_alloc(struct iommufd
 	if (cmd->flags || cmd->__reserved ||
 	    cmd->type == IOMMU_VEVENTQ_TYPE_DEFAULT)
 		return -EOPNOTSUPP;
-	if (!cmd->veventq_depth)
+	if (!cmd->veventq_depth || cmd->veventq_depth > VEVENTQ_MAX_DEPTH)
 		return -EINVAL;
 
 	viommu = iommufd_get_viommu(ucmd, cmd->viommu_id);


