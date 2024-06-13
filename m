Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4448144D3B;
	Thu, 13 Jun 2024 12:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281436; cv=none; b=dUFPtiQ6U4onFyvNqvcAuUImTxBZepPK5hLhEjdEey572B48XKCGUgrSrPhEv2ol+YSUBRRza07EHdAAXaOxtwagRxzjeYnmSPFCTVf2AkATuasWbcAnOpEd/9C0O6+oclXbcATc2lyshdLGjn/ITz5CDZuUSQSna8zoYP7VmJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281436; c=relaxed/simple;
	bh=7VxZvNjduGE3KosaTA7Mf9GyMeLB8mnY4Qf1TcbpjAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mYShO4KnTOGCsf2nDHMvlcoR/0pQQpbTGMm+rbk+es2FuFnuc0cELv2tN9gisoii7Y9oYfJPyAyoE7QQp86fmwDS6ysnT++Ou4D6vhHY2wNmWwSazsmsLYYkB0ba+Mfz51eRDbXI3atswP4u4PwaaRGk+eeMYB7npNTR833E9Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q0P6TdD6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q0P6TdD6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CB51C2BBFC;
	Thu, 13 Jun 2024 12:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281436;
	bh=7VxZvNjduGE3KosaTA7Mf9GyMeLB8mnY4Qf1TcbpjAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q0P6TdD6gDmZyEfp/w7aOSxCfVU05/d2CoG5wwfUOu3QW0GwVm5YiN3ThsYlsLr4q
	 p9TAgEfWMkScoe9/p5kWc20hu1jFoVQo9UdJr57QpQsjwBaAypMUm5bBL/VpphiKBd
	 0vKWCWcB0SQ0HBW8tcpHeKH26UAi7FXnzMmpJni8=
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
Subject: [PATCH 5.10 254/317] bpf: Allow delete from sockmap/sockhash only if update is allowed
Date: Thu, 13 Jun 2024 13:34:32 +0200
Message-ID: <20240613113257.374688840@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 25f8a8716e88d..ad115ccc2fe0e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4890,7 +4890,8 @@ static bool may_update_sockmap(struct bpf_verifier_env *env, int func_id)
 	enum bpf_attach_type eatype = env->prog->expected_attach_type;
 	enum bpf_prog_type type = resolve_prog_type(env->prog);
 
-	if (func_id != BPF_FUNC_map_update_elem)
+	if (func_id != BPF_FUNC_map_update_elem &&
+	    func_id != BPF_FUNC_map_delete_elem)
 		return false;
 
 	/* It's not possible to get access to a locked struct sock in these
@@ -4901,6 +4902,11 @@ static bool may_update_sockmap(struct bpf_verifier_env *env, int func_id)
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
@@ -4988,7 +4994,6 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 	case BPF_MAP_TYPE_SOCKMAP:
 		if (func_id != BPF_FUNC_sk_redirect_map &&
 		    func_id != BPF_FUNC_sock_map_update &&
-		    func_id != BPF_FUNC_map_delete_elem &&
 		    func_id != BPF_FUNC_msg_redirect_map &&
 		    func_id != BPF_FUNC_sk_select_reuseport &&
 		    func_id != BPF_FUNC_map_lookup_elem &&
@@ -4998,7 +5003,6 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 	case BPF_MAP_TYPE_SOCKHASH:
 		if (func_id != BPF_FUNC_sk_redirect_hash &&
 		    func_id != BPF_FUNC_sock_hash_update &&
-		    func_id != BPF_FUNC_map_delete_elem &&
 		    func_id != BPF_FUNC_msg_redirect_hash &&
 		    func_id != BPF_FUNC_sk_select_reuseport &&
 		    func_id != BPF_FUNC_map_lookup_elem &&
-- 
2.43.0



