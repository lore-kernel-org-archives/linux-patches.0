Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C16838F939;
	Tue, 10 Mar 2026 11:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142193; cv=none; b=Nd24hOmUzADiW33Z/kfTxX9FwzLeUBCdeYM4NPxrHyoi6mXqpbiScBfM4zjLXmHqiOQkLX3TJ8Zk3axdD04VonO7wQrgvGJBzCstlzCehyRSlN+DXVarb3P6WvcDn7n8LKfLAydb/IZjqfH6rNMLcvAh3TSKqf4J4xvmVJdWsmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142193; c=relaxed/simple;
	bh=LVU74UQWEH643l4SnKnVJ2RShOQuKyYCTZWfZLaC8gA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NrbZY5OJyv2z8n/tkkPtX4ZzuV33moTSDVvAYLZ8N3h1+afZMnXAA38tBAPBSk/JQRNMLga+GJoZnY+ZI1zWFCX+vq9G0XjZiyQ5Vr3868KCuU9fYroifft6XOi7CZcNR6a7sptwtwmN+rOYy8mNfKQe6c0XdOaP66Lj0Jmk7s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nY0ISczA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nY0ISczA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96EF9C2BC9E;
	Tue, 10 Mar 2026 11:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142193;
	bh=LVU74UQWEH643l4SnKnVJ2RShOQuKyYCTZWfZLaC8gA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nY0ISczARxmKmmU8btivH0sspduPaKXAwgQXfqM/srArLC4N1Xkb79xe9IAZMWOGI
	 G7O2wt4u56eHr90fely+W+4RPA/MsasfnFKNelo0Xo8gbpZmdDubgBVie779pAegqR
	 bvqDu7AJNTGAZ+BdB+TkB6RCfqOj1PpilVqEXllF30I2R2AzJL7fT+AsjuZZ6xH+3b
	 HEe0J1JdzqC1DkV5g6Y6GdLeFKOSi+PDOrrTxQ/tkzZV3OVCfp2fTWmBe2LgmJQ7vU
	 xECPHxso3WcKtkWXOKuearBSQD7chHf/E3QvK+SuuR//Gdkp0BSzLsnIM6Fe9an3mn
	 bvONNUk8cx+hw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>,
	Praveen Kaligineedi <pkaligineedi@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 282/314] net_sched: sch_fq: clear q->band_pkt_count[] in fq_reset()
Date: Tue, 10 Mar 2026 07:19:01 -0400
Message-ID: <a42a427069ef9accb155510b731246aa2179c0b2.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a4c2b8be2e5329e7fac6e8f64ddcb8958155cfcb ]

When/if a NIC resets, queues are deactivated by dev_deactivate_many(),
then reactivated when the reset operation completes.

fq_reset() removes all the skbs from various queues.

If we do not clear q->band_pkt_count[], these counters keep growing
and can eventually reach sch->limit, preventing new packets to be queued.

Many thanks to Praveen for discovering the root cause.

Fixes: 29f834aa326e ("net_sched: sch_fq: add 3 bands and WRR scheduling")
Diagnosed-by: Praveen Kaligineedi <pkaligineedi@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260304015640.961780-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_fq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index fee922da2f99c..5e41930079948 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -826,6 +826,7 @@ static void fq_reset(struct Qdisc *sch)
 	for (idx = 0; idx < FQ_BANDS; idx++) {
 		q->band_flows[idx].new_flows.first = NULL;
 		q->band_flows[idx].old_flows.first = NULL;
+		q->band_pkt_count[idx] = 0;
 	}
 	q->delayed		= RB_ROOT;
 	q->flows		= 0;
-- 
2.51.0

