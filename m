Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312E84FDA4C;
	Tue, 13 Oct 2026 12:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892887; cv=none; b=TwRhjwSS4Dhi+WRJJRdOXyeTINH/JyuVLPsYEkhNj+GdFJIURjN5zx/3iPD8yJVgf39yKCFtCX3ZvSZFi+oH6AHVa6KpnTt7jUGJLa+E+dFe2yImRO/KgTHlKzj+FS8ZFSkdwX1gJcNJ7fmuHqNDIOXcFXjWkuuTBWKbqYOF57o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892887; c=relaxed/simple;
	bh=5EkdB+xc5YtB6yypRJDEdn6VO35RDR+mo+kUytVQFRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LAXt1HLnySZ9OSVGsW4IUZJV758PYmkCBYBEnJQcvJkIb5g9XvX/pAOKvRMzhbcvxuoYkUjdIJsVhBxeQ+SsRq3gt2FERctz6T+9S8b6shQUsFuSwskVFn0OsR9wVd7T6qarkXeyRbuo4Xy7ZgI0XNFtg+3Ar2Vf06BJprTfrBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RoP6gLOf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RoP6gLOf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 867911F000FF;
	Tue, 13 Oct 2026 12:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892886;
	bh=+nPq54Hu1b2EAcQgR7TLWsUc4jC5oaD2JVMOQkyeKt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RoP6gLOfTvBvoZ/4r65WTOmE0vBsahWqeuvlvvB7ddmZt4vzuNorYm+yECtvQH0j6
	 9JeTefmF8tYa8iWPPMVTg1/vv1lYIupJQXdb7WAV+7RlMavWfDu5sipKQFIhjJbMvZ
	 7Om68gviy3khRs8DlD0ONrRbPF4mPyKL4JuuXtqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavankumar Kondeti <pavan.kondeti@oss.qualcomm.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.18 041/621] workqueue: Fix NULL current_pwq deref in chained work check
Date: Tue, 13 Oct 2026 13:30:36 +0200
Message-ID: <20261013112921.838147598@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2235,7 +2235,7 @@ static bool is_chained_work(struct workq
 	 * Return %true iff I'm a worker executing a work item on @wq.  If
 	 * I'm @worker, it's safe to dereference it without locking.
 	 */
-	return worker && worker->current_pwq->wq == wq;
+	return worker && worker->current_pwq && worker->current_pwq->wq == wq;
 }
 
 /*


