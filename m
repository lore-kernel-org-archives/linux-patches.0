Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4B32F5E;
	Tue, 12 Aug 2025 18:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023885; cv=none; b=PCpnIH3oQSmon6OgSPJHjT+4hGHOaF/SdYeCtz+Bw17cR0NBz/KUDjJ7+sztWuUM2PL5x/xjesTP/hSVvA0QuQiS2uodVsyt6Gls962e9nT0MCXJThhrdQdEiAAb9mxRfxTc5B0qfB0xqkmgOeYq5kYCMnLW63EG9QvXUqrIyi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023885; c=relaxed/simple;
	bh=B3sYB9H60DWxkVVJf9DammbAliin7Eu3e5CFYg5P/zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PTLDtf19FkukyhdyF0J7FuBc6eFJTxymLkYIAyHHbA9k5V9D6T7Iuw5GZbUgnvAQRqJji+YEQeCyG6V+vLys6q5P424Fc4gCs9o9q1ZUinI1csRsinR02vMOcwdjuu8Gi26TG3EVXs8lswpLI40xR+0e8RQ1rbdIyMvat9evDPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y2Bnxc5w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y2Bnxc5w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF53AC4CEF0;
	Tue, 12 Aug 2025 18:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023885;
	bh=B3sYB9H60DWxkVVJf9DammbAliin7Eu3e5CFYg5P/zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y2Bnxc5wHfaS+6urdbY6XeojPrJE/npOIaimNaBcK3+jyl1W9ZVuytp/nlcWRKfpq
	 6x/vF9y9w90tHP7NOq4Cdhrt3w9zEPFKe7Wrwpax3NHwQpNLJNJuP+mL00+XmGMbzQ
	 yXbw0dIiCQvVbAp0DKc6eF7F75KVVeTV4j+E4TgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Simona Vetter <simona.vetter@intel.com>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 203/627] drm/panthor: Fix UAF in panthor_gem_create_with_handle() debugfs code
Date: Tue, 12 Aug 2025 19:28:18 +0200
Message-ID: <20250812173426.999062591@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simona Vetter <simona.vetter@ffwll.ch>

[ Upstream commit fe69a391808404977b1f002a6e7447de3de7a88e ]

The object is potentially already gone after the drm_gem_object_put().
In general the object should be fully constructed before calling
drm_gem_handle_create(), except the debugfs tracking uses a separate
lock and list and separate flag to denotate whether the object is
actually initialized.

Since I'm touching this all anyway simplify this by only adding the
object to the debugfs when it's ready for that, which allows us to
delete that separate flag. panthor_gem_debugfs_bo_rm() already checks
whether we've actually been added to the list or this is some error
path cleanup.

v2: Fix build issues for !CONFIG_DEBUGFS (Adrián)

v3: Add linebreak and remove outdated comment (Liviu)

Fixes: a3707f53eb3f ("drm/panthor: show device-wide list of DRM GEM objects over DebugFS")
Cc: Adrián Larumbe <adrian.larumbe@collabora.com>
Cc: Boris Brezillon <boris.brezillon@collabora.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Liviu Dudau <liviu.dudau@arm.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Simona Vetter <simona.vetter@intel.com>
Signed-off-by: Simona Vetter <simona.vetter@ffwll.ch>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://lore.kernel.org/r/20250709135220.1428931-1-simona.vetter@ffwll.ch
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_gem.c | 31 +++++++++++++--------------
 drivers/gpu/drm/panthor/panthor_gem.h |  3 ---
 2 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_gem.c b/drivers/gpu/drm/panthor/panthor_gem.c
index 7c00fd77758b..a123bc740ba1 100644
--- a/drivers/gpu/drm/panthor/panthor_gem.c
+++ b/drivers/gpu/drm/panthor/panthor_gem.c
@@ -16,10 +16,15 @@
 #include "panthor_mmu.h"
 
 #ifdef CONFIG_DEBUG_FS
