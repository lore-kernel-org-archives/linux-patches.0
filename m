Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D597B2E62A8;
	Tue, 15 Jul 2025 13:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585967; cv=none; b=Vv1aQdlOCz5ZQDRvD292bxATHPvFwoCCuWnVwi3hSgyKg+gRin/C9oEnuroFmmF8jB3VAuYXy8FH2eQ+ROzZP1+D96K4+IosM8O2qC21qSH/l9uB0ArEWK/axmqTti7jfpR3Y46FJfqUhq/cAAGfnMJjlCso+MiCvdQLJZPTO3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585967; c=relaxed/simple;
	bh=NJajUqDZHgUiwhvhHtWL3/mfHSQCCcJWsRABP9KyokQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZFePx5eSPkURu0sO7DnMmmZ5l52LKdgj3Uh617AperGgAEzNWNXrvWAcga6OWH/mASI2yJvX5aKsI5zU+zp7GchX7FCUM1u5TM825wQ/pnf9m/ioFISCP7xK1lwL0uoQKI0UTyECJC930A/BDPzZgiIOo1EDFuTNVSrt8akT90A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JjUBpXZ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JjUBpXZ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05CFCC4CEE3;
	Tue, 15 Jul 2025 13:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585967;
	bh=NJajUqDZHgUiwhvhHtWL3/mfHSQCCcJWsRABP9KyokQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JjUBpXZ4r44LPYGmrFNLPg+OeQzgZ6XsMKo4gkzT4AL5YrjpTFrOKLveFa7+ktJxv
	 zf0FZtMeZv2v9kz7X72PkwIZ86EgcvvL0IBmzmqcQTgH8wM5Gg7g8eT1Ow/SPsuEor
	 Kvow4aEMwnJ380UyruaCDoIAo8yjhKhog3lgIT/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>
Subject: [PATCH 6.6 044/109] drm/sched: Increment job count before swapping tail spsc queue
Date: Tue, 15 Jul 2025 15:13:00 +0200
Message-ID: <20250715130800.644336063@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


