Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA7E189B94;
	Mon, 23 Dec 2024 16:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969765; cv=none; b=IGT/Vinb1yp6QML44Oyg2tT7ZJrqKKzej01K/Kdw/bUEKqIPiCdjhbmDxR4qsbv/t5CzRCQ+LWUDmltZoInp3To+QurBhfC8r9XZZ1CXHDQnq2eA5zW6GWXgIgRHhHGcDsiDhv8gCLw5a8RTYqAKN7hozTOlNaLNbn1lmu6G2Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969765; c=relaxed/simple;
	bh=JvpgFXFBOO1KsQkPALCs3Qj+FfEp/taAFLahPZ9pEZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nc4xFfdmKh9hBG/m+YPs14wMpWdoRXBZ2NandI3d+SsiE36qdWANe3m3QSw1qw92Epy5CLZaUECKESOJvX5GJqlWv62OIVVlrYkzN5bRrJ6M9jxxfFTnfDE3CXZ7b8uvISJT6N86itLA5r+9pQ0fu1Pef//0kJ5xPnuc6sT34pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KpWAIlAe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KpWAIlAe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3E8C4CED3;
	Mon, 23 Dec 2024 16:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969765;
	bh=JvpgFXFBOO1KsQkPALCs3Qj+FfEp/taAFLahPZ9pEZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KpWAIlAe4UBbJG8I6yMIJx3DAA66LwkyafoIaeCIDGJ9vZpTmi0H77FOehRTF2two
	 VVgbKtk4oEDZ5F5xJlvypIyb0DQWDvlOInPiudql1FTQzYvkTDZQeA94Z35lALPGXx
	 sihxGF0TrKby+ifodkcb1UYPzAvaon8u9MmZgyC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Vineeth Pillai (Google)" <vineeth@bitbyteword.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>,
	Marcel Ziswiler <marcel.ziswiler@codethink.co.uk>
Subject: [PATCH 6.12 017/160] sched/dlserver: Fix dlserver time accounting
Date: Mon, 23 Dec 2024 16:57:08 +0100
Message-ID: <20241223155409.311065249@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vineeth Pillai (Google) <vineeth@bitbyteword.org>

[ Upstream commit c7f7e9c73178e0e342486fd31e7f363ef60e3f83 ]

dlserver time is accounted when:
 - dlserver is active and the dlserver proxies the cfs task.
 - dlserver is active but deferred and cfs task runs after being picked
   through the normal fair class pick.

dl_server_update is called in two places to make sure that both the
above times are accounted for. But it doesn't check if dlserver is
active or not. Now that we have this dl_server_active flag, we can
consolidate dl_server_update into one place and all we need to check is
whether dlserver is active or not. When dlserver is active there is only
two possible conditions:
 - dlserver is deferred.
 - cfs task is running on behalf of dlserver.

Fixes: a110a81c52a9 ("sched/deadline: Deferrable dl server")
Signed-off-by: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Marcel Ziswiler <marcel.ziswiler@codethink.co.uk> # ROCK 5B
Link: https://lore.kernel.org/r/20241213032244.877029-2-vineeth@bitbyteword.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 93142f9077c7..1ca96c99872f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1159,8 +1159,6 @@ static inline void update_curr_task(struct task_struct *p, s64 delta_exec)
 	trace_sched_stat_runtime(p, delta_exec);
 	account_group_exec_runtime(p, delta_exec);
 	cgroup_account_cputime(p, delta_exec);
-	if (p->dl_server)
-		dl_server_update(p->dl_server, delta_exec);
 }
 
 static inline bool did_preempt_short(struct cfs_rq *cfs_rq, struct sched_entity *curr)
@@ -1237,11 +1235,16 @@ static void update_curr(struct cfs_rq *cfs_rq)
 		update_curr_task(p, delta_exec);
 
 		/*
-		 * Any fair task that runs outside of fair_server should
-		 * account against fair_server such that it can account for
-		 * this time and possibly avoid running this period.
+		 * If the fair_server is active, we need to account for the
+		 * fair_server time whether or not the task is running on
+		 * behalf of fair_server or not:
+		 *  - If the task is running on behalf of fair_server, we need
+		 *    to limit its time based on the assigned runtime.
+		 *  - Fair task that runs outside of fair_server should account
+		 *    against fair_server such that it can account for this time
+		 *    and possibly avoid running this period.
 		 */
-		if (p->dl_server != &rq->fair_server)
+		if (dl_server_active(&rq->fair_server))
 			dl_server_update(&rq->fair_server, delta_exec);
 	}
 
-- 
2.39.5



