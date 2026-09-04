Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E19411A1C;
	Fri,  4 Sep 2026 05:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501419; cv=none; b=caHRHl1p36A0UrX7Nu/rnjmPgWt2mvE3IBmHLc43wjP+ULD3d0IjIIKJerCWt8un972GOn8PHuHEqHebSm43WqE7eLG0t+Zd99GkdyPq2oC1pXzv4kXhmfNDUlIpvo+mNFQVj+hiLl8jo2mSXdc5VcUVql7cJlDOPL3wSIfhpgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501419; c=relaxed/simple;
	bh=mIgDu2/KUq+N9Eth7sGafYRR998YwFXNvGzwUcfZ3qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iB/O5k19ru5qQe7Us16DEn2EQC5x9Vq4S6Rpaj8iQyHzvGZ+4SrufleebVvI02s1I1KRYyH2RvwYbw61OL+uqeK4IV5wfYEENdTbOQ4FZ6xv1lomf6YmmS8cugetU+cTX/mXGrZufQhXHEgUF1tINCxvzvfYYFA1NsXJnmLpvkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PRZrfSSt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PRZrfSSt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9E11F00A3D;
	Fri,  4 Sep 2026 05:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501418;
	bh=w0xQA1/4X+38bRQbf1vJfZnuNsvvn2tVfa2mOgLqZac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PRZrfSStZGBA6T/+AJl5GCw2/EceRnB3V6rMiea/vemHYCazPSvJti+jP+LXBpozY
	 BzIizMoz5s7UZ06IuegQzTkCU8pLraiAjna8eD/iG2IseXiM77Z5X2Kihi1iniRBDK
	 yyQ1TGDjANwjdElBi6pEFWeFXTqEfyauuSyXfXic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.18 404/552] iommu/sva: Set handle->dev before the SVA handle is visible
Date: Fri,  4 Sep 2026 06:59:21 +0200
Message-ID: <20260904045759.675726244@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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


