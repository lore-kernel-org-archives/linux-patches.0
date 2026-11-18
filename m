Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018865;
	b=jHN1QtU0zEWSg0S+fgyNsQTa/fHuTY3aMjYAJV69FxD0tSJ4CiWznbeJzsP9//lEZlbB
	 tSpE9B0TKJmP/ZtNbVI4243uhma9h3I8zp2/BoxjIN7SgCF4rFsAxC3gwMgcFcJmBn19O
	 vilnW2IB03zGbdkE1/YYzYGFIU3lt1hMkh2ZbMFLjYJ+f2ckEXkppiDTszs3/l2g7omQI
	 iJ6jKnYgvVaClmmOdzTDyF0GV0v2p/AlaNih887EkYmMk0W4GKuYozgA8dxxR27kaWE/+
	 1aj4iYAb3f+/Xz9ptdzB7s/QiGqub5YFxldGkfgm8ey69cwqeSkWh0VSvrr8p4SR6sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018865;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2COh4A5Zz1hc0Nz+GSZP9nBNSCKEWPAtOMrSbEK+5tc=;
	b=bv4IXb1kuPXNkegERu8LRWwEOFFp9s9nHdq/Km0D80Ucn6E+qJH9ga0DQVoC9jix+g4t
	 8vIQDGRs7Hd0l9lSBt6+ghYZItf9eYCcZ4iFf6f2s2kvcx4M9PuPsu2ydbmXmR4BnklbJ
	 RqFcIMRtt8K9AtiNf/VHLrck+qdzgrW0AWh9fsPRDGj6yHV+TDmuRpIokrB8UKMKpB2vI
	 UX/naRjEZ0hMEaNwK/kJOTsTcgFqpPgEK2Y0G4hZQdrBAKYmRJEblfaJgP0dQXSG7LRfg
	 4Wz4r7Y9QhNN63JgfVR4W4c8fMffWtP1qoj3Nl8eg3G1OgW0WOPBiyVcUFnwhz5nrPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LKYpQYAi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73480606A320;
	Wed, 18 Nov 2026 16:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LKYpQYAi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3FF21F000C4;
	Wed, 18 Nov 2026 16:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018865;
	bh=2COh4A5Zz1hc0Nz+GSZP9nBNSCKEWPAtOMrSbEK+5tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LKYpQYAiulHIzYZP0tufhyG4m24wv/OVMXP3zTtxaOxelNFLMjgofiQbH+fF+iDa9
	 upQ195R/6WTqO8hocPzXsaJB2Fupqosq8bFhWEOTuzhV0bpXrVdwiYai+myaJ8sMaq
	 W/CvEe/nGS6vUtykLky5KyK0j02m8qpwPW9jUDB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1390/2651] sched_ext: Clear a sub-schedulers caps before ops.sub_detach()
Date: Wed, 18 Nov 2026 15:43:50 +0100
Message-ID: <20261118150338.060183095@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit a546831dff38b624240a90a6ff6d2b43d9226d51 ]

A sub-scheduler can leave standing state behind on the cids delegated to it,
cpuperf targets being the obvious case, and the kernel does not track who
wrote it. Restoring it is the parent's job and ops.sub_detach() is the place
for it. Today the parent can't rely on that: the dying sub-scheduler keeps
every cap until it is marked dead after ops.exit(), so its ops.exit() or a
late timer can write after the parent has cleaned up.

Clear every cap of the sub-scheduler before ops.sub_detach(). The pshard
caps go first as a pending sync recomputes ecaps from them, and ecaps are
then zeroed directly. A grant racing the clear is refused under the child's
pshard lock, so nothing hands the caps back.

Fixes: 86094b95efcf ("sched_ext: Add per-shard cap delegation for sub-schedulers")
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext/internal.h |  7 ++++++
 kernel/sched/ext/sub.c      | 49 ++++++++++++++++++++++++++++++++++---
 2 files changed, 52 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/ext/internal.h b/kernel/sched/ext/internal.h
