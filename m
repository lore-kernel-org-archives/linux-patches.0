Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E34C284881;
	Mon, 23 Mar 2026 16:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283216; cv=none; b=pf2lToJqo0DHSxV8WCifWC5QV0uFW0Y1a+sGtNQfug9a9SGySzwxxJZS6DPPv2iV5db+F9U1WsbIl4LkagZSMo3Fn4m7p+MKrCoknnSq+hplBzXzElZ/8zxiGyFD+YxpW38xW1qF2apV/aAd/mm44q93FeL38ubttiP2UDKYOOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283216; c=relaxed/simple;
	bh=1yuim09ubOzXSNmo+9/3QPYCR05c/nEjLTCPmSzps2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5ucCqUPFnkgW3lA8tyeKRc7Uk89cxI+dxVUpTgZcKnJ4zJoj6SweNEVJaS5a5wSuPi62oUy2Kb/ValIeerlSPnrufjiTSWD8l1i8+SU+wen6oMa3XJ5jUoYDH+mI+a3QgI9Ik4udmYPzI3trFZw32owxN+Iwel9LbL+YqedGD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uVV1t9Jv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uVV1t9Jv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD5DC2BCB5;
	Mon, 23 Mar 2026 16:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283215;
	bh=1yuim09ubOzXSNmo+9/3QPYCR05c/nEjLTCPmSzps2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uVV1t9Jvtpb45XMe9bou9/dR3RNgVcfHrtx5WtbXUOLRrhJLhvJEt65t6F9f8FbaV
	 uX3u0XytmTAAAe/AB6foDQ4OPw0UcMrIVBcEuHSmtT3pW1gOY0mLH5Yf9v3GV/wM74
	 F+eYHdqAkD3WaAGQzG7ywEn/ORODfPF4Ck6cmqmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Wu <wusamuel@google.com>,
	Alex Hoh <Alex.Hoh@mediatek.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.1 445/481] sched/fair: Fix pelt clock sync when entering idle
Date: Mon, 23 Mar 2026 14:47:07 +0100
Message-ID: <20260323134536.059920879@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Reported-by: Samuel Wu <wusamuel@google.com>
Closes: https://lore.kernel.org/all/CAG2KctpO6VKS6GN4QWDji0t92_gNBJ7HjjXrE+6H+RwRXt=iLg@mail.gmail.com/
Reported-by: Alex Hoh <Alex.Hoh@mediatek.com>
Closes: https://lore.kernel.org/all/8cf19bf0e0054dcfed70e9935029201694f1bb5a.camel@mediatek.com/
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Samuel Wu <wusamuel@google.com>
Tested-by: Alex Hoh <Alex.Hoh@mediatek.com>
Link: https://patch.msgid.link/20260121163317.505635-1-vincent.guittot@linaro.org
(cherry picked from commit 98c88dc8a1ace642d9021b103b28cba7b51e3abc)
[ wusamuel: Did not include line 'exec_start = rq_clock_task()', which
is not present in 6.1.y but found in mainline ]
Signed-off-by: Samuel Wu <wusamuel@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/fair.c |    6 ------
 kernel/sched/idle.c |    6 ++++++
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7924,12 +7924,6 @@ idle:
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
 
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -456,6 +456,12 @@ static void set_next_task_idle(struct rq
 {
 	update_idle_core(rq);
 	schedstat_inc(rq->sched_goidle);
+
+	/*
+	 * rq is about to be idle, check if we need to update the
+	 * lost_idle_time of clock_pelt
+	 */
+	update_idle_rq_clock_pelt(rq);
 }
 
 #ifdef CONFIG_SMP


