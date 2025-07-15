Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E824D2D29D9;
	Tue, 15 Jul 2025 13:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586588; cv=none; b=LlRAWteINorqp5dn1Fh9Q+sKAJ+uFO17qou1x3V+c1Blkz8A7hgyTTKjR2a55CuX6ADpZCKHk5fMFRquhAW/ihk+b9ZyS/XliljfYJuoaRcc3QVDziMk7kbyvNwRZxY5PAUk4COMKrJDOgko2n97QLdn2iVmrm+/0SrsMdzQbzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586588; c=relaxed/simple;
	bh=fLK7DZj+un7Xk5fPHkmJJf8fZwhAar6aYXRdPZRp3mU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m279UjTb2Afm1J9+Bwps9dLBwhm60wYP3pt2gARDK3Ob9JfQpCsWPisEDl8M9D+3CbnjnGRFv5XDw2W/I1sXzjMoDx1OGqtSSX/yWCFZWhipIIjaeRC+1VN08p3bKRVXcaLHA7aZdH/+o2D3b1Y8PozppgmNJYNZs8rRlD8q3i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H66ny2rV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H66ny2rV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D18C4CEE3;
	Tue, 15 Jul 2025 13:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586586;
	bh=fLK7DZj+un7Xk5fPHkmJJf8fZwhAar6aYXRdPZRp3mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H66ny2rVy40URhM/TNDxwH0Y/9fPBOClV5plEAFvB87KF5ZXz/Gls/uS1zCNuoez/
	 s5SU8brqAiy+pwdhALI8uS3np/2E1n8f2VS3jdifBkxjeBIK7MQ0hhjiO30nQKUC7s
	 CIQPNgOO0XKzhSFCba8aJrpdMYYvS2hjYx5XSoOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>
Subject: [PATCH 5.4 121/148] drm/sched: Increment job count before swapping tail spsc queue
Date: Tue, 15 Jul 2025 15:14:03 +0200
Message-ID: <20250715130805.145133899@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


