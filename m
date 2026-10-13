Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7373438A1;
	Tue, 13 Oct 2026 12:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895855; cv=none; b=J+seL92HIT0O+xwk/8QUC96IsRRal8RWGc4XYQIyLrop4y4YcP3eOBcuptSQwH3ooq8AECqaLjMVKvABAeu8FlLvv0FX3qHLZW7Xjbo/w1BeB3O227fcvbz5l+CIeupmbABiWxw+yzXSuYaujeoBig978UaB39LuvqTUydFlPH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895855; c=relaxed/simple;
	bh=teAFy+5q2lX0caKykspWOl4Ti3IqlJKWSya3a9g3nKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vx0y++dtFuD04wHGRgs+csaxeCtQFlAMoRpd/9HbknOBmGPgQQ2qAMvtyLsqfxR223uycpoKgmH45tBnqZm/DvQca/2/RDI6tVvZWzZtJXeyfjpvsEZ4L1nDvU5U1EnCYldBhRPOTEc8+1gZqbwEu7H8cqrHKqs8yUzkuRZ2t3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jFHko7zE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jFHko7zE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43CBB1F000FF;
	Tue, 13 Oct 2026 12:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895853;
	bh=YkAoUOm2QXZ2pffaRu6hP8N/ywfXcEzOnaMUgeXOv4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jFHko7zEIghffYZog0za0zYAjWTqaIxCEFEFAqoscXGq9JVTtYvzeA+sv+if7gZc/
	 q1hs/7M+3Ye2MYjMWpBVcGDwxyG/ZtaPsIE/a7zEDXvaBQvcfP9EMVmP9nZjiOxhHw
	 h9oh+UjlSicGw3auVOuPLx34HN4AooACZKggAikQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavankumar Kondeti <pavan.kondeti@oss.qualcomm.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.12 371/497] workqueue: Fix NULL current_pwq deref in chained work check
Date: Tue, 13 Oct 2026 13:38:58 +0200
Message-ID: <20261013112916.705198978@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavankumar Kondeti <pavan.kondeti@oss.qualcomm.com>

commit 980db94e3eeefdd8a1c46f86412c33a7f7806f51 upstream.

current_wq_worker() only tells us that %current is a kworker. It does
not guarantee that the worker is currently executing a work item, as
worker->current_pwq is populated only while process_one_work() is running
the work function.

is_chained_work() can be reached while queueing on a draining or
destroying workqueue. If a kworker outside work-item execution reaches
that path, current_wq_worker() returns a worker but worker->current_pwq is
NULL, and the chained-work test can fault before it emits the intended
warning.

Guard the chained-work test with worker->current_pwq. A kworker without
current_pwq is not executing work on the target workqueue, so the helper
should return false and let the draining/destroying warning fire.

Fixes: 8d03ecfe4718 ("workqueue: reimplement is_chained_work() using current_wq_worker()")
Cc: stable@vger.kernel.org
Signed-off-by: Pavankumar Kondeti <pavan.kondeti@oss.qualcomm.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/workqueue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2236,7 +2236,7 @@ static bool is_chained_work(struct workq
 	 * Return %true iff I'm a worker executing a work item on @wq.  If
 	 * I'm @worker, it's safe to dereference it without locking.
 	 */
-	return worker && worker->current_pwq->wq == wq;
+	return worker && worker->current_pwq && worker->current_pwq->wq == wq;
 }
 
 /*


