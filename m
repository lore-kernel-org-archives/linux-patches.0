Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAEFBA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:13:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC633C433EF;
	Tue,  7 Mar 2023 18:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212783;
	bh=WUG1ZwEXYSO6O1GBcmoMqpZcjtg+A3F1uKJDiGnLUr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jfbaXhYxu20JUOsRX9Qc0Dyn79MJ1J4k1FJhwrZ3SJYbE93BZDMxo9LYyBlO5aCr5
	 3zuFe/3ZIRcxgybTg1VCPU+bfLo9+lzGaMmWAkdZ5inQiqJTXTtgxJTPMAR8j0ovsq
	 JtciHTE59Qs5lSJmSM2l4BU5lPEpdn0BOmGClojs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Liu <leo.liu@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 295/885] drm/amdgpu: Use the sched from entity for amdgpu_cs trace
Date: Tue,  7 Mar 2023 17:53:49 +0100
Message-Id: <20230307170014.897122307@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Leo Liu <leo.liu@amd.com>

[ Upstream commit cf22ef78f22ce4df4757472c5dbd33c430c5b659 ]

The problem is that base sched hasn't been assigned yet at this moment,
causing something like "ring=0" all the time from trace.

mpv:cs0-3473    [002] ..... 129.047431: amdgpu_cs: ring=0, dw=48, fences=0
mpv:cs0-3473    [002] ..... 129.089125: amdgpu_cs: ring=0, dw=48, fences=0
mpv:cs0-3473    [002] ..... 129.130987: amdgpu_cs: ring=0, dw=48, fences=0
mpv:cs0-3473    [002] ..... 129.172478: amdgpu_cs: ring=0, dw=48, fences=0

Fixes: 4624459c84d7 ("drm/amdgpu: add gang submit frontend v6")
Signed-off-by: Leo Liu <leo.liu@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_trace.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_trace.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_trace.h
index 5e6ddc7e101c6..6cd6ea765d37f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_trace.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_trace.h
@@ -153,10 +153,10 @@ TRACE_EVENT(amdgpu_cs,
 
 	    TP_fast_assign(
 			   __entry->bo_list = p->bo_list;
-			   __entry->ring = to_amdgpu_ring(job->base.sched)->idx;
+			   __entry->ring = to_amdgpu_ring(job->base.entity->rq->sched)->idx;
 			   __entry->dw = ib->length_dw;
 			   __entry->fences = amdgpu_fence_count_emitted(
-				to_amdgpu_ring(job->base.sched));
+				to_amdgpu_ring(job->base.entity->rq->sched));
 			   ),
 	    TP_printk("bo_list=%p, ring=%u, dw=%u, fences=%u",
 		      __entry->bo_list, __entry->ring, __entry->dw,
-- 
2.39.2



