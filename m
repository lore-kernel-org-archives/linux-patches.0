Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CAC81A76B4;
	Tue, 30 Jul 2024 17:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359900; cv=none; b=H3VjJFdiah6IYc7OR2RXkk4ZcxT4BEgPvhb9mgUwKQ2TjGz5BiPqz0dVeFBiuuukTn1FaaOhm36e+CHjqhJi/j7YwU3dnfEdBkbsq2H1EHvrRgR+KkR0pJL9NDqZYn4w6nobhD9ByczJ95LK3OPxILRHm+co8tqzJk8eekP6K1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359900; c=relaxed/simple;
	bh=5p2EiN/a0DtftaLEryc2Q0sbeiPbsCzul6ooBFVJBqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqoJ6Gz0HWTdRxxnLF/RDFxrsAuA3WM9CWK/0NKnyVQHh++supZLlQXufu2hbr6B0KFbgMwxgUVTr7DXYAy+8A6wTRQYUFSFUbHo/eHPmIXbQaRLiLIrAkT+bNpfK7eEEfqMP77sI/kP2lENJq6hdh8XQAaeq05Jf1SbXN1IoAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JLajuQcY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JLajuQcY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 151DDC32782;
	Tue, 30 Jul 2024 17:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359900;
	bh=5p2EiN/a0DtftaLEryc2Q0sbeiPbsCzul6ooBFVJBqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JLajuQcYrD6Y8K84bJnwi+EB38OD4sN1kLnWxCH8fAlipjBfcq4R8AvQwidpDHb99
	 bKEVUKZwyZkQIDyXT25F1iP2IjAmGX3jzbtNzUgfBNuWs6J8f3/KNqGMRFEOoWF6Us
	 z2WJlMRynDw1cnE6A1UicwvkYeDdD60LeI0hflXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.10 551/809] workqueue: Always queue work items to the newest PWQ for order workqueues
Date: Tue, 30 Jul 2024 17:47:07 +0200
Message-ID: <20240730151746.519009290@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

commit 58629d4871e8eb2c385b16a73a8451669db59f39 upstream.

To ensure non-reentrancy, __queue_work() attempts to enqueue a work
item to the pool of the currently executing worker. This is not only
unnecessary for an ordered workqueue, where order inherently suggests
non-reentrancy, but it could also disrupt the sequence if the item is
not enqueued on the newest PWQ.

Just queue it to the newest PWQ and let order management guarantees
non-reentrancy.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Fixes: 4c065dbce1e8 ("workqueue: Enable unbound cpumask update on ordered workqueues")
Cc: stable@vger.kernel.org # v6.9+
Signed-off-by: Tejun Heo <tj@kernel.org>
(cherry picked from commit 74347be3edfd11277799242766edf844c43dd5d3)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/workqueue.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2298,9 +2298,13 @@ retry:
 	 * If @work was previously on a different pool, it might still be
 	 * running there, in which case the work needs to be queued on that
 	 * pool to guarantee non-reentrancy.
+	 *
+	 * For ordered workqueue, work items must be queued on the newest pwq
+	 * for accurate order management.  Guaranteed order also guarantees
+	 * non-reentrancy.  See the comments above unplug_oldest_pwq().
 	 */
 	last_pool = get_work_pool(work);
-	if (last_pool && last_pool != pool) {
+	if (last_pool && last_pool != pool && !(wq->flags & __WQ_ORDERED)) {
 		struct worker *worker;
 
 		raw_spin_lock(&last_pool->lock);


