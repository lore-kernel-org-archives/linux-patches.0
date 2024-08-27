Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92641C825E;
	Tue, 27 Aug 2024 15:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771704; cv=none; b=WJgR70LkI5zhAyigXHBUarmK34OTVXf3iPtnkkVk85WGbzmv7cb1N4e/7BA1Txgb032joPIl5EMRKrqdoOWjMJ8ubP7IR8uDC/txNFuyDA3nCIpMvZZwflr4e736sfJf7sRC9wrHNasCRsRMph2Y3VzYPmg3kzLPLrOlwzehwVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771704; c=relaxed/simple;
	bh=In0JbhKR2E6Qn214K/2rz2aWrONqwB+jlfb1YDSDRn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pDCDBbQtpGTmYKKbRIcZ1IhWJmi98naGp94gTrCI2qR7+IXgS8wxd8cr0l68nGU/CyrvBZWPTUzdCpXdl+MiUbPci6ieTmexu7zPTYdeNyMmtzuvWK22UaX/X0OP/fImNS+76vsSJWKI9jCVOVdEMgankrOqRP2i5cUNTuHrmLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LoV/vgUD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LoV/vgUD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 242DFC61075;
	Tue, 27 Aug 2024 15:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771703;
	bh=In0JbhKR2E6Qn214K/2rz2aWrONqwB+jlfb1YDSDRn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LoV/vgUDdXgnhHAOv+k5TmnJ2j5HnJqpdc35z7adf8wZ8As/TiPi0L2OTjRrWQ0RA
	 N20gxZiqFVxCg+ltGlTsA9khAZTG10vjlN3vepHvKhED/vRANsiHQKBcM0+GIcZtH6
	 U8rMq07vZMJuO8SWoLNJrf42Z9HZLtpCmS5zFWYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.10 237/273] iommufd/device: Fix hwpt at err_unresv in iommufd_device_do_replace()
Date: Tue, 27 Aug 2024 16:39:21 +0200
Message-ID: <20240827143842.423688088@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

From: Nicolin Chen <nicolinc@nvidia.com>

commit 950aeefb34923fe3c28ade35fe05f24e2c5b1d55 upstream.

The rewind routine should remove the reserved iovas added to the new hwpt.

Fixes: 89db31635c87 ("iommufd: Derive iommufd_hwpt_paging from iommufd_hw_pagetable")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/r/20240718050130.1956804-1-nicolinc@nvidia.com
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -525,7 +525,7 @@ iommufd_device_do_replace(struct iommufd
 err_unresv:
 	if (hwpt_is_paging(hwpt))
 		iommufd_group_remove_reserved_iova(igroup,
-						   to_hwpt_paging(old_hwpt));
+						   to_hwpt_paging(hwpt));
 err_unlock:
 	mutex_unlock(&idev->igroup->lock);
 	return ERR_PTR(rc);


