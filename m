Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5F62DAFB0;
	Tue, 16 Dec 2025 12:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886425; cv=none; b=FPn1cWjT4sbpI5KgjKxWlgSvgFujA2nXTwTJhZ3Oln5rUOPGCqcinRoovjyslKY9re5uAXHBfpQN8tzGq1LnsPIpMaTbJjj+k76DPOA8LjL6YKpn/CrV7ckXzXxZQBIV34cet53pIDnVHemlBwAOfS+OoeNaEfRzraAFou4u5RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886425; c=relaxed/simple;
	bh=tmliHKG+Atnpj1IfhKH/DnJUEk9m5F71Zs/wt0uiZGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c9KVFa72B/jvGVaaz5fiV+AjLxfc+EvNuXOGsIau0X/E/ujbANJMMl1SIb6PgFInyhXLkHMrI1GArNIbTtOdfSxSmHqXWwM8z/gEqPiaHeIMcIVDjEji3WIarxkmoaFQNZdaFUjlvRNE0QBkXDLHQPcvMu5mJoAwt8SiDDTOgtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zv0eLGPj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zv0eLGPj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CEA1C4CEF1;
	Tue, 16 Dec 2025 12:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886424;
	bh=tmliHKG+Atnpj1IfhKH/DnJUEk9m5F71Zs/wt0uiZGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zv0eLGPjNfTeGpCedaf2cqt5fr511Khf4T6Y5DUZVuT8UO44suoHIb7skZq5LXLLN
	 N/8TwKl4BSa27qTgn2+FdhWNQwPs3wtt47BG2svwAkT/OCG8tf8qQqC2zyISyHsZYg
	 V0BkjrC2J2lVNcTvsDies0svqYJdxGdi3nrASObo=
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
Subject: [PATCH 6.17 433/507] sched/fair: Fix unfairness caused by stalled tg_load_avg_contrib when the last task migrates out
Date: Tue, 16 Dec 2025 12:14:34 +0100
Message-ID: <20251216111401.145992602@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 35b98cad06515..434df3fb6c443 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4062,6 +4062,9 @@ static inline bool cfs_rq_is_decayed(struct cfs_rq *cfs_rq)
 	if (child_cfs_rq_on_list(cfs_rq))
 		return false;
 
+	if (cfs_rq->tg_load_avg_contrib)
+		return false;
+
 	return true;
 }
 
-- 
2.51.0



