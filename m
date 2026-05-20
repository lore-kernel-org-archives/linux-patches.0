Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35EF3ED3A4;
	Wed, 20 May 2026 17:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298047; cv=none; b=RBrobC2A1919aWZxuXXUq95v+DEhzX3azfH99scKNm+BoeMJS2zTFfbdUSkKPYPPk3khHOgqjtJmToaaXx5M9IX/29EvbAok6TEOBzTEMpSbC41lF/KNlwVGdKXUOBC5MPvUATkl+AqLlfFbTkUr+d5dAg0BKnopb9+AuxpfbHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298047; c=relaxed/simple;
	bh=wnZabdvochLpEEylh2kaYg5LYpeRttV+J5KsoEkw9Y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DOW8f2M6f/0xemtEu4liQhtTJrBcpXkCsJYhWN+ZRf1OpfxfyPmIptwanA1ve+I0OedTEEBV6esRq51IwYINOejGzgN4hH03nxcToaYr36YbxHAg2RXDJ1vNwnbCWUcYpGwxfG/cJpIiZKAtkNJtWYJuKFczHLmJc7jF5FYH7Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CmkHl1JO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CmkHl1JO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13AEC1F000E9;
	Wed, 20 May 2026 17:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298046;
	bh=IaCc80rP23ntapLtlh1iDRY53GzEu+Ltk2FMVl1Nlsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CmkHl1JO7s6XZ4hDuMSCesYPbVCyEwf1RXjE+J2LRNZ7q1f0isKfHj1m7W3pZtpwv
	 gsEa2W7hdTvM6tm8rpoO+Vn63Vu4qRaavEevQP4qFQpNQRZVkcUTiDmE1fJpU/ijOl
	 lDi8ndLm0w075Sn2BrwfA8qlc9dk0buUgTU/opio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iago Toral Quiroga <itoral@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 220/957] drm/v3d: Handle error from drm_sched_entity_init()
Date: Wed, 20 May 2026 18:11:43 +0200
Message-ID: <20260520162139.313542913@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit 8cf1bec37b27846ad3169744c9f1a89a06dcb3fa ]

drm_sched_entity_init() can fail but its return value is currently being
ignored in v3d_open(). Check the return value and properly unwind
on failure by destroying any already-initialized scheduler entities.

Fixes: 57692c94dcbe ("drm/v3d: Introduce a new DRM driver for Broadcom V3D V3.x+")
Reviewed-by: Iago Toral Quiroga <itoral@igalia.com>
Link: https://patch.msgid.link/20260306-v3d-reset-locking-improv-v3-1-49864fe00692@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/v3d/v3d_drv.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/v3d/v3d_drv.c b/drivers/gpu/drm/v3d/v3d_drv.c
index f4da7a94e4016..7bbb2256ce7dc 100644
--- a/drivers/gpu/drm/v3d/v3d_drv.c
+++ b/drivers/gpu/drm/v3d/v3d_drv.c
@@ -130,7 +130,7 @@ v3d_open(struct drm_device *dev, struct drm_file *file)
 	struct v3d_dev *v3d = to_v3d_dev(dev);
 	struct v3d_file_priv *v3d_priv;
 	struct drm_gpu_scheduler *sched;
-	int i;
+	int i, ret;
 
 	v3d_priv = kzalloc(sizeof(*v3d_priv), GFP_KERNEL);
 	if (!v3d_priv)
@@ -140,9 +140,11 @@ v3d_open(struct drm_device *dev, struct drm_file *file)
 
 	for (i = 0; i < V3D_MAX_QUEUES; i++) {
 		sched = &v3d->queue[i].sched;
-		drm_sched_entity_init(&v3d_priv->sched_entity[i],
-				      DRM_SCHED_PRIORITY_NORMAL, &sched,
-				      1, NULL);
+		ret = drm_sched_entity_init(&v3d_priv->sched_entity[i],
+					    DRM_SCHED_PRIORITY_NORMAL, &sched,
+					    1, NULL);
+		if (ret)
+			goto err_sched;
 
 		memset(&v3d_priv->stats[i], 0, sizeof(v3d_priv->stats[i]));
 		seqcount_init(&v3d_priv->stats[i].lock);
@@ -152,6 +154,12 @@ v3d_open(struct drm_device *dev, struct drm_file *file)
 	file->driver_priv = v3d_priv;
 
 	return 0;
+
+err_sched:
+	for (i--; i >= 0; i--)
+		drm_sched_entity_destroy(&v3d_priv->sched_entity[i]);
+	kfree(v3d_priv);
+	return ret;
 }
 
 static void
-- 
2.53.0



