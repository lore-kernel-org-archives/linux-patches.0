Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7124B3112A5;
	Sun,  7 Jun 2026 10:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826742; cv=none; b=n9cYGxR/08TELJ7Onz7RFQgFVyyCaPMqmGFFchw0T/YepTJAXRpm9r7IV7WQ3YBDWR2g+chmsWTsILf3ajthHA6Ibv/TWV4KACzXWgKYp8QDECtu8eFOxWnfbdS5FrHWRCe2afWU9zLkWAWVXxCT/NOHYwkZe9bW2yPdtnwZVqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826742; c=relaxed/simple;
	bh=pQguHxGc8ZkzRRitVUchkSvlHu6yTLcL7TGfQvCm0AM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JjNCaUcS7dSamjA6WDT3Wlrvfmellb0cGGtAMpp/r0/DasQOTErljJDjMWUGiDZWq5w1RGQR5tFuN0bZIAsrUPGdYOPD5oLDHRHpgng6pm3RRoPbNcuWQIpIAqr36fz/q4fHbG4j70cLFsxghsXpwtT9+nHW1QRNCJWA100eFpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x6jcROVF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x6jcROVF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CFEB1F00898;
	Sun,  7 Jun 2026 10:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826740;
	bh=XkN31PBAK7KC0PiBw0SamjUcQabfIBEyPNg/xq3RBQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x6jcROVFBlijybskLo1FPMINb3DiQSF82g1uX62pFn284qe1MzCiAAwLo3nFsmjPi
	 KKW+EfRCHpMwan6pmAGkbVUmyR3pvWDsgn2YguNaOL4V/c/lm9wMT6bZLx97L0w4Tj
	 HiViGtWbeHtoz/7pbb4VRDN6JrYNK/JTnmvry2iA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhabaleshwar Das <dhabal123@gmail.com>,
	Tomeu Vizoso <tomeu@tomeuvizoso.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 014/332] accel/rocket: fix UAF via dangling GEM handle in create_bo
Date: Sun,  7 Jun 2026 11:56:23 +0200
Message-ID: <20260607095728.557187754@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dhabaleshwar Das <dhabal123@gmail.com>

[ Upstream commit f706e6a4ce75585af979aec3dcbdce68bc76306b ]

rocket_ioctl_create_bo() inserts a GEM handle into the file's IDR via
drm_gem_handle_create() early on, then performs several operations that
can fail (sgt allocation, drm_mm insert, iommu_map). If any fail after
the handle is live, the error path calls drm_gem_shmem_object_free()
which kfree's the object without removing the handle from the IDR.

This leaves a dangling handle pointing to freed slab memory. Any
subsequent ioctl using that handle (PREP_BO, FINI_BO, SUBMIT) calls
drm_gem_object_lookup() and dereferences freed memory (UAF).

Fix by moving drm_gem_handle_create() to after all fallible operations
succeed, matching the pattern used by panfrost, lima, and etnaviv.

Also fix drm_mm_insert_node_generic() whose return value was silently
overwritten by iommu_map_sgtable() on the next line. Add the missing
error check.

[tomeu: Move handle creation to the very end]

Fixes: 658ebeac3351 ("accel/rocket: Add IOCTL for BO creation")
Reported-by: Dhabaleshwar Das <dhabal123@gmail.com>
Signed-off-by: Dhabaleshwar Das <dhabal123@gmail.com>
Reviewed-by: Tomeu Vizoso <tomeu@tomeuvizoso.net>
Link: https://patch.msgid.link/20260521165720.2113571-1-tomeu@tomeuvizoso.net
Signed-off-by: Tomeu Vizoso <tomeu@tomeuvizoso.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/rocket/rocket_gem.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/accel/rocket/rocket_gem.c b/drivers/accel/rocket/rocket_gem.c
index c8084719208a2a..a5fffa51ff3550 100644
--- a/drivers/accel/rocket/rocket_gem.c
+++ b/drivers/accel/rocket/rocket_gem.c
@@ -79,11 +79,6 @@ int rocket_ioctl_create_bo(struct drm_device *dev, void *data, struct drm_file *
 	rkt_obj->size = args->size;
 	rkt_obj->offset = 0;
 
-	ret = drm_gem_handle_create(file, gem_obj, &args->handle);
-	drm_gem_object_put(gem_obj);
-	if (ret)
-		goto err;
-
 	sgt = drm_gem_shmem_get_pages_sgt(shmem_obj);
 	if (IS_ERR(sgt)) {
 		ret = PTR_ERR(sgt);
@@ -95,6 +90,8 @@ int rocket_ioctl_create_bo(struct drm_device *dev, void *data, struct drm_file *
 					 rkt_obj->size, PAGE_SIZE,
 					 0, 0);
 	mutex_unlock(&rocket_priv->mm_lock);
+	if (ret)
+		goto err;
 
 	ret = iommu_map_sgtable(rocket_priv->domain->domain,
 				rkt_obj->mm.start,
@@ -112,8 +109,18 @@ int rocket_ioctl_create_bo(struct drm_device *dev, void *data, struct drm_file *
 	args->offset = drm_vma_node_offset_addr(&gem_obj->vma_node);
 	args->dma_address = rkt_obj->mm.start;
 
+	ret = drm_gem_handle_create(file, gem_obj, &args->handle);
+	if (ret)
+		goto err_unmap;
+
+	drm_gem_object_put(gem_obj);
+
 	return 0;
 
+err_unmap:
+	iommu_unmap(rocket_priv->domain->domain,
+		    rkt_obj->mm.start, rkt_obj->size);
+
 err_remove_node:
 	mutex_lock(&rocket_priv->mm_lock);
 	drm_mm_remove_node(&rkt_obj->mm);
-- 
2.53.0



