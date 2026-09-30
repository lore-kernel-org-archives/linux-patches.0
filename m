Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2FE514752;
	Wed, 30 Sep 2026 16:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786399; cv=none; b=M+MmNDJ6rnAK/a5O51JVgGhm9tB8NSxzhdwDdN0URO54I+j0IrR83skzW067PIX0RI4ib+qDPdkx4KkuROewjfkwg65Ak9QWNo3DCS2I9D/IuiVi2aeJF1mBCq+e5hNB2GtPlogCUML6P36rD5/1rLaqFU2L86K6QpMOpcCCQEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786399; c=relaxed/simple;
	bh=JNlYeeTnzCgNFakdq+vTxcvEfsg5BabuYuoZVS9drWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WDng4JBKsaQ3mED6ZYXvrDUTo+QzuM8MkU2GvOVBp621PLoktsJDendjgFB2yKkgcsKXxlWcI7Ckl0pd0q+bF8SzZBMx07HiDPHcXhHKzeJ/dEa1FDom0LNTXZZQ2S2xIFySrbrSpWULWRhSpRw4GvunVCXJqYe1CKeNPF/2e4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pqu3X7Fk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pqu3X7Fk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119211F000FF;
	Wed, 30 Sep 2026 16:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786398;
	bh=y+h/tlPLT8v4EHd0YGrGVS5MJrn6bsOY/NxwXwI2IjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pqu3X7Fks5U4s7UajM/EnyxtvCCQB9Mg39fS2XOro607VOcGR3McL3WCvwy46ZW79
	 HcxqgS7dznCAE4YSj6y4opYCcMnh48mnFJP0gIe088MgWDNU7ykHTpMXv0TOrWhZtu
	 xQm+nxIHUNYdt5oRh1hOHkfJadiH7MyUG0XBQBUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junrui Luo <moonafterrain@outlook.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 849/982] drm/virtio: fix object leak in virtio_gpu_resource_create_ioctl()
Date: Wed, 30 Sep 2026 17:26:25 +0200
Message-ID: <20260930152434.984963721@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
index bc8c1e9a845fd..df6edae131139 100644
--- a/drivers/gpu/drm/virtio/virtgpu_ioctl.c
+++ b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
@@ -358,7 +358,7 @@ static int virtio_gpu_resource_create_ioctl(struct drm_device *dev, void *data,
 
 	ret = drm_gem_handle_create(file, obj, &handle);
 	if (ret) {
-		drm_gem_object_release(obj);
+		drm_gem_object_put(obj);
 		return ret;
 	}
 
-- 
2.53.0



