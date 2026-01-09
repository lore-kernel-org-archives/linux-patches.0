Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446A3359FB5;
	Fri,  9 Jan 2026 11:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959114; cv=none; b=n+0aNB1l9yBXQUHggWzYEAZvePU8gA5PwwOqQpysDGXRjc6Dm5Tvc8cccK5cDNvvrzipZ2HlOV2BJiJ9LtA2RTq7Tt4dRinCC4y6WysEUB4oyn8mbu5LbuwEIGgDOvbFIYuRPRhwkYjqtxXqMi/o3xvpcxKqIIANBVr3mnGMw0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959114; c=relaxed/simple;
	bh=wi07Mr0yh9S+hUsxli6RFtuu/4x5RVC3gVHHeVOwG/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WZupJg8a+Kuwkq9+m6qD/20pvWu8MRX9KhvOLwjFhvlCz7mJ0tceGNG6sCuBCOUx4wzK/UMSSq71mAB2sZGCBNKsLZRi4HaoP+wSUOrY0xy+vsW1/dih/qjsPEJCGrya6IlZJZQ+X2t/7uWD6X42uZQphJPOcD2MZUxc4IGagOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SQVJjlv5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SQVJjlv5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 742EDC4CEF1;
	Fri,  9 Jan 2026 11:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959113;
	bh=wi07Mr0yh9S+hUsxli6RFtuu/4x5RVC3gVHHeVOwG/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SQVJjlv5TJzAQq16buZt3qmO4Mo3zJSPNAEobVGBcSexypFda6aVzLDk9Un+eeQKh
	 1acfIhtJHQu2lCiadbsJ9lCet6JGZlySZ6rLbJ3E8ZAGojxbjr5rogIMGqjSjxkwut
	 Lr2Q65W7eIdWao1i9ODWKBge70DrDnn+NMei8thg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Chris Mason <clm@meta.com>
Subject: [PATCH 6.18 3/5] sched/fair: Small cleanup to update_newidle_cost()
Date: Fri,  9 Jan 2026 12:44:05 +0100
Message-ID: <20260109111950.476102220@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109111950.344681501@linuxfoundation.org>
References: <20260109111950.344681501@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit 08d473dd8718e4a4d698b1113a14a40ad64a909b upstream.

Simplify code by adding a few variables.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Chris Mason <clm@meta.com>
Link: https://patch.msgid.link/20251107161739.655208666@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/fair.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -12124,22 +12124,25 @@ void update_max_interval(void)
 
 static inline bool update_newidle_cost(struct sched_domain *sd, u64 cost)
 {
+	unsigned long next_decay = sd->last_decay_max_lb_cost + HZ;
+	unsigned long now = jiffies;
+
 	if (cost > sd->max_newidle_lb_cost) {
 		/*
 		 * Track max cost of a domain to make sure to not delay the
 		 * next wakeup on the CPU.
 		 */
 		sd->max_newidle_lb_cost = cost;
-		sd->last_decay_max_lb_cost = jiffies;
-	} else if (time_after(jiffies, sd->last_decay_max_lb_cost + HZ)) {
+		sd->last_decay_max_lb_cost = now;
+
+	} else if (time_after(now, next_decay)) {
 		/*
 		 * Decay the newidle max times by ~1% per second to ensure that
 		 * it is not outdated and the current max cost is actually
 		 * shorter.
 		 */
 		sd->max_newidle_lb_cost = (sd->max_newidle_lb_cost * 253) / 256;
-		sd->last_decay_max_lb_cost = jiffies;
-
+		sd->last_decay_max_lb_cost = now;
 		return true;
 	}
 


