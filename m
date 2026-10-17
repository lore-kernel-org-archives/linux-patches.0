Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9EE36B93B;
	Sat, 17 Oct 2026 16:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254072; cv=none; b=Uxf0H521XCgrEp/R94WbdSU6RUMlGt/ZRcPrpew0nQ1eC+z0Ea2MUoDy1iiJVIzmiOpCIGX4FThfGYk7IMerJKO6yOL1IfcWavirYO1DoTEshBUE9jlU6d4JOekWuPNPlgOUBukrmbkTMSKcPVbSef8nYuvX8N6s4i3tc8W/fgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254072; c=relaxed/simple;
	bh=0ShyCY5riUl41YXFQhQSGXEEDK5xezOjE0UgHSsTi9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MHRQNPHA6D0S9TohWkuxOoJV6KuZCPNxpmUBUQVp11DwDHEcrAdSiRtbgEm1U7UlIsOsbqOBnUdl+dgdQ9458KQ3WQYiFtRmi1e4NFtnhwGu+lFTO3/6B1Y6dhPhcyeAUiCLfc4TxblEW3fu0MZpliKgyAStwhf9BoSbh1rIjuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UiWrG//h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UiWrG//h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B671F000C4;
	Sat, 17 Oct 2026 16:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254071;
	bh=CX3lQ1yqP5093Xs/obcg7KYLOY0keHqr1ZqwBrOKU7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UiWrG//hASGXVIrAXqruEdJDLcHGYYGUys/QcLWodZfxnUvBKyvZkRmYA/luImF6K
	 0Zln8zfuTYW0b5WNH9jsP8OnHzqp1YBRjRnGewupTdndbcEN7vYT3WxV06RTT/SOao
	 bB3ZIzsOhoGLrmyQrd+0HGyFIsLDAmldWl24Jxig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Zhenzhong Duan <zhenzhong.duan@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 325/869] iommu/vt-d: Avoid NULL pointer dereference or refcount corruption
Date: Sat, 17 Oct 2026 17:52:46 +0200
Message-ID: <20261017160045.409874604@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhenzhong Duan <zhenzhong.duan@intel.com>

[ Upstream commit 79ea2feb917b05366b49d85573c9c5331f043b2c ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 39742525e1a89..9da974068b828 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4339,9 +4339,9 @@ static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
 	}
 	spin_unlock_irqrestore(&dmar_domain->lock, flags);
 
-	cache_tag_unassign_domain(dmar_domain, dev, pasid);
-	domain_detach_iommu(dmar_domain, iommu);
 	if (!WARN_ON_ONCE(!dev_pasid)) {
+		cache_tag_unassign_domain(dmar_domain, dev, pasid);
+		domain_detach_iommu(dmar_domain, iommu);
 		intel_iommu_debugfs_remove_dev_pasid(dev_pasid);
 		kfree(dev_pasid);
 	}
-- 
2.53.0



