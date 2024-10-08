Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2FFC1DE2AD;
	Tue,  8 Oct 2024 12:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391254; cv=none; b=ORAZPVslsjPd+xiNjDmMxWK9rU7BmiC7U95QluVucPQ6iL9F2fsNBzpP9bGvKxZhZyykYz4NNO1H974yGS2zI9s3+YHc9wLV6DAuJeOoEg0w0SH7NNizKdquMR3xqOU4xNU0E7zNDoxpCgN7gw2BSYnzjV6CNaLl9KZTbvX+MFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391254; c=relaxed/simple;
	bh=ENf+d9H2D5FyBQnbr56eP6fdTKvxohqSbVvRmpZzPMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AG7+64i+XhUoK+Tu/tjNMJg8k5+bPji7e0NSt1fxSeHb/bN6y/XOGckrsqsHxjBExH57HBTITuHLhB6RB4q5cuGgrqpEnn/+S5uxOPeRQpWMZdHv+3uaZ8tL6c5bAJrDQeMNGI+4NTJZaRNzDP1rOSC4GsoGhUnPZZUhD8eOhMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MZh7Ht3f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MZh7Ht3f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E685C4CECF;
	Tue,  8 Oct 2024 12:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391254;
	bh=ENf+d9H2D5FyBQnbr56eP6fdTKvxohqSbVvRmpZzPMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MZh7Ht3fcSAz7eGJKb+H+ceTxGKOVfmOdxcHO4PpoeihILWcIq6KhYTuKjYunyXRV
	 YpaQOtSEXvED2rOVZqvzUaxvike6gAGwb927sLb1g1WwDbZBzVVWgAzAbbVr1fv4IK
	 Cu0si1glUa+uS11G+XQwI+RM7IoxkVTeA0iYpyLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 056/558] drm/panthor: Fix race when converting group handle to group object
Date: Tue,  8 Oct 2024 14:01:26 +0200
Message-ID: <20241008115704.424529697@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



