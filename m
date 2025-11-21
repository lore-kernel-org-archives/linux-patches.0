Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3108E2FF64E;
	Fri, 21 Nov 2025 13:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731139; cv=none; b=g375qaSkQmQzTVYT+Hf1V1n6fsLWMe/od8LvwXTGef7fDLUEl0itLHAmfjFEK5pRMS/znqfo6+FSrPckUsLth5KAUcWQnGw/fw8SAaPPMUbx4Vs9bl9fFXcVfW4GDvhHZB0V5X8OnaTnmSpgnmHzdrc3yTeA0y5WFuRdc9DfTbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731139; c=relaxed/simple;
	bh=ZLtG3znRlWJKljGYcBp0GwGZIEZxPR2z28oM2w0J2oU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=otcsJUyasIODPofLrzKP1y7CXRLh/IvW9tz7nI/328ZrypgqcN1h+PjxoQZitrBSZktEFJJplv4e2pCwcpfcpiiSWjVAOhKihPThG4pqDMw+wL25CpUJCx45qLEHdCUMDRH/Ip46j0mdbEAFufdj245yRUco5THvgH9aRryd5Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=125vcMAT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="125vcMAT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C2ABC4CEF1;
	Fri, 21 Nov 2025 13:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731138;
	bh=ZLtG3znRlWJKljGYcBp0GwGZIEZxPR2z28oM2w0J2oU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=125vcMATEKeCvYyCWHrlAvg8fi1H3i+jAwVLGACfA+/N+WeJyAhTiaAKdI2a5bMyW
	 uLzMK9uIATf2FKgh/16tk4CJDRVNOG6jvmJ1YLm3AQCPe2IHqeTI/nh2orp37q/HtB
	 YlYgYnOzlJb07ADg6xei8KMEPFWfknKjvwLgtAQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 103/247] drm/panthor: Flush shmem writes before mapping buffers CPU-uncached
Date: Fri, 21 Nov 2025 14:10:50 +0100
Message-ID: <20251121130158.284795545@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_gem.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/gpu/drm/panthor/panthor_gem.c b/drivers/gpu/drm/panthor/panthor_gem.c
index a123bc740ba14..eb5f0b9d437fc 100644
--- a/drivers/gpu/drm/panthor/panthor_gem.c
+++ b/drivers/gpu/drm/panthor/panthor_gem.c
@@ -291,6 +291,23 @@ panthor_gem_create_with_handle(struct drm_file *file,
 
 	panthor_gem_debugfs_set_usage_flags(bo, 0);
 
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
@@ -299,6 +316,7 @@ panthor_gem_create_with_handle(struct drm_file *file,
 	if (!ret)
 		*size = bo->base.base.size;
 
+out_put_gem:
 	/* drop reference from allocate - handle holds it now. */
 	drm_gem_object_put(&shmem->base);
 
-- 
2.51.0



