Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6163375CD;
	Mon, 18 Aug 2025 14:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526250; cv=none; b=L0t7xp8PqqMsSMrurtdHQg86IjuM5jc9lrTR4GcmOz96zG/B6MlOzi+TtE6nH94uuC3Ykzl1y+rTQrQoWRp1n3yMQ6iHq6Pj4OuiPbIwPA/fjHwzyS53ZJfOvKyP5LaTZ7YMwBh53qNpo7vflHfgMmWeQox/EcMRlFThJKbclPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526250; c=relaxed/simple;
	bh=IGucrGU/t6NpTWlW/nnAEGIO3z9tGbFaLiL9i21uvJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hEnIhwhG2+ZLA2KZ8Fn57QqQn9sF25Ik+0A8GG1kO6EAQaaz//bFGSCrmkbhMMvN0qTwJ/yETxrJ37eF2TmY5AcrtQw9uoZy1A81oXSTf6ofSyo1tAsZDA0FNlsrtJxKKRje3ltnzZdAqq+I0idwevhAbDKeHMKE0Y5ooh3sfC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VkvDdZmB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VkvDdZmB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94960C4CEEB;
	Mon, 18 Aug 2025 14:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526250;
	bh=IGucrGU/t6NpTWlW/nnAEGIO3z9tGbFaLiL9i21uvJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VkvDdZmBGzsSqWx02l54aqRpK0mECKF8ZP8rDOuJqEKr/PqKykX3VMNjM/90p7OLN
	 MC6WLo3cd/CGwh5bv7UFQyu+AU8MQ69+APxdkCYLcy5bYYXzrhSxa5698E4KX04wEf
	 bIuGyp45Nos2zVuiMic9rRYTCXeJqSV7r+/peg1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Nicolin Chen <nicolinc@nvidia.com>
Subject: [PATCH 6.16 500/570] iommufd: Report unmapped bytes in the error path of iopt_unmap_iova_range
Date: Mon, 18 Aug 2025 14:48:07 +0200
Message-ID: <20250818124525.123360734@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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


