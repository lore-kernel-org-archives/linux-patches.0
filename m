Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DA22571AB;
	Tue, 25 Mar 2025 12:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906026; cv=none; b=Q7P/ioEcdmtiYW8ljrZW19Lpqa1RGA2Ho6PDl0vR0yvnTymqgpOO5xHj40OGNiuPePO+gqF7ZfEx57wBWrq0bX2D0pWy8dDr1SoscQwoeopPgreiPFbFUnSbFLB8zu4NzmgH5vD02cQN3Ao+CV6ubDFLT0tyvEbauqwRa5VidUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906026; c=relaxed/simple;
	bh=AFnEYVPAaqWftawgJiR0TQuZ/MuYDxF98kkIkrD9XtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i3AXUrR1zBDXD/5b7RU3pXX2yKVhaisXzLZ3Rae9sYITDrtX/K5SQQEQwI/YyqYO7O89Y2ZgG/qbNMfRLXXwagcRknjXkQqPCRkabDa1pLxsx3qhqLjThxBKa6CgZq10lwBXthJCLn7rfNcRENQaM4BR17qTJmAwM2qiwjC84yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wj3c/pnM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wj3c/pnM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D619AC4CEE4;
	Tue, 25 Mar 2025 12:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906026;
	bh=AFnEYVPAaqWftawgJiR0TQuZ/MuYDxF98kkIkrD9XtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wj3c/pnMJCxVreRtIVodq4ImWikH2dz1aJkSqsEHl0N2WZzSVTjdt1Ty465BMMOBS
	 1F6R6hBARfPNOr6vXJEWgn8O6bSFY5GQRShC8Jpr8h9cO7bFtwFnVpjdbpI2yzejoD
	 6EmisGodcUlYIHBvhEUxM4wAqQ6ZSHmu+RywqCe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	qianyi liu <liuqianyi125@gmail.com>,
	Philipp Stanner <phasta@kernel.org>
Subject: [PATCH 6.13 095/119] drm/sched: Fix fence reference count leak
Date: Tue, 25 Mar 2025 08:22:33 -0400
Message-ID: <20250325122151.488104664@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: qianyi liu <liuqianyi125@gmail.com>

commit a952f1ab696873be124e31ce5ef964d36bce817f upstream.

The last_scheduled fence leaks when an entity is being killed and adding
the cleanup callback fails.

Decrement the reference count of prev when dma_fence_add_callback()
fails, ensuring proper balance.

Cc: stable@vger.kernel.org	# v6.2+
[phasta: add git tag info for stable kernel]
Fixes: 2fdb8a8f07c2 ("drm/scheduler: rework entity flush, kill and fini")
Signed-off-by: qianyi liu <liuqianyi125@gmail.com>
Signed-off-by: Philipp Stanner <phasta@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20250311060251.4041101-1-liuqianyi125@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/scheduler/sched_entity.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/scheduler/sched_entity.c
+++ b/drivers/gpu/drm/scheduler/sched_entity.c
@@ -259,9 +259,16 @@ static void drm_sched_entity_kill(struct
 		struct drm_sched_fence *s_fence = job->s_fence;
 
 		dma_fence_get(&s_fence->finished);
-		if (!prev || dma_fence_add_callback(prev, &job->finish_cb,
-					   drm_sched_entity_kill_jobs_cb))
+		if (!prev ||
+		    dma_fence_add_callback(prev, &job->finish_cb,
+					   drm_sched_entity_kill_jobs_cb)) {
+			/*
+			 * Adding callback above failed.
+			 * dma_fence_put() checks for NULL.
+			 */
+			dma_fence_put(prev);
 			drm_sched_entity_kill_jobs_cb(NULL, &job->finish_cb);
+		}
 
 		prev = &s_fence->finished;
 	}


