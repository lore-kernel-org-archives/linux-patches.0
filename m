Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E242D8773;
	Wed,  4 Feb 2026 15:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218694; cv=none; b=caq5BPD4qgIEt84rOXhOjE61ooI0Rpl+Nqs3afhFcVDsMdovUKP8jTU/YZSQ5x50Bt9JPejrwXdeTtlNwLYESZ+STkK5CrQPN1soeeIX9fVhrFr2NvbSN6roytAALf49hQR+3kSfjKF6KnKihcRVZa/kchL22VYM/fwyQNtzAVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218694; c=relaxed/simple;
	bh=GkdWH556kaxXvROF/T/A3c5nMoyK0j7nqmNO0eSs9hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nrJRtI2d/nyKm4FI3yukyKT1ra3Wk7kfcxfKq7d1v5hUm66TCbIihEVqKt3di9XeEzHhC8m8+5C+IPCtFNdOgDo4N807htOv/iHGS6e3SV89XW6fYm/fcXXiosLqs/9tzmzSDXEeWTdjDmXokL5IIjQEJN99UdriY756BFCb8fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nqg2MXmv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nqg2MXmv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3085BC4CEF7;
	Wed,  4 Feb 2026 15:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218694;
	bh=GkdWH556kaxXvROF/T/A3c5nMoyK0j7nqmNO0eSs9hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nqg2MXmv5v0luBRa2f5QBknuh+32VhSTmWz/IpU7t544A9C9n7hhu5MuEkH3GsDUB
	 jqW14X/1ztn4QeI4y/XlQ0jnI+28xNfX9LLsQBaepVIv605dMgYrJSDPryrmDPE57G
	 tjmpr/BdFQ9JQwheHBje1qNZN5aWIDg1TouCCtuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 33/87] sched/deadline: Fix stuck dl_server
Date: Wed,  4 Feb 2026 15:40:31 +0100
Message-ID: <20260204143848.103960729@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 115135422562e2f791e98a6f55ec57b2da3b3a95 ]

Andrea reported the dl_server getting stuck for him. He tracked it
down to a state where dl_server_start() saw dl_defer_running==1, but
the dl_server's job is no longer valid at the time of
dl_server_start().

In the state diagram this corresponds to [4] D->A (or dl_server_stop()
due to no more runnable tasks) followed by [1], which in case of a
lapsed deadline must then be A->B.

Now our A has dl_defer_running==1, while B demands
dl_defer_running==0, therefore it must get cleared when the CBS wakeup
rules demand a replenish.

Fixes: a110a81c52a9 ("sched/deadline: Deferrable dl server")
Reported-by: Andrea Righi arighi@nvidia.com
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Juri Lelli <juri.lelli@redhat.com>
Tested-by: Andrea Righi arighi@nvidia.com
Link: https://lkml.kernel.org/r/20260123161645.2181752-1-arighi@nvidia.com
Link: https://patch.msgid.link/20260130124100.GC1079264@noisy.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/deadline.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index a860d77062395..1689d190dea8f 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1086,6 +1086,12 @@ static void update_dl_entity(struct sched_dl_entity *dl_se)
 			return;
 		}
 
+		/*
+		 * When [4] D->A is followed by [1] A->B, dl_defer_running
+		 * needs to be cleared, otherwise it will fail to properly
+		 * start the zero-laxity timer.
+		 */
+		dl_se->dl_defer_running = 0;
 		replenish_dl_new_period(dl_se, rq);
 	} else if (dl_server(dl_se) && dl_se->dl_defer) {
 		/*
@@ -1692,6 +1698,12 @@ void dl_server_update(struct sched_dl_entity *dl_se, s64 delta_exec)
  *   dl_server_active = 1;
  *   enqueue_dl_entity()
  *     update_dl_entity(WAKEUP)
+ *       if (dl_time_before() || dl_entity_overflow())
+ *         dl_defer_running = 0;
+ *         replenish_dl_new_period();
+ *           // fwd period
+ *           dl_throttled = 1;
+ *           dl_defer_armed = 1;
  *       if (!dl_defer_running)
  *         dl_defer_armed = 1;
  *         dl_throttled = 1;
-- 
2.51.0



