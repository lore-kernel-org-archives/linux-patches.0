Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756F041F5D9;
	Fri,  4 Sep 2026 06:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502714; cv=none; b=uN0XyvOukSOuSqOdrOQsiqKSSgk9/EmddzRsZrWmzrA+teJ4cK0nvUczn7RIYv79G0hPyGK2P7zfeIDpL8AqN0LBtNMQntRdPnkMEBXHU9Sno++m40uWDvYJD83rjzXkrnJo3E5UsmliljQoyf+aaNhBqWNDMlI6nZCAEi9XUAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502714; c=relaxed/simple;
	bh=IaSyVuFOGN22elHEBJdZDxQjJd9L+Sn1/hmX23ncIog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GDbM+qvyVaOADQXxcQBATSoV+ngxUpxNMLgwlTodcPI16+eaN319oG/DNZNXO9h6w2Tm7PzoLz2ybae3jbZBTcG3xbI+2ivoRye4wToG0d73Npsgrl8aOmeVaRQI9kcwp2T2V9c9L2u7cwXhmhBMMpjIZL/eu/brQeRh9NCUDLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DH9tqw2N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DH9tqw2N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6BE11F00A3D;
	Fri,  4 Sep 2026 06:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502713;
	bh=aGd7wk2Zbxb5eo+A3BVx1mWWAm/wsH6y0N0pw8bGtaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DH9tqw2NL5BKr/Ip3mwRzudgFxH8+kbtCEgt/aFbMMVnfbv6wql6dsG3rmMGPiDvT
	 az09ObXesLIIeH/5CFQe1UpUo9HW3PmhzOaKXBckjnA/Io8v/XgH0hAdksjpBRo9VJ
	 zyX5Be/ticvVSjXeW95DKkvqBurdtLKWOebr0oSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.12 303/403] iommu/sva: Set handle->dev before the SVA handle is visible
Date: Fri,  4 Sep 2026 07:01:46 +0200
Message-ID: <20260904045741.734501049@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

From: Shuai Xue <xueshuai@linux.alibaba.com>

commit 530f8f9c3546cb3ebee1b135375aaee08a073ebb upstream.

iommu_attach_device_pasid() installs the new SVA attach handle in the
group PASID lookup before iommu_sva_bind_device() returns. A concurrent
bind can therefore find and reuse the same handle after iommu_sva_lock is
dropped.

handle->dev was initialized after dropping iommu_sva_lock. This leaves a
window where a racing bind can return a handle whose dev pointer is still
NULL. A subsequent iommu_sva_unbind_device() can then dereference it via
handle->dev->iommu_group.

Initialize handle->dev before releasing iommu_sva_lock so any visible SVA
handle is fully initialized.

Fixes: be51b1d6bbff ("iommu/sva: Refactoring iommu_sva_bind/unbind_device()")
Cc: stable@vger.kernel.org
Assisted-by: Qoder:Qwen-3.8-MAX-Preview
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommu-sva.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/iommu-sva.c
+++ b/drivers/iommu/iommu-sva.c
@@ -142,8 +142,8 @@ struct iommu_sva *iommu_sva_bind_device(
 
 out:
 	refcount_set(&handle->users, 1);
-	mutex_unlock(&iommu_sva_lock);
 	handle->dev = dev;
+	mutex_unlock(&iommu_sva_lock);
 	return handle;
 
 out_free_domain:


