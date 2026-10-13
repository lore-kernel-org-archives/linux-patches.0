Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC3F4DDB5A;
	Tue, 13 Oct 2026 11:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892163; cv=none; b=Tn1G/K4KLbpHxpGL9usR0yV5HsjPoI318Us+J0mY++aKTK56llbISaRDNpnbDL5HJODMf1TtphjPm3iNjd4rh/RdyvRs9YN2wXZlhUsKK+MQusE1hzurTlKQj1NTVnKDYlmqCTY4YbTV5/mv3ZwFNA09GPL9t2jr0DpgoLk2WzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892163; c=relaxed/simple;
	bh=6L35tmA1ONkp9w0/qBUWKP59sDbZ/whUScrxKHD/IPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qxt8VHjJ+zAtFxeNmzRBP1tAOnCnM/I/OKNzOJJUbjKSru0aRoldxnR6yPbIL8KSTh9u0Jwc4d9X0tAcqKHfijS+TW2OIeU5otEfYns+/hUZcAJeX7U2EGw9ULS/nx66OXpxz93S7a4/ZvIIIzwBh9yDKs46GYPaxgQ/vgTF4Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ge3Psaz7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ge3Psaz7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 912841F000FF;
	Tue, 13 Oct 2026 11:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892162;
	bh=LJK+WbvmdapZ9BnZD+hAGwq2f26wYsxPgJcPfpTNSis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ge3Psaz790aQ3kFgBGvJZzCM1BRmdE/CBusTWxePWZnCumd7kPxMyVY4bdYQXMTdH
	 xpAI/nvzENJnljIOTJLvsyXVQbdqJ6gXKo21RYyQkZOQ43jooqDVb0ptp139gCyeZD
	 aGbaK5Ja9RCgGMhCnx4mnAnU7pL8VGqAZdU5JVG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavankumar Kondeti <pavan.kondeti@oss.qualcomm.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 7.2 036/281] workqueue: Fix NULL current_pwq deref in chained work check
Date: Tue, 13 Oct 2026 13:35:52 +0200
Message-ID: <20261013112855.929124588@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2244,7 +2244,7 @@ static bool is_chained_work(struct workq
 	 * Return %true iff I'm a worker executing a work item on @wq.  If
 	 * I'm @worker, it's safe to dereference it without locking.
 	 */
-	return worker && worker->current_pwq->wq == wq;
+	return worker && worker->current_pwq && worker->current_pwq->wq == wq;
 }
 
 /*


