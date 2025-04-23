Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CEB02798E3;
	Wed, 23 Apr 2025 15:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421537; cv=none; b=W1v8uGjF/LMbK142bVF7G6qY6SV0l+gNCK1m6kX/4wIJR7rN0DSunpDPEaxpgFsCMC3nAPQIaLmmqSVVpai2HIoKPu2WMr2S1GJVY2UdnNblbzGBYEzSuuYSgDMfWeQyvYDxAHgRPl6KmHdaG2xJ9pnVIm/jWM5gRO2H3K+7grE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421537; c=relaxed/simple;
	bh=dA19ena+8XEfmvVlYPP5GVomPXO+n9+3FlXu6yqWSXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uES2HDJWYG8T8+jpiIWHgrzscX7+1abnR/grX+3sRZaT5tupQx73EeSp4mMJ7/Til4UlJLP/9WH42WdsP8H2zuxJXpdofjJWxauF0G4S5QS4pZgu+OwqCBySZ2K84bBhFhtGUuG6nKIZjFWUca1R2CPH8qxeVqAFyuHmSaORUrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ShAPo/Z2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ShAPo/Z2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F8EC4CEE2;
	Wed, 23 Apr 2025 15:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421537;
	bh=dA19ena+8XEfmvVlYPP5GVomPXO+n9+3FlXu6yqWSXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ShAPo/Z2fqoAKK7tvn7QhrRiad6H16JYizgRAYsVDG0+19G4wPbBI3/ZdLeAUFtK8
	 +TPM/d+YFQD52qxVjEYxTQpoJD2tNTAjW7hHS8kr5LcWT9KczlhOJQ1J4lvxT4madg
	 NzCNqBnEmwjLkDam3bWu5aqkggCDP3j03qDpoxTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>
Subject: [PATCH 6.14 200/241] drm/virtio: Fix missed dmabuf unpinning in error path of prepare_fb()
Date: Wed, 23 Apr 2025 16:44:24 +0200
Message-ID: <20250423142628.679747564@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

From: Dmitry Osipenko <dmitry.osipenko@collabora.com>

commit 395cc80051f8da267b27496a4029dd931a198855 upstream.

Correct error handling in prepare_fb() to fix leaking resources when
error happens.

Fixes: 4a696a2ee646 ("drm/virtio: Add prepare and cleanup routines for imported dmabuf obj")
Cc: <stable@vger.kernel.org> # v6.14+
Acked-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: https://lore.kernel.org/r/20250401123842.2232205-2-dmitry.osipenko@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/virtio/virtgpu_plane.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/virtio/virtgpu_plane.c
+++ b/drivers/gpu/drm/virtio/virtgpu_plane.c
@@ -322,12 +322,6 @@ static int virtio_gpu_plane_prepare_fb(s
 		return 0;
 
 	obj = new_state->fb->obj[0];
-	if (obj->import_attach) {
-		ret = virtio_gpu_prepare_imported_obj(plane, new_state, obj);
-		if (ret)
-			return ret;
-	}
-
 	if (bo->dumb || obj->import_attach) {
 		vgplane_st->fence = virtio_gpu_fence_alloc(vgdev,
 						     vgdev->fence_drv.context,
@@ -336,7 +330,21 @@ static int virtio_gpu_plane_prepare_fb(s
 			return -ENOMEM;
 	}
 
+	if (obj->import_attach) {
+		ret = virtio_gpu_prepare_imported_obj(plane, new_state, obj);
+		if (ret)
+			goto err_fence;
+	}
+
 	return 0;
+
+err_fence:
+	if (vgplane_st->fence) {
+		dma_fence_put(&vgplane_st->fence->f);
+		vgplane_st->fence = NULL;
+	}
+
+	return ret;
 }
 
 static void virtio_gpu_cleanup_imported_obj(struct drm_gem_object *obj)


