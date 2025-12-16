Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310E13277AF;
	Tue, 16 Dec 2025 11:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885523; cv=none; b=TVEsgpB5nVevfMmodiyknGZNlJ7peXmSfOqkx9RkcVCUBHqJvqfGvS12gUMnKb5LZql21ohF7E4iGfEYXCIPNlVl869gEgpj4UXk0XR2mgFPBbHcGkZaH2cuCqu3YscW3fYv561G5t/7EaF3JqZE+Xc8tCtYWEb1WWgVbk1kufQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885523; c=relaxed/simple;
	bh=xTyFx4hsX+tCLlXGnyfJbceSgjh8t+VxC+V2/j/D3N4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uPoBuGc2o0S+vwXIQGQzUJ2vLkAckzEN5JAUP7QOJNBjOxG98MEyPNmsqSotbKeN7gzfhLkwfYFmVP8fFtioVYnEyU5qymHFbzjRz3q75sZLWsw67yBCAU8/6AaTCuGRqI/YlKnAjnSlUSgv8CvLzLSdXW74zy4syynlrgvsifI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=padTnTcx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="padTnTcx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF3BC4CEF1;
	Tue, 16 Dec 2025 11:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885522;
	bh=xTyFx4hsX+tCLlXGnyfJbceSgjh8t+VxC+V2/j/D3N4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=padTnTcxiB1yPMR3bMlWlf6NomgKLyUYzim4JZyt4jjuLooAQ4vEA+EXlfhDCgIhY
	 jHeDyIL6vvzOPqskGuFWWAznzXeQdj6m7PSL4+T23vWQ9pcJrXYZ986CfOnpWL05NJ
	 O7N3OBaY24rUhH/LsZMS8r6J6ApXkyFNtX3xAkEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 163/507] drm/panthor: Fix group_free_queue() for partially initialized queues
Date: Tue, 16 Dec 2025 12:10:04 +0100
Message-ID: <20251216111351.425200191@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index a0a31aa6c6bcf..552542f70cabd 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -886,7 +886,8 @@ static void group_free_queue(struct panthor_group *group, struct panthor_queue *
 	if (IS_ERR_OR_NULL(queue))
 		return;
 
-	drm_sched_entity_destroy(&queue->entity);
+	if (queue->entity.fence_context)
+		drm_sched_entity_destroy(&queue->entity);
 
 	if (queue->scheduler.ops)
 		drm_sched_fini(&queue->scheduler);
-- 
2.51.0



