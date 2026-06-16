Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1767013777E;
	Tue, 16 Jun 2026 16:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627471; cv=none; b=cfJo/Ymx0+lY0/YDUz5Ibnw1XwhwXWnLpO+qtuyEh2ir7hWgQ/K5k6Kgq/MZH/CvAzRc0bMSoleru0DRa86KWN/DnhUt94YrA7RZnnXasw0F1P9TBSlZl8t3AlsdIG3qKixDcrHLFzI3WTU35C3ra3W9GBD5YSXPD6B8bb5IyWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627471; c=relaxed/simple;
	bh=O9hxNoyBL02BkO+eNqfp56/J2KPnMZO8PPCJl4fflyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DZlzO36ixQQ7KcvaHV5c/iV9meKElRMHw6I9Nv6DYf8Xuli5wS69HyqspmOm5g1pbREZ1fSFGRHF1vJ7DgbETEFT7LWD0sc2+i2BFcyUJiDuIJLm7LQ+ZVa67tzXCjydtaFiHN08m8B4PGsxHAF7aj/hS7ZthHvUhYd2tELoAm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uh7j7snZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uh7j7snZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1DC81F000E9;
	Tue, 16 Jun 2026 16:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627469;
	bh=clVPpttSFDZtwDgTfdmmohNS/zVHuymzxMaTvCjgrZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uh7j7snZPl/8LQOmwwTEaL+bDFAIfxRPi3h7/tKAjJTwYRKbjkIVbqZXDQeHKNI8X
	 uAFzaIagfSLQglYtxU4swdpnh11ORn/1t41IbsXpfrsop2/5jp/cVvfyESUs/hc9lA
	 pMWT08W1AW0WrVibdaVKq6/Mrn/YvL6SezYo0mDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>
Subject: [PATCH 6.12 146/261] drm/virtio: fix dma_fence refcount leak on error in virtio_gpu_dma_fence_wait()
Date: Tue, 16 Jun 2026 20:29:44 +0530
Message-ID: <20260616145051.846268508@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


