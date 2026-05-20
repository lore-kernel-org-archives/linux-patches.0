Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A093EF0D7;
	Wed, 20 May 2026 17:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297305; cv=none; b=Y/6Gej652CoiV7wILlKMN+WnO8/sJFhozZsB6oIqzlzMlv/Qhd6tfsdATgYlU8kF/N6HqMA8BD84rsvpFv9VExNMT1G9uyltYR0Vp9XZnnNOqHNIXZ45IVJmKu82vbIXubrUEdrUyUU69lW9mTkTZS1NrabYlAGiLHdxeep3NMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297305; c=relaxed/simple;
	bh=4O30pmPPLYn84alshYSnU7Ad9CPgEHZC391sffbukhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lvrzSqax4qbLe4xDqXPZBYXxHUmkjkeDEVHOUFkbm376R5qMfvt2f3ENJUnMV0QnWAD2Y7bPh4swuHTXGdvJzA3J+AnVxdhF3Tzpb0JbdXaZrSudGmzhB2/sZA4iVF+wMuNZoZb/Of78PJPRWoMy5ISOnesaA7H3DQjfnXZo5kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TWwP5IPo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TWwP5IPo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC451F00893;
	Wed, 20 May 2026 17:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297304;
	bh=7hwb/SeGtPZ7z8xBRQYYTHiV6THWJvlxFp+IuWrHDDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TWwP5IPoaCBKfjffIbDRAj1yTs5WuJrG0G9Uk6t1fl/lQTFRazhZYPiTAPfTI7bH4
	 K2Bi0RIDOqiqyvLVJKsgk+snosvVXmZEnV5e2gzITtbgWkgLYnXrZ+pwqOk5Ex3Cth
	 hY7hlDKzNc+kh6GcxFbpe7n8dCVWIeHOmu0cwxrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 7.0 1127/1146] iommu: Fix ATS invalidation timeouts during __iommu_remove_group_pasid()
Date: Wed, 20 May 2026 18:22:57 +0200
Message-ID: <20260520162213.750845117@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <nicolinc@nvidia.com>

commit fc3523b16d2b4b88e61e69504b0ae0b18b869c8f upstream.

If a device is blocked, its PASID domains are already detached. Repeating
iommu_remove_dev_pasid() is unnecessary and might trigger ATS invalidation
timeouts.

Skip the iommu_remove_dev_pasid() call upon gdev->blocked.

Fixes: c279e83953d9 ("iommu: Introduce pci_dev_reset_iommu_prepare/done()")
Cc: stable@vger.kernel.org
Closes: https://sashiko.dev/#/patchset/20260407194644.171304-1-nicolinc%40nvidia.com
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommu.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3572,7 +3572,12 @@ static void __iommu_remove_group_pasid(s
 	struct group_device *device;
 
 	for_each_group_device(group, device) {
-		if (device->dev->iommu->max_pasids > 0)
+		/*
+		 * A group-level detach cannot fail, even if there is a blocked
+		 * device. In fact, blocked devices must be already detached for
+		 * a pending device recovery.
+		 */
+		if (!device->blocked && device->dev->iommu->max_pasids > 0)
 			iommu_remove_dev_pasid(device->dev, pasid, domain);
 	}
 }


