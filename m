Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2662611C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:29:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E452C433C7;
	Mon, 28 Aug 2023 10:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218563;
	bh=gsVMPNCM3Lk9Ztpj4B8O6vQ/0R5AhsNyTiCR4iCFVM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hZs7sEOQNz3CRrNFxWfyyzruRKQmZ2fvqAvTi8FOU9TG7cDbJP/6KTuqe+iBeQfeo
	 K5XJNijVA6z7nYX8PeAXyOrecIO8td/etAav3HBiIkuRbatKYmltE1iydozgHbzQCY
	 1Fhp0WUhRqXPCIZAsBdTiEIlfHpKHcJ6pAd17Rqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pietro Borrello <borrello@diag.uniroma1.it>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Phil Auld <pauld@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>,
	Srish Srinivasan <ssrish@vmware.com>
Subject: [PATCH 4.19 122/129] sched/rt: pick_next_rt_entity(): check list_entry
Date: Mon, 28 Aug 2023 12:13:36 +0200
Message-ID: <20230828101157.667792677@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101153.030066927@linuxfoundation.org>
References: <20230828101153.030066927@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pietro Borrello <borrello@diag.uniroma1.it>

commit 7c4a5b89a0b5a57a64b601775b296abf77a9fe97 upstream.

Commit 326587b84078 ("sched: fix goto retry in pick_next_task_rt()")
removed any path which could make pick_next_rt_entity() return NULL.
However, BUG_ON(!rt_se) in _pick_next_task_rt() (the only caller of
pick_next_rt_entity()) still checks the error condition, which can
never happen, since list_entry() never returns NULL.
Remove the BUG_ON check, and instead emit a warning in the only
possible error condition here: the queue being empty which should
never happen.

Fixes: 326587b84078 ("sched: fix goto retry in pick_next_task_rt()")
Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Phil Auld <pauld@redhat.com>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Link: https://lore.kernel.org/r/20230128-list-entry-null-check-sched-v3-1-b1a71bd1ac6b@diag.uniroma1.it
Signed-off-by: Sasha Levin <sashal@kernel.org>
[ Fixes CVE-2023-1077: sched/rt: pick_next_rt_entity(): check list_entry
  An insufficient list empty checking in pick_next_rt_entity().  The
  _pick_next_task_rt() checks pick_next_rt_entity() returns NULL or not
  but pick_next_rt_entity() never returns NULL.  So, even if the list is
  empty, _pick_next_task_rt() continues its process. ]
Signed-off-by: Srish Srinivasan <ssrish@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/rt.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1522,6 +1522,8 @@ static struct sched_rt_entity *pick_next
 	BUG_ON(idx >= MAX_RT_PRIO);
 
 	queue = array->queue + idx;
+	if (SCHED_WARN_ON(list_empty(queue)))
+		return NULL;
 	next = list_entry(queue->next, struct sched_rt_entity, run_list);
 
 	return next;
@@ -1535,7 +1537,8 @@ static struct task_struct *_pick_next_ta
 
 	do {
 		rt_se = pick_next_rt_entity(rq, rt_rq);
-		BUG_ON(!rt_se);
+		if (unlikely(!rt_se))
+			return NULL;
 		rt_rq = group_rt_rq(rt_se);
 	} while (rt_rq);
 


