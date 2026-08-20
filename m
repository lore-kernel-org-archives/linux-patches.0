Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73B547DF8B;
	Thu, 20 Aug 2026 16:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243950; cv=none; b=nrfXiMjLh6GpZbIFG+FUUvgPE1kq1bHbe+M+9+NB62cY9OBSbjn+aVSWtA5ZgKi6roX7UsClopw+sGj35bpNqnrsP4+feY/zME77H4OkwmFS4VNC2UFuf14EEqowUFZ+DtuG1f05s8+CrnophT0WH/toxwxMSbqpSfRzjURId4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243950; c=relaxed/simple;
	bh=Jvx8ToFCElrQR9aiUkbSlpXnFTHthqeNcG93i3Z8Edw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CtZkN+hQZlB0GN/DRyev/1ItULtIyxBLUT0ghmXbBNRAkrXPzBdsd8VZr69Gkr376PxPQLIva1hv3oM0CjXNeDtq9AMkYVMqxhfxdOdGfCd34+CwbU76l1DLKrmePNBQyTkPYmIKXNSBzIY9D9hHWxRfQtir93RM0jPYc7/H+vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lLbYqL0b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lLbYqL0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E39F1F00A3A;
	Thu, 20 Aug 2026 16:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243948;
	bh=do5vPi0ch2Gnhw0PaDKFGShPj/AdxRX7JQmSeXT2RAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lLbYqL0b0/ZOVn0axhCPIBLfrjVqGrLK/Gn8XTKdopLL4enfNdWq46OUVxp5ayERN
	 eaZsgoJpzwl6VKmcO3KCEJP9Vbv3zYetPYQ3M/5AYar+DBtowYrSSlQ3/ScIM16H2M
	 OFdGTxgDKiS6sxz7OG53rs6zeeUCIWw9dzxZXKyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH 5.15 271/272] drm/virtio: Unlock reservations on dma_resv_reserve_fences() error
Date: Thu, 20 Aug 2026 16:57:35 +0200
Message-ID: <20260820145239.765658813@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Osipenko <dmitry.osipenko@collabora.com>

commit 0f877398d30e1df657a31a62f7c7de1869b072b5 upstream.

Unlock reservations on dma_resv_reserve_fences() error to fix recursive
locking of the reservations when this error happens.

Cc: stable@vger.kernel.org
Fixes: c8d4c18bfbc4 ("dma-buf/drivers: make reserving a shared slot mandatory v4")
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20220630200726.1884320-5-dmitry.osipenko@collabora.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/virtio/virtgpu_gem.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/virtio/virtgpu_gem.c
+++ b/drivers/gpu/drm/virtio/virtgpu_gem.c
@@ -228,8 +228,10 @@ int virtio_gpu_array_lock_resv(struct vi
 
 	for (i = 0; i < objs->nents; ++i) {
 		ret = dma_resv_reserve_fences(objs->objs[i]->resv, 1);
-		if (ret)
+		if (ret) {
+			virtio_gpu_array_unlock_resv(objs);
 			return ret;
+		}
 	}
 	return ret;
 }


