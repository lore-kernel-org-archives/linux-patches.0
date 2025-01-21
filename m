Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463971F0E44;
	Tue, 21 Jan 2025 18:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482426; cv=none; b=fqN6602kwgE++0+2fWLfMvQ3/4huiSOAgQDzMliBlu1fVkuih13i6vTnag8nJnpZcPM7/0bHIOBNb2tJUsZG6efhEN4yjo9l64tVhDZl4vuqB1YgiVYOTOCg2C7k5mMO+h32INgvj+uIwTmUK270GPncSkS2FKip+rU1iDtvLP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482426; c=relaxed/simple;
	bh=P83EabExJxckXSxQjLxeb7ui0boekyd8/zK4gMzYQgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e59sdxosABwTNADPMDF9K2xxdJUjhHyjRl3kSwYxUAETDIx2x8xZS9LwsyCPSdZugXKkNgRllkdSk5Lj9cSnUVN8LVCEPnIkRKLcDOXFjB0YgPmgvfs8kUb6fQLkTpOT0MwSLad5fwAt4Q7/rSQ29CU+SxJPXkL7c5JU8MTeaZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zz4wjse7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zz4wjse7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51801C4CEDF;
	Tue, 21 Jan 2025 18:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482425;
	bh=P83EabExJxckXSxQjLxeb7ui0boekyd8/zK4gMzYQgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zz4wjse7SNwE5oDcD9CuSf0kw1Gjp9iChcrDP4jD2zH5nAzy8zDgM6RSpnpDVMCXY
	 MOTDDi46B7i+aIJ/WcAw0RMMjhrIneJhSeZCgqwFZfKdAhskqxXGmaRBOIarftvwV/
	 8TxD6bJeZlwI+joKIVFnVq5W0aBsuD8CAlJhYOHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 073/122] sched/fair: Fix update_cfs_group() vs DELAY_DEQUEUE
Date: Tue, 21 Jan 2025 18:52:01 +0100
Message-ID: <20250121174535.806721086@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 66951e4860d3c688bfa550ea4a19635b57e00eca ]

Normally dequeue_entities() will continue to dequeue an empty group entity;
except DELAY_DEQUEUE changes things -- it retains empty entities such that they
might continue to compete and burn off some lag.

However, doing this results in update_cfs_group() re-computing the cgroup
weight 'slice' for an empty group, which it (rightly) figures isn't much at
all. This in turn means that the delayed entity is not competing at the
expected weight. Worse, the very low weight causes its lag to be inflated,
which combined with avg_vruntime() using scale_load_down(), leads to artifacts.

As such, don't adjust the weight for empty group entities and let them compete
at their original weight.

Fixes: 152e11f6df29 ("sched/fair: Implement delayed dequeue")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20250110115720.GA17405@noisy.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index bf8153af96879..7f8677ce83f9f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3956,7 +3956,11 @@ static void update_cfs_group(struct sched_entity *se)
 	struct cfs_rq *gcfs_rq = group_cfs_rq(se);
 	long shares;
 
-	if (!gcfs_rq)
+	/*
+	 * When a group becomes empty, preserve its weight. This matters for
+	 * DELAY_DEQUEUE.
+	 */
+	if (!gcfs_rq || !gcfs_rq->load.weight)
 		return;
 
 	if (throttled_hierarchy(gcfs_rq))
-- 
2.39.5



