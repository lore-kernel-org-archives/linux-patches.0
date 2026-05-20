Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B6029B78D;
	Wed, 20 May 2026 18:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301258; cv=none; b=BIHi7crzr9zNXbQVeCx84eiuTo016XpNuS9fLazMO+OwFkUqG9domH9tGUlJvoupzO3FlCIbmVnKT9ehVVWMS0CyuV4Gecb0taQfE3VebmEcIhrN1VJjIUeaUZ5NIWSfiXjRJlqRU9fwqSBnzvU+DxQjeekw2Ks18JrP4JtDNc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301258; c=relaxed/simple;
	bh=Fn2yuHdThLWWesVX4l0c7AdopvbUV5kiqZ39Nl/8Sus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WEDoRx4aqanUCWgpu0/moQD8jSt5lelIW/3TwzCTi3j6aSAwigXqgtZrf25ckXrvmgCwCwIu5/J2oQ0OQwCDZf8wKn765GLmeiiCJCzvTI5jgExduyn2HcLenm3lfsOfelJhnenMoWyr1BWKe3tjSC+lJJt1KYVPG2b9wj0odH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uzWxJTWX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uzWxJTWX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 948341F000E9;
	Wed, 20 May 2026 18:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301257;
	bh=7SG4EBr1usEIZ+8IH/jPbGGmUruW/9L7zgTJVgMEquQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uzWxJTWXzbs1IbS3Kp2SoVlZ+OOtnpWWsAEza/NuFjmqB8xMYjegNzICvnHEINaMB
	 XibS1VaZ6XAWlQCrNVl7QPCvVaPpLE6XX0hF/Ta0slM2dBAPXip5xuEPkILu7dmlm7
	 utZG+nTSet/Gi1XoYGxxJ4yMz53cE+wnH4siTW2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 487/666] net/sched: sch_fq_codel: remove data-races from fq_codel_dump_stats()
Date: Wed, 20 May 2026 18:21:38 +0200
Message-ID: <20260520162121.819758059@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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
index 551b7cbdae90c..3f797ec4b0c2f 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -581,6 +581,8 @@ static int fq_codel_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 	};
 	struct list_head *pos;
 
+	sch_tree_lock(sch);
+
 	st.qdisc_stats.maxpacket = q->cstats.maxpacket;
 	st.qdisc_stats.drop_overlimit = q->drop_overlimit;
 	st.qdisc_stats.ecn_mark = q->cstats.ecn_mark;
@@ -589,7 +591,6 @@ static int fq_codel_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 	st.qdisc_stats.memory_usage  = q->memory_usage;
 	st.qdisc_stats.drop_overmemory = q->drop_overmemory;
 
-	sch_tree_lock(sch);
 	list_for_each(pos, &q->new_flows)
 		st.qdisc_stats.new_flows_len++;
 
-- 
2.53.0



