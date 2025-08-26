Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B31B35AADD;
	Tue, 26 Aug 2025 14:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218655; cv=none; b=DB2Vf0p0B+TDrjGbeGJN60DM/dMXr6JNr7130xnK3iRlGl7OjgKQtNksPz7rorw2u1668tRe+iIklzRdp6FAUqEzUeaNYF/Ne/SYEA5mwlHw6mc2HN68indEr5U1uLXTI9QgOUP/p9Ldo+tkuRmzCSJigE1jVNUPdeDsxahd8sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218655; c=relaxed/simple;
	bh=anTHzID9FuEVynkE+aZkJWRQNREpyCKWrdIgQD60gV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FY61sKIkL1BmPVKJEXUAh+s36Zeqhs84z5UvCUAzt2M6QUKHu6PgX6+CnXa8eKof3q/n1z1h/P+ZpcgIBiM+TM1lu1A7tJgGvKEW2yUX4FiKy5W/XQ5h2hNb4QbxvUxm5PbARLDrhb2u+aJz4AtukHVewK35AFm69gUqzgq8XzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BzUHcZys; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BzUHcZys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8CEBC4CEF1;
	Tue, 26 Aug 2025 14:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218654;
	bh=anTHzID9FuEVynkE+aZkJWRQNREpyCKWrdIgQD60gV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BzUHcZysdpLyug5C9QYjUn3vFw2k0bleieY1XWOG0GRoLnelm6HbH+XZWO0Jgdl6T
	 cZtiZp3do3xmP2numty4CsrNFbLYOx7drvCQiEkZnChUobAMNkGxWDcogd9U+2ebY7
	 YVbALMos16ANn5/zmWFicAkxJmOwi1+NWjAgNJpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Octavian Purdila <tavip@google.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 5.4 051/403] net_sched: sch_sfq: use a temporary work area for validating configuration
Date: Tue, 26 Aug 2025 13:06:17 +0200
Message-ID: <20250826110907.269075859@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Octavian Purdila <tavip@google.com>

[ Upstream commit 8c0cea59d40cf6dd13c2950437631dd614fbade6 ]

Many configuration parameters have influence on others (e.g. divisor
-> flows -> limit, depth -> limit) and so it is difficult to correctly
do all of the validation before applying the configuration. And if a
validation error is detected late it is difficult to roll back a
partially applied configuration.

To avoid these issues use a temporary work area to update and validate
the configuration and only then apply the configuration to the
internal state.

Signed-off-by: Octavian Purdila <tavip@google.com>
Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_sfq.c |   56 ++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 44 insertions(+), 12 deletions(-)

--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -631,6 +631,15 @@ static int sfq_change(struct Qdisc *sch,
 	struct red_parms *p = NULL;
 	struct sk_buff *to_free = NULL;
 	struct sk_buff *tail = NULL;
+	unsigned int maxflows;
+	unsigned int quantum;
+	unsigned int divisor;
+	int perturb_period;
+	u8 headdrop;
+	u8 maxdepth;
+	int limit;
+	u8 flags;
+
 
 	if (opt->nla_len < nla_attr_size(sizeof(*ctl)))
 		return -EINVAL;
@@ -656,36 +665,59 @@ static int sfq_change(struct Qdisc *sch,
 		NL_SET_ERR_MSG_MOD(extack, "invalid limit");
 		return -EINVAL;
 	}
+
 	sch_tree_lock(sch);
+
+	limit = q->limit;
+	divisor = q->divisor;
+	headdrop = q->headdrop;
+	maxdepth = q->maxdepth;
+	maxflows = q->maxflows;
+	perturb_period = q->perturb_period;
+	quantum = q->quantum;
+	flags = q->flags;
+
+	/* update and validate configuration */
 	if (ctl->quantum)
-		q->quantum = ctl->quantum;
-	WRITE_ONCE(q->perturb_period, ctl->perturb_period * HZ);
+		quantum = ctl->quantum;
+	perturb_period = ctl->perturb_period * HZ;
 	if (ctl->flows)
-		q->maxflows = min_t(u32, ctl->flows, SFQ_MAX_FLOWS);
+		maxflows = min_t(u32, ctl->flows, SFQ_MAX_FLOWS);
 	if (ctl->divisor) {
-		q->divisor = ctl->divisor;
-		q->maxflows = min_t(u32, q->maxflows, q->divisor);
+		divisor = ctl->divisor;
+		maxflows = min_t(u32, maxflows, divisor);
 	}
 	if (ctl_v1) {
 		if (ctl_v1->depth)
-			q->maxdepth = min_t(u32, ctl_v1->depth, SFQ_MAX_DEPTH);
+			maxdepth = min_t(u32, ctl_v1->depth, SFQ_MAX_DEPTH);
 		if (p) {
-			swap(q->red_parms, p);
-			red_set_parms(q->red_parms,
+			red_set_parms(p,
 				      ctl_v1->qth_min, ctl_v1->qth_max,
 				      ctl_v1->Wlog,
 				      ctl_v1->Plog, ctl_v1->Scell_log,
 				      NULL,
 				      ctl_v1->max_P);
 		}
-		q->flags = ctl_v1->flags;
-		q->headdrop = ctl_v1->headdrop;
+		flags = ctl_v1->flags;
+		headdrop = ctl_v1->headdrop;
 	}
 	if (ctl->limit) {
-		q->limit = min_t(u32, ctl->limit, q->maxdepth * q->maxflows);
-		q->maxflows = min_t(u32, q->maxflows, q->limit);
+		limit = min_t(u32, ctl->limit, maxdepth * maxflows);
+		maxflows = min_t(u32, maxflows, limit);
 	}
 
+	/* commit configuration */
+	q->limit = limit;
+	q->divisor = divisor;
+	q->headdrop = headdrop;
+	q->maxdepth = maxdepth;
+	q->maxflows = maxflows;
+	WRITE_ONCE(q->perturb_period, perturb_period);
+	q->quantum = quantum;
+	q->flags = flags;
+	if (p)
+		swap(q->red_parms, p);
+
 	qlen = sch->q.qlen;
 	while (sch->q.qlen > q->limit) {
 		dropped += sfq_drop(sch, &to_free);


