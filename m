Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0DA1DE4FC;
	Tue,  8 Oct 2024 12:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389704; cv=none; b=kYGw141G1SdoyieB3O2RaQbMi9Q3Id6YfpOO6Kf/f0BPZoeeShUwZyFhMYa0Ih1I8LQWq90imnCur0b/AD7mHkoEz4avcbvfxV6eBFmDzgcFS9Y6niYi9yygF+1okObfkQwNy8/s8iv9IX0ZSgHt81enFgqFzj0VLvTmDWCmaMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389704; c=relaxed/simple;
	bh=GwX8FuVKWwzczN/Fc/I1K9Na75pLUL9J8YR73l6/tro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mehQGJWLX1XVumwe3R0bciQXCGl66d8sWACH7zADTaS5ouYQ9r9VF+iRonqRaipiNqo7Obd8JAHJqWDcIvpp9p5Be48511+56de1lZJgOd6QBqoiPeSTYi0EuoTa8lNaS1hoQ5YzJk7sGNcid6jcGf9qfNd1WLr3anC4j4Snc6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PjYYXWv5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PjYYXWv5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2B5C4CEC7;
	Tue,  8 Oct 2024 12:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389704;
	bh=GwX8FuVKWwzczN/Fc/I1K9Na75pLUL9J8YR73l6/tro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PjYYXWv5GQ5jWT/vfCYeg+hM9pImmkL5x/prB0U8CXr148E8Mj4r4vJFKWHND7xFQ
	 5DxbczbIhSIZCCmSgYLAYo173oUWNcNjY9pybWAFra2VNhb+qeMHuYu26ONaeg33Ni
	 fWiDUhLzr0FvxKss9ksFcuDTegRpRwvHZB6l72m4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 054/482] drm/panthor: Fix race when converting group handle to group object
Date: Tue,  8 Oct 2024 14:01:57 +0200
Message-ID: <20241008115650.433421899@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Price <steven.price@arm.com>

[ Upstream commit cac075706f298948898b1f63e81709df42afa75d ]

XArray provides it's own internal lock which protects the internal array
when entries are being simultaneously added and removed. However there
is still a race between retrieving the pointer from the XArray and
incrementing the reference count.

To avoid this race simply hold the internal XArray lock when
incrementing the reference count, this ensures there cannot be a racing
call to xa_erase().

Fixes: de8548813824 ("drm/panthor: Add the scheduler logical block")
Signed-off-by: Steven Price <steven.price@arm.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240923103406.2509906-1-steven.price@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_sched.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_sched.c b/drivers/gpu/drm/panthor/panthor_sched.c
index 12b272a912f86..d21fe63ae2281 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -3242,6 +3242,18 @@ int panthor_group_destroy(struct panthor_file *pfile, u32 group_handle)
 	return 0;
 }
 
+static struct panthor_group *group_from_handle(struct panthor_group_pool *pool,
+					       u32 group_handle)
+{
+	struct panthor_group *group;
+
+	xa_lock(&pool->xa);
+	group = group_get(xa_load(&pool->xa, group_handle));
+	xa_unlock(&pool->xa);
+
+	return group;
+}
+
 int panthor_group_get_state(struct panthor_file *pfile,
 			    struct drm_panthor_group_get_state *get_state)
 {
@@ -3253,7 +3265,7 @@ int panthor_group_get_state(struct panthor_file *pfile,
 	if (get_state->pad)
 		return -EINVAL;
 
-	group = group_get(xa_load(&gpool->xa, get_state->group_handle));
+	group = group_from_handle(gpool, get_state->group_handle);
 	if (!group)
 		return -EINVAL;
 
@@ -3384,7 +3396,7 @@ panthor_job_create(struct panthor_file *pfile,
 	job->call_info.latest_flush = qsubmit->latest_flush;
 	INIT_LIST_HEAD(&job->node);
 
-	job->group = group_get(xa_load(&gpool->xa, group_handle));
+	job->group = group_from_handle(gpool, group_handle);
 	if (!job->group) {
 		ret = -EINVAL;
 		goto err_put_job;
-- 
2.43.0



