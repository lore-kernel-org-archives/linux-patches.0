Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656FA325485;
	Mon, 27 Oct 2025 19:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592274; cv=none; b=kq3yOqMIPXyap3sDf1LrlSx8RgOArZCrWP4QYHKcEmCz6n4ZBuBo6uub2lr+kpidIo+2bEEYcmIr/1u5t5TGCdMXxZE/L3dcGZ5t3GrAIhEkP1simOv350anNWyTvRB/3aHLW9cy8V0YrzjxxkmvjTXsE4q3NeMgF+RUZZ0OLqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592274; c=relaxed/simple;
	bh=NkcqNXFMQbYgTLPUfRRSGN68ulYYwv8TYcnrt0CTm+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bvfppQo66+BzXMqOPbgrpgc1TahCHgTOyJG+zJyyT6JVG1sIZmp6UceS32ZXHZSUZOBfniiy4JiYglN5jU2FBnwkqTKXaNHCv/kRANe6qy5a6vgMfggNMml1Pq+O2wWcsBxTJnrVq5A8mZdYJ/C7656AshkK6HEQImJCieAmfOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e4jrOx9T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e4jrOx9T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4044C4CEF1;
	Mon, 27 Oct 2025 19:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592274;
	bh=NkcqNXFMQbYgTLPUfRRSGN68ulYYwv8TYcnrt0CTm+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e4jrOx9TD3zOFhCKOrI/Znog0AC5Z0cDCVUf/1vOK6SsnN4R9GGIGmFuk10Trg1TL
	 j1FGALtqjy4Jzo8jmdgxx1cJvoswXT9qWRpUO/8N0HdLPgpM1w82L3h/9StkpvHoh+
	 YrDx4hGHimOsAzQky+g5wCWDXXjdkyNcj6pt8A00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Guittot <vincent.guittot@linaro.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 060/157] sched/fair: Fix pelt lost idle time detection
Date: Mon, 27 Oct 2025 19:35:21 +0100
Message-ID: <20251027183502.896337108@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Guittot <vincent.guittot@linaro.org>

[ Upstream commit 17e3e88ed0b6318fde0d1c14df1a804711cab1b5 ]

The check for some lost idle pelt time should be always done when
pick_next_task_fair() fails to pick a task and not only when we call it
from the fair fast-path.

The case happens when the last running task on rq is a RT or DL task. When
the latter goes to sleep and the /Sum of util_sum of the rq is at the max
value, we don't account the lost of idle time whereas we should.

Fixes: 67692435c411 ("sched: Rework pick_next_task() slow-path")
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index cf889d1ed13d1..b6795bf15211c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7908,21 +7908,21 @@ done: __maybe_unused;
 	return p;
 
 idle:
-	if (!rf)
-		return NULL;
-
-	new_tasks = sched_balance_newidle(rq, rf);
+	if (rf) {
+		new_tasks = sched_balance_newidle(rq, rf);
 
-	/*
-	 * Because sched_balance_newidle() releases (and re-acquires) rq->lock, it is
-	 * possible for any higher priority task to appear. In that case we
-	 * must re-start the pick_next_entity() loop.
-	 */
-	if (new_tasks < 0)
-		return RETRY_TASK;
+		/*
+		 * Because sched_balance_newidle() releases (and re-acquires)
+		 * rq->lock, it is possible for any higher priority task to
+		 * appear. In that case we must re-start the pick_next_entity()
+		 * loop.
+		 */
+		if (new_tasks < 0)
+			return RETRY_TASK;
 
-	if (new_tasks > 0)
-		goto again;
+		if (new_tasks > 0)
+			goto again;
+	}
 
 	/*
 	 * rq is about to be idle, check if we need to update the
-- 
2.51.0



