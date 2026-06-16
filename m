Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4D62E612E;
	Tue, 16 Jun 2026 15:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623228; cv=none; b=mQLXXSUg3uvRXqDuCrEmbEnUEimJPUA+tz56nEAe9qYezN0X0gyGxd7L6GdRxNdFZA22W1LKKSwgh1AjjSqfR1rLX2wJ0+yS3hyTCNAFM0P3vQMbQpu/bxBCLwstGB3HVt8BjyyEcj5VKxqeukB67haU1EZCvLm0yoNytmkVxxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623228; c=relaxed/simple;
	bh=bPF8PP4nUW4YY5xqKQJvi+qNiab/PY2IxJsiLmsFYbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nZjYSd8CbUF6rsy5e22E3ZJQ841MA5J9tZkDxvQlChddgeFNcrVy6VbhnxZ2765KXe++pzX2m2qmsNRjuPQBQkgrUGCMFQANpFGMfl6Dw/xGg6Kj+h96sby0b3Set3q59SkVcHAjMC+1CHGPNgvIPF97ptWKMIW/ImbI9XR1IFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MkdQNmw9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MkdQNmw9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF9A51F000E9;
	Tue, 16 Jun 2026 15:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623226;
	bh=m7L5COqtBekIbpGe1j5xqQUO/eLG6vcGeDswLeQtD+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MkdQNmw9r6+yzTZi+4NSmCJXd7x1LXiDVlPpL2KAyQePqHj0/2TgtZQow+gXGPNKh
	 0vt0SYzGZULLVFLPBM8H10fjwO4LVMSuaPFAP+Qzo+6+Gc6z3jOssyp3CtC95ykTna
	 cqTf1mpghGacASgxSRppmJaWuBeB4BmcGKwlL6qM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 076/378] drm/hyperv: During panic do VMBus unload after frame buffer is flushed
Date: Tue, 16 Jun 2026 20:25:07 +0530
Message-ID: <20260616145114.164673848@linuxfoundation.org>
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

From: Michael Kelley <mhklinux@outlook.com>

[ Upstream commit 8b35874f56ded0cc1a90a25b87411249a86246cd ]

In a VM, Linux panic information (reason for the panic, stack trace,
etc.) may be written to a serial console and/or a virtual frame buffer
for a graphics console. The latter may need to be flushed back to the
host hypervisor for display.

The current Hyper-V DRM driver for the frame buffer does the flushing
*after* the VMBus connection has been unloaded, such that panic messages
are not displayed on the graphics console. A user with a Hyper-V graphics
console is left with just a hung empty screen after a panic. The enhanced
control that DRM provides over the panic display in the graphics console
is similarly non-functional.

Commit 3671f3777758 ("drm/hyperv: Add support for drm_panic") added
the Hyper-V DRM driver support to flush the virtual frame buffer. It
provided necessary functionality but did not handle the sequencing
problem with VMBus unload.

Fix the full problem by using VMBus functions to suppress the VMBus
unload that is normally done by the VMBus driver in the panic path. Then
after the frame buffer has been flushed, do the VMBus unload so that a
kdump kernel can start cleanly. As expected, CONFIG_DRM_PANIC must be
selected for these changes to have effect. As a side benefit, the
enhanced features of the DRM panic path are also functional.

Fixes: 3671f3777758 ("drm/hyperv: Add support for drm_panic")
Signed-off-by: Michael Kelley <mhklinux@outlook.com>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/hyperv/hyperv_drm_drv.c     |  5 +++++
 drivers/gpu/drm/hyperv/hyperv_drm_modeset.c | 15 ++++++++-------
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/hyperv/hyperv_drm_drv.c b/drivers/gpu/drm/hyperv/hyperv_drm_drv.c
index 06b5d96e6eaf6b..b6bf6412ae34ac 100644
--- a/drivers/gpu/drm/hyperv/hyperv_drm_drv.c
+++ b/drivers/gpu/drm/hyperv/hyperv_drm_drv.c
@@ -150,6 +150,10 @@ static int hyperv_vmbus_probe(struct hv_device *hdev,
 		goto err_free_mmio;
 	}
 
+	/* If DRM panic path is stubbed out VMBus code must do the unload */
+	if (IS_ENABLED(CONFIG_DRM_PANIC))
+		vmbus_set_skip_unload(true);
+
 	drm_client_setup(dev, NULL);
 
 	return 0;
@@ -169,6 +173,7 @@ static void hyperv_vmbus_remove(struct hv_device *hdev)
 	struct drm_device *dev = hv_get_drvdata(hdev);
 	struct hyperv_drm_device *hv = to_hv(dev);
 
+	vmbus_set_skip_unload(false);
 	drm_dev_unplug(dev);
 	drm_atomic_helper_shutdown(dev);
 	vmbus_close(hdev->channel);
diff --git a/drivers/gpu/drm/hyperv/hyperv_drm_modeset.c b/drivers/gpu/drm/hyperv/hyperv_drm_modeset.c
index 7978f8c8108c23..d48ca6c23b7c5e 100644
--- a/drivers/gpu/drm/hyperv/hyperv_drm_modeset.c
+++ b/drivers/gpu/drm/hyperv/hyperv_drm_modeset.c
@@ -212,15 +212,16 @@ static void hyperv_plane_panic_flush(struct drm_plane *plane)
 	struct hyperv_drm_device *hv = to_hv(plane->dev);
 	struct drm_rect rect;
 
-	if (!plane->state || !plane->state->fb)
-		return;
+	if (plane->state && plane->state->fb) {
+		rect.x1 = 0;
+		rect.y1 = 0;
+		rect.x2 = plane->state->fb->width;
+		rect.y2 = plane->state->fb->height;
 
-	rect.x1 = 0;
-	rect.y1 = 0;
-	rect.x2 = plane->state->fb->width;
-	rect.y2 = plane->state->fb->height;
+		hyperv_update_dirt(hv->hdev, &rect);
+	}
 
-	hyperv_update_dirt(hv->hdev, &rect);
+	vmbus_initiate_unload(true);
 }
 
 static const struct drm_plane_helper_funcs hyperv_plane_helper_funcs = {
-- 
2.53.0



