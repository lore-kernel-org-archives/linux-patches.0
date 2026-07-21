Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F52314D34;
	Tue, 21 Jul 2026 17:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653434; cv=none; b=GOrRKZuYlUGxy0mGQtPt5J1E/nT3x9EUz1z5MZqtQ4c4U1R8GZFdMs5F2WS9wqqCEs9OXj02svd82zr5PGyIHEAsfQP3iHtq6fGElwragvJ8jt/P/zArQ179KDJqbkVUb/RitHtkQPfE3YPeaazaKpeqKnWT0rnrjXS+fCRO0L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653434; c=relaxed/simple;
	bh=zDuiFPfQyx6X5f5f+WsUaIYOM4R7K2ipVIIRaTxVDmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wcttb8x8qgbATyQHnUj9Df531wrn8/7gcE6EVO5KLDgqbIP/9FzJgwsxC6J7lXvmu6Z5Rye/BCJIvBAKLQuOM5FhuJspNxeB+okqGT60YKRPtZ6jNA9hSdyWPYxWdJl8L8Z5sFCpEw4e7tZCC8cCsj3ltW1JuOx3pu9kDWtMFTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PKMS3wYD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PKMS3wYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B59C1F000E9;
	Tue, 21 Jul 2026 17:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653433;
	bh=fegmoOBUFx6T31LCIby6Mn11HUF6Q5Bow/xsIfjHIX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PKMS3wYDkAHZ34oPjK6w0QftyGfIFpbFODtF/FcCCQHkGTLI8typP+pOO5WS8ujnh
	 TIwSsvTl+JQ+2Wt/XeKwnlD8BE80jE+I6zH3t57s+mhfmCeTrzJYPTGy35VXO6nnwP
	 P9bJBraJq9OCknsErGWkrZvaPCYInyuxVmlVQduU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1324/2077] accel/amdxdna: Fix iommu domain lifetime race during device removal
Date: Tue, 21 Jul 2026 17:16:37 +0200
Message-ID: <20260721152624.044843260@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit b4a0500fdf6e61a6c5f92ff2e61bc91578075803 ]

When force_iova mode is enabled, amdxdna_remove() frees xdna->domain. If
amdxdna_gem_obj_free() is called after device removal, it may attempt to
access xdna->domain, resulting in a use-after-free.

Fix the race by adding freeing xdna->domain as a managed release action,
so its lifetime is managed by DRM and remains valid until all managed
resources are released.

Fixes: ece3e8980907 ("accel/amdxdna: Allow forcing IOVA-based DMA via module parameter")
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260611055150.3070216-3-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_iommu.c | 43 ++++++++++++++++++---------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/accel/amdxdna/amdxdna_iommu.c b/drivers/accel/amdxdna/amdxdna_iommu.c
index 5a9f06183487fd..77443872beb2d9 100644
--- a/drivers/accel/amdxdna/amdxdna_iommu.c
+++ b/drivers/accel/amdxdna/amdxdna_iommu.c
@@ -4,6 +4,7 @@
  */
 
 #include <drm/amdxdna_accel.h>
+#include <drm/drm_managed.h>
 #include <linux/iommu.h>
 #include <linux/iova.h>
 
@@ -136,10 +137,30 @@ void amdxdna_iommu_free(struct amdxdna_dev *xdna, size_t size,
 	free_pages((unsigned long)cpu_addr, get_order(size));
 }
 
+static void amdxdna_cleanup_force_iova(struct drm_device *dev, void *res)
+{
+	struct amdxdna_dev *xdna = to_xdna_dev(dev);
+
+	if (xdna->domain) {
+		iommu_detach_group(xdna->domain, xdna->group);
+		put_iova_domain(&xdna->iovad);
+		iova_cache_put();
+		iommu_domain_free(xdna->domain);
+	}
+
+	iommu_group_put(xdna->group);
+}
+
+void amdxdna_iommu_fini(struct amdxdna_dev *xdna)
+{
+	if (xdna->group && !xdna->domain)
+		iommu_group_put(xdna->group);
+}
+
 int amdxdna_iommu_init(struct amdxdna_dev *xdna)
 {
 	unsigned long order;
-	int ret;
+	int ret = 0;
 
 	xdna->group = iommu_group_get(xdna->ddev.dev);
 	if (!xdna->group || !force_iova)
@@ -165,8 +186,14 @@ int amdxdna_iommu_init(struct amdxdna_dev *xdna)
 	if (ret)
 		goto put_iova;
 
+	ret = drmm_add_action(&xdna->ddev, amdxdna_cleanup_force_iova, NULL);
+	if (ret)
+		goto detach_group;
+
 	return 0;
 
+detach_group:
+	iommu_detach_group(xdna->domain, xdna->group);
 put_iova:
 	put_iova_domain(&xdna->iovad);
 	iova_cache_put();
@@ -174,20 +201,8 @@ int amdxdna_iommu_init(struct amdxdna_dev *xdna)
 	iommu_domain_free(xdna->domain);
 put_group:
 	iommu_group_put(xdna->group);
+	xdna->group = NULL;
 	xdna->domain = NULL;
 
 	return ret;
 }
-
-void amdxdna_iommu_fini(struct amdxdna_dev *xdna)
-{
-	if (xdna->domain) {
-		iommu_detach_group(xdna->domain, xdna->group);
-		put_iova_domain(&xdna->iovad);
-		iova_cache_put();
-		iommu_domain_free(xdna->domain);
-	}
-
-	if (xdna->group)
-		iommu_group_put(xdna->group);
-}
-- 
2.53.0



