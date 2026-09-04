Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8210E37DAD0;
	Fri,  4 Sep 2026 05:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499934; cv=none; b=XuRM14Y4DCMakeWh0nOsmPIsbkwPuuzc1CPSPkDicLRgCy2J6uoN1ltGk4F8rr5Z9PGx/ZMHoIOw94mmeMltkflB2lipi9maBmdpdbIXQM+PYjLBzMSwaen9CXs3JBPyB3Ejsxzj4l/oNUbZ7b/i6hECxlTOZovh0F6F6Iaw29I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499934; c=relaxed/simple;
	bh=rwDl7gZK6FVj5VtPaTxahSc/Zth4LHo56R2PtmzJmuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OZXj7EcU5aGQNvtK88RKEy62C1P2fHhSZQF3WzqEoIvvhhtASYuSW5U3nuQfGdSZxPpm/Q8/mx9gYQ4Kqg7XbFvGDWsf1zAsjujtr6lycjhvRaNvwpGT6Nnx9nscZ1W2ZFTKM3r86V9zcBurXxwsxk8+kdNwmsqSuu/nv3APf00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dl7r402F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dl7r402F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA4F1F00A3D;
	Fri,  4 Sep 2026 05:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499933;
	bh=/Ah5tzEbU62vtFqfqFhXPoZdJikQZHdL/HZ/6cEdh7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dl7r402FhV+mYKzMKgVe6Y+uPwIIAaVoCTWmiQh8nSxuOiB7NIAUeqODV3tGstF4P
	 hfhUIXdvFlirR/WEKo2LNXL6F6yjRhsYJT7O6KCKb7tK9z/D35XzAb8dYQQNuDPVVS
	 uEZiwG3JCGEUEFaqjBtWYeR+1+AvNkVBWUcRholQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 7.2 548/713] iommufd: Release current IOAS on xa_store() failure
Date: Fri,  4 Sep 2026 06:58:36 +0200
Message-ID: <20260904045816.102584414@linuxfoundation.org>
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

commit 4ac2ce123824d5f885c868fa1f9f4d463141a2ba upstream.

iommufd_take_all_iova_rwsem() takes an object reference and the
iova_rwsem write lock before storing the IOAS in the temporary ioas_list
xarray.

If xa_store() fails, the current IOAS has not been inserted into
ioas_list yet. iommufd_release_all_iova_rwsem() only unwinds IOAS
objects already present in that xarray, so it cannot release the current
IOAS.

Release the current IOAS rwsem and object reference before unwinding the
previously stored entries.

Fixes: 051ae5aa73d7 ("iommufd: Lock all IOAS objects")
Cc: stable@vger.kernel.org
Assisted-by: Qoder:Qwen-3.8-MAX-Preview
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/ioas.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iommu/iommufd/ioas.c
+++ b/drivers/iommu/iommufd/ioas.c
@@ -427,6 +427,8 @@ static int iommufd_take_all_iova_rwsem(s
 
 		rc = xa_err(xa_store(ioas_list, index, ioas, GFP_KERNEL));
 		if (rc) {
+			up_write(&ioas->iopt.iova_rwsem);
+			refcount_dec(&ioas->obj.users);
 			iommufd_release_all_iova_rwsem(ictx, ioas_list);
 			return rc;
 		}


