Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F4917A5B8;
	Wed,  3 Jul 2024 11:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004584; cv=none; b=gC7+tEeN1roRRgRqV3iRgpJOy2j/FsrvbbsQKJusnc8vCds73eny/KrfC/Hc8ItUola1enX6OGzUrf22hwDiOGkbY7JJ+nXBsxRk2mqP/Ne1N7imZ+Fzi5MbDoiFcSLlZ9U7nDn/VYoJBCb/Okr8+aCSPmHCFRdX44tAZMFg75Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004584; c=relaxed/simple;
	bh=t52r9H2WzYht3PjbzMBYehvxgOtuvHZ9OR8F0T+jpn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FASPEpvpcqBUhpMoVL8Mx8D9JyaqUedAEmrIf8vc/0HrfhRDQrY1NOhia0Z0gXkO3c7d4clcQ6Xwl3O/BYSUgPawav23rM4PWwnMBWdb5hm4wBqf3uHiDqg0t0QsfK1gSUYa98nh8IjIt4y4XUhEKQ4R4cw1AG3i+cQaA7FQIDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fW/Hb4PO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fW/Hb4PO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB8AC2BD10;
	Wed,  3 Jul 2024 11:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004584;
	bh=t52r9H2WzYht3PjbzMBYehvxgOtuvHZ9OR8F0T+jpn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fW/Hb4POSj5++Y+yMp+0IkQKOFQ9oe23TAGtemQBTN+Nm7J9LiVWmRY6UoEepwJr9
	 TUigTuX5E3E66qakP+nf9skz7AnAMU8as3+uwV2xDWKxjO6/+nGT06jwo7hh6t1Agm
	 wmteVr0B0zJivLK11pRq5lQYeZ+Ry/2SdCAePAdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 059/290] iommu: Return right value in iommu_sva_bind_device()
Date: Wed,  3 Jul 2024 12:37:20 +0200
Message-ID: <20240703102906.429559027@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 89e8a2366e3bce584b6c01549d5019c5cda1205e ]

iommu_sva_bind_device() should return either a sva bond handle or an
ERR_PTR value in error cases. Existing drivers (idxd and uacce) only
check the return value with IS_ERR(). This could potentially lead to
a kernel NULL pointer dereference issue if the function returns NULL
instead of an error pointer.

In reality, this doesn't cause any problems because iommu_sva_bind_device()
only returns NULL when the kernel is not configured with CONFIG_IOMMU_SVA.
In this case, iommu_dev_enable_feature(dev, IOMMU_DEV_FEAT_SVA) will
return an error, and the device drivers won't call iommu_sva_bind_device()
at all.

Fixes: 26b25a2b98e4 ("iommu: Bind process address spaces to devices")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Link: https://lore.kernel.org/r/20240528042528.71396-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/iommu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index e90c267e7f3e1..2698dd231298c 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -1026,7 +1026,7 @@ iommu_aux_get_pasid(struct iommu_domain *domain, struct device *dev)
 static inline struct iommu_sva *
 iommu_sva_bind_device(struct device *dev, struct mm_struct *mm, void *drvdata)
 {
-	return NULL;
+	return ERR_PTR(-ENODEV);
 }
 
 static inline void iommu_sva_unbind_device(struct iommu_sva *handle)
-- 
2.43.0



