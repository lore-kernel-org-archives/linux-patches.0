Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8EC30748B;
	Tue,  6 Jan 2026 17:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720943; cv=none; b=IMdjVK+b2JbcQH4lnPNr1JOXmDzDSNQ1jleOqdvxphQSneP1Wo3+Yt5U8SFRLd+5U9rp6he4+ce/DRp4mhe1ATc1UU6Qdc4u1WpK5macDBfEImR594dzWHzH4jltOGpGKOA0VTQ1LSwfaQCirkbOsTpJTRY7xoNAAr7miNQ3GVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720943; c=relaxed/simple;
	bh=5hEO0KuTaYZbUl4v2JPjTee7tO3+Ketak0Gq1zbZFIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UGQ8DIUKjIMSIJjJxQmj6U+OmE3oG/Xj8Lb7o9qJD1Fn4ewAcZoaG1vM013jXSuiDIil7Tb51uU7P1IabsiL8JSbe+gIHLzPYH1/vkEvo6OqQDMDxGliWsmZnLhY6cyZBImK4pKFrxNb90ZvbF5ck/CtfdXl1mYy0q2ZN80JlTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iFQzbTtJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iFQzbTtJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C29F9C116C6;
	Tue,  6 Jan 2026 17:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720943;
	bh=5hEO0KuTaYZbUl4v2JPjTee7tO3+Ketak0Gq1zbZFIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iFQzbTtJwxisJZF/+0xrOBOi48N7L9/m7+sy1EpCoK18errwY91Km59oLXshoER/X
	 Fvlg34hUE1GwLqGyrKdGDXEFguNwdzCXPec7w/rgPklVTyqk0f4l5gOG1nacpLIUFT
	 IE3kY/WiFWRl2g7/k97gePWD+1N0tKF0ggsOGDnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinhui Guo <guojinhui.liam@bytedance.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.12 355/567] iommu/amd: Propagate the error code returned by __modify_irte_ga() in modify_irte_ga()
Date: Tue,  6 Jan 2026 18:02:17 +0100
Message-ID: <20260106170504.466360734@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Jinhui Guo <guojinhui.liam@bytedance.com>

commit 2381a1b40be4b286062fb3cf67dd7f005692aa2a upstream.

The return type of __modify_irte_ga() is int, but modify_irte_ga()
treats it as a bool. Casting the int to bool discards the error code.

To fix the issue, change the type of ret to int in modify_irte_ga().

Fixes: 57cdb720eaa5 ("iommu/amd: Do not flush IRTE when only updating isRun and destination fields")
Cc: stable@vger.kernel.org
Signed-off-by: Jinhui Guo <guojinhui.liam@bytedance.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/amd/iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3172,7 +3172,7 @@ static int __modify_irte_ga(struct amd_i
 static int modify_irte_ga(struct amd_iommu *iommu, u16 devid, int index,
 			  struct irte_ga *irte)
 {
-	bool ret;
+	int ret;
 
 	ret = __modify_irte_ga(iommu, devid, index, irte);
 	if (ret)


