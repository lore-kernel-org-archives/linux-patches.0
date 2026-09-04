Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6589A4137B2;
	Fri,  4 Sep 2026 05:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499937; cv=none; b=c2QL2YSFwmPWLfCzgsW/pFF2m9qJXdkMcX73whz5FSkiFgLpSeUnwGvU44uk1hA/OK+A3tLtP214Rmvh2OhKtTvJLZ7/BNhCMQCq0BCWMG8m6IkD5N6mcFpXFTP5iQAxMtM//DMhxBf27RNZ9zbJXToj1aSx9OLAGluXiRRj33I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499937; c=relaxed/simple;
	bh=AmdraST8IHbcq2v9W8uHO83MgF68ZkxgrQlegHyY3ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wq9ZkOO46szEJkUkz7lDoDMZPW7YPzeBeGvVmBasuu0N6KqovnvWLQ54vpTzPa8Ll/qD/Lg3ulQCu449TvsU6CqzvclMPiREWMd3u2/cr105/0nX8/zpUSC4+AKUA7d9LosDnMf2VaCmXGkOsgXeGlupdCErqJNHZfOLcFOs6vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CpTpm2nG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CpTpm2nG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD00C1F00A3D;
	Fri,  4 Sep 2026 05:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499936;
	bh=nx3Jo2vfjQDiEt9alA0EyU2fnOkFDXPcOTYe2i0xt3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CpTpm2nG7OkSFsZLu2PES9qfxYgzx6UirbwwD0+0hRdbdwBbugacH/ph9qOpOp6pQ
	 KBqpJoLWeFo5dbZ1/juGa7UzT/s/y2FcQFAD/RZyqj2Ii4vSoCYJaYSsXqUi8NAYo8
	 /0GpqE//nyzEYDF9qLPZ9nu5s5W8P6bn4TnMIRA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 7.2 539/713] iommu/sva: Set handle->dev before the SVA handle is visible
Date: Fri,  4 Sep 2026 06:58:27 +0200
Message-ID: <20260904045815.902685817@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -145,8 +145,8 @@ struct iommu_sva *iommu_sva_bind_device(
 	list_add(&domain->next, &iommu_mm->sva_domains);
 out:
 	refcount_set(&handle->users, 1);
-	mutex_unlock(&iommu_sva_lock);
 	handle->dev = dev;
+	mutex_unlock(&iommu_sva_lock);
 	return handle;
 
 out_free_domain:


