Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8EC509F06;
	Wed, 30 Sep 2026 18:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792368; cv=none; b=fDpwe5F0pCktE1+G2Wk3AlUH0k1+tHEc3tCrwgXZD3XztefUAInqB6ePkpwDduuAU3vilDkAD0Y9DVmdrNFNBG4I8/1d5th2jzbmCr+I9y21MQQ8dvjHNYDTstaIJX3Pp2t4tp4pw8+0QlONutWn1BglMklU1Hg3Cu4ZW9WF1nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792368; c=relaxed/simple;
	bh=PMHxU4zc/6konZ3mYl95S+E9UJ/U8i1R7jdWkWUHhwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WfzxuOm11Qzg+RjapVwDEdkZbjE7ILWAFwhULPvqKhL/JHGngp9rRfdpaEehgooqJLl3oogdf8ELg3Hg418AKOmvyk+9TnC9Un8/JBq3GNMojNMMlir+WL5+Uxpo3H5XhB52S5H2sjia19MOIiSa29tgm2WAdIbQqg4J8eaj8Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tbA9qURk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tbA9qURk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D4E1F000FF;
	Wed, 30 Sep 2026 18:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792367;
	bh=QVmuUFIl1A6XebwbBGRY/J7i/U2yO85VN5w4kdQmzPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tbA9qURkSJYVuvn41NxGL/ANhbY1h8xBfMaLTa6DhRty65FQD1DwR8/qunbm7ae/q
	 3lLEuIRyMHmnhDXqM9QM3R9LyCe0KO+beZZxZwvDXLxfkdwYs15QnfNWEUrs9IDwyI
	 plzyeMRzllq999yltpEs9/pqLzf3w5brBaCf7abU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junrui Luo <moonafterrain@outlook.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 630/752] drm/virtio: fix object leak in virtio_gpu_resource_create_ioctl()
Date: Wed, 30 Sep 2026 17:28:20 +0200
Message-ID: <20260930152411.903341619@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3c750ba6ba1fe..3f327a8a8aa3a 100644
--- a/drivers/gpu/drm/virtio/virtgpu_ioctl.c
+++ b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
@@ -289,7 +289,7 @@ static int virtio_gpu_resource_create_ioctl(struct drm_device *dev, void *data,
 
 	ret = drm_gem_handle_create(file, obj, &handle);
 	if (ret) {
-		drm_gem_object_release(obj);
+		drm_gem_object_put(obj);
 		return ret;
 	}
 
-- 
2.53.0



