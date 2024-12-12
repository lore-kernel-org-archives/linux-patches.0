Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFBD6F2FE;
	Thu, 12 Dec 2024 16:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021820; cv=none; b=fthmIqNJnKvwQoc3xw+PuORFgW7N1314ZHCnisnunEk/WuszPBmlLCcFAWlcmkfQuQi3nN9LOjoiABLfVIgXkqrQBlm9Ye3iA/NNBjtFbFfGXW1UU3WBs5dOCuohIyfkUrzi+PL7cVoX4M9277erHxrobQ9EM2Xq3jOQjAYvTWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021820; c=relaxed/simple;
	bh=x4xbLZ9Uekw0ONhVIe5scJ82QhK9pvy3gAJWmYcsO6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ea2yXHQTWDLT46Z9exd6PEXu1JP/z9GYUCdP9rCU+3KTeiTxCfa1KEmr4e4Nnr1hr3UW644IZM5TRjD3xsqg0R0+4Fsf6V0u2QiK9JTcdBMiis1l3yrWon9BYjjIbE8JYoTORtdqckgQBBfgAqgDO1uqrwQaUWcl8apYYJZbeUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bXoDT4sA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bXoDT4sA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABB93C4CECE;
	Thu, 12 Dec 2024 16:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021820;
	bh=x4xbLZ9Uekw0ONhVIe5scJ82QhK9pvy3gAJWmYcsO6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bXoDT4sAIJbwdT3xkFUw6I5/Om0Ni4Xb0tCo6fUlxBWNmDWJRTELKrfJz7eXEQP/2
	 5due2dvjaNY+DxbzCMHMYKoZCWTHgRS+JGFy/yryMyK1Rl/xxQpkC5Na9g8JrlF0mE
	 cXBw0AMvOtL2uCNUwHawfci/8CGIUWGtjlKF9A5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Neeraj Upadhyay <quic_neeraju@quicinc.com>,
	Eric Dumazet <edumazet@google.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <kafai@fb.com>,
	KP Singh <kpsingh@kernel.org>,
	Krister Johansen <kjlx@templeofstupid.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 072/565] rcu-tasks: Idle tasks on offline CPUs are in quiescent states
Date: Thu, 12 Dec 2024 15:54:27 +0100
Message-ID: <20241212144314.337229422@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul E. McKenney <paulmck@kernel.org>

commit 5c9a9ca44fda41c5e82f50efced5297a9c19760d upstream.

Any idle task corresponding to an offline CPU is in an RCU Tasks Trace
quiescent state.  This commit causes rcu_tasks_trace_postscan() to ignore
idle tasks for offline CPUs, which it can do safely due to CPU-hotplug
operations being disabled.

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Neeraj Upadhyay <quic_neeraju@quicinc.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: KP Singh <kpsingh@kernel.org>
Signed-off-by: Krister Johansen <kjlx@templeofstupid.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tasks.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index 0e50ec9ded86e..0a83d0ce46d78 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -1090,7 +1090,7 @@ static void rcu_tasks_trace_postscan(struct list_head *hop)
 {
 	int cpu;
 
-	for_each_possible_cpu(cpu)
+	for_each_online_cpu(cpu)
 		rcu_tasks_trace_pertask(idle_task(cpu), hop);
 
 	// Re-enable CPU hotplug now that the tasklist scan has completed.
-- 
2.43.0



