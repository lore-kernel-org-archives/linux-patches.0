Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B3C3976BA;
	Sat, 17 Oct 2026 17:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257184; cv=none; b=b5vCgli5KduZhO1SYQQ4nUS6Bf1PxO9POllD042oTI5MyPJdflWWt5RWAZ3UMH3wgJGtdyg3Dh6Xb7Jp20eXCzmntT6ACm9NYftUFZW0LR7tcMupOY4SBo6kr8525Q7aXjcBpKGujZo0duRXcoyA5zQ9gMu0hxBVb0I3HzI9/H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257184; c=relaxed/simple;
	bh=QmJSL+CYKmkjQEzkVKE0AVZBmhLwaKW2axQA33AELm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RHZ6sy0jQX/YoYlyULRinbGH+xZS8OmOSrl6471cWwbxecvnOREFv6Q689A0zDnw4JNdeJ47F82pL2vOlgeSScHKZ9NAXklQAOXjNO09dyq7KNWt1wuboiyYl0tHao7MH/pqC9bDnZeZzqNGw9qlNoHlLzmY97mOx1odl5LTu1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hc2NdsU8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hc2NdsU8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFFEB1F000C4;
	Sat, 17 Oct 2026 17:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257183;
	bh=AFNloL5iaNh3LRGlI8yjG0vUSNOonQHQff/AYi6pmj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hc2NdsU85CmNEp/GuBQdG4XAoPeUklOOR9hCj+VcE6MIzQfUr2QMN8f5RvYYLhHc1
	 LeJGnDHtEa/XyGjGwfGjS6IAYI7zYatwh6wb8daOy+16oqlCC7dGa2tXzVzpXZBazL
	 kw1Szqb93QhMiggMN6tFIgUS6gAlAE7SNrcIKvHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavankumar Kondeti <pavan.kondeti@oss.qualcomm.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.6 0476/1674] workqueue: Fix NULL current_pwq deref in chained work check
Date: Sat, 17 Oct 2026 17:45:48 +0200
Message-ID: <20261017160443.332414103@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1692,7 +1692,7 @@ static bool is_chained_work(struct workq
 	 * Return %true iff I'm a worker executing a work item on @wq.  If
 	 * I'm @worker, it's safe to dereference it without locking.
 	 */
-	return worker && worker->current_pwq->wq == wq;
+	return worker && worker->current_pwq && worker->current_pwq->wq == wq;
 }
 
 /*


