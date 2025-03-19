Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1311DED55;
	Wed, 19 Mar 2025 14:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395184; cv=none; b=jdWB/mjnS4bev4Xe2yuxt2P+MFkfoBWgud74OudoFG4Rm5K5nnXvllyPdUAviHZDY67DN7/CITDoDUR/zeaRje+n/ntcBPiJsz+0xFQha6VncJn7ysKX0sJTpLYRw6U5IKE25DMBr/e9IAT3iFiKYUf24NF3g4bRboySHnw38A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395184; c=relaxed/simple;
	bh=NStSWo2Xhq/TsaHnDWw+fbO7zlBwwOVILHd+eDI850Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKZZPvEnHI6j3tZXVtHvVdEyGavYDcvMFnJ7PkZdTKP/IdkA2pySKC25bEYFUgLwBuCZCjgag9SWL8Q94LUjHjgeyjTeBDN1JrhfPaYQNesWaLUhzHuZ0bo2kG/bvJ3IgqtS+6qDrLf7Jt+ogFY5sGglX9b3OETAxnyQ6YTWWl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=opIvQdAO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="opIvQdAO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1134C4CEE8;
	Wed, 19 Mar 2025 14:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395184;
	bh=NStSWo2Xhq/TsaHnDWw+fbO7zlBwwOVILHd+eDI850Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=opIvQdAOKBCriSpJ/6CDUOgs33HSfGzxDHXKIONb65mI2vOeDrdNfHdpVExasN+Cj
	 HQdzH+Z0G/WGo+3vQa/8w3wMosr70qRynkhcJnjmvY1E1vtcyiDFsr95m5NcreU82i
	 rNDU5W2w3jv5SWR0GtExYD1UfQoFrbdpqz9LMrUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <christian.loehle@arm.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/166] sched/debug: Provide slice length for fair tasks
Date: Wed, 19 Mar 2025 07:30:12 -0700
Message-ID: <20250319143021.102116867@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Christian Loehle <christian.loehle@arm.com>

[ Upstream commit 9065ce69754dece78606c8bbb3821449272e56bf ]

Since commit:

  857b158dc5e8 ("sched/eevdf: Use sched_attr::sched_runtime to set request/slice suggestion")

... we have the userspace per-task tunable slice length, which is
a key parameter that is otherwise difficult to obtain, so provide
it in /proc/$PID/sched.

[ mingo: Clarified the changelog. ]

Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/453349b1-1637-42f5-a7b2-2385392b5956@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/debug.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 4c3d0d9f3db63..115e266db76bf 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -1089,6 +1089,8 @@ void proc_sched_show_task(struct task_struct *p, struct pid_namespace *ns,
 	if (task_has_dl_policy(p)) {
 		P(dl.runtime);
 		P(dl.deadline);
+	} else if (fair_policy(p->policy)) {
+		P(se.slice);
 	}
 #undef PN_SCHEDSTAT
 #undef P_SCHEDSTAT
-- 
2.39.5



