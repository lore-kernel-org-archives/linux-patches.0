Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52372566;
	Tue, 27 May 2025 17:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367027; cv=none; b=Gag3fm/z0qZ/nhxnfqPyKG9JleBHz899GuwpwzcayxuX088IMFwzDW/I9Fi7DqgTGkEUD1m/PgDAb/XmQp5Ursvk4rECs0VTodoBL2XntYo9XqM/XgCQu7yQ6km8K+8WpUJo7kBrPxUthL7DEpGLUwpZEuwdQAEEfRFTWii5cAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367027; c=relaxed/simple;
	bh=ZByjT47l3bI9TCepItSSzkAj3HSM61uUSmJYB5Onqaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BveYxYJS/W/roFezZIyMB4FIkJZR107ItfQL+GGxtM1HM8cs+V9qanxpXn5hbHV/CzYZEdmgQxFibiYDp5GYWG4R521eBOEljUpkiFor+vQ2idh313BZeUrI2rxrqbGZ+GBpykTxykBTsOgga4dX2mHJb2k5ImcXBLD59wS9vnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GMT0Ke7G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GMT0Ke7G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19409C4CEE9;
	Tue, 27 May 2025 17:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367027;
	bh=ZByjT47l3bI9TCepItSSzkAj3HSM61uUSmJYB5Onqaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GMT0Ke7GPb0c/Wikb22RxDy8YaOjrJOv1jRJJoJQ5ZjquqofNR4qeAjabfFLO1cc2
	 LsXY2+MiMXrDxBjgbmoSmUPU0mkRf+o1qGmuEA3FNlW+5nU7mEuIlOVdxTILtes6mw
	 TiRDW8+2SLlpig1A5A6CC5NqvhRrr2U5pyfa9M9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 214/783] iommu: Keep dev->iommu state consistent
Date: Tue, 27 May 2025 18:20:11 +0200
Message-ID: <20250527162521.845616866@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 3832862eb9c4dfa0e80b2522bfaedbc8a43de97d ]

At the moment, if of_iommu_configure() allocates dev->iommu itself via
iommu_fwspec_init(), then suffers a DT parsing failure, it cleans up the
fwspec but leaves the empty dev_iommu hanging around. So far this is
benign (if a tiny bit wasteful), but we'd like to be able to reason
about dev->iommu having a consistent and unambiguous lifecycle. Thus
make sure that the of_iommu cleanup undoes precisely whatever it did.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/d219663a3f23001f23d520a883ac622d70b4e642.1740753261.git.robin.murphy@arm.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommu-priv.h | 2 ++
 drivers/iommu/iommu.c      | 2 +-
 drivers/iommu/of_iommu.c   | 6 +++++-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommu-priv.h b/drivers/iommu/iommu-priv.h
index de5b54eaa8bf1..a5913c0b02a0a 100644
--- a/drivers/iommu/iommu-priv.h
+++ b/drivers/iommu/iommu-priv.h
@@ -17,6 +17,8 @@ static inline const struct iommu_ops *dev_iommu_ops(struct device *dev)
 	return dev->iommu->iommu_dev->ops;
 }
 
+void dev_iommu_free(struct device *dev);
+
 const struct iommu_ops *iommu_ops_from_fwnode(const struct fwnode_handle *fwnode);
 
 static inline const struct iommu_ops *iommu_fwspec_ops(struct iommu_fwspec *fwspec)
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 1efe7cddb4fe3..3a2804a98203b 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -352,7 +352,7 @@ static struct dev_iommu *dev_iommu_get(struct device *dev)
 	return param;
 }
 
-static void dev_iommu_free(struct device *dev)
+void dev_iommu_free(struct device *dev)
 {
 	struct dev_iommu *param = dev->iommu;
 
diff --git a/drivers/iommu/of_iommu.c b/drivers/iommu/of_iommu.c
index 97987cd78da93..e10a68b5ffde1 100644
--- a/drivers/iommu/of_iommu.c
+++ b/drivers/iommu/of_iommu.c
@@ -116,6 +116,7 @@ static void of_pci_check_device_ats(struct device *dev, struct device_node *np)
 int of_iommu_configure(struct device *dev, struct device_node *master_np,
 		       const u32 *id)
 {
+	bool dev_iommu_present;
 	int err;
 
 	if (!master_np)
@@ -127,6 +128,7 @@ int of_iommu_configure(struct device *dev, struct device_node *master_np,
 		mutex_unlock(&iommu_probe_device_lock);
 		return 0;
 	}
+	dev_iommu_present = dev->iommu;
 
 	/*
 	 * We don't currently walk up the tree looking for a parent IOMMU.
@@ -147,8 +149,10 @@ int of_iommu_configure(struct device *dev, struct device_node *master_np,
 		err = of_iommu_configure_device(master_np, dev, id);
 	}
 
-	if (err)
+	if (err && dev_iommu_present)
 		iommu_fwspec_free(dev);
+	else if (err && dev->iommu)
+		dev_iommu_free(dev);
 	mutex_unlock(&iommu_probe_device_lock);
 
 	if (!err && dev->bus)
-- 
2.39.5



