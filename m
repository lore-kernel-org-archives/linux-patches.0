Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670C23B2D1A;
	Wed, 30 Sep 2026 19:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796722; cv=none; b=ai7CRCxaAfi5i64fd3nnbkvlOnF3A9D6qhqxtEgQfEjEGYdOQz0324ZEqIBdgpUrniZ0Q08COPFUb9BaegIfnyFmBk+yj7e3THTrK/x3+rJcPU9M6EjJ1/RTb/LjIe3U/6jJe+knwobPW8NMdtpz1q1KYEcYJDP1aupLC3LOuwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796722; c=relaxed/simple;
	bh=Ohpkk6Vz++4z3I9p8qnoik2c7U4+R0BK+zTEMCoofqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RDmp9wU5xFE6D5sf4zZ5K6LlpIsjgCcGYZSgRDCB11ivW8FPk1VCeorTakLZGN0HVr0qDftC97yH9zqvbIb+sNuzcvY3E3ix3TM4w+HuzYW9mDAxDD/ZrRhwkHK0rN/olyvyKLlB2tyxpXjo0VWN2y2A6G+nPnkYZuO0fgjr2OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cs4ddNPk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cs4ddNPk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B4541F000FF;
	Wed, 30 Sep 2026 19:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796721;
	bh=6gljCGrSOj8sZGkmKkmYmLGEiWjBPS9t9oPlAHRZW4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cs4ddNPkbpcRXTNng0v1zhr5iMqKtP6zvjCnkiOwT6imbCJiJ6Hcj2Q66s/PrbU3U
	 dh3Qhu59PJzRDUnZtJc/gobBDivg6WEXhBczNNM4OESlr7UD3twOkKeC9WrY/E0SYJ
	 qnws4eBGKPnqo2sguJMKSsWPTW2TLHgBOBUDQX4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junrui Luo <moonafterrain@outlook.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1014/1193] drm/virtio: fix object leak in virtio_gpu_resource_create_ioctl()
Date: Wed, 30 Sep 2026 17:28:18 +0200
Message-ID: <20260930152456.772693129@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit 477bc3068fc3777b9d8ffd79e265b0dfdf2d3a6b ]

virtio_gpu_resource_create_ioctl() calls drm_gem_object_release() on the
drm_gem_handle_create() error path instead of dropping the reference it
owns, so obj->funcs->free() never runs and the virtio_gpu_object, its
pages and sg table, the resource id and the host-side resource are
leaked.

Use drm_gem_object_put() instead.

Fixes: 62fb7a5e1096 ("virtio-gpu: add 3d/virgl support")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: https://patch.msgid.link/20260915-fixes-v2-2-a0d799e4db66@outlook.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_ioctl.c b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
index b24b11f25197d..55b9076287601 100644
--- a/drivers/gpu/drm/virtio/virtgpu_ioctl.c
+++ b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
@@ -170,7 +170,7 @@ static int virtio_gpu_resource_create_ioctl(struct drm_device *dev, void *data,
 
 	ret = drm_gem_handle_create(file, obj, &handle);
 	if (ret) {
-		drm_gem_object_release(obj);
+		drm_gem_object_put(obj);
 		return ret;
 	}
 
-- 
2.53.0



