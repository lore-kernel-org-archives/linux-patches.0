Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DAF4BA96;
	Mon,  8 Jan 2024 15:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vz52vKh7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA096C433BB;
	Mon,  8 Jan 2024 15:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726801;
	bh=Uy2DjOE4u2hnBdq5GDLfdmc5qobDRwOusWQmiq5xl5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vz52vKh7Oc8R2rVJZO2tu3dHeViFDpvTVRbW6kBdmd2m0QyyVV9YKPa1cSHSY/Pnb
	 lIdqfxPaQHsPQEeyXV50HQ96VwbWgmoxKMyFPAAmRfQGbzUPSZ4Fq3pqnjmQ97EL6A
	 CBmjBTC3g00W5XToCt9snSP9ZjBlefD0ZUeJGt+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Joel Fernandes <joel@joelfernandes.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 081/124] rcu/tasks-trace: Handle new PF_IDLE semantics
Date: Mon,  8 Jan 2024 16:08:27 +0100
Message-ID: <20240108150606.703319378@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

From: Frederic Weisbecker <frederic@kernel.org>

[ Upstream commit a80712b9cc7e57830260ec5e1feb9cdb59e1da2f ]

The commit:

	cff9b2332ab7 ("kernel/sched: Modify initial boot task idle setup")

has changed the semantics of what is to be considered an idle task in
such a way that the idle task of an offline CPU may not carry the
PF_IDLE flag anymore.

However RCU-tasks-trace tests the opposite assertion, still assuming
that idle tasks carry the PF_IDLE flag during their whole lifecycle.

Remove this assumption to avoid spurious warnings but keep the initial
test verifying that the idle task is the current task on any offline
CPU.

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Fixes: cff9b2332ab7 ("kernel/sched: Modify initial boot task idle setup")
Suggested-by: Joel Fernandes <joel@joelfernandes.org>
Suggested-by: "Paul E. McKenney" <paulmck@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tasks.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index b5dc1e5d78c83..65e000ca332cc 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -1548,7 +1548,7 @@ static int trc_inspect_reader(struct task_struct *t, void *bhp_in)
 	} else {
 		// The task is not running, so C-language access is safe.
 		nesting = t->trc_reader_nesting;
-		WARN_ON_ONCE(ofl && task_curr(t) && !is_idle_task(t));
+		WARN_ON_ONCE(ofl && task_curr(t) && (t != idle_task(task_cpu(t))));
 		if (IS_ENABLED(CONFIG_TASKS_TRACE_RCU_READ_MB) && ofl)
 			n_heavy_reader_ofl_updates++;
 	}
-- 
2.43.0



