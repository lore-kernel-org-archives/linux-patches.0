Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656D131A7EA;
	Fri,  9 Jan 2026 11:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959067; cv=none; b=kYaBYQaTq0sy6eQLUVkQq3jY5Bnp8q6BEhKGJecY+HG95NkLeV+ygOWdiiXXZljdPUi5hLUwEJ2w8tzRrHOgLCTATRCgi+uI4hr83phnaSbmVW2nUJ6VOXWJOsShx7IG7B/GPe2JreAUraAMdZPFoNB/fPW7+u8+v6R/biHsePw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959067; c=relaxed/simple;
	bh=+Y8zA8Qztjv2vQNYxql7OEic9/HyWDFCGGPb+B8uPvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UtnB+sGmUCqlkQJPMCN6312raUNEdfojoRv4ji81cQfg8uZ3WjwXm1SlzFNJHDhVC/PLO6MIhI3VH0Hfb+e/ZhTfL2hXGWLWujs+EOm+SB5SV1DO6D5lC1IZ2Ax2NXF3hjEOmqLkhv89coFzbuVNWacYdX8IHgNa7hXjOn63i0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TJHcN4y2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TJHcN4y2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27A6C4CEF1;
	Fri,  9 Jan 2026 11:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959067;
	bh=+Y8zA8Qztjv2vQNYxql7OEic9/HyWDFCGGPb+B8uPvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TJHcN4y2a6hmYYB0NeBzevhYTnTMYufELzYuI8W69XTzsEHvcwWqvWG8wCsS0/0Ws
	 YiTaKl1VbrEVTe2PGCjouzn7T9dNbq/GzmIs6JG9Q1S1xNtx/bEG+Bqz2v28QnJxKB
	 snbKmYaG/9o3mlyRpVBy+T2aCUFhhoKbqFqQ1b0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Chris Mason <clm@meta.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>
Subject: [PATCH 6.12 12/16] sched/fair: Small cleanup to update_newidle_cost()
Date: Fri,  9 Jan 2026 12:43:53 +0100
Message-ID: <20260109111951.886539649@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109111951.415522519@linuxfoundation.org>
References: <20260109111951.415522519@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

commit 08d473dd8718e4a4d698b1113a14a40ad64a909b upstream.

Simplify code by adding a few variables.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Chris Mason <clm@meta.com>
Link: https://patch.msgid.link/20251107161739.655208666@infradead.org
[ Ajay: Modified to apply on v6.12 ]
Signed-off-by: Ajay Kaher <ajay.kaher@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/fair.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -12188,22 +12188,25 @@ void update_max_interval(void)
 
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
 


