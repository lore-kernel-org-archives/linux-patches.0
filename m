Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01730441600;
	Thu, 30 Jul 2026 15:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424380; cv=none; b=Q+77elETpE72mhl1/mRI1qysnKj7fJdCRTnU5Sz3N4/Eap9NVeHkAlMEvcyIY1OvtUaHrdUKJSuHL+DT/Q6wBLfmjG9AQpLu3nkcjPUUxUpZQrHFNiVmeGNjlwMPK1ie7+eCrl9s5ds+Zv9FHoh1aT/9Opem40ETeYQmnrK+qcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424380; c=relaxed/simple;
	bh=18fXxoU4Pq++4Cu3lf/KdoyaZPAJW395G0TDkOF84OU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OHUmq+rET0OT86hHdpcvAImrTb0MKI9OvVez4NiM8GQlBN19BT75HvXuwerqPRS0DeiYLeOYG8l6fZq/tRIlT5TsxuOLsPSu3njoOq+EVBv8RAeqw0ESumZrK+bQGYyMCtzBXl00rlVSdzt+x11b/ehMfun8wsqBhjzqrLIfJXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DIbRHZDp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DIbRHZDp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 586861F000E9;
	Thu, 30 Jul 2026 15:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424378;
	bh=B5g50TovnSuQBDAyS7t2h5rNqBgwvXQDZIVtH9ZPqZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DIbRHZDpuSS9oaX/iD2AN8Wa1dKOt15+3vTz4VxL5jw27os5eX+xWW56i6oXBWEcB
	 UN/s2wg8XmEe06lf4MRCttmC+m2EMbr5xj81aZGUbQAAnoHuOFpsADDFx+8gppVMEp
	 Fwab8F/zGMo7mJ5tNlJODiOed9eklPIvOEB6UHYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Macnak <natsu@google.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>
Subject: [PATCH 6.18 374/675] drm/virtio: Dont detach GEM from a non-created context
Date: Thu, 30 Jul 2026 16:11:44 +0200
Message-ID: <20260730141453.083665242@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Macnak <natsu@google.com>

commit d489a5305b9d5480d6fb97d5636f5f4b1e0b3827 upstream.

Applies the same treatment as commit 7cf6dd467e87 ("drm/virtio:
Don't attach GEM to a non-created context in gem_object_open()")
to virtio_gpu_gem_object_close() to avoid trying to detach
a resource that was never attached due to a context
never being created when context_init is supported.

Fixes: 086b9f27f0ab ("drm/virtio: Don't create a context with default param if context_init is supported")
Cc: <stable@vger.kernel.org> # v6.14+
Signed-off-by: Jason Macnak <natsu@google.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: https://patch.msgid.link/20260625170828.3335431-1-natsu@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/virtio/virtgpu_gem.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/virtio/virtgpu_gem.c
+++ b/drivers/gpu/drm/virtio/virtgpu_gem.c
@@ -139,13 +139,15 @@ void virtio_gpu_gem_object_close(struct
 	if (!vgdev->has_virgl_3d)
 		return;
 
-	objs = virtio_gpu_array_alloc(1);
-	if (!objs)
-		return;
-	virtio_gpu_array_add_obj(objs, obj);
+	if (vfpriv->context_created) {
+		objs = virtio_gpu_array_alloc(1);
+		if (!objs)
+			return;
+		virtio_gpu_array_add_obj(objs, obj);
 
-	virtio_gpu_cmd_context_detach_resource(vgdev, vfpriv->ctx_id,
-					       objs);
+		virtio_gpu_cmd_context_detach_resource(vgdev, vfpriv->ctx_id,
+						       objs);
+	}
 	virtio_gpu_notify(vgdev);
 }
 


