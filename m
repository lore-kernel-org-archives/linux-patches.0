Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D1E2F6167;
	Tue, 30 Sep 2025 15:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244826; cv=none; b=mD3934pMPmVhlRVwVtdWxUakD6alJE3gWA3UPscu6UnVmE1Re54oAsVeapqwh++1PO1PWNhXKkJxsrswBUqqU4+jd158+TJ5Exwpw/X9fuyfTFJgLuolzNzbKRtWDpbHMyx4ifVHmRIbcxl7IJ7wYJckP9uw/lcED5emDZu77KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244826; c=relaxed/simple;
	bh=fG2WSxqhzefKadTaM8ytUR0GT4yNtvlCTxDt4Ahz2Kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R+y9unpNqsnm497b/SNTqP5sS9vt81nKhQ2o1avQddiG3PiJ0YRc0ndaD+LLCZiZBYxhn5TtXxCq2yJEAQ0G3L1FriNhC/tKMqKMsNndy6DU66fVpim50Sxdbkq7KOrybfVaX5MB4JiaKJXj7xZ3N1FLMErjzjJoQgl0OvGSVSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jSrXNxwb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jSrXNxwb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19035C4CEF0;
	Tue, 30 Sep 2025 15:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244825;
	bh=fG2WSxqhzefKadTaM8ytUR0GT4yNtvlCTxDt4Ahz2Kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jSrXNxwbVY+hPYStAXsX9enn4hK4Usa0XHFpBhXSXMi+1rzC3V0xqextb962AWrVe
	 ifTKrCXYY9D1fKSkguhn4kV1bnFATmZ2d6VWiTufmWIGMGI9qKPMJ6Zzuihc1sC5x2
	 NQ3ABiu4Mi7pbmNfWmfydZ/anBIkTDGw5/naI+Hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 094/143] drm/panthor: Defer scheduler entitiy destruction to queue release
Date: Tue, 30 Sep 2025 16:46:58 +0200
Message-ID: <20250930143834.974065287@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 43ee57728de54..e927d80d6a2af 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -886,8 +886,7 @@ static void group_free_queue(struct panthor_group *group, struct panthor_queue *
 	if (IS_ERR_OR_NULL(queue))
 		return;
 
-	if (queue->entity.fence_context)
-		drm_sched_entity_destroy(&queue->entity);
+	drm_sched_entity_destroy(&queue->entity);
 
 	if (queue->scheduler.ops)
 		drm_sched_fini(&queue->scheduler);
@@ -3558,11 +3557,6 @@ int panthor_group_destroy(struct panthor_file *pfile, u32 group_handle)
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



