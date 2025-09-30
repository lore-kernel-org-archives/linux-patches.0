Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16C516A956;
	Tue, 30 Sep 2025 15:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759246140; cv=none; b=D+40E1rKPnPhymJ9iFAYZ5MFKEtNSlAnI2VpIkzfwElss1LGYwTgj+0MnKS3MBAKzofKVtypCJAyjh//nIkgl3uMvYGef5Puzk969tjDibMJRNqcsXp+oJDsYz0zxjTz0Sa3btmLKU2ZXoLcOsmrLOWpgPOTgKOde4OvI1/FyKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759246140; c=relaxed/simple;
	bh=jgldId6h/QPfRjBMSW7XcNFrEcWB8DmQeODxcywOk44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N46hUIiSapvtqjZugxfMNWJFyK69oov3/SK7sZEXxAey9E7r++WUwc7RaqqAOl0QbRGaqOikbaCDemfhQx18Wmpft2n4D3/r5hlYwHmhLp6F3EF8b+GbahxJ1fQ+xsLEx4GTzRpDnw7f4q3D9uSJ7+/7qpAzlUt20rVc3YePNQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xYPf1mH5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xYPf1mH5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58013C4CEF0;
	Tue, 30 Sep 2025 15:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759246140;
	bh=jgldId6h/QPfRjBMSW7XcNFrEcWB8DmQeODxcywOk44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xYPf1mH5zN+fUrKSiJFuzulP0asKDIVqwqm9esPcCnsQNeOlQxRCeDJJ6SJoVxgMi
	 Hk9ubPLvhdx91J+GlFgq7r1Y7SUTQzZaHlk+OeocEAh7K3LvfqKSG0di9hOZHcutK/
	 0uzyR7St3Z/UUjrFDY670XChuHislijRVqmdBSRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 63/89] drm/panthor: Defer scheduler entitiy destruction to queue release
Date: Tue, 30 Sep 2025 16:48:17 +0200
Message-ID: <20250930143824.521587453@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrián Larumbe <adrian.larumbe@collabora.com>

[ Upstream commit 7d9c3442b02ab7dd3c44e20095a178fd57d2eccb ]

Commit de8548813824 ("drm/panthor: Add the scheduler logical block")
handled destruction of a group's queues' drm scheduler entities early
into the group destruction procedure.

However, that races with the group submit ioctl, because by the time
entities are destroyed (through the group destroy ioctl), the submission
procedure might've already obtained a group handle, and therefore the
ability to push jobs into entities. This is met with a DRM error message
within the drm scheduler core as a situation that should never occur.

Fix by deferring drm scheduler entity destruction to queue release time.

Fixes: de8548813824 ("drm/panthor: Add the scheduler logical block")
Signed-off-by: Adrián Larumbe <adrian.larumbe@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://lore.kernel.org/r/20250919164436.531930-1-adrian.larumbe@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_sched.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_sched.c b/drivers/gpu/drm/panthor/panthor_sched.c
index 20135a9bc026e..0bc5b69ec636b 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -865,8 +865,7 @@ static void group_free_queue(struct panthor_group *group, struct panthor_queue *
 	if (IS_ERR_OR_NULL(queue))
 		return;
 
-	if (queue->entity.fence_context)
-		drm_sched_entity_destroy(&queue->entity);
+	drm_sched_entity_destroy(&queue->entity);
 
 	if (queue->scheduler.ops)
 		drm_sched_fini(&queue->scheduler);
@@ -3458,11 +3457,6 @@ int panthor_group_destroy(struct panthor_file *pfile, u32 group_handle)
 	if (!group)
 		return -EINVAL;
 
-	for (u32 i = 0; i < group->queue_count; i++) {
-		if (group->queues[i])
-			drm_sched_entity_destroy(&group->queues[i]->entity);
-	}
-
 	mutex_lock(&sched->reset.lock);
 	mutex_lock(&sched->lock);
 	group->destroyed = true;
-- 
2.51.0



