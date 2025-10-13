Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4858230CDA8;
	Mon, 13 Oct 2025 15:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369933; cv=none; b=WmpGtXkTa43t35znSWtsQ8nVzde7fhtvYGQZf4pQ/hfxBZtRT+657KYqDXc9pnEFh68qAHH2Mkur1CfN5ffx4P+dno2bFqihpRsARCcR7s0rEu2m8e4ONknXL5LSRtosQ4NcQAno/3dFQPKgxkV9RGQqSxntAL3Wqg6DsK5yOKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369933; c=relaxed/simple;
	bh=0nnRk5M36By0Dytj9lnD0AVq2IJ0saHCfLSWigftsuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dh/MKvSA7z81Iu39R7JZ9V9aHMEtOyWHz4N1IVDrBxrcXjSmxyKO4VwqgjLA9S8oMeC7Q5/3RIK7Hqi33+yFcqreGAjzteYvUeeL8udAYtfaYX8TY4ufpII+/2hjrOxhoIUiqk+YYt6eWDV4UdM4qT4pnOWaRYv0PeE8xd7D9fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yEKlxHVJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yEKlxHVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE71BC4CEFE;
	Mon, 13 Oct 2025 15:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369933;
	bh=0nnRk5M36By0Dytj9lnD0AVq2IJ0saHCfLSWigftsuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yEKlxHVJFWVoUezAmAzZpKXW3eeydtr8mIj0UHD0Ble0X6GkudcTzHimYDPFDv8GY
	 oATzK+AuHQ0ic4OhB/xy1DOmRcA2lt9SKilXrFlHDWKcW1jCIOlWYuzPcQyBDstTr/
	 KkllB0OZScCVHj6KNN9ratzMCZe5bjg3+LBFleNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 412/563] RDMA/rxe: Fix race in do_task() when draining
Date: Mon, 13 Oct 2025 16:44:33 +0200
Message-ID: <20251013144426.214514317@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 6f8f353e95838..f522820b950c7 100644
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