index 352547aedbb70..b9658b35bf966 100644
--- a/kernel/sched/ext/internal.h
+++ b/kernel/sched/ext/internal.h
@@ -828,6 +828,10 @@ struct sched_ext_ops {
 	/**
 	 * @sub_detach: Detach a sub-scheduler
 	 * @args: argument container, see the struct definition
+	 *
+	 * The sub-scheduler holds no caps by this point and can no longer
+	 * affect any cid. Whatever was delegated to it, e.g. cpuperf targets,
+	 * is the parent's to restore here.
 	 */
 	void (*sub_detach)(struct scx_sub_detach_args *args);
 
@@ -911,6 +915,9 @@ struct sched_ext_ops {
 	 * ops.exit() is also called on ops.init() failure, which is a bit
 	 * unusual. This is to allow rich reporting through @info on how
 	 * ops.init() failed.
+	 *
+	 * A sub-scheduler holds no caps by the time ops.exit() runs. Its
+	 * cap-gated kfuncs are denied.
 	 */
 	void (*exit)(struct scx_exit_info *info);
 
diff --git a/kernel/sched/ext/sub.c b/kernel/sched/ext/sub.c
index 212de1cb8502d..a75b43296dc92 100644
--- a/kernel/sched/ext/sub.c
+++ b/kernel/sched/ext/sub.c
@@ -1153,6 +1153,34 @@ void scx_offline_ecaps(struct rq *rq)
 	}
 }
 
+/*
+ * Clear every cap @sch holds. The pshard caps go first as they are the source a
+ * pending sync recomputes ecaps from. ecaps are then zeroed directly for the
+ * cap checks.
+ */
+static void clear_all_caps(struct scx_sched *sch)
+{
+	s32 si, cpu;
+	u32 cap_bit;
+
+	/* enable may have failed before scx_alloc_pshards() */
+	if (!sch->pshard)
+		return;
+
+	for (si = 0; si < sch->nr_pshards; si++) {
+		struct scx_pshard *ps = sch->pshard[si];
+
+		guard(raw_spinlock_irqsave)(&ps->lock);
+		for (cap_bit = 0; cap_bit < __SCX_NR_CAPS; cap_bit++)
+			scx_cmask_clear(&ps->caps[cap_bit].cmask);
+	}
+
+	for_each_possible_cpu(cpu) {
+		guard(rq_lock_irqsave)(cpu_rq(cpu));
+		WRITE_ONCE(per_cpu_ptr(sch->pcpu, cpu)->ecaps, 0);
+	}
+}
+
 /*
  * @pcpu's sched was unhashed before the grace period, so nothing re-queues its
  * sync node. Remove the node from @rq's pending list so the pcpu can be freed.
@@ -1628,6 +1656,12 @@ void scx_sub_disable(struct scx_sched *sch)
 
 	scx_unlink_sched(sch);
 
+	/*
+	 * The parent restores what it delegated in ops.sub_detach(). @sch must
+	 * hold no caps by then.
+	 */
+	clear_all_caps(sch);
+
 	mutex_unlock(&scx_enable_mutex);
 
 	/*
@@ -2306,8 +2340,8 @@ static s32 sub_cap_preamble(u64 cgroup_id, u64 caps, const struct bpf_prog_aux *
  * All-or-nothing keeps the caller-visible result binary per cid, so the denied
  * mask is one mask to interpret rather than a per-cap matrix.
  *
- * Return 0 on full success, -EPERM if any cid was refused, or a negative
- * errno on other failures.
+ * Return 0 on full success, -EPERM if any cid was refused, -ENODEV if the child
+ * is gone or being disabled, or a negative errno on other failures.
  */
 __bpf_kfunc s32 scx_bpf_sub_grant(u64 cgroup_id, u64 caps,
 				  const struct scx_cmask *cmask__arena,
@@ -2361,6 +2395,12 @@ __bpf_kfunc s32 scx_bpf_sub_grant(u64 cgroup_id, u64 caps,
 		scoped_guard (raw_spinlock, &pps->lock) {
 			guard(raw_spinlock_nested)(&cps->lock);
 
+			/* the child is being disabled, see clear_all_caps() */
+			if (unlikely(READ_ONCE(child->aborting))) {
+				ret = -ENODEV;
+				goto out;
+			}
+
 			/*
 			 * Narrow granted_cids to cids the parent holds every
 			 * requested cap on. All-or-nothing per cid.
@@ -2413,9 +2453,10 @@ __bpf_kfunc s32 scx_bpf_sub_grant(u64 cgroup_id, u64 caps,
 		}
 	}
 
+	ret = any_denied ? -EPERM : 0;
+out:
 	caps_updated_deliver(&to_deliver);
-
-	return any_denied ? -EPERM : 0;
+	return ret;
 }
 
 /**
-- 
2.53.0



