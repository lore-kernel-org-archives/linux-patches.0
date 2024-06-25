Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2EF924B34;
	Tue, 25 Jun 2024 09:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309168; cv=none; b=lqeIiuqGFrKnGUa+mBHTbbEOHoXQkhLPo/EJXxSUWk+MtuRt/5U02XyD5q073hp/dftZrqCXa7dSWSsQbLAPvSZvzGTvki+1pG8L5hVUFWBFJ3aY6FGBN0zLCRnbnUOjzSCXI56YZ9b915+c1/Hu6RoDCNr+S6dhTRP/dU3uc1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309168; c=relaxed/simple;
	bh=r4jQIFBvBmT1XKLtp5kJ7w4Eh8cc6ber0jf/+OBKmWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CFgcHZ0xSA8q5KFmUFAVmFDSpXr/MksVABtQ34RGyOBV/pFSW1ZjOvTnQ2AXiZ/rPrzAVoJAYcIqM83c8xCf05m9JQ28t1l1DcOWogFuBxhHwR1J2795kzApQ+etCsHQl/JuMmZQHC21b3cV0c+O08WFugZ3kk3P8hrNFPmt7wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GbZhT2Rr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GbZhT2Rr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39068C32781;
	Tue, 25 Jun 2024 09:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309168;
	bh=r4jQIFBvBmT1XKLtp5kJ7w4Eh8cc6ber0jf/+OBKmWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GbZhT2RrZhICvSJ4tWdysxetPI1/Oc0JuzvWIoAlK3Jdr06oRtQZ9+6WC8IW+dxBc
	 D4WwOey2Wn1iJQLnGzC1hloPTVlp1ojEXte+Eizfwx3hUzGgHpkaIFweir71qRUPD7
	 jppc0BRkIULB2z83/YgD0h5BkQxeXdFq+N6nydoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b87c222546179f4513a7@syzkaller.appspotmail.com,
	David Ruth <druth@chromium.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 088/192] net/sched: act_api: fix possible infinite loop in tcf_idr_check_alloc()
Date: Tue, 25 Jun 2024 11:32:40 +0200
Message-ID: <20240625085540.553960717@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Ruth <druth@chromium.org>

[ Upstream commit d864319871b05fadd153e0aede4811ca7008f5d6 ]

syzbot found hanging tasks waiting on rtnl_lock [1]

A reproducer is available in the syzbot bug.

When a request to add multiple actions with the same index is sent, the
second request will block forever on the first request. This holds
rtnl_lock, and causes tasks to hang.

Return -EAGAIN to prevent infinite looping, while keeping documented
behavior.

[1]

INFO: task kworker/1:0:5088 blocked for more than 143 seconds.
Not tainted 6.9.0-rc4-syzkaller-00173-g3cdb45594619 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/1:0 state:D stack:23744 pid:5088 tgid:5088 ppid:2 flags:0x00004000
Workqueue: events_power_efficient reg_check_chans_work
Call Trace:
<TASK>
context_switch kernel/sched/core.c:5409 [inline]
__schedule+0xf15/0x5d00 kernel/sched/core.c:6746
__schedule_loop kernel/sched/core.c:6823 [inline]
schedule+0xe7/0x350 kernel/sched/core.c:6838
schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:6895
__mutex_lock_common kernel/locking/mutex.c:684 [inline]
__mutex_lock+0x5b8/0x9c0 kernel/locking/mutex.c:752
wiphy_lock include/net/cfg80211.h:5953 [inline]
reg_leave_invalid_chans net/wireless/reg.c:2466 [inline]
reg_check_chans_work+0x10a/0x10e0 net/wireless/reg.c:2481

Fixes: 0190c1d452a9 ("net: sched: atomically check-allocate action")
Reported-by: syzbot+b87c222546179f4513a7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b87c222546179f4513a7
Signed-off-by: David Ruth <druth@chromium.org>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://lore.kernel.org/r/20240614190326.1349786-1-druth@chromium.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_api.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 5d34852ca5003..2d6d58e1b278a 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -830,7 +830,6 @@ int tcf_idr_check_alloc(struct tc_action_net *tn, u32 *index,
 	u32 max;
 
 	if (*index) {
-again:
 		rcu_read_lock();
 		p = idr_find(&idrinfo->action_idr, *index);
 
@@ -839,7 +838,7 @@ int tcf_idr_check_alloc(struct tc_action_net *tn, u32 *index,
 			 * index but did not assign the pointer yet.
 			 */
 			rcu_read_unlock();
-			goto again;
+			return -EAGAIN;
 		}
 
 		if (!p) {
-- 
2.43.0



