Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD3013B2B8;
	Tue, 27 Feb 2024 13:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041323; cv=none; b=hV01DQtnMVRJa+Cr/Dw2n8BrnPywh0/KZTBqkOvf7afX1dI5v1s0QyXKtUwBecw4fYJkzDxlJlMEVZqki6XdehQNuy75C+pAl3QL4Y1qk200Cpb6UXDg8Uq16lDfXFZmZyajNyl9S6s4sNCd3Nh3XwPpUmqb3mwlJt8JZql43Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041323; c=relaxed/simple;
	bh=qhR0sSKRK9+hR5t6Wqibl+EmdSjJI1+NKymNMvAlj+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=peqQFo8zENHH70qYpFSdCYtdwau6ky1MOiy3xUerZcJ194EWRUzjlpochpFqjswhUqEelaFV0HmPRgpWo7X7mcGswp0YEIIVnFUN5zCFWJH9JoXkKvnQ0lyE2+6qhz+1OvSLWRcU7lrS/LAivNGaI+u6ihybrAQe3VN4L7ccaK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VkQQuXUu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VkQQuXUu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B90C433C7;
	Tue, 27 Feb 2024 13:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041322;
	bh=qhR0sSKRK9+hR5t6Wqibl+EmdSjJI1+NKymNMvAlj+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VkQQuXUuwaIpToGOt3eSCE5fKnxyRSAsD/v5LyP1jEpu36C4urlPE7XgbZkE2kPsK
	 JtgF8fDdMoijb/xA0OTplgqKcDMb1dz9ETzXlhCcll3G6yCU1s1hlxA++L0vtCJhv4
	 An5MrztQI8cb8HvLPpl4FjCJ/rx8k7SlRJF9qL+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 298/334] iommufd: Reject non-zero data_type if no data_len is provided
Date: Tue, 27 Feb 2024 14:22:36 +0100
Message-ID: <20240227131640.657548875@linuxfoundation.org>
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

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 7adc0c1cfa7732b81bf7bf2ed16ffb99719ceebf ]

Since the current design doesn't forward the data_type to the driver to
check unless there is a data_len/uptr for a driver specific struct we
should check and ensure that data_type is 0 if data_len is 0. Otherwise
any value is permitted.

Fixes: bd529dbb661d ("iommufd: Add a nested HW pagetable object")
Link: https://lore.kernel.org/r/0-v1-9b1ea6869554+110c60-iommufd_ck_data_type_jgg@nvidia.com
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommufd/hw_pagetable.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
index cbb5df0a6c32f..6f680959b23ed 100644
--- a/drivers/iommu/iommufd/hw_pagetable.c
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -261,7 +261,8 @@ int iommufd_hwpt_alloc(struct iommufd_ucmd *ucmd)
 
 	if (cmd->__reserved)
 		return -EOPNOTSUPP;
-	if (cmd->data_type == IOMMU_HWPT_DATA_NONE && cmd->data_len)
+	if ((cmd->data_type == IOMMU_HWPT_DATA_NONE && cmd->data_len) ||
+	    (cmd->data_type != IOMMU_HWPT_DATA_NONE && !cmd->data_len))
 		return -EINVAL;
 
 	idev = iommufd_get_device(ucmd, cmd->dev_id);
-- 
2.43.0