-static void panthor_gem_debugfs_bo_add(struct panthor_device *ptdev,
-				       struct panthor_gem_object *bo)
+static void panthor_gem_debugfs_bo_init(struct panthor_gem_object *bo)
 {
 	INIT_LIST_HEAD(&bo->debugfs.node);
+}
+
+static void panthor_gem_debugfs_bo_add(struct panthor_gem_object *bo)
+{
+	struct panthor_device *ptdev = container_of(bo->base.base.dev,
+						    struct panthor_device, base);
 
 	bo->debugfs.creator.tgid = current->group_leader->pid;
 	get_task_comm(bo->debugfs.creator.process_name, current->group_leader);
@@ -44,14 +49,13 @@ static void panthor_gem_debugfs_bo_rm(struct panthor_gem_object *bo)
 
 static void panthor_gem_debugfs_set_usage_flags(struct panthor_gem_object *bo, u32 usage_flags)
 {
-	bo->debugfs.flags = usage_flags | PANTHOR_DEBUGFS_GEM_USAGE_FLAG_INITIALIZED;
+	bo->debugfs.flags = usage_flags;
+	panthor_gem_debugfs_bo_add(bo);
 }
 #else
-static void panthor_gem_debugfs_bo_add(struct panthor_device *ptdev,
-				       struct panthor_gem_object *bo)
-{}
 static void panthor_gem_debugfs_bo_rm(struct panthor_gem_object *bo) {}
 static void panthor_gem_debugfs_set_usage_flags(struct panthor_gem_object *bo, u32 usage_flags) {}
+static void panthor_gem_debugfs_bo_init(struct panthor_gem_object *bo) {}
 #endif
 
 static void panthor_gem_free_object(struct drm_gem_object *obj)
@@ -246,7 +250,7 @@ struct drm_gem_object *panthor_gem_create_object(struct drm_device *ddev, size_t
 	drm_gem_gpuva_set_lock(&obj->base.base, &obj->gpuva_list_lock);
 	mutex_init(&obj->label.lock);
 
-	panthor_gem_debugfs_bo_add(ptdev, obj);
+	panthor_gem_debugfs_bo_init(obj);
 
 	return &obj->base.base;
 }
@@ -285,6 +289,8 @@ panthor_gem_create_with_handle(struct drm_file *file,
 		bo->base.base.resv = bo->exclusive_vm_root_gem->resv;
 	}
 
+	panthor_gem_debugfs_set_usage_flags(bo, 0);
+
 	/*
 	 * Allocate an id of idr table where the obj is registered
 	 * and handle has the id what user can see.
@@ -296,12 +302,6 @@ panthor_gem_create_with_handle(struct drm_file *file,
 	/* drop reference from allocate - handle holds it now. */
 	drm_gem_object_put(&shmem->base);
 
-	/*
-	 * No explicit flags are needed in the call below, since the
-	 * function internally sets the INITIALIZED bit for us.
-	 */
-	panthor_gem_debugfs_set_usage_flags(bo, 0);
-
 	return ret;
 }
 
@@ -387,7 +387,7 @@ static void panthor_gem_debugfs_bo_print(struct panthor_gem_object *bo,
 	unsigned int refcount = kref_read(&bo->base.base.refcount);
 	char creator_info[32] = {};
 	size_t resident_size;
-	u32 gem_usage_flags = bo->debugfs.flags & (u32)~PANTHOR_DEBUGFS_GEM_USAGE_FLAG_INITIALIZED;
+	u32 gem_usage_flags = bo->debugfs.flags;
 	u32 gem_state_flags = 0;
 
 	/* Skip BOs being destroyed. */
@@ -436,8 +436,7 @@ void panthor_gem_debugfs_print_bos(struct panthor_device *ptdev,
 
 	scoped_guard(mutex, &ptdev->gems.lock) {
 		list_for_each_entry(bo, &ptdev->gems.node, debugfs.node) {
-			if (bo->debugfs.flags & PANTHOR_DEBUGFS_GEM_USAGE_FLAG_INITIALIZED)
-				panthor_gem_debugfs_bo_print(bo, m, &totals);
+			panthor_gem_debugfs_bo_print(bo, m, &totals);
 		}
 	}
 
diff --git a/drivers/gpu/drm/panthor/panthor_gem.h b/drivers/gpu/drm/panthor/panthor_gem.h
index 4dd732dcd59f..8fc7215e9b90 100644
--- a/drivers/gpu/drm/panthor/panthor_gem.h
+++ b/drivers/gpu/drm/panthor/panthor_gem.h
@@ -35,9 +35,6 @@ enum panthor_debugfs_gem_usage_flags {
 
 	/** @PANTHOR_DEBUGFS_GEM_USAGE_FLAG_FW_MAPPED: BO is mapped on the FW VM. */
 	PANTHOR_DEBUGFS_GEM_USAGE_FLAG_FW_MAPPED = BIT(PANTHOR_DEBUGFS_GEM_USAGE_FW_MAPPED_BIT),
-
-	/** @PANTHOR_DEBUGFS_GEM_USAGE_FLAG_INITIALIZED: BO is ready for DebugFS display. */
-	PANTHOR_DEBUGFS_GEM_USAGE_FLAG_INITIALIZED = BIT(31),
 };
 
 /**
-- 
2.39.5



