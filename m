Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF023F20FF;
	Wed, 20 May 2026 16:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294462; cv=none; b=lLtEmlq0M0peC+R6A3xDryyJB7AAErSvIAuh/n6sAcakT3XrPoo+1YWUJm6dkfCQIO3VEo6bMqqUfBrs1LaUbd9LDOA6t2Q6ETJztBhJBs/ut72ZCB8/Uw3miCldLUxd8qEqjxyQHWsi27aSPIBkEAt/vjyecy+TK1Rb6e+ryr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294462; c=relaxed/simple;
	bh=BPhyCTxV6Vvkc3BE5H87EsyAZUo9jQd8V3aqbufv/as=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fpW7RfGS8Qj/85pZJKU6jZsqe6O3Y5L9226VMgxA5V1LW7epFil4FMjGkqSwhSP3V8bcTIjhppaHORGGI4a8iTpQJsoP/kvDAZJ4zHrJtH4Ioyy17TawG3WY3GZfrfYbvTXtOiULAJmo3nAqAsrS0Drc4auAcif38V7mj/A6+GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mHr7mkeH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mHr7mkeH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC99F1F000E9;
	Wed, 20 May 2026 16:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294461;
	bh=gg6xdKRTb08mvgzUt5S3EI+8gnubXdEDhax63NEK0Ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mHr7mkeHpo3ZBGYKs7GVE4V2igcK1b2jQFupqycve6t1d3YHVKFMuopzpd9Icp5GI
	 89uFuugpMbWH/1pX6qecQ3TjLzTEJJ5nhEoQkwK3/hjduq6pS9Y6G5O0HEUGL5IpNs
	 +9duCsesrP8aXprW+hCmqykm5NejebvhocBPplN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Marco Elver <elver@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0049/1146] signal: Fix the lock_task_sighand() annotation
Date: Wed, 20 May 2026 18:04:59 +0200
Message-ID: <20260520162149.486659036@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 39be7b21af24d1d2ed3b18caac57dd219fef226e ]

lock_task_sighand() may return NULL. Make this clear in its lock context
annotation.

Fixes: 04e49d926f43 ("sched: Enable context analysis for core.c and fair.c")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Marco Elver <elver@google.com>
Link: https://patch.msgid.link/20260225183244.4035378-3-bvanassche@acm.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched/signal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index a22248aebcf90..a4835a7de07ee 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -739,7 +739,7 @@ static inline int thread_group_empty(struct task_struct *p)
 
 extern struct sighand_struct *lock_task_sighand(struct task_struct *task,
 						unsigned long *flags)
-	__acquires(&task->sighand->siglock);
+	__cond_acquires(nonnull, &task->sighand->siglock);
 
 static inline void unlock_task_sighand(struct task_struct *task,
 						unsigned long *flags)
-- 
2.53.0



