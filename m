Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5367B1D0493;
	Wed,  2 Oct 2024 13:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876313; cv=none; b=rDWIQbO9t407hUmeKEVElw3shCj5jnkZCd13dMBc5KB9jmsupo+UEPEJLY6YTeIb2t7d6BErDhkClJshgg1sMNOwpO+kNyNOv7mcoChDEdrTdsvDyNBbfip7+54dUe1rOyPANBPY4BCF6t/C1vaLArW6SJLtzLoNioIAw+FtWmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876313; c=relaxed/simple;
	bh=DtnunyiHmdAyvuj3n7UCh4h7NSMArhtlZdHDz0oQqO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oU4mS0foE5Ua+9BGURa/uf+xkSnhQd+v5SkaD4Z6MfDw2Ze3oxcX/wDnjE4jmJ0gOtIMGJuAVXTaIRLJ02V5by2AUDwjG1dB1DPdZTUqji1vpOvpF/1UFwbN7GM66qs5sxQnxMj1qz+6RInP9GghBQIe2CjudGuriVMl1P0ZT4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kJyMiKzn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kJyMiKzn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8FD6C4CEC5;
	Wed,  2 Oct 2024 13:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876313;
	bh=DtnunyiHmdAyvuj3n7UCh4h7NSMArhtlZdHDz0oQqO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kJyMiKznzUD/OF6eeMfgQ0b/FA/+7wQBoigBANMJgMGPXuaU03QeZUGGUyhKW7eay
	 Fvkc37dDE5B1FZeWlXXiB8zrCJWksDuuPLYQ+kzxpyDlGOcGljjB+ZklTpQgTU/Xps
	 KbFXWTPhFWEOcnWvt3Gpttulr22RQGbajds22jpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 402/695] iommufd: Check the domain owner of the parent before creating a nesting domain
Date: Wed,  2 Oct 2024 14:56:40 +0200
Message-ID: <20241002125838.503701624@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 73183ad6ea51029d04b098286dcee98d715015f1 ]

This check was missed, before we can pass a struct iommu_domain to a
driver callback we need to validate that the domain was created by that
driver.

Fixes: bd529dbb661d ("iommufd: Add a nested HW pagetable object")
Link: https://patch.msgid.link/r/0-v1-c8770519edde+1a-iommufd_nesting_ops_jgg@nvidia.com
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommufd/hw_pagetable.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
index aefde4443671e..d06bf6e6c19fd 100644
--- a/drivers/iommu/iommufd/hw_pagetable.c
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -225,7 +225,8 @@ iommufd_hwpt_nested_alloc(struct iommufd_ctx *ictx,
 	if ((flags & ~IOMMU_HWPT_FAULT_ID_VALID) ||
 	    !user_data->len || !ops->domain_alloc_user)
 		return ERR_PTR(-EOPNOTSUPP);
-	if (parent->auto_domain || !parent->nest_parent)
+	if (parent->auto_domain || !parent->nest_parent ||
+	    parent->common.domain->owner != ops)
 		return ERR_PTR(-EINVAL);
 
 	hwpt_nested = __iommufd_object_alloc(
-- 
2.43.0



