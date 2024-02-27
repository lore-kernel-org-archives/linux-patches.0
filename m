Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0CF13B7AE;
	Tue, 27 Feb 2024 13:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041309; cv=none; b=h0IzCJc3+S2bftftoxQ9lRSmsxUdDeWNK9olwUw71JI3ZJOSW2UCcjhVnPO1pDDj/ilpxBuxNqXvT1gGQbm4cFM2rSGb3TYRpAcxqZqr03joDCLT6o2Hj1+3g078+yMOuc9UfZIlUwkUQPN6tEspItrNEY40vm1nqV1XixeEVbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041309; c=relaxed/simple;
	bh=iEUnRVid7J/H97FXF+H18GhI/QRYJBi5Js4ZZxw+urY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q680/FDP3JAUpW3NtYynl7xmhbgf2mlQ5K+5JWRqk7aJCThet9jdasgt7d9Ss/smSwUc4Cw+Pt3yICbRtvCUcLk1rVDgwePnjkXr+FtRgmtCt/q8vqIJZNfSd3OSUbaiUIb1u+wrRB5Rn1G3av/i9xJYigJcFYV7B2AQjfiCDNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g+sBjCuZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g+sBjCuZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D2D9C433F1;
	Tue, 27 Feb 2024 13:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041308;
	bh=iEUnRVid7J/H97FXF+H18GhI/QRYJBi5Js4ZZxw+urY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g+sBjCuZHu1kRtNuaHl9ZeajoxuOIo1cg8DZ+HzNUlhLqpeAYoCTOxzGuBEYnKTiD
	 EQhA8jwuNBf02hDNIGPnFvniGJv6NVvz0dHo4OfgeFC6rIprjflD5oSmlPhrOW7jUk
	 YmxuCISMzoPWCRdTHp86GrgTCe7Vlf6tgEVtfyf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Sun <yi.y.sun@linux.intel.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 293/334] iommu/vt-d: Add missing dirty tracking set for parent domain
Date: Tue, 27 Feb 2024 14:22:31 +0100
Message-ID: <20240227131640.487238790@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Liu <yi.l.liu@intel.com>

[ Upstream commit f1e1610950eac0af5e40f6ee02315952f78192f7 ]

Setting dirty tracking for a s2 domain requires to loop all the related
devices and set the dirty tracking enable bit in the PASID table entry.
This includes the devices that are attached to the nested domains of a
s2 domain if this s2 domain is used as parent. However, the existing dirty
tracking set only loops s2 domain's own devices. It will miss dirty page
logs in the parent domain.

Now, the parent domain tracks the nested domains, so it can loop the
nested domains and the devices attached to the nested domains to ensure
dirty tracking on the parent is set completely.

Fixes: b41e38e22539 ("iommu/vt-d: Add nested domain allocation")
Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20240208082307.15759-9-yi.l.liu@intel.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index e3b3ab506b185..a8366b1f4f48b 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4884,6 +4884,35 @@ static int device_set_dirty_tracking(struct list_head *devices, bool enable)
 	return ret;
 }
 
+static int parent_domain_set_dirty_tracking(struct dmar_domain *domain,
+					    bool enable)
+{
+	struct dmar_domain *s1_domain;
+	unsigned long flags;
+	int ret;
+
+	spin_lock(&domain->s1_lock);
+	list_for_each_entry(s1_domain, &domain->s1_domains, s2_link) {
+		spin_lock_irqsave(&s1_domain->lock, flags);
+		ret = device_set_dirty_tracking(&s1_domain->devices, enable);
+		spin_unlock_irqrestore(&s1_domain->lock, flags);
+		if (ret)
+			goto err_unwind;
+	}
+	spin_unlock(&domain->s1_lock);
+	return 0;
+
+err_unwind:
+	list_for_each_entry(s1_domain, &domain->s1_domains, s2_link) {
+		spin_lock_irqsave(&s1_domain->lock, flags);
+		device_set_dirty_tracking(&s1_domain->devices,
+					  domain->dirty_tracking);
+		spin_unlock_irqrestore(&s1_domain->lock, flags);
+	}
+	spin_unlock(&domain->s1_lock);
+	return ret;
+}
+
 static int intel_iommu_set_dirty_tracking(struct iommu_domain *domain,
 					  bool enable)
 {
@@ -4898,6 +4927,12 @@ static int intel_iommu_set_dirty_tracking(struct iommu_domain *domain,
 	if (ret)
 		goto err_unwind;
 
+	if (dmar_domain->nested_parent) {
+		ret = parent_domain_set_dirty_tracking(dmar_domain, enable);
+		if (ret)
+			goto err_unwind;
+	}
+
 	dmar_domain->dirty_tracking = enable;
 out_unlock:
 	spin_unlock(&dmar_domain->lock);
-- 
2.43.0



