Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74AC81EEA5D;
	Tue, 15 Jul 2025 13:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586891; cv=none; b=cNGpu/DIvDN8E5pj9pkiMGhwwl3H5SEHY46xX4T/6o5BbOiDCEjHHVO0t1n1SKQMybCgDR4tnoqahy4q7daj6DbtkfqulQPMH8TWRNfpw37EwJT9BinRNsuxHuFDqDDrTXizFLJDId1DQnrTijoQ4jNeVNmCpKEjT7ksy2H/sdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586891; c=relaxed/simple;
	bh=jMkjv4K6bdPK+jRam1kIEETLIOi4ka8BG/gH0dQJ12s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fg6aryG+VE9IQx7bcj3auKTOsFVpVt7BJCGeaL7BS3d7OSrRLo8Vm4/YUu3/qVXvSxfzWfglC2fbTYfmsFIY6AdWo6+oHpAsj2oef2fi6pzzeiTiPqZ1wfYbntovwHVxZXiez3m7JzdBudKrncxb4cMZ0FWzZS5ZOMOBeKB4Olo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CpAEOgd4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CpAEOgd4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E97C4CEE3;
	Tue, 15 Jul 2025 13:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586891;
	bh=jMkjv4K6bdPK+jRam1kIEETLIOi4ka8BG/gH0dQJ12s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CpAEOgd4fM8xZ62oEoRYPaZ4XiZZ0PusjduG0GyIFbbNLK5b4BvYlM8Bg4UiNAB7p
	 3kM4kwzSgqsfJKQ0zkvsurnalOgCChKWbW7Yu8qWwnqP8wFQAubP0u0Xfzg9oQSea+
	 TtpeOPrVn4t5PkOAi1g8NkCOSXrjZ3lV5cm7LXdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>
Subject: [PATCH 6.15 086/192] drm/sched: Increment job count before swapping tail spsc queue
Date: Tue, 15 Jul 2025 15:13:01 +0200
Message-ID: <20250715130818.366303572@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Brost <matthew.brost@intel.com>

commit 8af39ec5cf2be522c8eb43a3d8005ed59e4daaee upstream.

A small race exists between spsc_queue_push and the run-job worker, in
which spsc_queue_push may return not-first while the run-job worker has
already idled due to the job count being zero. If this race occurs, job
scheduling stops, leading to hangs while waiting on the job’s DMA
fences.

Seal this race by incrementing the job count before appending to the
SPSC queue.

This race was observed on a drm-tip 6.16-rc1 build with the Xe driver in
an SVM test case.

Fixes: 1b1f42d8fde4 ("drm: move amd_gpu_scheduler into common location")
Fixes: 27105db6c63a ("drm/amdgpu: Add SPSC queue to scheduler.")
Cc: stable@vger.kernel.org
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Link: https://lore.kernel.org/r/20250613212013.719312-1-matthew.brost@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/drm/spsc_queue.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/include/drm/spsc_queue.h
+++ b/include/drm/spsc_queue.h
@@ -70,9 +70,11 @@ static inline bool spsc_queue_push(struc
 
 	preempt_disable();
 
+	atomic_inc(&queue->job_count);
+	smp_mb__after_atomic();
+
 	tail = (struct spsc_node **)atomic_long_xchg(&queue->tail, (long)&node->next);
 	WRITE_ONCE(*tail, node);
-	atomic_inc(&queue->job_count);
 
 	/*
 	 * In case of first element verify new node will be visible to the consumer


