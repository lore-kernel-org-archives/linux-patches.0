Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA27421F11;
	Wed, 20 May 2026 18:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302761; cv=none; b=UwIoNMJzPEsUreKrvRLtnevm/1IG0HC1muF32iM2kijSjwTsKcdc+0vPjIOiPZE3Yv08LWEcPkqTNPYWUTiVYzQJyVYeeGa+x6xHwPj0HC0cR/+9K0Bqbg06maZy5AVq0BojUpDwhvNJ6R6AaMe0hK914Rd7dN3q5fqspgoXTuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302761; c=relaxed/simple;
	bh=GbTamra561eF+3XSPrWm1Jc7SmZSsBhnZnL27vzlumo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BYGTV2hwDCNhnH+TJtXz14G6gIn/lD8OfEk1v8EJp7xtm+WVhPeRSQmkxItgELHG4qebGLuzas1cV9N3RNUQ/QkSn3hBSOxLorHx8x6eIXfL1SLQc3FzFLhr7lUBvUkAra+jXWz/Mh4kx2+AcBwZKfeShF95UQcZplSRtph9TH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X49jIoWB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X49jIoWB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE641F000E9;
	Wed, 20 May 2026 18:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302759;
	bh=MFFD7KNTOZh1KN85yolISZG+4qf/8hroZqq7bRGZzl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X49jIoWBqRZfokRG1bIRUz+NfKLUYYRdpX3hTifE2R9jR5DjohBoTfN3GRu+C23pD
	 cpqjp+4o+iEDuuoBHPZRdTCYUF93iDFBHNzHXZaXyvghpobH2CXwurZyCMs0hVSkys
	 JdH6nm4ePkK8AAM5Pnw7b69tOnjgKNMjcHpILK6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 348/508] net/sched: sch_fq_codel: remove data-races from fq_codel_dump_stats()
Date: Wed, 20 May 2026 18:22:51 +0200
Message-ID: <20260520162106.177818926@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit bbfaa73ea6871db03dc05d7f05f00557a8981f25 ]

fq_codel_dump_stats() acquires the qdisc spinlock a bit too late.

Move this acquisition before we fill st.qdisc_stats with live data.

Fixes: edb09eb17ed8 ("net: sched: do not acquire qdisc spinlock in qdisc/class stats dump")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260421142509.3967231-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_fq_codel.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index 47b5a056165cb..056895df17854 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -568,6 +568,8 @@ static int fq_codel_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 	};
 	struct list_head *pos;
 
+	sch_tree_lock(sch);
+
 	st.qdisc_stats.maxpacket = q->cstats.maxpacket;
 	st.qdisc_stats.drop_overlimit = q->drop_overlimit;
 	st.qdisc_stats.ecn_mark = q->cstats.ecn_mark;
@@ -576,7 +578,6 @@ static int fq_codel_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 	st.qdisc_stats.memory_usage  = q->memory_usage;
 	st.qdisc_stats.drop_overmemory = q->drop_overmemory;
 
-	sch_tree_lock(sch);
 	list_for_each(pos, &q->new_flows)
 		st.qdisc_stats.new_flows_len++;
 
-- 
2.53.0



