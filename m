Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09350341069;
	Tue, 16 Dec 2025 11:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884169; cv=none; b=gWjQIWEB70K/M5lNCqb8jR5dytfVFKqjsve6dKHoVnsX+DtzLix2wT4u8OTdAcqdythPZSpQijQnsjeDg9yDb0sRK4gHQtEZfi0diNKyIC/TMxcZ6fkJtB/bWrHwmqDvVahzpsjOGbRvE8KdlSht3quUcqKK0Dtor1QGTHawEgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884169; c=relaxed/simple;
	bh=Q2f9VFPbfDJkrAKfUZGKEz220GgktzLPCsZb3hoVywc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NSP6wcAv2fjomM1pbrbjvJMo2+6KGbBDRumASXSyXb1Lx1Ziy+IFb5snT7jU7PWA1wi43kDIjQPGiNG5LyNzUuBpqIu2BPnKVnjR7SZBbjhvQ3xyScZBENkZ60dTG4l6DPhTxhAbje7znF70PCWaE8DkwIO/BVNdVdsn8xRL7mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vc2z5Ql4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vc2z5Ql4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80094C4CEF5;
	Tue, 16 Dec 2025 11:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884168;
	bh=Q2f9VFPbfDJkrAKfUZGKEz220GgktzLPCsZb3hoVywc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vc2z5Ql4draZWOxUvfbwZMRRHKghTZI2vgrEtTH3banxAKCuNO+i91WoyS2KdMp08
	 gekmE5c7MxkLeADPXueFYWKbR3+V8Zn4tFGOZuaxq1//mOC5WqcoqgNJbeP9K3l6YM
	 ihU82iy2j1grkIozDLDMeztWWrBh5E74/OuTUvf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 113/354] drm/panthor: Fix group_free_queue() for partially initialized queues
Date: Tue, 16 Dec 2025 12:11:20 +0100
Message-ID: <20251216111325.016712035@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit 94a6d20feadbbe24e8a7b1c56394789ea5358fcc ]

group_free_queue() can be called on a partially initialized queue
object if something fails in group_create_queue(). Make sure we don't
call drm_sched_entity_destroy() on an entity that hasn't been
initialized.

Fixes: 7d9c3442b02a ("drm/panthor: Defer scheduler entitiy destruction to queue release")
Reviewed-by: Adrián Larumbe <adrian.larumbe@collabora.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://patch.msgid.link/20251031160318.832427-2-boris.brezillon@collabora.com
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_sched.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panthor/panthor_sched.c b/drivers/gpu/drm/panthor/panthor_sched.c
index 875b9a78d34bc..81ea3a79ab49c 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -865,7 +865,8 @@ static void group_free_queue(struct panthor_group *group, struct panthor_queue *
 	if (IS_ERR_OR_NULL(queue))
 		return;
 
-	drm_sched_entity_destroy(&queue->entity);
+	if (queue->entity.fence_context)
+		drm_sched_entity_destroy(&queue->entity);
 
 	if (queue->scheduler.ops)
 		drm_sched_fini(&queue->scheduler);
-- 
2.51.0



