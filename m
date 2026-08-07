Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC3042D758;
	Fri,  7 Aug 2026 15:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117095; cv=none; b=kGVk7KJykg/fTR/Pm+eBRVWurqGSRRFD5IFCxxPHjA2BkqJXRwu84mz+OEayw9rVVwA3uWPJfD+a8sT7l/YnzTu7/T/BthE0JIJRCJ7vBFrKREYlKIZfyfeE1ObTcwT1PoP3KwfC2960jWzsJIf1nVJdF6648LEekwz32h+V1CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117095; c=relaxed/simple;
	bh=HQEeywKao0xspqRI/ftqnWhYv8w5F/IacpB3bkX0S1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hh3CO0QuG4V8Jh7zWNEYBbfdfuzJZ2AsfDz+3r5QN8SBJZjW5FzG0Z7W5xe+Vr6eopl+cWeipLRvy1V5AyWQ3lBsYDmF4Cxo5CUZJBnYMyIxkWjnnFYCryspszBgHsSwKIO5R1/YdbHwZdBqP1mSluxIULhA4SkdBOP0pqvi2cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IdellUHX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IdellUHX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E96181F000E9;
	Fri,  7 Aug 2026 15:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117094;
	bh=Pqx1SKNll/UiGQRu5qu1Rgpk5Ow6bkTdOtcqXeMy4AQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IdellUHXY1EPmkSsm2zlBR/cCCq3fEt+NrUKO2qRinGmV9F9F9aLaRVXxetLROfv2
	 toFi1HESwILWH8Gywm09MgSnYRar4LQk6QvuayRKAXVizYITFUz6hoAuKKRtMsSySX
	 1rqwIe+yMJ+uZz6WM8DoSP6F56ynHKfXEa5C/O5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Pranjal Shrivastava <praan@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 7.1 197/438] iommufd/viommu: Release the igroup lock on the vdevice_size error path
Date: Fri,  7 Aug 2026 16:36:33 +0200
Message-ID: <20260807143432.224157111@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

commit 339bd11591593ab7ce88136ab7fd01ef3813b724 upstream.

iommufd_vdevice_alloc_ioctl() takes idev->igroup->lock, then validates the
driver's vdevice_size against the core structure size with a WARN_ON_ONCE.
On failure that guard jumps to out_put_idev, below out_unlock_igroup, so it
skips the mutex_unlock(), leaving the igroup lock held and deadlocking the
next vDEVICE operation on that group.

Jump to out_unlock_igroup instead.

Fixes: ed42eee797ff3 ("iommufd/viommu: Add driver-defined vDEVICE support")
Link: https://patch.msgid.link/r/e903f775d491296a525097e2a90b3eb6a47cf2ef.1783311134.git.nicolinc@nvidia.com
Cc: stable@vger.kernel.org
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Assisted-by: Claude:claude-opus-4-8
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/viommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/iommufd/viommu.c
+++ b/drivers/iommu/iommufd/viommu.c
@@ -189,7 +189,7 @@ int iommufd_vdevice_alloc_ioctl(struct i
 		if (WARN_ON_ONCE(viommu->ops->vdevice_size < vdev_size ||
 				 !viommu->ops->vdevice_init)) {
 			rc = -EOPNOTSUPP;
-			goto out_put_idev;
+			goto out_unlock_igroup;
 		}
 		vdev_size = viommu->ops->vdevice_size;
 	}


