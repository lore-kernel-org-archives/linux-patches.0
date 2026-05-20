Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8F6372EDE;
	Wed, 20 May 2026 16:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295085; cv=none; b=hJF9brESquOHRD+3fhHBjP8NqJAXkrKZvWCdAOf0fqNkK/wXcnqeD0VhTBTM8ezQqLJApC7slfvfFcBvhrGB6OO3ksKnQIwZdQJa4ywdkK9OndcOv9BzOaBLSqKd91NQ/nPV2pXLGmPBq5t0C4IOLGEPNqRJtoUSagytBHO4dNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295085; c=relaxed/simple;
	bh=rRHYsbhMuXYAxZTdHol3x9qbvvS88JI5REfknus5x0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ehUxw6h5kL8iYH09HTp5ShJhNKxxNsKdqJrM9SLT1Qygs3lbE5NGcj4SGdKslGBPtNR+mGmIIijguoaQDX4cCcY35IlSn4vrvm0eqCSac6dJBkOFW+diW6I9UqnAQTDxZWmF+HP2M8ZEwVPosv6i9yuxNXuk+qBlKIlhaalMqm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XmDpiKbe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XmDpiKbe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B95AF1F000E9;
	Wed, 20 May 2026 16:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295082;
	bh=BM8nP0z+62NVLMjWA32Vo7dGefW6c97iN5OFqw3Qrv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XmDpiKbefF1t3ro0HfKXQYMhK0PBHJ0GMOHGsHDufK/q6MisSH8pQVcyvHyzPK1zT
	 MlwdUnYilf+BbY3EmuJcAkzK+OhHhdIjSjKycjdvj5Ts4cMn8FmenFNlUllwfMdpkF
	 CLOLis5wQbmihHrmqCzbt5WYTrKwURdUXhO7p26k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iago Toral Quiroga <itoral@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0283/1146] drm/v3d: Handle error from drm_sched_entity_init()
Date: Wed, 20 May 2026 18:08:53 +0200
Message-ID: <20260520162154.621625272@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index dd60acdf52c2b..86e05fcf6cf65 100644
--- a/drivers/gpu/drm/v3d/v3d_drv.c
+++ b/drivers/gpu/drm/v3d/v3d_drv.c
@@ -131,7 +131,7 @@ v3d_open(struct drm_device *dev, struct drm_file *file)
 	struct v3d_dev *v3d = to_v3d_dev(dev);
 	struct v3d_file_priv *v3d_priv;
 	struct drm_gpu_scheduler *sched;
-	int i;
+	int i, ret;
 
 	v3d_priv = kzalloc_obj(*v3d_priv);
 	if (!v3d_priv)
@@ -141,9 +141,11 @@ v3d_open(struct drm_device *dev, struct drm_file *file)
 
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
@@ -153,6 +155,12 @@ v3d_open(struct drm_device *dev, struct drm_file *file)
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



