Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4BB374C4;
	Tue, 26 Aug 2025 14:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217068; cv=none; b=bUG2xFCBO/+o4/48254z8AYZd3ZvUPgdnvhTbzipEaHRyLgF4UWV8n8QIcHfmAVvIwBbCrxG3qEaDvkdF90nTZz8aCGwblfgBwr4vAgptip7+156FDslB6RH8sfwgqy6aK51y4DRMVJLGFz8ZpHA31IX/PEGCduPZUZwDyVty1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217068; c=relaxed/simple;
	bh=CfS4YxZqWlnjdgiRUKW+OG7oUwWIrFb9C+QQPFtrBSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i+/RVr6/nojCoGe86wSWZRvqUXOpGbdfv8l13xmJp0lDab1TPNh43KQP1OAcxU+uJI4vHKQnBW58cQhZpq/FBAS1g7/9M6lSjW7vpQt4XBa8W7QmPuoUSvK8HEy1I5fdNBSsGYVqwjx2ETFxi7dJhw2dVUXR+UaWem4SLZTmrMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xpSQaeg2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xpSQaeg2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96BD9C113D0;
	Tue, 26 Aug 2025 14:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217067;
	bh=CfS4YxZqWlnjdgiRUKW+OG7oUwWIrFb9C+QQPFtrBSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xpSQaeg2ol8ji+VasbONi51WUKi77d5Ir1GVcBfZfGinAEZikrLtICIxaujvbIURG
	 sCDrmaX8/YtWmDurZTPc8gn3wKN2ayIBVgKngn+R1W4w4uCDs53+c6KjumUPehadpB
	 nY7j7Pfu0cv/KStvpqtgi8wmD0V8x7oP5iSTFzwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Liu <will@willsroot.io>,
	Savino Dicanosa <savy@syst3mfailure.io>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 638/644] net/sched: Remove unnecessary WARNING condition for empty child qdisc in htb_activate
Date: Tue, 26 Aug 2025 13:12:09 +0200
Message-ID: <20250826111002.369603789@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e9f349cb6446..6c4de685a8e4 100644
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



