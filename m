Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C365622A4EE;
	Tue, 26 Aug 2025 13:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213417; cv=none; b=hNUnP6A1WKRgaYlSpnsYktEWfyYUSbUxTld5VbLmbgkRYJXYmNNNOM0HYR/QautKE8AC+yf8HNyoAH0FPjGs8Be0t+tiVlHaHdwHDjfBlz/ZEhlIKDA2mjHHjsdAQf+DrMsP6ONX20f+Bot+3JWZ30F76bXDmXA7pk+DvAsqaZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213417; c=relaxed/simple;
	bh=l4TUW+psjTj0eF0TNpAvOkOFgbhLDLPeIBrbnNIFW4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZUvMPudTeepakC7zb6XlVkH4j2cKrURJDle3Ru1AJtMyvO1iYu8u96+G100TeSfDJyaMc12yNE8o2vX73c9TqBaxzf/Ca8Mo7a6yfl3GQcaiSTXVsae3RamL1mVEWYW0eiEXE70yRG7JDJaZVevibt5KjjKF/AwRPqvnvyUeclE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VqdezQ8o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VqdezQ8o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6BAC113CF;
	Tue, 26 Aug 2025 13:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213417;
	bh=l4TUW+psjTj0eF0TNpAvOkOFgbhLDLPeIBrbnNIFW4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VqdezQ8obRKlxEVgY2nonD03awm0J31hToqTOAI+3X5s9kST3j+4SenAOdcAHfH8W
	 YYIPn5cDEZmye2fP/w2IKb+9nMjYQK3w+SEUJsgc6yaQcK3rzFeTe1eyiXy8NGmSl1
	 nXHnkDiQQjlW85SDxFVRIUufLLlb7PLHddjjBGTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Nicolin Chen <nicolinc@nvidia.com>
Subject: [PATCH 6.6 299/587] iommufd: Report unmapped bytes in the error path of iopt_unmap_iova_range
Date: Tue, 26 Aug 2025 13:07:28 +0200
Message-ID: <20250826111000.532577997@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -524,8 +524,10 @@ again:
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
 
@@ -547,6 +549,7 @@ again:
 out_unlock_iova:
 	up_write(&iopt->iova_rwsem);
 	up_read(&iopt->domains_rwsem);
+out_unmapped:
 	if (unmapped)
 		*unmapped = unmapped_bytes;
 	return rc;


