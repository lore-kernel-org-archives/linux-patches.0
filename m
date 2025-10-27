Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BA8322520;
	Mon, 27 Oct 2025 18:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590856; cv=none; b=tilWCgVn8hCNLVG0g6jkstsnW/uFRJv92KL79ZvUFCJOjmN39P//Evxsl7sPaMxI7/xpci2ICOj5L8+pNZiTq733YzYERoY2nDQ/ykc/RCKPnjhbouY4kOJeLrgA8CPS0Ge4IIvKBk89Ja2mNog+KL/ar/B5J8nd89bmcMsNyhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590856; c=relaxed/simple;
	bh=J3Iw3IS8AbXRpBG11pG2mN5RJXxF0SK/OPqhHdyJMKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NDD6ULhUEApohTAlyA/cKTF8pSGnjDtw4iasAzFzqdi0F4Hz4HuvQ0dnP5PeNY7B+8p0UVGLBSSWTu6BKXW9cHCSPxYruEHQgbdriR58it3GLCTCZIAr9x18Iauy7ckt3PNLW7+Tcm3OzCMZj4VcZMj6iqxHzGrD/ve+SDV9RiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RoJaWlad; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RoJaWlad"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD40C4CEF1;
	Mon, 27 Oct 2025 18:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590856;
	bh=J3Iw3IS8AbXRpBG11pG2mN5RJXxF0SK/OPqhHdyJMKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RoJaWlade+/8Bg7/HhifL9pqMZ8wL4lZ3OgUrLLqx6q7Bv6xqNfWmKq88MsL69OW3
	 Q2ipYSHrQ7mXA+vUvtVbQRRbE0oTC9qHWvwAtkQQ5koMLXpGZlqnSvAFLYyN4eaGGq
	 v8Ir/USdoFBllpR7wbMsijWRUlYDqPFpJM3eHAfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Guittot <vincent.guittot@linaro.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 169/224] sched/fair: Fix pelt lost idle time detection
Date: Mon, 27 Oct 2025 19:35:15 +0100
Message-ID: <20251027183513.426387259@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 62c0348ef556a..5e8f2167d8caa 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6978,21 +6978,21 @@ done: __maybe_unused;
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



