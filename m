Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4981A257D;
	Thu,  6 Jun 2024 14:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683764; cv=none; b=jEf87g9ByHgfowEnC/5obulgO8liLXgYSJozTh2ixkLPA+JXG53h9VrIdIHGweezLxi/0gUUc5yG2/b+8/73LVHJNQ5fBo+FxfhPBlWAr3pdtWkAQiw0JIt46A0L4t5Lotmu+3r4cePZKOCIRds8sER/Q4Q0gznDXtPB88u75SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683764; c=relaxed/simple;
	bh=fh1L0DzA1oNvpAipzLqEDWL5x29uxq4mq2PaPKl7if8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RzsjPydEIm9WTIMpuTa8WduDfqafWXZpzrh+G7JBGErLDg/wEx8q1MIgprKZPequJ+zMIqTcVb62EQYCH6sRJqdVEcs1Ea9XUj7BeSOmjsccLAAvT03V+8szSdNs74662oZyXIATVJl9AZrELJVZE+Y8lIG8eYnrViAgLSHhrCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cBupHqCo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cBupHqCo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1638C2BD10;
	Thu,  6 Jun 2024 14:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683763;
	bh=fh1L0DzA1oNvpAipzLqEDWL5x29uxq4mq2PaPKl7if8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cBupHqCoelUZMMjYflRzNyqBM4SEup6XGxc7n+cgAe+5aPbViitV7RUlDOMs6XBaT
	 Bj4s8j2pxVkyMsDd1gy6yb3pCs5IJs6r6BbU8YlSw2t+0xZXEtwIMxVpx1NJKpWG9j
	 D4XxNBvIR/3Jb1ucR38T5OslhVj563ZLr053o9C4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	syzbot+ec941d6e24f633a59172@syzkaller.appspotmail.com,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 702/744] bpf: Allow delete from sockmap/sockhash only if update is allowed
Date: Thu,  6 Jun 2024 16:06:14 +0200
Message-ID: <20240606131754.993583455@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Jakub Sitnicki <jakub@cloudflare.com>

[ Upstream commit 98e948fb60d41447fd8d2d0c3b8637fc6b6dc26d ]

We have seen an influx of syzkaller reports where a BPF program attached to
a tracepoint triggers a locking rule violation by performing a map_delete
on a sockmap/sockhash.

We don't intend to support this artificial use scenario. Extend the
existing verifier allowed-program-type check for updating sockmap/sockhash
to also cover deleting from a map.

>From now on only BPF programs which were previously allowed to update
sockmap/sockhash can delete from these map types.

Fixes: ff9105993240 ("bpf, sockmap: Prevent lock inversion deadlock in map delete elem")
Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Reported-by: syzbot+ec941d6e24f633a59172@syzkaller.appspotmail.com
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: syzbot+ec941d6e24f633a59172@syzkaller.appspotmail.com
Acked-by: John Fastabend <john.fastabend@gmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=ec941d6e24f633a59172
Link: https://lore.kernel.org/bpf/20240527-sockmap-verify-deletes-v1-1-944b372f2101@cloudflare.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 1385d01a21e4f..24d7a32f1710e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8742,7 +8742,8 @@ static bool may_update_sockmap(struct bpf_verifier_env *env, int func_id)
 	enum bpf_attach_type eatype = env->prog->expected_attach_type;
 	enum bpf_prog_type type = resolve_prog_type(env->prog);
 
-	if (func_id != BPF_FUNC_map_update_elem)
+	if (func_id != BPF_FUNC_map_update_elem &&
+	    func_id != BPF_FUNC_map_delete_elem)
 		return false;
 
 	/* It's not possible to get access to a locked struct sock in these
@@ -8753,6 +8754,11 @@ static bool may_update_sockmap(struct bpf_verifier_env *env, int func_id)
 		if (eatype == BPF_TRACE_ITER)
 			return true;
 		break;
+	case BPF_PROG_TYPE_SOCK_OPS:
+		/* map_update allowed only via dedicated helpers with event type checks */
+		if (func_id == BPF_FUNC_map_delete_elem)
+			return true;
+		break;
 	case BPF_PROG_TYPE_SOCKET_FILTER:
 	case BPF_PROG_TYPE_SCHED_CLS:
 	case BPF_PROG_TYPE_SCHED_ACT:
@@ -8848,7 +8854,6 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 	case BPF_MAP_TYPE_SOCKMAP:
 		if (func_id != BPF_FUNC_sk_redirect_map &&
 		    func_id != BPF_FUNC_sock_map_update &&
-		    func_id != BPF_FUNC_map_delete_elem &&
 		    func_id != BPF_FUNC_msg_redirect_map &&
 		    func_id != BPF_FUNC_sk_select_reuseport &&
 		    func_id != BPF_FUNC_map_lookup_elem &&
@@ -8858,7 +8863,6 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 	case BPF_MAP_TYPE_SOCKHASH:
 		if (func_id != BPF_FUNC_sk_redirect_hash &&
 		    func_id != BPF_FUNC_sock_hash_update &&
-		    func_id != BPF_FUNC_map_delete_elem &&
 		    func_id != BPF_FUNC_msg_redirect_hash &&
 		    func_id != BPF_FUNC_sk_select_reuseport &&
 		    func_id != BPF_FUNC_map_lookup_elem &&
-- 
2.43.0



