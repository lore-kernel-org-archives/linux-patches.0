Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A0A1B2194;
	Wed, 19 Mar 2025 14:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394904; cv=none; b=Bv9asO7lzTC9UmWwGUnGyKXy3ps/AI0bwV1GOJTHkB+WxFlB7/qDRdZRMvqedWDwsHy82XNZRPVFskFk0g5EeRh+HzTNpoQnJOmr/yR54PKPns80JHB2pme/xwTbO7ltFgoukB9VQr5TXAN7oeyX96omDK3YYix0KtkdCRa2FVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394904; c=relaxed/simple;
	bh=sjFtLJ1iS93fwb/PQ4KW3Fjt+ljisj6KhYvLihwr1ZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EQAgNOUrTgyzcxlhPESiRsXe8gUegjg4MBABUVluiHzluvxRwFHQWuU/KJ/xV8seT6wLrb2GQQnSz4BCoL+l+qiNbCFSjpNqI4M/Um0vs279uA/aTHerT8yKQ6uUWLUUqZpr2V4TZXottsfn33FIvgvHkbCEtLqI1OmGg8Hs1So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WAuy4N6u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WAuy4N6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6373EC4AF0B;
	Wed, 19 Mar 2025 14:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394904;
	bh=sjFtLJ1iS93fwb/PQ4KW3Fjt+ljisj6KhYvLihwr1ZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WAuy4N6ul8lHfRCNfcqCI0JeUFhEBAZL+jZ/AFnCtoU5ftxhAbjwVw2GmY91LrbVY
	 LLTRhLM/59pDjGt7rDchLZ5CWDoNzZisW14iv/ywh4+Z/wX6D3/KPip4bB1BpICx1R
	 FRaTZl0OLpCrxGk3HofbdHX7lrqnGupDmRVE1+Vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <christian.loehle@arm.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 064/241] sched/debug: Provide slice length for fair tasks
Date: Wed, 19 Mar 2025 07:28:54 -0700
Message-ID: <20250319143029.310674544@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index a1be00a988bf6..5b32d3cc393bf 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -1265,6 +1265,8 @@ void proc_sched_show_task(struct task_struct *p, struct pid_namespace *ns,
 	if (task_has_dl_policy(p)) {
 		P(dl.runtime);
 		P(dl.deadline);
+	} else if (fair_policy(p->policy)) {
+		P(se.slice);
 	}
 #ifdef CONFIG_SCHED_CLASS_EXT
 	__PS("ext.enabled", task_on_scx(p));
-- 
2.39.5



