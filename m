Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217218;
	b=0WOsOdePL4TINmZnq/SuLEliQmF6QYsK4GTvUpW2nn2FPtj5IW3Ei1tum1BMeQgnefby
	 //b7RuFZarlD0KEmjfBs7FKeVHslQ+rcKXORz+dE+bZWLFgWctENDdholFxqjPMPkr/hq
	 8T+tTXRVFtzcd04ZoWTg8IfcZ+vYSH+sijFeCmtSVKFd33XBjq/xnji08b/qQ3kg8OWXs
	 3tX+erAlCzxhm9w7wsodP3JEpLq/DC8eeqk5ZzN0+1lgahehiNcF7IvfQNz8dRGk96ldO
	 QhXvwVAwN8Advf5gLL5rbchwwxK0DouUBocuvVXPJ5QX0N5tG/6HuoDTcXjDmdadkTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217218;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A8cmwkFQbH5TaF7ti87W704ik38sB1Y/Sjl02vFx4sk=;
	b=Lo6mtkvXwEbFHWYFKwE34UDDy5esCqD7JHNLChsE+/c36/BqfEKT+RPkl4yIifNbyWTh
	 6Q0l1jr/DVgnYXNQxh4ReHDDs5Ecrnww7xJkInNu773zT+2M/thp/28m9eRDD2e2cs/EZ
	 /dcy0FbwxcxI+8MzhSDoL/Kj44THSxjd09hx0PUZB/etYxiKFQ4KFS1vjsBQvjIBbrtRe
	 fFIqJXY0Q4PQC8tcZNbSmeiORBp6OFYIBs+T0cuwiT5F/9td47Qd8J4RJ/tqaG8s1QD2v
	 edPw09kC0tzOm58bG/UlIiWN0sIVZ72KtLjMJXBekFhbU+y+6QDMObSUQgfedKQ/xJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="TOOR6K/T";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E349606A31E;
	Wed, 28 Oct 2026 19:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TOOR6K/T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D72B1F01825;
	Wed, 28 Oct 2026 19:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217218;
	bh=A8cmwkFQbH5TaF7ti87W704ik38sB1Y/Sjl02vFx4sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TOOR6K/TwxbqiUJr/lX81Xfj8VimxpnKJg922GP25F2kh95fcwTfFLoDyQ0GMmbd8
	 /sM3psxtsTSXuYnT+GGylNiv+AyKDx4j5In+FuAeLuSR1CZBXL4RWFqI+FJ3NZ5vZv
	 oCxCCEu76Pk3IlnORBZu5Tvp5c7HnBMSvOO+Xf3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1989ee16d94720836244@syzkaller.appspotmail.com,
	Cong Wang <cong.wang@bytedance.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jiri Olsa <jolsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1826/1887] bpf: Fix a potential use-after-free in bpf_link_free()
Date: Wed, 28 Oct 2026 18:05:22 +0100
Message-ID: <20261028170540.995863340@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Wang <cong.wang@bytedance.com>

[ Upstream commit 2884dc7d08d98a89d8d65121524bb7533183a63a ]

After commit 1a80dbcb2dba, bpf_link can be freed by
link->ops->dealloc_deferred, but the code still tests and uses
link->ops->dealloc afterward, which leads to a use-after-free as
reported by syzbot. Actually, one of them should be sufficient, so
just call one of them instead of both. Also add a WARN_ON() in case
of any problematic implementation.

Fixes: 1a80dbcb2dba ("bpf: support deferring bpf_link dealloc to after RCU grace period")
Reported-by: syzbot+1989ee16d94720836244@syzkaller.appspotmail.com
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/bpf/20240602182703.207276-1-xiyou.wangcong@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index df9ce9cc7c112..97dbfb8832aef 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2725,6 +2725,7 @@ static int bpf_obj_get(const union bpf_attr *attr)
 void bpf_link_init(struct bpf_link *link, enum bpf_link_type type,
 		   const struct bpf_link_ops *ops, struct bpf_prog *prog)
 {
+	WARN_ON(ops->dealloc && ops->dealloc_deferred);
 	atomic64_set(&link->refcnt, 1);
 	link->type = type;
 	link->id = 0;
@@ -2781,16 +2782,17 @@ static void bpf_link_defer_dealloc_mult_rcu_gp(struct rcu_head *rcu)
 /* bpf_link_free is guaranteed to be called from process context */
 static void bpf_link_free(struct bpf_link *link)
 {
+	const struct bpf_link_ops *ops = link->ops;
 	bool sleepable = false;
 
 	bpf_link_free_id(link->id);
 	if (link->prog) {
 		sleepable = link->prog->aux->sleepable;
 		/* detach BPF program, clean up used resources */
-		link->ops->release(link);
+		ops->release(link);
 		bpf_prog_put(link->prog);
 	}
-	if (link->ops->dealloc_deferred) {
+	if (ops->dealloc_deferred) {
 		/* schedule BPF link deallocation; if underlying BPF program
 		 * is sleepable, we need to first wait for RCU tasks trace
 		 * sync, then go through "classic" RCU grace period
@@ -2799,9 +2801,8 @@ static void bpf_link_free(struct bpf_link *link)
 			call_rcu_tasks_trace(&link->rcu, bpf_link_defer_dealloc_mult_rcu_gp);
 		else
 			call_rcu(&link->rcu, bpf_link_defer_dealloc_rcu_gp);
-	}
-	if (link->ops->dealloc)
-		link->ops->dealloc(link);
+	} else if (ops->dealloc)
+		ops->dealloc(link);
 }
 
 static void bpf_link_put_deferred(struct work_struct *work)
-- 
2.53.0



