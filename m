Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52F31D04A8;
	Wed,  2 Oct 2024 13:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876033; cv=none; b=SNBCDLsC76zaRTnp1HoFaacrxU0xupGpUNcTGH29jeuziUq7fx33PVbI6V83VuCvr9Oo2wCT4nsJpEjCaGb+0Ayzk1rKdjY4zKprXh0D/H+VXzgqUPWp6M5gZBRm2adubSrIn7detNvEhJ7wQHh0xb8sPBoabGIDTZ8krOQRcS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876033; c=relaxed/simple;
	bh=Aul+LCi63dQ4oX6Hi8VwmuIvFrXH6JWBipZnWIWIG+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+1zdMkvRLMeK94lpccwPFm5tnFyHBLu0Nou4PsW4waw9qqJf27q0ycWX3o/71h6ebV6mzy0KvPN1VFRnrkcVyYH1DNC1YRqFnEicEUixIX797ALa4/FIO9UQoa5kXJ2SC/SHyo5OZk+fVOCfKJEMR4kl7OKkMsnuK+R4QMpY74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nUqfjnPA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nUqfjnPA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB0AC4CEC5;
	Wed,  2 Oct 2024 13:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876033;
	bh=Aul+LCi63dQ4oX6Hi8VwmuIvFrXH6JWBipZnWIWIG+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nUqfjnPAqpfGZaRfvASRX89T+IUKl8kVa53YC6++GFlKgN6mdyJ8QPFTwLbQSMqQE
	 /48oTlEjyUY0hKUhjG0OhsYcZ2lvv5TypoZ/AyeyPxzP751xpwioX/RZ0M9UdrmIgP
	 a24XN9k7uD/0oI07t5AjgUaIbnIli4MlKXnSKUPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huang Shijie <shijie@os.amperecomputing.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 306/695] sched/deadline: Fix schedstats vs deadline servers
Date: Wed,  2 Oct 2024 14:55:04 +0200
Message-ID: <20241002125834.654856349@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huang Shijie <shijie@os.amperecomputing.com>

[ Upstream commit 9c602adb799e72ee537c0c7ca7e828c3fe2acad6 ]

In dl_server_start(), when schedstats is enabled, the following
happens:

  dl_server_start()
    dl_se->dl_server = 1;
    enqueue_dl_entity()
      update_stats_enqueue_dl()
        __schedstats_from_dl_se()
          dl_task_of()
            BUG_ON(dl_server(dl_se));

Since only tasks have schedstats and internal entries do not, avoid
trying to update stats in this case.

Fixes: 63ba8422f876 ("sched/deadline: Introduce deadline servers")
Signed-off-by: Huang Shijie <shijie@os.amperecomputing.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Juri Lelli <juri.lelli@redhat.com>
Link: https://lkml.kernel.org/r/20240829031111.12142-1-shijie@os.amperecomputing.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/deadline.c | 38 ++++++++++++++++----------------------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index f59e5c19d9445..c5a3691ba6cc1 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1599,46 +1599,40 @@ static inline bool __dl_less(struct rb_node *a, const struct rb_node *b)
 	return dl_time_before(__node_2_dle(a)->deadline, __node_2_dle(b)->deadline);
 }
 
-static inline struct sched_statistics *
+static __always_inline struct sched_statistics *
 __schedstats_from_dl_se(struct sched_dl_entity *dl_se)
 {
+	if (!schedstat_enabled())
+		return NULL;
+
+	if (dl_server(dl_se))
+		return NULL;
+
 	return &dl_task_of(dl_se)->stats;
 }
 
 static inline void
 update_stats_wait_start_dl(struct dl_rq *dl_rq, struct sched_dl_entity *dl_se)
 {
-	struct sched_statistics *stats;
-
-	if (!schedstat_enabled())
-		return;
-
-	stats = __schedstats_from_dl_se(dl_se);
-	__update_stats_wait_start(rq_of_dl_rq(dl_rq), dl_task_of(dl_se), stats);
+	struct sched_statistics *stats = __schedstats_from_dl_se(dl_se);
+	if (stats)
+		__update_stats_wait_start(rq_of_dl_rq(dl_rq), dl_task_of(dl_se), stats);
 }
 
 static inline void
 update_stats_wait_end_dl(struct dl_rq *dl_rq, struct sched_dl_entity *dl_se)
 {
-	struct sched_statistics *stats;
-
-	if (!schedstat_enabled())
-		return;
-
-	stats = __schedstats_from_dl_se(dl_se);
-	__update_stats_wait_end(rq_of_dl_rq(dl_rq), dl_task_of(dl_se), stats);
+	struct sched_statistics *stats = __schedstats_from_dl_se(dl_se);
+	if (stats)
+		__update_stats_wait_end(rq_of_dl_rq(dl_rq), dl_task_of(dl_se), stats);
 }
 
 static inline void
 update_stats_enqueue_sleeper_dl(struct dl_rq *dl_rq, struct sched_dl_entity *dl_se)
 {
-	struct sched_statistics *stats;
-
-	if (!schedstat_enabled())
-		return;
-
-	stats = __schedstats_from_dl_se(dl_se);
-	__update_stats_enqueue_sleeper(rq_of_dl_rq(dl_rq), dl_task_of(dl_se), stats);
+	struct sched_statistics *stats = __schedstats_from_dl_se(dl_se);
+	if (stats)
+		__update_stats_enqueue_sleeper(rq_of_dl_rq(dl_rq), dl_task_of(dl_se), stats);
 }
 
 static inline void
-- 
2.43.0



