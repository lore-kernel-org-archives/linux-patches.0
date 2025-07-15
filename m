Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721D32F0043;
	Tue, 15 Jul 2025 13:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587870; cv=none; b=gFfn9KEZ6ihMsYFPX+khOrNhSzafFevIAq4YXEQwGAQSnHkp6VExhYw+rXb4lsptfi+UQdw/odmxQ2PTBrt1qEknEcLpe8ZAGFqaSLaDXNbQkmVnQdFMIRTew4h5VrWT7dd5NU/i7unj+zF8cJRa6SLQDNi+ZxrTWZcR2aamHi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587870; c=relaxed/simple;
	bh=xyBnJ7iCcPE8ZToIqINQ3ldzvzrlQIr0+kL/lp6vOZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O4PC970mfx72zKCqq70f/a1SdCbktR8wisM/tLxUNczXi7otTqKmSh6g44iWVKlN1Moyj3E8owRKUwpFZ/NG3zOJUV16PWNk4rv7af1Z/RoEmUJpkk7L5QsvG6/Qo0yMqI5ktNYJ82MXJur9eRCyWuMCYj9ypqhD+OTSuoFntKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fruZDe+F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fruZDe+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A8EC4CEE3;
	Tue, 15 Jul 2025 13:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587870;
	bh=xyBnJ7iCcPE8ZToIqINQ3ldzvzrlQIr0+kL/lp6vOZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fruZDe+FZsabF0vjMxYbWE3LH2b6WGaoxjhrP+vuTuR+YP1sX1QW3xucIrNrRd4VR
	 Fv1v4+SHKuHdurWTp/GW/GAbN+lCrkHJKdxt3D2TxnE6pwfs0ZKQometWiTIn4YgzE
	 wtqy2Le4lYblnBVIdLQr+ueU35aptMatndfsufk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>
Subject: [PATCH 5.10 175/208] drm/sched: Increment job count before swapping tail spsc queue
Date: Tue, 15 Jul 2025 15:14:44 +0200
Message-ID: <20250715130817.979962654@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


