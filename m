Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C2838C2C3;
	Sat, 17 Oct 2026 16:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253706; cv=none; b=hCEQDTpGGNS0bECfwjHcgL8Bu0EoI7s2cmuDzL1yS8FLaItFoSft5pG3GFljQSgP6kLQ8J3/+hpfFoceNEw6Aa8f0J3X+5gDffMXP2Bm2q/ReBWd/IEbyEwkWB54BzGZ0pByCp1OS2SKrHcDkETK+qddA3EaYumrUNgriZTWftY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253706; c=relaxed/simple;
	bh=owykMeypf2BfqQ6EsJHj/WIQl2Yh4rFEtWYMqyFzDDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tiK3homfHzn6bZUqAZM2bK8uQagkIwTtl/B4RTUBrz0WsOE+os4bZ4y3w7K6TkuC7iw2ajzGk9eZwiY84Wj3YTfD3kLKNi/cSV0MG8SVYZW2F/dkYgo1LazoYBxf1Uw1uDO8ssyeA/8f4D2+/cOgL5hp4pHiX8LvuRDGxDDCGeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HdbVF/MC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HdbVF/MC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55241F000C4;
	Sat, 17 Oct 2026 16:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253705;
	bh=CWDVKEKPyhpYchf2ywi0oSGf6DDDG9+107C8nZ4JqYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HdbVF/MCJu2GdDMGXPQFhC+mS8nNRNHiuzelAHIiHtMLD5OHiXKl4CtvxC1u88/Lg
	 ZlerC0JRI01YaIHPOW9m+6x0DMHFOA/GPXaiSJVrKgdTgQT8l7j9oZpqPR63180z8M
	 +RTxEtMEgf2NwX0loeF7hqCWz2IgbENQzpVYZyek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Akash Goel <akash.goel@arm.com>,
	Steven Price <steven.price@arm.com>,
	Chia-I Wu <olvaffe@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 163/869] drm/panthor: Prevent potential UAF in group creation
Date: Sat, 17 Oct 2026 17:50:04 +0200
Message-ID: <20261017160041.227371560@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Akash Goel <akash.goel@arm.com>

[ Upstream commit eec7e23d848d2194dd8791fcd0f4a54d4378eecd ]

This commit prevents the possibility of a use after free issue in the
GROUP_CREATE ioctl function, which arose as pointer to the group is
accessed in that ioctl function after storing it in the Xarray.
A malicious userspace can second guess the handle of a group and try
to call GROUP_DESTROY ioctl from another thread around the same time
as GROUP_CREATE ioctl.

To prevent the use after free exploit, this commit uses a mark on an
entry of group pool Xarray which is added just before returning from
the GROUP_CREATE ioctl function. The mark is checked for all ioctls
that specify the group handle and so userspace won't be abe to delete
a group that isn't marked yet.

v2: Add R-bs and fixes tags

Fixes: de85488138247 ("drm/panthor: Add the scheduler logical block")
Co-developed-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Akash Goel <akash.goel@arm.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Chia-I Wu <olvaffe@gmail.com>
Link: https://patch.msgid.link/20251127164912.3788155-1-akash.goel@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_sched.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_sched.c b/drivers/gpu/drm/panthor/panthor_sched.c
index 822b003893a89..c1fc52f1ee426 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -742,6 +742,12 @@ struct panthor_job_profiling_data {
  */
 #define MAX_GROUPS_PER_POOL 128
 
+/*
+ * Mark added on an entry of group pool Xarray to identify if the group has
+ * been fully initialized and can be accessed elsewhere in the driver code.
+ */
+#define GROUP_REGISTERED XA_MARK_1
+
 /**
  * struct panthor_group_pool - Group pool
  *
@@ -3509,6 +3515,8 @@ int panthor_group_create(struct panthor_file *pfile,
 	}
 	mutex_unlock(&sched->reset.lock);
 
+	xa_set_mark(&gpool->xa, gid, GROUP_REGISTERED);
+
 	return gid;
 
 err_put_group:
@@ -3523,6 +3531,9 @@ int panthor_group_destroy(struct panthor_file *pfile, u32 group_handle)
 	struct panthor_scheduler *sched = ptdev->scheduler;
 	struct panthor_group *group;
 
+	if (!xa_get_mark(&gpool->xa, group_handle, GROUP_REGISTERED))
+		return -EINVAL;
+
 	group = xa_erase(&gpool->xa, group_handle);
 	if (!group)
 		return -EINVAL;
@@ -3548,12 +3559,12 @@ int panthor_group_destroy(struct panthor_file *pfile, u32 group_handle)
 }
 
 static struct panthor_group *group_from_handle(struct panthor_group_pool *pool,
-					       u32 group_handle)
+					       unsigned long group_handle)
 {
 	struct panthor_group *group;
 
 	xa_lock(&pool->xa);
-	group = group_get(xa_load(&pool->xa, group_handle));
+	group = group_get(xa_find(&pool->xa, &group_handle, group_handle, GROUP_REGISTERED));
 	xa_unlock(&pool->xa);
 
 	return group;
-- 
2.53.0



