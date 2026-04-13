Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DB2313298;
	Mon, 13 Apr 2026 16:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098957; cv=none; b=sodMflcW4OSRTZGWQ/LOtMM+ZbqODutre/qLlfW0RHDhVziz3ElwKtNyCFvCUvx0Xv8CH9ulW6UVXK3530VB6shm9YMw0vniyySo5xUnI3nHm/e2oA5NPKY2i38aLDdOSBcSTpW0L38zcTRQjjfScruLg4nTcWFFucnn3GelwmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098957; c=relaxed/simple;
	bh=GbkEaxtqcGlZ+5ztIkd1WNSh/7rjH2Emy52Ec5fSEoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uv9qfssV2kapIJ83u+j9WsLkDn6/25mX0r78Bh9jNaljfW5+czJprVg174EVkOTzzxyYNYoik924Ju8sWljfuuhxN1QenJqACnr0cAO6fdwhVLG/eUSN79HWeLI6lwEmrAY9qwCaIkaI3zuJuIaoDwTtPTLlPDOh/EruR3nsA70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k1FnRtIT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k1FnRtIT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1617C2BCAF;
	Mon, 13 Apr 2026 16:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098957;
	bh=GbkEaxtqcGlZ+5ztIkd1WNSh/7rjH2Emy52Ec5fSEoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k1FnRtITiBsNU0/Ler08T+KGqRNznh/MULm85Mdu7UE8KmYNHBafYW3oBfbambvCp
	 g7TqxCxC0jivVSifDztS5EvjrwhyO3XHZt72P32X17hqyuDLzAESr4HyAq87M9h8+U
	 hWAgPtJVdEXVD0TBc/YM3eYcjZjEVPepYTV4GqRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeongjun Park <aha310510@gmail.com>,
	Inki Dae <inki.dae@samsung.com>
Subject: [PATCH 5.10 155/491] drm/exynos: vidi: fix to avoid directly dereferencing user pointer
Date: Mon, 13 Apr 2026 17:56:40 +0200
Message-ID: <20260413155824.834590960@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeongjun Park <aha310510@gmail.com>

commit d4c98c077c7fb2dfdece7d605e694b5ea2665085 upstream.

In vidi_connection_ioctl(), vidi->edid(user pointer) is directly
dereferenced in the kernel.

This allows arbitrary kernel memory access from the user space, so instead
of directly accessing the user pointer in the kernel, we should modify it
to copy edid to kernel memory using copy_from_user() and use it.

Cc: <stable@vger.kernel.org>
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/exynos/exynos_drm_vidi.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/exynos/exynos_drm_vidi.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_vidi.c
@@ -251,19 +251,26 @@ int vidi_connection_ioctl(struct drm_dev
 
 	if (vidi->connection) {
 		struct edid *raw_edid;
+		struct edid edid_buf;
+		void *edid_userptr = u64_to_user_ptr(vidi->edid);
 
-		raw_edid = (struct edid *)(unsigned long)vidi->edid;
-		if (!drm_edid_is_valid(raw_edid)) {
+		if (copy_from_user(&edid_buf, edid_userptr, sizeof(struct edid)))
+			return -EFAULT;
+
+		if (!drm_edid_is_valid(&edid_buf)) {
 			DRM_DEV_DEBUG_KMS(ctx->dev,
 					  "edid data is invalid.\n");
 			return -EINVAL;
 		}
-		ctx->raw_edid = drm_edid_duplicate(raw_edid);
-		if (!ctx->raw_edid) {
+
+		raw_edid = drm_edid_duplicate(&edid_buf);
+
+		if (!raw_edid) {
 			DRM_DEV_DEBUG_KMS(ctx->dev,
 					  "failed to allocate raw_edid.\n");
 			return -ENOMEM;
 		}
+		ctx->raw_edid = raw_edid;
 	} else {
 		/*
 		 * with connection = 0, free raw_edid


