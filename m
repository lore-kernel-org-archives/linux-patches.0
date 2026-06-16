Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A94B38837F;
	Tue, 16 Jun 2026 15:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623866; cv=none; b=SOG0+gCSQXAoPigkDE5ECW8GqGx0BIRAj01Z825sgx28qdNXJyGcTWcEosDfJtJnKjo1TbjXdhuMfT/9YrKvg+fNUJnKHX9Fa71ty9wNkDi31hvzHW7Nn3b8TDC9FzUkhL1vFOlBNPuemDM0olg4Z27pt2Ncms2nnoeK2ORljnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623866; c=relaxed/simple;
	bh=HD3qu6pcu/ur9zRDxNxW9vIkhH2EKMABuvwP6dWF7zI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tj70/3AWzo5I+PNCq7Hybs8xZkY/JS5plBbjkXQJgGCQBu3eEwvymvkPdsUpesXYmrCiEST6ymPvEnu0p+eKfjYW5xvKIL1LSSb3IZ4KXaFEjWLMpMCxi0Rjnko21kdAk2cRNxIFe3H1mggwUNIk4GrDJsGw+AJo8cVaOWfgE68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jJKwTD3c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jJKwTD3c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C4211F000E9;
	Tue, 16 Jun 2026 15:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623865;
	bh=LF/cz+Jidc4TzUjj6WiVUW3hacT23hnEbgsWzek9XMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jJKwTD3cdu47tPUWvEm7X2KsCSrMidHQ4chF1XMMnzsu5yqd0brh6WmwOCJ+wGI4P
	 z1QN1UAtU+Vz2jSNiUHTpUqjYKsrD1vEdQl/YudMmRAmMxC3p563wghaN7QWPliI7M
	 LG1GPDuT5zXbA1QhBDbK5v0vzA1memYwZl0pO7us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>
Subject: [PATCH 7.0 216/378] drm/virtio: fix dma_fence refcount leak on error in virtio_gpu_dma_fence_wait()
Date: Tue, 16 Jun 2026 20:27:27 +0530
Message-ID: <20260616145121.704394887@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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
 drivers/gpu/drm/virtio/virtgpu_submit.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/virtio/virtgpu_submit.c
+++ b/drivers/gpu/drm/virtio/virtgpu_submit.c
@@ -65,8 +65,10 @@ static int virtio_gpu_dma_fence_wait(str
 
 	dma_fence_unwrap_for_each(f, &itr, fence) {
 		err = virtio_gpu_do_fence_wait(submit, f);
-		if (err)
+		if (err) {
+			dma_fence_put(itr.chain);
 			return err;
+		}
 	}
 
 	return 0;


