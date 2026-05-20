Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7FC43A381D;
	Wed, 20 May 2026 17:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298329; cv=none; b=qaUIPUHnf4vFkiFEc8V1W8tupSKaJ3YpvarTRujMRMZzaseAhS+wuvmK+A08Sx6ihopf0zVywQLx5Z+xfhQuQKUd9jB1zAczwVnRuAtKP0B3ASJdZSmyymPH/h4BpHrIrzHmy+xcUrnhwhh1Gg6NWzGtASMU1vdydeML4SaB+wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298329; c=relaxed/simple;
	bh=yU0qyHJfigjbZ4cDjuYTeIDdSHmiA3o15R8lubKqlKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IbVAIOy4SanLT5ba0LFwYJMcBb+AChM/doamaiUoYKznkB7QDG7/vMWMQJ2VxQ5l0UrzQzmPruX1qdAwL+YXZXPTK9v16vAX9wU4rA55b1+qoUVR93S20Hqig5222QB9hKw05jCEAcoKBVemGsx0y7bmzzNMVtJ6e6WIUQ+iUZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MHnjy3WI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MHnjy3WI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4751F00893;
	Wed, 20 May 2026 17:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298328;
	bh=N6acFPxx69igUCNH1HL92ss6jQBowSLpwaZuFgdlfyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MHnjy3WIOA3kFiWEA0Veu/PaokhLqJG0rcpxn408qe/OziXrwjgJmtTYjKEShFs1o
	 XobR4OdKkysB45MSctcM2aZWDOftlebmCfR/h8qaG/zfSBAGnRIn9VaVQQtrAvgTk1
	 wiVYR21aJwY141cROpvmigzriTr9nsrR9yCDjNYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 369/957] iommufd: vfio compatibility extension check for noiommu mode
Date: Wed, 20 May 2026 18:14:12 +0200
Message-ID: <20260520162142.531049696@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Jacob Pan <jacob.pan@linux.microsoft.com>

[ Upstream commit 7147ec874ea08c322d779d8eba28946e294ed1f3 ]

VFIO_CHECK_EXTENSION should return false for TYPE1_IOMMU variants when
in NO-IOMMU mode and IOMMUFD compat container is set. This change makes
the behavior match VFIO_CONTAINER in noiommu mode. It also prevents
userspace from incorrectly attempting to use TYPE1 IOMMU operations
in a no-iommu context.

Fixes: d624d6652a65 ("iommufd: vfio container FD ioctl compatibility")
Link: https://patch.msgid.link/r/20260213183636.3340-1-jacob.pan@linux.microsoft.com
Signed-off-by: Jacob Pan <jacob.pan@linux.microsoft.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommufd/vfio_compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/iommufd/vfio_compat.c b/drivers/iommu/iommufd/vfio_compat.c
index a258ee2f4579f..acb48cdd3b005 100644
--- a/drivers/iommu/iommufd/vfio_compat.c
+++ b/drivers/iommu/iommufd/vfio_compat.c
@@ -283,7 +283,7 @@ static int iommufd_vfio_check_extension(struct iommufd_ctx *ictx,
 	case VFIO_TYPE1_IOMMU:
 	case VFIO_TYPE1v2_IOMMU:
 	case VFIO_UNMAP_ALL:
-		return 1;
+		return !ictx->no_iommu_mode;
 
 	case VFIO_NOIOMMU_IOMMU:
 		return IS_ENABLED(CONFIG_VFIO_NOIOMMU);
-- 
2.53.0



