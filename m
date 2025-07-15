Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B872E2657;
	Tue, 15 Jul 2025 13:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585532; cv=none; b=RBAz03R1BQeZ0noT3z/uYPMgWV8bDL6BoLi7xV4R+KeLevpfqqYSbu9LbYReOPfXX/NRRkIWWPfJBvlpOAqp8fuYnZovf4fkCgVuuBqHYFQDd2CkPQ8RLoRgdZedO+OCX/uLKasxcF9VWUQ2g+jW8xIeuJsy+aCmdWMoGO4LIg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585532; c=relaxed/simple;
	bh=hdRqsUUBUDy3+qD+imm0FxMlaCMTR6siVMoIC4GBpiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tKl0gF/nihIUlsBHIgONtsjfE3L0sxND+MTVQkl/aAvyjbb0GqaXtAMJ9XMPWN39G/lzVmTidm3bvmYEO58bka/pLreOWCRokn7IOSw+T3lMk3Z9YwkvxBEKyW9c05EwIYegnrBrBlKqi6qhICI9gzc0o9SPxOUbCmbJf+m8gMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=amID4KTQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="amID4KTQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C8F2C4CEE3;
	Tue, 15 Jul 2025 13:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585532;
	bh=hdRqsUUBUDy3+qD+imm0FxMlaCMTR6siVMoIC4GBpiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=amID4KTQJeHe+gwEBSHI1sWrR+LkWdUYY+S+CzTdFILmqsW59sbtGqqvbeF/+X39G
	 qgIyo4m3CqIinZfeYC0yDO/ReDyb/XrPMBKJV8+uQxMnX+c0DXSp7GcDKFJpVoKJbz
	 wdEnt2HpeR0o9jlLrgRvqXZjsyW7Pf82E/Kaj7/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>
Subject: [PATCH 6.12 075/163] drm/sched: Increment job count before swapping tail spsc queue
Date: Tue, 15 Jul 2025 15:12:23 +0200
Message-ID: <20250715130811.744934235@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


