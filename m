Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A3B305E2E;
	Wed, 28 Jan 2026 15:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615842; cv=none; b=lfMCZnqiay9vs0liXIdinNl23Hn6YjrzNQ/ty4bqF03jr6gTHciB4VPkzlMybSzrAZSHBRK38helQs2/KV5O7tut5f/a6V/juMtIMO/K9oqMSlqKdOc2nZjVE77ZJIDyHK7Woj/WksgT03+fWaXXiDHyZnHZsw458Wx22hb3LWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615842; c=relaxed/simple;
	bh=6levQweMcNo9fqNB/3u+nuvNVo3va75/5+zbKQJysbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kl2PFzwrb74LmiKTxEs11HmR+td3j3RIoFK8XYoykB4P9ykKZ/szNzJSPWPXdFriQuuypJFaVk05D39h21eSXNnNQ/k+X/A4w9sx9mXQNgYxPYIAouodHZ7d6XYeulWMYz/7cnlaei68T/Tjz9NjpP3eHSe3N9aoGLKOx5GIVyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SRMVP4rB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SRMVP4rB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A63C4CEF1;
	Wed, 28 Jan 2026 15:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615841;
	bh=6levQweMcNo9fqNB/3u+nuvNVo3va75/5+zbKQJysbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SRMVP4rBHo7Z1NciR35kK/Vo/kpQUm4A+zN21uHpoqNbz7aaRr+IkjotiOL8XL1G+
	 WYXriaCQqDxTlzRe7SKntfuNotKWLV3qEYTDTYicnWLU9ZbJJS+d4m2AQziqRgBc7f
	 cTXbNR1cbe0KjAfhp2d+cVlCR1PbU9LjiDuHQRGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Wu <wusamuel@google.com>,
	Alex Hoh <Alex.Hoh@mediatek.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 128/227] sched/fair: Fix pelt clock sync when entering idle
Date: Wed, 28 Jan 2026 16:22:53 +0100
Message-ID: <20260128145349.068491602@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Vincent Guittot <vincent.guittot@linaro.org>

[ Upstream commit 98c88dc8a1ace642d9021b103b28cba7b51e3abc ]

Samuel and Alex reported regressions of the util_avg of RT rq with
commit 17e3e88ed0b6 ("sched/fair: Fix pelt lost idle time detection").
It happens that fair is updating and syncing the pelt clock with task one
when pick_next_task_fair() fails to pick a task but before the prev
scheduling class got a chance to update its pelt signals.

Move update_idle_rq_clock_pelt() in set_next_task_idle() which is called
after prev class has been called.

Fixes: 17e3e88ed0b6 ("sched/fair: Fix pelt lost idle time detection")
Closes: https://lore.kernel.org/all/CAG2KctpO6VKS6GN4QWDji0t92_gNBJ7HjjXrE+6H+RwRXt=iLg@mail.gmail.com/
Closes: https://lore.kernel.org/all/8cf19bf0e0054dcfed70e9935029201694f1bb5a.camel@mediatek.com/
Reported-by: Samuel Wu <wusamuel@google.com>
Reported-by: Alex Hoh <Alex.Hoh@mediatek.com>
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Samuel Wu <wusamuel@google.com>
Tested-by: Alex Hoh <Alex.Hoh@mediatek.com>
Link: https://patch.msgid.link/20260121163317.505635-1-vincent.guittot@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 6 ------
 kernel/sched/idle.c | 6 ++++++
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d1206f81f8b2e..f0c7c94421bea 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -8901,12 +8901,6 @@ pick_next_task_fair(struct rq *rq, struct task_struct *prev, struct rq_flags *rf
 			goto again;
 	}
 
-	/*
-	 * rq is about to be idle, check if we need to update the
-	 * lost_idle_time of clock_pelt
-	 */
-	update_idle_rq_clock_pelt(rq);
-
 	return NULL;
 }
 
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index c39b089d4f09b..ac9690805be4f 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -464,6 +464,12 @@ static void set_next_task_idle(struct rq *rq, struct task_struct *next, bool fir
 	scx_update_idle(rq, true, true);
 	schedstat_inc(rq->sched_goidle);
 	next->se.exec_start = rq_clock_task(rq);
+
+	/*
+	 * rq is about to be idle, check if we need to update the
+	 * lost_idle_time of clock_pelt
+	 */
+	update_idle_rq_clock_pelt(rq);
 }
 
 struct task_struct *pick_task_idle(struct rq *rq)
-- 
2.51.0



