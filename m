Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3512247AF65;
	Tue, 13 Oct 2026 11:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892507; cv=none; b=Ta7p8QWGcK0b0V43OBKNZ8sBCdQ/rzx1G0e5tzCXwY/1a0dTo26gDpPPMKYm37o5UeKVWHvdbOUx+cdny32YM07+N/wxgeUp+DDOEG3pQewmMNKKUINq9XxgYdoFwHHMWX6mHjaAoxdfDqOENAk4hm3bNZGc7YfNjPzcyB/PiNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892507; c=relaxed/simple;
	bh=nIct3ck8M0R4XD3qQxjA95dBZvTR83w2XtbnFwV2PSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JoDLz6YzS373bzolyLT0m/AgblojZAFbdLNtzg8+qT+4+O8h5TSwLw4cPOnoVlAVb55tkV3ebr4Z5Ok2ZPcUe6rg+UtVm6OU2gwu5J6Lp16aeSde/vMvFlVGZcu/mjqSpBkG2GRFhAqnUbWaFd/HDJ/7oIOkFz3PP+TZrwrNZ7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ff/GtO01; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ff/GtO01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 867971F000FF;
	Tue, 13 Oct 2026 11:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892506;
	bh=nneJhwK1CPGHQ0/GBaVZ0Ga2cUTqNoAKc8Y3DgHND8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ff/GtO01nfZX88f8aMVjRhl39BHhviWEWk/Tvp3ez5+pT/CuRFIlZcq77XLcyPAE4
	 E8Q03VvQFOpmXeUqA4NjU/t9YTWMqnWpADnAtyuJc0qsZuS5PQFyB7gTNux/Pth2Rc
	 x5HRHX0+gDCKMGd9Ol/1gH7xFA1cZbE6t2ZeMzBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 196/281] drm/vc4: Use kvmalloc_objs() for the BO cache size list
Date: Tue, 13 Oct 2026 13:38:32 +0200
Message-ID: <20261013112859.921468754@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit bca45af5998a05f34b13a2ef11e639bac9c62643 ]

The BO cache size list has one entry per BO page count, so its size
scales with the largest BO ever freed. A 64 MiB BO already needs at
least an order-6 allocation, which fails under fragmentation and
triggers a warn_alloc() splat on BO close:

  page allocation failure: order:7, mode:0x40cc0(GFP_KERNEL|__GFP_COMP)
  Call trace:
   ...
   warn_alloc+0x118/0x190
   __alloc_pages_slowpath+0x4a8/0x520
   ...
   __kmalloc_noprof+0x3ac/0x5d8
   vc4_free_object+0x128/0x370 [vc4]
   drm_gem_object_handle_put_unlocked+0xb8/0x158 [drm]
   drm_gem_object_release_handle+0x74/0xe8 [drm]
   drm_gem_handle_delete+0x6c/0xa8 [drm]
   drm_gem_close_ioctl+0x34/0x50 [drm]

The list doesn't need physically contiguous memory. Use kvmalloc_objs()
so large lists can fall back to vmalloc(), avoiding the allocation
failure.

Fixes: c826a6e10644 ("drm/vc4: Add a BO cache.")
Reviewed-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Link: https://patch.msgid.link/20260930190721.1897264-2-mcanal@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_bo.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_bo.c b/drivers/gpu/drm/vc4/vc4_bo.c
index ea1be891ac781..7b8b3364000fc 100644
--- a/drivers/gpu/drm/vc4/vc4_bo.c
+++ b/drivers/gpu/drm/vc4/vc4_bo.c
@@ -204,7 +204,7 @@ static struct list_head *vc4_get_cache_list_for_size(struct drm_device *dev,
 		struct list_head *new_list;
 		uint32_t i;
 
-		new_list = kmalloc_objs(struct list_head, new_size);
+		new_list = kvmalloc_objs(struct list_head, new_size);
 		if (!new_list)
 			return NULL;
 
@@ -224,7 +224,7 @@ static struct list_head *vc4_get_cache_list_for_size(struct drm_device *dev,
 		for (i = vc4->bo_cache.size_list_size; i < new_size; i++)
 			INIT_LIST_HEAD(&new_list[i]);
 
-		kfree(vc4->bo_cache.size_list);
+		kvfree(vc4->bo_cache.size_list);
 		vc4->bo_cache.size_list = new_list;
 		vc4->bo_cache.size_list_size = new_size;
 	}
@@ -1052,7 +1052,7 @@ static void vc4_bo_cache_destroy(struct drm_device *dev, void *unused)
 	cancel_work_sync(&vc4->bo_cache.time_work);
 
 	vc4_bo_cache_purge(dev);
-	kfree(vc4->bo_cache.size_list);
+	kvfree(vc4->bo_cache.size_list);
 
 	for (i = 0; i < vc4->num_labels; i++) {
 		if (vc4->bo_labels[i].num_allocated) {
-- 
2.53.0



