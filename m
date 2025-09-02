Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D5E26563F;
	Tue,  2 Sep 2025 13:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819371; cv=none; b=PcZWBQMbVRe8QaUQFsLvBEd5lhTaP1VdGhQXa207xMlNXyjWxiYR2WM37B1MxS8Vn0z3lOD0SLpJo3Ftc1EiXEDwEGdyfb5xNi4zM0W6b3mJUI9b6TBu5DuwS+SdSIww0TJUc1sTeuHsLb7j/ZlVO0U6z34PKeCpvKkt1UgsPQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819371; c=relaxed/simple;
	bh=0ZoUdcZJuLVMckwdFTncIOFEDnoZvs5OGP+pOg7R3AE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hn4dQ5NP6sSnQ0qGvseuuV8C1mZpxgrFQOkOBzWLMi6amP7PEkEfh7Cw3kV6SrhU0AiDouLdvZbUS4Ogi6tiB6lPZbdrq7JJXZPXJnWGITysTpf6wxbyWhtaAvDJNUC7Lx2xtitcuFr0rMrqa5o2KtFagoFeIcNsJhdydUb+3Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HPuOatLj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HPuOatLj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1848C4CEF4;
	Tue,  2 Sep 2025 13:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819371;
	bh=0ZoUdcZJuLVMckwdFTncIOFEDnoZvs5OGP+pOg7R3AE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HPuOatLjJWs93kUHn3xLTcSvWwwrzsq7JVb5iW3r2DxFb1p01uH8L7lDOHlTWq+ys
	 pY4bTmrldSATelLcU0fQd0eNY1zc47f0oBUWfoFOb7pGDt1HIpzv3OsVzSSbcqavXr
	 OB03CPEKKNp2Xb5YiGE7sRr/nFc1O/85+1f5jCHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Torrente <igor.torrente@collabora.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 015/142] Revert "virtio: reject shm region if length is zero"
Date: Tue,  2 Sep 2025 15:18:37 +0200
Message-ID: <20250902131948.736546179@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Torrente <igor.torrente@collabora.com>

[ Upstream commit ced17ee32a9988b8a260628e7c31a100d7dc082e ]

The commit 206cc44588f7 ("virtio: reject shm region if length is zero")
breaks the Virtio-gpu `host_visible` feature.

As you can see in the snippet below, host_visible_region is zero because
of the `kzalloc`.  It's using the `vm_get_shm_region`
(drivers/virtio/virtio_mmio.c:536) to read the `addr` and `len` from
qemu/crosvm.

```
drivers/gpu/drm/virtio/virtgpu_kms.c
132         vgdev = drmm_kzalloc(dev, sizeof(struct virtio_gpu_device), GFP_KERNEL);
[...]
177         if (virtio_get_shm_region(vgdev->vdev, &vgdev->host_visible_region,
178                                   VIRTIO_GPU_SHM_ID_HOST_VISIBLE)) {
```
Now it always fails.

To fix, revert the offending commit.

Fixes: 206cc44588f7 ("virtio: reject shm region if length is zero")
Signed-off-by: Igor Torrente <igor.torrente@collabora.com>
Message-Id: <20250807124145.81816-1-igor.torrente@collabora.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/virtio_config.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index b3e1d30c765bc..169c7d367facb 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -329,8 +329,6 @@ static inline
 bool virtio_get_shm_region(struct virtio_device *vdev,
 			   struct virtio_shm_region *region, u8 id)
 {
-	if (!region->len)
-		return false;
 	if (!vdev->config->get_shm_region)
 		return false;
 	return vdev->config->get_shm_region(vdev, region, id);
-- 
2.50.1



