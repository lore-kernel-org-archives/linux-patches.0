Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC9830BF6E;
	Mon, 13 Oct 2025 15:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367798; cv=none; b=jB8DSZjTYDZCnuWl9K63q/1tSQSVf0p/GQN/yQLH6s5doLebl/W5tFx1RjJFcOC4etw7TdYr5eZEEIzkJvSqUUVORMZEC2+OBbWoF9OI8WWbRr94Cx8EAHecssA6ryFgi+7E/nYZSPA5c4hju4sNo2HDiVoa3xLL8py+ji9bk0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367798; c=relaxed/simple;
	bh=Yxd2ZkHNEwMnqr10GPZba+AWEYyRZyruOeIedl1m1KI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oQipVrxRff2TB/nakX/xTgiAI783OZqF1dY+Nl6Bc8QI/2ufW/JdJ0CvNpMfcAFcexpYi6rCt9K28DzzTPhSJV4tVAVt/tYhy2pqD7HtyUAtKgdlFe4AWIqg6dLlx2oqfZjozZTB7NGrqJpz1/hDRDiKEuSUN5Y7uRIoCsmPyzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JVMqW6mG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JVMqW6mG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA605C4CEE7;
	Mon, 13 Oct 2025 15:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367798;
	bh=Yxd2ZkHNEwMnqr10GPZba+AWEYyRZyruOeIedl1m1KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JVMqW6mGl6K+Guccj5N3DJEPk8lzaJeIjgIBlU/8QemVueT+EHtPFNgoba9FRxsYP
	 CX+cKweHJOPt6cyDUbSIUg7aUEe5xEIfNxTOq+2YRkGQs7+nzHqXRdRPAVNb5idC1G
	 I+a9z1b3RoDeANlYUmfNJk4K7cTGg9sXNTpG8hXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 136/196] RDMA/rxe: Fix race in do_task() when draining
Date: Mon, 13 Oct 2025 16:45:27 +0200
Message-ID: <20251013144320.234588369@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

From: Gui-Dong Han <hanguidong02@gmail.com>

[ Upstream commit 8ca7eada62fcfabf6ec1dc7468941e791c1d8729 ]

When do_task() exhausts its iteration budget (!ret), it sets the state
to TASK_STATE_IDLE to reschedule, without a secondary check on the
current task->state. This can overwrite the TASK_STATE_DRAINING state
set by a concurrent call to rxe_cleanup_task() or rxe_disable_task().

While state changes are protected by a spinlock, both rxe_cleanup_task()
and rxe_disable_task() release the lock while waiting for the task to
finish draining in the while(!is_done(task)) loop. The race occurs if
do_task() hits its iteration limit and acquires the lock in this window.
The cleanup logic may then proceed while the task incorrectly
reschedules itself, leading to a potential use-after-free.

This bug was introduced during the migration from tasklets to workqueues,
where the special handling for the draining case was lost.

Fix this by restoring the original pre-migration behavior. If the state is
TASK_STATE_DRAINING when iterations are exhausted, set cont to 1 to
force a new loop iteration. This allows the task to finish its work, so
that a subsequent iteration can reach the switch statement and correctly
transition the state to TASK_STATE_DRAINED, stopping the task as intended.

Fixes: 9b4b7c1f9f54 ("RDMA/rxe: Add workqueue support for rxe tasks")
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Gui-Dong Han <hanguidong02@gmail.com>
Link: https://patch.msgid.link/20250919025212.1682087-1-hanguidong02@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_task.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_task.c b/drivers/infiniband/sw/rxe/rxe_task.c
index 80332638d9e3a..be6cd8ce4d97e 100644
--- a/drivers/infiniband/sw/rxe/rxe_task.c
+++ b/drivers/infiniband/sw/rxe/rxe_task.c
@@ -132,8 +132,12 @@ static void do_task(struct rxe_task *task)
 		 * yield the cpu and reschedule the task
 		 */
 		if (!ret) {
-			task->state = TASK_STATE_IDLE;
-			resched = 1;
+			if (task->state != TASK_STATE_DRAINING) {
+				task->state = TASK_STATE_IDLE;
+				resched = 1;
+			} else {
+				cont = 1;
+			}
 			goto exit;
 		}
 
-- 
2.51.0



