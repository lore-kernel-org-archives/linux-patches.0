Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768A337CD3A;
	Fri,  7 Aug 2026 14:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114438; cv=none; b=NQca5bkDCXjhNl/5grABWXE9IOYv12dCBGg+cel/B8YKED93rB8Jckzwu0szawzy6AhNzH3XomPbhbJP2T4eV60UT97BFngwHsaV7264SArnm+STAahiu+DqJlD26YWBeWnCO2hQN1piPb+nQjU14W7LYjEAMuu7tfhLV6jo0ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114438; c=relaxed/simple;
	bh=c6nrhwMtfQ71D81kbh6WJkHCVznpdyFSiHG2PTc0PiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QiWFzuX9i5VQXJn1cBEQ64C6h+SyQcClueFt/bIXhiCJqyVnzRsm9PAutWUAyvuQ9E7g82SfYZLY2X8nfPo9G2kDYyLRxm5DSIPNfeI8qzsB12MN2yLobuNfj9EdA/y6X3hprcb0v71Rw3OZEeBlq/h0nlLyePxyqOUboH8ErMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iGsl7AUi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iGsl7AUi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D16AD1F000E9;
	Fri,  7 Aug 2026 14:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114436;
	bh=8zN5U6fdbBaCE6ZDR8GQ3t20MrF4wSJRILwCJcegG/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iGsl7AUidiY4SJSlsloPXknkGOGeqLiDz9dv4zdEI6TzF1PVuXog2/h2z+qonFiBc
	 NvOr2f/dksiJbdNd5HQO/W37Eo9OYasnlN92074BobtWmf2qovgr8L5VdPWSCGBV15
	 WaNVuoNQxKNpkzAzEOAO6AsoQF9RCREs0MukHnTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	Ian Forbes <ian.forbes@broadcom.com>
Subject: [PATCH 6.12 261/337] drm/vmwgfx: drop dma_buf reference on foreign-fd prime import
Date: Fri,  7 Aug 2026 16:37:44 +0200
Message-ID: <20260807143424.203974481@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

From: Zack Rusin <zack.rusin@broadcom.com>

commit f739416dc555fa205a785e5135d73fa39b26f35d upstream.

ttm_prime_fd_to_handle() returns -ENOSYS when the imported fd's
dma_buf->ops do not match the ttm_object_device's ops, but does so
without releasing the reference acquired by dma_buf_get().  Any
unprivileged renderD client passing a non-vmwgfx prime fd through the
DRM_VMW_GB_SURFACE_REF{,_EXT} path leaks one dma_buf reference per
call and indefinitely pins the foreign exporter's GEM resources.

Funnel the error path through the existing dma_buf_put() so the
reference is always dropped.

Fixes: 65981f7681ab ("drm/ttm: Add a minimal prime implementation for ttm base objects")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4.7
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Reviewed-by: Ian Forbes <ian.forbes@broadcom.com>
Link: https://patch.msgid.link/20260505222728.519626-6-zack.rusin@broadcom.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/ttm_object.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/vmwgfx/ttm_object.c
+++ b/drivers/gpu/drm/vmwgfx/ttm_object.c
@@ -547,14 +547,17 @@ int ttm_prime_fd_to_handle(struct ttm_ob
 	if (IS_ERR(dma_buf))
 		return PTR_ERR(dma_buf);
 
-	if (dma_buf->ops != &tdev->ops)
-		return -ENOSYS;
+	if (dma_buf->ops != &tdev->ops) {
+		ret = -ENOSYS;
+		goto out;
+	}
 
 	prime = (struct ttm_prime_object *) dma_buf->priv;
 	base = &prime->base;
 	*handle = base->handle;
 	ret = ttm_ref_object_add(tfile, base, NULL, false);
 
+out:
 	dma_buf_put(dma_buf);
 
 	return ret;


