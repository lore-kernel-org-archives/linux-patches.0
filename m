Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5751320CB9;
	Mon, 18 Aug 2025 13:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524367; cv=none; b=ugzcd/UFNCDYAd10tDvY2v7PaWBW+lou18E+A5LQjZsFAdkka16nZZvD6xTR3y/gGwxh2TN60JTE5M4I5msSGV6mK4ya2UfzN0HIVoQDOV++1/YxOjqkX96fBWkhqQaXLSWWxbPQ/eC35dy7YIQLLF0ux8NTX7WC4zf9889TMNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524367; c=relaxed/simple;
	bh=XxSwBid5ITdbxea8I4QXROssz7QOWnYFCz+elgMzQCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hSeoSYspdGrQULvUzhEED0DI76YHbU0NiUrHsJ/Mikzn4/iFd9E8wnqIDdT65o4FdxNXmevh5XpuySfTZENmf9RY1uE+3cUBzKG3n4dmTS9WZmlXc3yH4kDlVtJIWa4HIauh48sVAfalZ1d4Bp0wcnZLawnGu/KjvVej5dvtk/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yn3d0pvR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yn3d0pvR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB9AC113D0;
	Mon, 18 Aug 2025 13:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524367;
	bh=XxSwBid5ITdbxea8I4QXROssz7QOWnYFCz+elgMzQCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yn3d0pvRyS92E0v8K7GX2pbGhccnB4eeqvA5yLhNLvGHX5f6c71y6ngGd+26f5XBw
	 W0p6haTbHEDOowhl4fDBQ13i5R0JxCKcAGPoSCDlpx9Nj4ssV0ctVe9wSSmeI1SiR1
	 QW62xguY2Fo8qquCyQnq/nhfWQrRDcpNxtll9SOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Nicolin Chen <nicolinc@nvidia.com>
Subject: [PATCH 6.15 450/515] iommufd: Report unmapped bytes in the error path of iopt_unmap_iova_range
Date: Mon, 18 Aug 2025 14:47:16 +0200
Message-ID: <20250818124515.743379835@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <nicolinc@nvidia.com>

commit b23e09f9997771b4b739c1c694fa832b5fa2de02 upstream.

There are callers that read the unmapped bytes even when rc != 0. Thus, do
not forget to report it in the error path too.

Fixes: 8d40205f6093 ("iommufd: Add kAPI toward external drivers for kernel access")
Link: https://patch.msgid.link/r/e2b61303bbc008ba1a4e2d7c2a2894749b59fdac.1752126748.git.nicolinc@nvidia.com
Cc: stable@vger.kernel.org
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/io_pagetable.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -743,8 +743,10 @@ again:
 			iommufd_access_notify_unmap(iopt, area_first, length);
 			/* Something is not responding to unmap requests. */
 			tries++;
-			if (WARN_ON(tries > 100))
-				return -EDEADLOCK;
+			if (WARN_ON(tries > 100)) {
+				rc = -EDEADLOCK;
+				goto out_unmapped;
+			}
 			goto again;
 		}
 
@@ -766,6 +768,7 @@ again:
 out_unlock_iova:
 	up_write(&iopt->iova_rwsem);
 	up_read(&iopt->domains_rwsem);
+out_unmapped:
 	if (unmapped)
 		*unmapped = unmapped_bytes;
 	return rc;


