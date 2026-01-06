Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925C83590B9;
	Tue,  6 Jan 2026 17:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721543; cv=none; b=pbT0asb1PMaLJAGEIV2Pdmn/WvVIboQP60K876nLFRhKsoOp4q07Z1dxJJ2CXDVct5o6tYGwdSJaQelwWM6ubPkStaeiwBRWDsguav+ZvVNpWctW4wW87l33LjIGFk7XTlIDXOCqEH+iSwsvTMTsJBh/6ZSOx16GIVDZaLsPc1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721543; c=relaxed/simple;
	bh=X6w1RNtIf7D/y+Ip4BG8RuIKzociJEUxHUVZN65zR5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=naTrA9H2Httqk30v5WgP6Y7PWIi+KA8Q3lwC5NoLmD4Jvos5wG9QKKxa392KSbvRZrLM2cPUjBdxdGqn+YJ9mxuVOp88qe8IxPEZ1p+rdSFIPEnwMRyy49tR3B9MeeB0+q6IOPyNPTxiZnxiNxji49Zu9qP2bLyIgt6pWhNg5jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mRm654Z/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mRm654Z/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E78DAC16AAE;
	Tue,  6 Jan 2026 17:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721543;
	bh=X6w1RNtIf7D/y+Ip4BG8RuIKzociJEUxHUVZN65zR5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mRm654Z/iPCTIfzHeuHQe1zplLcj66HvLct6Wmn8+YH3YDsewfE4WeV0I2wZrLLIP
	 wNs0OZDxlRoDT5e6eKhmPxW1JGOOfHcYO6aqWPvlEp1R+DCFreJPwhkHDEmHqP/5sU
	 DHWeKNJAmZCfXLlUfq4y6x/HY6/TEJmgOSg4/j6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 6.12 525/567] drm/panthor: Flush shmem writes before mapping buffers CPU-uncached
Date: Tue,  6 Jan 2026 18:05:07 +0100
Message-ID: <20260106170510.811846047@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit 576c930e5e7dcb937648490611a83f1bf0171048 ]

The shmem layer zeroes out the new pages using cached mappings, and if
we don't CPU-flush we might leave dirty cachelines behind, leading to
potential data leaks and/or asynchronous buffer corruption when dirty
cachelines are evicted.

Fixes: 8a1cc07578bf ("drm/panthor: Add GEM logical block")
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patch.msgid.link/20251107171214.1186299-1-boris.brezillon@collabora.com
[Harshit: Resolve conflicts due to missing commit: fe69a3918084
("drm/panthor: Fix UAF in panthor_gem_create_with_handle() debugfs
code") in 6.12.y]
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panthor/panthor_gem.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/gpu/drm/panthor/panthor_gem.c
+++ b/drivers/gpu/drm/panthor/panthor_gem.c
@@ -214,6 +214,23 @@ panthor_gem_create_with_handle(struct dr
 		bo->base.base.resv = bo->exclusive_vm_root_gem->resv;
 	}
 
+	/* If this is a write-combine mapping, we query the sgt to force a CPU
+	 * cache flush (dma_map_sgtable() is called when the sgt is created).
+	 * This ensures the zero-ing is visible to any uncached mapping created
+	 * by vmap/mmap.
+	 * FIXME: Ideally this should be done when pages are allocated, not at
+	 * BO creation time.
+	 */
+	if (shmem->map_wc) {
+		struct sg_table *sgt;
+
+		sgt = drm_gem_shmem_get_pages_sgt(shmem);
+		if (IS_ERR(sgt)) {
+			ret = PTR_ERR(sgt);
+			goto out_put_gem;
+		}
+	}
+
 	/*
 	 * Allocate an id of idr table where the obj is registered
 	 * and handle has the id what user can see.
@@ -222,6 +239,7 @@ panthor_gem_create_with_handle(struct dr
 	if (!ret)
 		*size = bo->base.base.size;
 
+out_put_gem:
 	/* drop reference from allocate - handle holds it now. */
 	drm_gem_object_put(&shmem->base);
 


