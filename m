Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441F04C74;
	Wed, 19 Jun 2024 13:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802019; cv=none; b=bRZI6LYvOchGmMGhcvUOT8t9b2gaResdBD68sz/3wC6lGl63u0ucKSSoYq3ZkNOpiA5aUEl13Za3ZazqUCw/vn385xAQcx9/1mw/SUmjV94HsyefdYtrguONzLoVkMPwJNuck2SPCam8R4uqODbN/UKxJ47CW1lJO+JgouUtncg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802019; c=relaxed/simple;
	bh=YxivzJGtomxFVJj8ocwPG10xAqSEVLVnHT/G2n8GpLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KMBdUy5BZLKMH4uU9tdZegjWN4hmF5s2b3T7wn5ddhL3WqRCKxQnz0d1cKNU5Crf/nbvera3u/ZuOmyIRBX3QKUTXDufFf7r5wZT/vFToZs5IHREojpHeOoM0J+p4aWm1f8HqRVMLz0o/d+8pasbLoYuV93QnnDnEYs3aSDifPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jazZrLH2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jazZrLH2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFFA1C2BBFC;
	Wed, 19 Jun 2024 13:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802019;
	bh=YxivzJGtomxFVJj8ocwPG10xAqSEVLVnHT/G2n8GpLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jazZrLH28wPsu2CA3nD4aotzNuulN3iq77F5Y8ZpZb4/JAiXX3sIXD9SRpwHCI1mg
	 j+MvtyWAQrTuO+LhR9dXWa3wgk233DILQq5yZBq8I4dWUqarc91SADIyqqzfbBi/GL
	 td7yNGDnBOan1hS5NtWaO7qYRDzMd44gqphpuCKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1989ee16d94720836244@syzkaller.appspotmail.com,
	Cong Wang <cong.wang@bytedance.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jiri Olsa <jolsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/267] bpf: Fix a potential use-after-free in bpf_link_free()
Date: Wed, 19 Jun 2024 14:52:54 +0200
Message-ID: <20240619125607.248143797@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
User-Agent: quilt/0.67
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
index e9a68c6043ce5..65df92f5b1922 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2830,6 +2830,7 @@ static int bpf_obj_get(const union bpf_attr *attr)
 void bpf_link_init(struct bpf_link *link, enum bpf_link_type type,
 		   const struct bpf_link_ops *ops, struct bpf_prog *prog)
 {
+	WARN_ON(ops->dealloc && ops->dealloc_deferred);
 	atomic64_set(&link->refcnt, 1);
 	link->type = type;
 	link->id = 0;
@@ -2888,16 +2889,17 @@ static void bpf_link_defer_dealloc_mult_rcu_gp(struct rcu_head *rcu)
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
@@ -2906,9 +2908,8 @@ static void bpf_link_free(struct bpf_link *link)
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
2.43.0



