Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026CE1649C6;
	Tue, 30 Jul 2024 17:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360638; cv=none; b=pKuS97QOIItsx7F/WI3/kptm1zGsp7F8aWUT43DmWgZzIwOhREaFYT/jrygIBssYtEwpKv2SMfyPB9L1lG0VQNsoAnZsFmTyah999b00bdwGjEijxuj9pCdDd/sH62evzCORaUl/DtHxydtQq639haoCHr2OoZV/07Ivh94BeHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360638; c=relaxed/simple;
	bh=cX7O+DmRp3bVPqn3/txwWWEtWz4OkWP3rZH7SmSSos0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hxpnLM+hWWK0DXvVm8B1xRWopPXfX6w53VqSy862KC9Mbmho2hD7g0F8TiLrCrvjmsYEXucvaUGB13zpJzYk/CXwsZMQUzHOR1/ceDlWtvjQBjpYczGtHZGqgWV9fkP2YeISMOLkAaNumA8dsImyaQZC6p55G6MV2PvBj/eMqpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hdJc23gl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hdJc23gl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D4AC32782;
	Tue, 30 Jul 2024 17:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360637;
	bh=cX7O+DmRp3bVPqn3/txwWWEtWz4OkWP3rZH7SmSSos0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hdJc23glRz0bzh21h2us1MNDo/iq8eEW8XBsVuNkybTEhUTNyp+4P8qS6zYgbojL2
	 cYVeedQiU5/7Sl91LUTKwt+0f5yP/Mhf5vfmiclUf6w0twjKoALzut3pCLpG4b0l1Z
	 SBLEwQgbRcdHVBXnr3vBKBhJ/BUHee8b563Dr5y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Stach <l.stach@pengutronix.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Christian Gmeiner <cgmeiner@igalia.com>
Subject: [PATCH 6.10 729/809] drm/etnaviv: dont block scheduler when GPU is still active
Date: Tue, 30 Jul 2024 17:50:05 +0200
Message-ID: <20240730151753.734946719@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

From: Lucas Stach <l.stach@pengutronix.de>

commit 704d3d60fec451f37706368d9d3e320322978986 upstream.

Since 45ecaea73883 ("drm/sched: Partial revert of 'drm/sched: Keep
s_fence->parent pointer'") still active jobs aren't put back in the
pending list on drm_sched_start(), as they don't have a active
parent fence anymore, so if the GPU is still working and the timeout
is extended, all currently active jobs will be freed.

To avoid prematurely freeing jobs that are still active on the GPU,
don't block the scheduler until we are fully committed to actually
reset the GPU.

As the current job is already removed from the pending list and
will not be put back when drm_sched_start() isn't called, we must
make sure to put the job back on the pending list when extending
the timeout.

Cc: stable@vger.kernel.org #6.0
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Reviewed-by: Christian Gmeiner <cgmeiner@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_sched.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/etnaviv/etnaviv_sched.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_sched.c
@@ -38,9 +38,6 @@ static enum drm_gpu_sched_stat etnaviv_s
 	u32 dma_addr;
 	int change;
 
-	/* block scheduler */
-	drm_sched_stop(&gpu->sched, sched_job);
-
 	/*
 	 * If the GPU managed to complete this jobs fence, the timout is
 	 * spurious. Bail out.
@@ -63,6 +60,9 @@ static enum drm_gpu_sched_stat etnaviv_s
 		goto out_no_timeout;
 	}
 
+	/* block scheduler */
+	drm_sched_stop(&gpu->sched, sched_job);
+
 	if(sched_job)
 		drm_sched_increase_karma(sched_job);
 
@@ -76,8 +76,7 @@ static enum drm_gpu_sched_stat etnaviv_s
 	return DRM_GPU_SCHED_STAT_NOMINAL;
 
 out_no_timeout:
-	/* restart scheduler after GPU is usable again */
-	drm_sched_start(&gpu->sched, true);
+	list_add(&sched_job->list, &sched_job->sched->pending_list);
 	return DRM_GPU_SCHED_STAT_NOMINAL;
 }
 


