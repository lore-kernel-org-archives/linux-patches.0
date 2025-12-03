Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3811F35BDAE;
	Wed,  3 Dec 2025 16:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780098; cv=none; b=io12KwVuTYAo6935yRwPve9kHsxACPbX2ZoZMY2OGih7Zherf3tiQxIBGqjh2pXTwzwxMtXKWin2ic0td7T9paa2EjAr27D+p0E5suhi+cpnGfLqqUusoR06mj7o1Fsnmlg8QtSJ0l11lkimr0zKWdl2bH7LjtmLtRTo8uW9XC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780098; c=relaxed/simple;
	bh=TVMkVp8KpmB0/cHqmagBpNde7+Dg3C6ZTFsjx6c2wuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3dla33Q127Vwak9iu5yrPh5UhmT4ZU6eNUDO+2v0YAaY0eu10Prbajtotok+s6cwtJ0HD7M4uqy1Ti5Ey5JFOv5X1DMHsh48RSXYeHJWb5yuf/6kRWyeJxGWwVBPbYP4ln+YiWNyicGrK0sO6y9p2xRIcBfz0ltGPlpwnKaFWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a3kZ+DzS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a3kZ+DzS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D1A0C4CEF5;
	Wed,  3 Dec 2025 16:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780097;
	bh=TVMkVp8KpmB0/cHqmagBpNde7+Dg3C6ZTFsjx6c2wuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a3kZ+DzSNGZy3RaF9gwFZJPrKKOq2G8oXvXYpzsGi17RmOKZ2/iLIy8dCI32ksRBA
	 NCJgjf3+9n1fPti46Z4FyO/PpeHMzgKrzIXrbmGjntEBY2b2iaJ/rxTJKuxuHwwezZ
	 ipT7m6NE2HvhfD0uYXF7lywgDai8jnQ7FUTvyicc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 453/568] gpu: host1x: Select context device based on attached IOMMU
Date: Wed,  3 Dec 2025 16:27:35 +0100
Message-ID: <20251203152457.296686010@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit 8935002fc37fce1ad211d98a70f2fd42083c0594 ]

On Tegra234, engines that are programmed through Host1x channels can
be attached to either the NISO0 or NISO1 SMMU. Because of that, when
selecting a context device to use with an engine, we need to select
one that is also attached to the same SMMU.

Add a parameter to host1x_memory_context_alloc to specify which device
we are allocating a context for, and use it to pick an appropriate
context device.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
[treding@nvidia.com: update !IOMMU_API stub signature]
Signed-off-by: Thierry Reding <treding@nvidia.com>
Stable-dep-of: 6cbab9f0da72 ("drm/tegra: Add call to put_pid()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/uapi.c | 2 +-
 drivers/gpu/host1x/context.c | 4 ++++
 include/linux/host1x.h       | 2 ++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tegra/uapi.c b/drivers/gpu/drm/tegra/uapi.c
index a98239cb0e29a..5adab6b229164 100644
--- a/drivers/gpu/drm/tegra/uapi.c
+++ b/drivers/gpu/drm/tegra/uapi.c
@@ -116,7 +116,7 @@ int tegra_drm_ioctl_channel_open(struct drm_device *drm, void *data, struct drm_
 
 		if (supported)
 			context->memory_context = host1x_memory_context_alloc(
-				host, get_task_pid(current, PIDTYPE_TGID));
+				host, client->base.dev, get_task_pid(current, PIDTYPE_TGID));
 
 		if (IS_ERR(context->memory_context)) {
 			if (PTR_ERR(context->memory_context) != -EOPNOTSUPP) {
diff --git a/drivers/gpu/host1x/context.c b/drivers/gpu/host1x/context.c
index 93c0c532fe5af..9c0db178fade9 100644
--- a/drivers/gpu/host1x/context.c
+++ b/drivers/gpu/host1x/context.c
@@ -112,6 +112,7 @@ void host1x_memory_context_list_free(struct host1x_memory_context_list *cdl)
 }
 
 struct host1x_memory_context *host1x_memory_context_alloc(struct host1x *host1x,
+							  struct device *dev,
 							  struct pid *pid)
 {
 	struct host1x_memory_context_list *cdl = &host1x->context_list;
@@ -126,6 +127,9 @@ struct host1x_memory_context *host1x_memory_context_alloc(struct host1x *host1x,
 	for (i = 0; i < cdl->len; i++) {
 		struct host1x_memory_context *cd = &cdl->devs[i];
 
+		if (cd->dev.iommu->iommu_dev != dev->iommu->iommu_dev)
+			continue;
+
 		if (cd->owner == pid) {
 			refcount_inc(&cd->ref);
 			mutex_unlock(&cdl->lock);
diff --git a/include/linux/host1x.h b/include/linux/host1x.h
index cb2100d9b0ffe..dc55d9d3b94f0 100644
--- a/include/linux/host1x.h
+++ b/include/linux/host1x.h
@@ -469,11 +469,13 @@ struct host1x_memory_context {
 
 #ifdef CONFIG_IOMMU_API
 struct host1x_memory_context *host1x_memory_context_alloc(struct host1x *host1x,
+							  struct device *dev,
 							  struct pid *pid);
 void host1x_memory_context_get(struct host1x_memory_context *cd);
 void host1x_memory_context_put(struct host1x_memory_context *cd);
 #else
 static inline struct host1x_memory_context *host1x_memory_context_alloc(struct host1x *host1x,
+									struct device *dev,
 									struct pid *pid)
 {
 	return NULL;
-- 
2.51.0



