Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86DC03FE36C;
	Wed, 20 May 2026 17:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299926; cv=none; b=SQyxqvBBWcWqgd6DItSe50tsbM/MWVvQJa25+sO7Nm5bhRaDOuc7R59jP7qmrFyAXAn6slauy2/1DjbygjXRL7URXXmaS6eBKMeXEgK1jhlW0KsY68dvlO9bdakZGTUKLhiPaZCW4pJC8anRo3+nCcyhM/E/K4dEI0eWFoXr4Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299926; c=relaxed/simple;
	bh=dnOoFixhGd22cAx795Nld9mzIIAtv0m7mFg2QXVwtSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NDjDO3AnPBugSbtV+qFRwLPYZ+r6UfKiw0UyZWURKFiwAMskFIdItiXy9LAlBY4W9CvsVfx60DY1tiIfwrgixyH9+BYf6KRJ9PyRL37g1naupvKgMhXx8OTKV00PXrnr1/cXsLUtPqbTXxK40dHbRExV1lOkb7Y3K+aKDNUBADI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fuvh3d/q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fuvh3d/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E41CD1F00893;
	Wed, 20 May 2026 17:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299923;
	bh=ZWLG0Pa8tySJzrdhtbf34rYosEouEQkdlKjZVoJUQj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fuvh3d/qf/+6Vt2tzcwS+lufE4HOB453tPOfIgxxAfonFxzwxAoJT8RvcE8Rayztl
	 jEY8lJm+G3rUenKHwHr+qM/lS6tuHdz9skFI1eETANc0rXgd9Y3/QQhL2zf9o/7QGK
	 39g166lCsneViOsTRHjGPum6GB+wRyG5hHxUHdDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Zhenzhong Duan <zhenzhong.duan@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.18 939/957] iommu/vt-d: Avoid NULL pointer dereference or refcount corruption
Date: Wed, 20 May 2026 18:23:42 +0200
Message-ID: <20260520162154.961152981@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Zhenzhong Duan <zhenzhong.duan@intel.com>

commit 79ea2feb917b05366b49d85573c9c5331f043b2c upstream.

Commit 60f030f7418d ("iommu/vt-d: Avoid use of NULL after WARN_ON_ONCE")
fixed a NULL pointer dereference in an unlikely situation partly.

If dev_pasid is not found in the dev_pasids list, it remains NULL.
However, the teardown operations are executed unconditionally, this lead
to a NULL pointer dereference or refcount corruption.

If the domain was never attached to this IOMMU, info will be NULL, which
would cause an immediate dereference when checking --info->refcnt.

Even if info is not NULL, decrementing the refcount without having removed
a valid PASID might unbalance the count. This could lead to premature
dropping of the refcount to 0, potentially causing a use-after-free for the
remaining active devices sharing the domain.

Fix it by returning early if dev_pasid is NULL, before executing the
teardown operations.

Issue found by AI review and suggested by Kevin Tian.
https://sashiko.dev/#/patchset/20260421031347.1408890-1-zhenzhong.duan%40intel.com

Fixes: 60f030f7418d ("iommu/vt-d: Avoid use of NULL after WARN_ON_ONCE")
Cc: stable@vger.kernel.org
Suggested-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20260422033538.95000-1-zhenzhong.duan@intel.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/iommu.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4083,12 +4083,13 @@ void domain_remove_dev_pasid(struct iomm
 	}
 	spin_unlock_irqrestore(&dmar_domain->lock, flags);
 
+	if (WARN_ON_ONCE(!dev_pasid))
+		return;
+
 	cache_tag_unassign_domain(dmar_domain, dev, pasid);
 	domain_detach_iommu(dmar_domain, iommu);
-	if (!WARN_ON_ONCE(!dev_pasid)) {
-		intel_iommu_debugfs_remove_dev_pasid(dev_pasid);
-		kfree(dev_pasid);
-	}
+	intel_iommu_debugfs_remove_dev_pasid(dev_pasid);
+	kfree(dev_pasid);
 }
 
 static int blocking_domain_set_dev_pasid(struct iommu_domain *domain,


