Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2D234029C;
	Tue, 16 Dec 2025 11:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884760; cv=none; b=g/t90LO/n0TifCFiX2opWCwLcx+skZLfb1R8JzuBmNEw8PhxEVrP5TnZWHWEfVom8+AxARVQB+aMyQ5Eq38RQftJVyMLANsHfRm6THiHgpCb8UKYNfHk/7+jSP+fDolI3D2hWzPcJ0K5qOQ/Jm3PUPJEOtFjIL+DtpNvlJahdQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884760; c=relaxed/simple;
	bh=oZQTZ1wvdkW3n6/DdFBI8vB9ojhJpq+pL5sx0bL6F/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cNmX6bH3P2FIRt98JPbOUeQF5kLIn8h295UKvACuZNGy+I6aWs+NaKKNIMu65jUCZfUa6i4Lep1zhLZvBeEKkgHdAjK/a4WV8Cd1iuVwtMCWgxOKrFdAFq9huQafrHW0hbM/wmYXZQHBWI1wUZQs2dLxHnmE8yRxN7u0NXGiSPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QOgb4hYe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QOgb4hYe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC43AC4CEF1;
	Tue, 16 Dec 2025 11:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884760;
	bh=oZQTZ1wvdkW3n6/DdFBI8vB9ojhJpq+pL5sx0bL6F/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QOgb4hYe3wT6fiQzznTUwwMm0sZzPUmbaV8dFv1o61ir6CvSREO9jh9C9q8kDyCSB
	 3xVwt5MYnXA+o6qhgzB6hteZj18WTsYvFOhDt5UiwWjB/zELiwKAQN7hAwcpw37NdD
	 hlp5KGYxn5ALzSQGR5Dv5K6cF3pDT8j9WeG6rLKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xupengbo <xupengbo@oppo.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Aaron Lu <ziqianlu@bytedance.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 291/354] sched/fair: Fix unfairness caused by stalled tg_load_avg_contrib when the last task migrates out
Date: Tue, 16 Dec 2025 12:14:18 +0100
Message-ID: <20251216111331.454959658@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: xupengbo <xupengbo@oppo.com>

[ Upstream commit ca125231dd29fc0678dd3622e9cdea80a51dffe4 ]

When a task is migrated out, there is a probability that the tg->load_avg
value will become abnormal. The reason is as follows:

1. Due to the 1ms update period limitation in update_tg_load_avg(), there
   is a possibility that the reduced load_avg is not updated to tg->load_avg
   when a task migrates out.

2. Even though __update_blocked_fair() traverses the leaf_cfs_rq_list and
   calls update_tg_load_avg() for cfs_rqs that are not fully decayed, the key
   function cfs_rq_is_decayed() does not check whether
   cfs->tg_load_avg_contrib is null. Consequently, in some cases,
   __update_blocked_fair() removes cfs_rqs whose avg.load_avg has not been
   updated to tg->load_avg.

Add a check of cfs_rq->tg_load_avg_contrib in cfs_rq_is_decayed(),
which fixes the case (2.) mentioned above.

Fixes: 1528c661c24b ("sched/fair: Ratelimit update to tg->load_avg")
Signed-off-by: xupengbo <xupengbo@oppo.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Aaron Lu <ziqianlu@bytedance.com>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Tested-by: Aaron Lu <ziqianlu@bytedance.com>
Link: https://patch.msgid.link/20250827022208.14487-1-xupengbo@oppo.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index bf35f6f0a9c4b..62b8c7e914ebc 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4198,6 +4198,9 @@ static inline bool cfs_rq_is_decayed(struct cfs_rq *cfs_rq)
 	if (child_cfs_rq_on_list(cfs_rq))
 		return false;
 
+	if (cfs_rq->tg_load_avg_contrib)
+		return false;
+
 	return true;
 }
 
-- 
2.51.0



