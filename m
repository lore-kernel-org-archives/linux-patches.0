Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E0E28314A;
	Tue, 26 Aug 2025 13:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215336; cv=none; b=K0bW7sjVS1tENHAcvwQ4lnqp3rSddUdHSlTkcrDImWDbl9rXzjWHbfGo/ikQmK+ofhurr3yXVUTNd/fum3nHyXNUhFINK7LhIGnEzffFnklxD7amVG8CwUtRIodiMNvknTVdJL56J1uS0wnTdgftEPXVW4cOil+q2Fty4xMu3aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215336; c=relaxed/simple;
	bh=RFeOXaeZGCf9SYWoBjZ8BExoDv5tzfLCC8xHe9LYgUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GnAuwW8dClAtGIczM3xKe6eT7VNYiD5RVBEJGeB1mTnFPF541SuEyBYYt2hwBT7gv/BPa2Dwu662wcpYdIpwxwll8XrnaYn4uFXxrvqqItc99RZlApV/3EnpZi5Mr6kHKcyYQ89XCroTepBwG4lcH55pa/1GDllYp/F0DJHdzVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Ni3zbYS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Ni3zbYS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683EBC4CEF1;
	Tue, 26 Aug 2025 13:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215335;
	bh=RFeOXaeZGCf9SYWoBjZ8BExoDv5tzfLCC8xHe9LYgUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Ni3zbYSB6j89FwOLg0qHrX89+Y37tdeN9gAjFh2tdO6NamYP7jYkSi9vQn1FJBk9
	 A8uQaMLVhcZkDG0ucPyfQnYFRvYGz9Sqk3GB9dXwwj4In+pE2sD61swOFefuVjHI6G
	 yBp0Aw9F+uNMRq9c2x0YDbDmV3+hxZK4Ah3kxh6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Liu <will@willsroot.io>,
	Savino Dicanosa <savy@syst3mfailure.io>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 475/482] net/sched: Remove unnecessary WARNING condition for empty child qdisc in htb_activate
Date: Tue, 26 Aug 2025 13:12:08 +0200
Message-ID: <20250826110942.554478300@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: William Liu <will@willsroot.io>

[ Upstream commit 2c2192e5f9c7c2892fe2363244d1387f62710d83 ]

The WARN_ON trigger based on !cl->leaf.q->q.qlen is unnecessary in
htb_activate. htb_dequeue_tree already accounts for that scenario.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: William Liu <will@willsroot.io>
Reviewed-by: Savino Dicanosa <savy@syst3mfailure.io>
Link: https://patch.msgid.link/20250819033632.579854-1-will@willsroot.io
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_htb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 1e19d3ffbf21..7aac0916205b 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -589,7 +589,7 @@ htb_change_class_mode(struct htb_sched *q, struct htb_class *cl, s64 *diff)
  */
 static inline void htb_activate(struct htb_sched *q, struct htb_class *cl)
 {
-	WARN_ON(cl->level || !cl->leaf.q || !cl->leaf.q->q.qlen);
+	WARN_ON(cl->level || !cl->leaf.q);
 
 	if (!cl->prio_activity) {
 		cl->prio_activity = 1 << cl->prio;
-- 
2.50.1



