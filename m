Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85EC526A1C5;
	Tue, 25 Mar 2025 12:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906177; cv=none; b=WagNvP6MiM2vx1s3iPGJ7z4jgfm7GTS0/5YEaKUEbRk5g0K4nhkC/htXoVkv86+G7Ph7Af82DH+3fzKkBJW9fVie/iIw+rn01ITEvZR97Uphy1Qim5JDhN0eqWagolu4EACEO3Jo2ntlVZFjzVlysHKSUMTr1f8Efg1EhvUgWQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906177; c=relaxed/simple;
	bh=aFPt36b88bu/IS2oPE/0m/mpGF4Ik3SGQMiA60dE9rE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8faI/d9DcLUZYQjznKQ4QgOQTmeY/lBpmh8pHAP2OZIZmndsxClFMwkCip9YQaLMoLlLXjlPfuvz8LwWdDPi+qSNLSHknEzCVXPozUKKdB8VI8bhTp22GtSg/EKb1r30luFjtuxSGXdWGNWi/pOz8qtpCDS2UkF2WRclcwQbF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W6fXubfj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W6fXubfj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3873EC4CEE4;
	Tue, 25 Mar 2025 12:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906177;
	bh=aFPt36b88bu/IS2oPE/0m/mpGF4Ik3SGQMiA60dE9rE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W6fXubfjzI0o0w9aFA/fXxlWNCR9He8JHF4+7al9v78ScZJUGiNMB8iACmaCT/PzC
	 iWOw52zJEoOCYIDz/Ckr90OSvly5vnJVv1SJ3iWewgtVZ1L09xgjEQcEdr7NE0FUZ+
	 R630t8WzVAzRhTk4aottstLhoSAKQdrBq7VoEfek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	qianyi liu <liuqianyi125@gmail.com>,
	Philipp Stanner <phasta@kernel.org>
Subject: [PATCH 6.6 56/77] drm/sched: Fix fence reference count leak
Date: Tue, 25 Mar 2025 08:22:51 -0400
Message-ID: <20250325122145.817427302@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -237,9 +237,16 @@ static void drm_sched_entity_kill(struct
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


