Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D641DE3D6;
	Wed, 19 Feb 2025 08:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954455; cv=none; b=s3ybuAj7pDfhXVK0FqiVPN0AnRyhbEDd+snc+BaEurPgnoihMbjyOs01F8eLkcs93t/aXgWfRnIC53oR4LI2AKDmNiliT51r2+Maow5hDDO8Uswiz3pU05N7Bk2kCyBJZ++Z4IXtCxChsfCwjvXizPD+zX6Wswd98Sot3UPOvco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954455; c=relaxed/simple;
	bh=U28+zILs9PfA0GvfG1DVbQr95Ra8qlDrLbhW9S+8AK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aTP7ZBZHGT5S+EhG35OCA2tfpHd+j7V/vwEr1i6DRLcgrmWz7rcWvzNnoodN2nKUud2cLAgWH199ChCfuuGxVvru6vZojJTTvokP8wWQOn1Z40paRbFh8jWcDm0VhpikkMdzgfS3Z/7kyWKHeKJhurSsvnpBZ9kIKqyZmiyzwKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y0rTzl8t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y0rTzl8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE6BEC4CEE7;
	Wed, 19 Feb 2025 08:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954455;
	bh=U28+zILs9PfA0GvfG1DVbQr95Ra8qlDrLbhW9S+8AK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y0rTzl8ttGGCF+Tpv1P7JGG/boyMICkBZdtTSgJ3QTMDsHmcWfOakC9gVXKOlslRa
	 8G3V4PA9/CxODfceYJUdF6gxoTYhNE0ZB8VaiSYSHn+Ml2J9HKxbZljOuC3cgOq3nU
	 dVOPT1R1Mq+4qWBHxsv5EwLNsnRsvPD1REbViprI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 6.13 179/274] iommu: Fix potential memory leak in iopf_queue_remove_device()
Date: Wed, 19 Feb 2025 09:27:13 +0100
Message-ID: <20250219082616.592749091@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

commit 9759ae2cee7cd42b95f1c48aa3749bd02b5ddb08 upstream.

The iopf_queue_remove_device() helper removes a device from the per-iommu
iopf queue when PRI is disabled on the device. It responds to all
outstanding iopf's with an IOMMU_PAGE_RESP_INVALID code and detaches the
device from the queue.

However, it fails to release the group structure that represents a group
of iopf's awaiting for a response after responding to the hardware. This
can cause a memory leak if iopf_queue_remove_device() is called with
pending iopf's.

Fix it by calling iopf_free_group() after the iopf group is responded.

Fixes: 199112327135 ("iommu: Track iopf group instead of last fault")
Cc: stable@vger.kernel.org
Suggested-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20250117055800.782462-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/io-pgfault.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iommu/io-pgfault.c
+++ b/drivers/iommu/io-pgfault.c
@@ -478,6 +478,7 @@ void iopf_queue_remove_device(struct iop
 
 		ops->page_response(dev, iopf, &resp);
 		list_del_init(&group->pending_node);
+		iopf_free_group(group);
 	}
 	mutex_unlock(&fault_param->lock);
 


