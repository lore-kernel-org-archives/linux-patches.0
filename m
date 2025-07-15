Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B0D2561AE;
	Tue, 15 Jul 2025 13:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586764; cv=none; b=SRNqPQT3mymhEp4qFzujbxGbT7dLCb3reNbYRhAAx8aXRVh0a2I+F9L+nhY9ZXFQebRhfGPc19Wv04taKGgVEJ4dxAb3wrQ0oyJ9LhfZ/W+AMP/+oXqB4ThE+l0wBdS034n6RpwCE6oaocUN7WSmp++u3nbukYMyrIS72JyAQc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586764; c=relaxed/simple;
	bh=YvT008b7+l0GifvLYBPe1WUO6NKLt3k4f4XQ7lpDDNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mOtQYuaXQX9Csh+xxOggTC4G0idnd9QJkUtXau/tMajiVr6TJOC4BGRBJLHPs090HS5Ia7JRIX9CCzsoaUakkop9aNFBxU2f30JtVN0YnWHUD7/pJYXBGVLetpV8T6CnCHz0Lc6YhgcGApTkGxOVdV2ypR8CMop8cnG1QqpQ6cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RpcGCPZh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RpcGCPZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD51C4CEE3;
	Tue, 15 Jul 2025 13:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586764;
	bh=YvT008b7+l0GifvLYBPe1WUO6NKLt3k4f4XQ7lpDDNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RpcGCPZhnfvRr+47brkaDxlRCgqKlYmmgvNaAckUy2IyFfav2rY205nmzK998I8IF
	 qvp2d3nVxfaVMQ3qY2OCRYVgMDpMSX5/bjG0JnXh9EV78o/Qp7sRTaVQHxqliugKrF
	 g+TfwRpQ54erX4C9mRzxMkuds9ikV2yA1b3juFMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	John Stultz <jstultz@google.com>,
	kuyo chang <kuyo.chang@mediatek.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 022/192] sched/deadline: Fix dl_server runtime calculation formula
Date: Tue, 15 Jul 2025 15:11:57 +0200
Message-ID: <20250715130815.755238240@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: kuyo chang <kuyo.chang@mediatek.com>

[ Upstream commit fc975cfb36393db1db517fbbe366e550bcdcff14 ]

In our testing with 6.12 based kernel on a big.LITTLE system, we were
seeing instances of RT tasks being blocked from running on the LITTLE
cpus for multiple seconds of time, apparently by the dl_server. This
far exceeds the default configured 50ms per second runtime.

This is due to the fair dl_server runtime calculation being scaled
for frequency & capacity of the cpu.

Consider the following case under a Big.LITTLE architecture:
Assume the runtime is: 50,000,000 ns, and Frequency/capacity
scale-invariance defined as below:
Frequency scale-invariance: 100
Capacity scale-invariance: 50
First by Frequency scale-invariance,
the runtime is scaled to 50,000,000 * 100 >> 10 = 4,882,812
Then by capacity scale-invariance,
it is further scaled to 4,882,812 * 50 >> 10 = 238,418.
So it will scaled to 238,418 ns.

This smaller "accounted runtime" value is what ends up being
subtracted against the fair-server's runtime for the current period.
Thus after 50ms of real time, we've only accounted ~238us against the
fair servers runtime. This 209:1 ratio in this example means that on
the smaller cpu the fair server is allowed to continue running,
blocking RT tasks, for over 10 seconds before it exhausts its supposed
50ms of runtime.  And on other hardware configurations it can be even
worse.

For the fair deadline_server, to prevent realtime tasks from being
unexpectedly delayed, we really do want to use fixed time, and not
scaled time for smaller capacity/frequency cpus. So remove the scaling
from the fair server's accounting to fix this.

Fixes: a110a81c52a9 ("sched/deadline: Deferrable dl server")
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Suggested-by: John Stultz <jstultz@google.com>
Signed-off-by: kuyo chang <kuyo.chang@mediatek.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Juri Lelli <juri.lelli@redhat.com>
Acked-by: John Stultz <jstultz@google.com>
Tested-by: John Stultz <jstultz@google.com>
Link: https://lore.kernel.org/r/20250702021440.2594736-1-kuyo.chang@mediatek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/deadline.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index ad45a8fea245e..89019a1408264 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1504,7 +1504,9 @@ static void update_curr_dl_se(struct rq *rq, struct sched_dl_entity *dl_se, s64
 	if (dl_entity_is_special(dl_se))
 		return;
 
-	scaled_delta_exec = dl_scaled_delta_exec(rq, dl_se, delta_exec);
+	scaled_delta_exec = delta_exec;
+	if (!dl_server(dl_se))
+		scaled_delta_exec = dl_scaled_delta_exec(rq, dl_se, delta_exec);
 
 	dl_se->runtime -= scaled_delta_exec;
 
@@ -1611,7 +1613,7 @@ static void update_curr_dl_se(struct rq *rq, struct sched_dl_entity *dl_se, s64
  */
 void dl_server_update_idle_time(struct rq *rq, struct task_struct *p)
 {
-	s64 delta_exec, scaled_delta_exec;
+	s64 delta_exec;
 
 	if (!rq->fair_server.dl_defer)
 		return;
@@ -1624,9 +1626,7 @@ void dl_server_update_idle_time(struct rq *rq, struct task_struct *p)
 	if (delta_exec < 0)
 		return;
 
-	scaled_delta_exec = dl_scaled_delta_exec(rq, &rq->fair_server, delta_exec);
-
-	rq->fair_server.runtime -= scaled_delta_exec;
+	rq->fair_server.runtime -= delta_exec;
 
 	if (rq->fair_server.runtime < 0) {
 		rq->fair_server.dl_defer_running = 0;
-- 
2.39.5



