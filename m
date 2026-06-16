Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2165478E45;
	Tue, 16 Jun 2026 17:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629684; cv=none; b=hRyD6rr4FdA6Dr8rDb58b8fByOc4Tw0gY0vPeZSQ0MtxIsVEjcubHwZhVdzyTFMtHRz2XeGDf8hKiI1fpnFGmomMeqb4vZQ3HgkJut6mMU3Fn0jqCQRmrXLBI98DgBolq4eAshlvNu8xN7NsA86LTLRK0/OGWRoAoyDpgl/WsOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629684; c=relaxed/simple;
	bh=I87c7wgzosQJctdB+QvL1pBJg0dOIDNruBZP9U7ZB2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RVIIi6SJczh38bK9I9L/fTgEvcclOA6DyX0dmmYJLqP/Eesu8TEVZMbBlZPvbKfgalN1ssDkZ9xx+sT6j/oielNoxJexuWGmS1reW9PTPtMR+6sL/ylR7rSuVKMesKioYg8/1IW7EeGif3LdUw2y+e3he372PXm3TO17SD4OyME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dju8QaXh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dju8QaXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC371F000E9;
	Tue, 16 Jun 2026 17:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629683;
	bh=lPVmqAbjQgdHzc7d3jvJJxId4YEs4FbzU5sieHQsBrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dju8QaXh1fti04ifRrrams+ZzRZeRDpLyKAglEyjTMqODzCU8m/yNKhMG8/+s1sup
	 ovk/IDWvx99bOSRIcc/0VmXCcBBcF5Wn7tGeXL08wWMoTTIkMnvp2hnaIYiuftEYAI
	 TkCKKasfp2mauej7Rl2IA0k1/dIy3wm7xEvMP9XI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>
Subject: [PATCH 6.6 305/452] drm/virtio: fix dma_fence refcount leak on error in virtio_gpu_dma_fence_wait()
Date: Tue, 16 Jun 2026 20:28:52 +0530
Message-ID: <20260616145133.526779784@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

commit 3f26bb732cc136ab20176697c92f32c9c84cb125 upstream.

dma_fence_unwrap_for_each() internally calls dma_fence_unwrap_first()
which does cursor->chain = dma_fence_get(head), taking an extra
reference. On normal loop completion, dma_fence_unwrap_next()
releases this via dma_fence_chain_walk() -> dma_fence_put().

When virtio_gpu_do_fence_wait() fails and the function returns early
from inside the loop, the cursor->chain reference is never released.
This is the only caller in the entire kernel that does an early return
inside dma_fence_unwrap_for_each.

Add dma_fence_put(itr.chain) before the early return.

Cc: stable@vger.kernel.org
Fixes: eba57fb5498f ("drm/virtio: Wait for each dma-fence of in-fence array individually")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: https://patch.msgid.link/20260607090303.92423-1-vulab@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/virtio/virtgpu_submit.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_submit.c b/drivers/gpu/drm/virtio/virtgpu_submit.c
index dae761fa5788..32cb1e4aa425 100644
--- a/drivers/gpu/drm/virtio/virtgpu_submit.c
+++ b/drivers/gpu/drm/virtio/virtgpu_submit.c
@@ -65,8 +65,10 @@ static int virtio_gpu_dma_fence_wait(struct virtio_gpu_submit *submit,
 
 	dma_fence_unwrap_for_each(f, &itr, fence) {
 		err = virtio_gpu_do_fence_wait(submit, f);
-		if (err)
+		if (err) {
+			dma_fence_put(itr.chain);
 			return err;
+		}
 	}
 
 	return 0;
-- 
2.54.0



