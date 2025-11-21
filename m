Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7EE134C981;
	Fri, 21 Nov 2025 13:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733372; cv=none; b=mIN6G7z0tdycNe/ipnh0TX45DW16w6FIII0shkamP8its4jGSBJ4fu36Y6yXopjsHGeT0pRrpQ+sT3x/YaWV6Etlo8zW0opOgS92Fk1mkS+xBdy1HqtpM+piEren4VF3MaUCN6f7bSZZJ/o1CBk9wdZf9urm0NW48QPuPKb8zRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733372; c=relaxed/simple;
	bh=6C/ZZsY9iq6mKhvNpDQbF0hMzV61fOmS5b2Ob8goKiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gHKPolRfbuiosIHqbYIik6XodQZQ9KXdUWr6i4xutW/HjiHvJAGlvGv0GB2zPBglizB7h903kxmej65h6NFdC1Dbdc32dCZ9hL+v5GT05Zwgxe4qDLBG4E/RrUEzhLj/iIL10I6Pe5BL9FQBCxwi1HwmqHCoQ27CDosc8SGSAzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GG6lgrEx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GG6lgrEx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4787C4CEF1;
	Fri, 21 Nov 2025 13:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733372;
	bh=6C/ZZsY9iq6mKhvNpDQbF0hMzV61fOmS5b2Ob8goKiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GG6lgrEx1kQrVdP59WsTu8c/LxZMjFYgd3UhSF3z80m8rhiA1ZWqvgCyfx4f9ydNW
	 TmaN+fBiz7vCZs3iLS6FMUwlldY2TwlP4dosa9nmt8lK6OYgKNL5Q/olc4NCEFUsux
	 ZdSlJcm79CXmi68HByE8y1Sw301BjfQT2JwY9Fq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 446/529] bpf: Add bpf_prog_run_data_pointers()
Date: Fri, 21 Nov 2025 14:12:25 +0100
Message-ID: <20251121130246.880444362@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

[ Upstream commit 4ef92743625818932b9c320152b58274c05e5053 ]

syzbot found that cls_bpf_classify() is able to change
tc_skb_cb(skb)->drop_reason triggering a warning in sk_skb_reason_drop().

WARNING: CPU: 0 PID: 5965 at net/core/skbuff.c:1192 __sk_skb_reason_drop net/core/skbuff.c:1189 [inline]
WARNING: CPU: 0 PID: 5965 at net/core/skbuff.c:1192 sk_skb_reason_drop+0x76/0x170 net/core/skbuff.c:1214

struct tc_skb_cb has been added in commit ec624fe740b4 ("net/sched:
Extend qdisc control block with tc control block"), which added a wrong
interaction with db58ba459202 ("bpf: wire in data and data_end for
cls_act_bpf").

drop_reason was added later.

Add bpf_prog_run_data_pointers() helper to save/restore the net_sched
storage colliding with BPF data_meta/data_end.

Fixes: ec624fe740b4 ("net/sched: Extend qdisc control block with tc control block")
Reported-by: syzbot <syzkaller@googlegroups.com>
Closes: https://lore.kernel.org/netdev/6913437c.a70a0220.22f260.013b.GAE@google.com/
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Reviewed-by: Victor Nogueira <victor@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20251112125516.1563021-1-edumazet@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/filter.h | 20 ++++++++++++++++++++
 net/sched/act_bpf.c    |  6 ++----
 net/sched/cls_bpf.c    |  6 ++----
 3 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 4ffea87e6fb64..ad5a3d68b5552 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -685,6 +685,26 @@ static inline void bpf_compute_data_pointers(struct sk_buff *skb)
 	cb->data_end  = skb->data + skb_headlen(skb);
 }
 
+static inline int bpf_prog_run_data_pointers(
+	const struct bpf_prog *prog,
+	struct sk_buff *skb)
+{
+	struct bpf_skb_data_end *cb = (struct bpf_skb_data_end *)skb->cb;
+	void *save_data_meta, *save_data_end;
+	int res;
+
+	save_data_meta = cb->data_meta;
+	save_data_end = cb->data_end;
+
+	bpf_compute_data_pointers(skb);
+	res = bpf_prog_run(prog, skb);
+
+	cb->data_meta = save_data_meta;
+	cb->data_end = save_data_end;
+
+	return res;
+}
+
 /* Similar to bpf_compute_data_pointers(), except that save orginal
  * data in cb->data and cb->meta_data for restore.
  */
diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
index ac87fcff4795e..a1c0e8a9fc8c2 100644
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -47,12 +47,10 @@ TC_INDIRECT_SCOPE int tcf_bpf_act(struct sk_buff *skb,
 	filter = rcu_dereference(prog->filter);
 	if (at_ingress) {
 		__skb_push(skb, skb->mac_len);
-		bpf_compute_data_pointers(skb);
-		filter_res = bpf_prog_run(filter, skb);
+		filter_res = bpf_prog_run_data_pointers(filter, skb);
 		__skb_pull(skb, skb->mac_len);
 	} else {
-		bpf_compute_data_pointers(skb);
-		filter_res = bpf_prog_run(filter, skb);
+		filter_res = bpf_prog_run_data_pointers(filter, skb);
 	}
 	if (unlikely(!skb->tstamp && skb->tstamp_type))
 		skb->tstamp_type = SKB_CLOCK_REALTIME;
diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
index db7151c6b70b7..29dfe6767f108 100644
--- a/net/sched/cls_bpf.c
+++ b/net/sched/cls_bpf.c
@@ -97,12 +97,10 @@ TC_INDIRECT_SCOPE int cls_bpf_classify(struct sk_buff *skb,
 		} else if (at_ingress) {
 			/* It is safe to push/pull even if skb_shared() */
 			__skb_push(skb, skb->mac_len);
-			bpf_compute_data_pointers(skb);
-			filter_res = bpf_prog_run(prog->filter, skb);
+			filter_res = bpf_prog_run_data_pointers(prog->filter, skb);
 			__skb_pull(skb, skb->mac_len);
 		} else {
-			bpf_compute_data_pointers(skb);
-			filter_res = bpf_prog_run(prog->filter, skb);
+			filter_res = bpf_prog_run_data_pointers(prog->filter, skb);
 		}
 		if (unlikely(!skb->tstamp && skb->tstamp_type))
 			skb->tstamp_type = SKB_CLOCK_REALTIME;
-- 
2.51.0



