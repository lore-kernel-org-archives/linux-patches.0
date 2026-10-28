Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213377;
	b=jxsvvNggm/5ptXv+GoJXec12AY7duA3xwV6X6CsTl0vbZNl3xSfpvkDAieo95Rv+tC2k
	 EZti9ooFVod1hpcI9kIXJ1jiWQB53oQtAxiMxuVxLlRPegUH3+FLAe9JYjVyZ24xZ85W3
	 jUHdxk6WBsE2zeOFREw6NlWJz4yRAYvaHcChIIXxk64z3RoUgzI0sgT/ww+0O4f+5/ody
	 9UWVZ4GzyP75T82b9L36RT+lvuX3+4wpAiQQO4g3VANGEFKWhyneAL5NO9qfc6echm72P
	 FkwdYElOXvGg1xyjgfRzGzwWi2ygRltMEXpjvKX/caBywi8KReXMQIwr9N2vvXCMHIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213377;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y0uUNveI6bXvPpEyqzv8PT56l+N3tubK7BmpbRplIAs=;
	b=KIGAJ1cijeg2I+O5ceqApqQLKrsH4Vm7Q9sSsWLnJ9wOORxf+uXoIDyUKWzTcG2mnTFO
	 4gC18V1DqnUxdFldrFmd1Tv/YyL+zFRB5yIumdSGBwN0yrhWZJMKV9aF1tFpJQKYW2gp3
	 +8AMXRocTTFNfU9oNJQFV0myTmXgu4Qp4yrFkevRJk5kCImSM9IwcEbPf/xISaBYzb0wG
	 /uCSxjzuQYLpSVb3KF9qnM5H+M8KbspZ46gj0oiNVB/k8b7GHqbbnttj+wPD+Hzmhyxii
	 uW6IJqpP1HTUQLLKIHVs/Ih+ZOQkwlkpoz8uY4m03Z/uQ/+ixBPrhjfdcO6Hn4w2CaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UrpxWT41;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8461606A31C;
	Wed, 28 Oct 2026 18:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UrpxWT41
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E711F01825;
	Wed, 28 Oct 2026 18:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213376;
	bh=Y0uUNveI6bXvPpEyqzv8PT56l+N3tubK7BmpbRplIAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UrpxWT41cTp2esBGyWRbrCE6mm+xgbj5sY30q0P1MRFXb0kQlqEaSSgCGv8IempPk
	 0VNcVSzpfFaFoEXMMZpzK/zRhvKGDaYIw3mnySszBSCV3qAkGdVsp8YE/CqJ/5jz0e
	 Tv+Us763ABIKExCmMFyaM2xJb38QOvMWyjo6woMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavankumar Kondeti <pavan.kondeti@oss.qualcomm.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.1 0440/1887] workqueue: Fix NULL current_pwq deref in chained work check
Date: Wed, 28 Oct 2026 17:42:16 +0100
Message-ID: <20261028170509.244752580@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1382,7 +1382,7 @@ static bool is_chained_work(struct workq
 	 * Return %true iff I'm a worker executing a work item on @wq.  If
 	 * I'm @worker, it's safe to dereference it without locking.
 	 */
-	return worker && worker->current_pwq->wq == wq;
+	return worker && worker->current_pwq && worker->current_pwq->wq == wq;
 }
 
 /*


