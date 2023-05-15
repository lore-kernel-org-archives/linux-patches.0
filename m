Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149A0DF40
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:34:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806A8C433D2;
	Mon, 15 May 2023 16:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684168496;
	bh=Yqc+NXA9J0/UpiDzriuKFaSMD5cOuLG4XqSWh50Z51c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fhDsHzRF1wFEKwkt+ZMukq/qnKueBM5VjuCvV24FVl5uzy/VDmsM1yGBPAzBD9YOO
	 pbuXANRlDLI/XLeMfuyIdZBoZVuiSUaDh4FvMlG2AIVh4zhq7Sj8pY9OGgzPDMc7Tq
	 O47NE7Z8a9Hqg+Jey6B6xGAHWJb8G7T6cTok43Ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helen Chao <helen.chao@oracle.com>,
	Dai Ngo <dai.ngo@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 069/116] SUNRPC: remove the maximum number of retries in call_bind_status
Date: Mon, 15 May 2023 18:26:06 +0200
Message-Id: <20230515161700.584878950@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161658.228491273@linuxfoundation.org>
References: <20230515161658.228491273@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit 691d0b782066a6eeeecbfceb7910a8f6184e6105 ]

Currently call_bind_status places a hard limit of 3 to the number of
retries on EACCES error. This limit was done to prevent NLM unlock
requests from being hang forever when the server keeps returning garbage.
However this change causes problem for cases when NLM service takes
longer than 9 seconds to register with the port mapper after a restart.

This patch removes this hard coded limit and let the RPC handles
the retry based on the standard hard/soft task semantics.

Fixes: 0b760113a3a1 ("NLM: Don't hang forever on NLM unlock requests")
Reported-by: Helen Chao <helen.chao@oracle.com>
Tested-by: Helen Chao <helen.chao@oracle.com>
Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/sched.h | 3 +--
 net/sunrpc/clnt.c            | 3 ---
 net/sunrpc/sched.c           | 1 -
 3 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/include/linux/sunrpc/sched.h b/include/linux/sunrpc/sched.h
index c9548a63d09bb..0f7c8f820aa3f 100644
--- a/include/linux/sunrpc/sched.h
+++ b/include/linux/sunrpc/sched.h
@@ -88,8 +88,7 @@ struct rpc_task {
 #endif
 	unsigned char		tk_priority : 2,/* Task priority */
 				tk_garb_retry : 2,
-				tk_cred_retry : 2,
-				tk_rebind_retry : 2;
+				tk_cred_retry : 2;
 };
 
 typedef void			(*rpc_action)(struct rpc_task *);
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 411925b043cce..de917d45e512a 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1827,9 +1827,6 @@ call_bind_status(struct rpc_task *task)
 			status = -EOPNOTSUPP;
 			break;
 		}
-		if (task->tk_rebind_retry == 0)
-			break;
-		task->tk_rebind_retry--;
 		rpc_delay(task, 3*HZ);
 		goto retry_timeout;
 	case -ETIMEDOUT:
diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index 4e0ebb4780df8..b368f5aabe291 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -697,7 +697,6 @@ rpc_init_task_statistics(struct rpc_task *task)
 	/* Initialize retry counters */
 	task->tk_garb_retry = 2;
 	task->tk_cred_retry = 2;
-	task->tk_rebind_retry = 2;
 
 	/* starting timestamp */
 	task->tk_start = ktime_get();
-- 
2.39.2



