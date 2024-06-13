Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E9A23A0;
	Thu, 13 Jun 2024 12:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282607; cv=none; b=UrAFTARXD+1mhhA0dBlXyuC0FxWf2gcXgmtHRl7vQcCiIGtBi+qujUirAITK4CI+fnT6t8K/PkEQHFc2BHFCch9R9OtfVABehF5zq/wA2BOic/4Pil//2R5PSuF/Ehrs1ywBSfeWhsLijQqe0Q31QCwsPXKNz4ZCrR3u4zMO0K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282607; c=relaxed/simple;
	bh=a/4zI3zwVRZPGRAvKofRtc/Lj+RHYItSMlc6v/NDl/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sEAR6sm8PK0PP1Oc3ytnGHb08V+LS8zVmoLIuJDw7QNI7bplB/uw+L+agmrtNZ0LJJMevTM39C6frEDomOB2ZWlRzYOXzi2wzATkhpBmXyZif2Xjl7RhS8spZIIsIK5Mrm86kit/jqSB24oHc/AUj8qedw3B87T4R1Pw2r3rRek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kyN1T7j6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kyN1T7j6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC58C2BBFC;
	Thu, 13 Jun 2024 12:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282607;
	bh=a/4zI3zwVRZPGRAvKofRtc/Lj+RHYItSMlc6v/NDl/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kyN1T7j6hJbpXWHqHVPrMJsOurNt6Yrzjde94QhkjDNj0YkaTFwzmaP2NHapv4DwY
	 csEzBLd7GaL1g+CHbb9v65BIzy3/L2nRzW1pVIBywtdW3jEI+GhcTIPVU6PjirD3aO
	 uomPdGEy41X4254RQgoObjSlS6zcBcSs57deS+90=
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
Subject: [PATCH 5.15 317/402] bpf: Allow delete from sockmap/sockhash only if update is allowed
Date: Thu, 13 Jun 2024 13:34:34 +0200
Message-ID: <20240613113314.505872466@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 94d952967fbf9..07ca1157f97cf 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5568,7 +5568,8 @@ static bool may_update_sockmap(struct bpf_verifier_env *env, int func_id)
 	enum bpf_attach_type eatype = env->prog->expected_attach_type;
 	enum bpf_prog_type type = resolve_prog_type(env->prog);
 
-	if (func_id != BPF_FUNC_map_update_elem)
+	if (func_id != BPF_FUNC_map_update_elem &&
+	    func_id != BPF_FUNC_map_delete_elem)
 		return false;
 
 	/* It's not possible to get access to a locked struct sock in these
@@ -5579,6 +5580,11 @@ static bool may_update_sockmap(struct bpf_verifier_env *env, int func_id)
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
@@ -5666,7 +5672,6 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 	case BPF_MAP_TYPE_SOCKMAP:
 		if (func_id != BPF_FUNC_sk_redirect_map &&
 		    func_id != BPF_FUNC_sock_map_update &&
-		    func_id != BPF_FUNC_map_delete_elem &&
 		    func_id != BPF_FUNC_msg_redirect_map &&
 		    func_id != BPF_FUNC_sk_select_reuseport &&
 		    func_id != BPF_FUNC_map_lookup_elem &&
@@ -5676,7 +5681,6 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 	case BPF_MAP_TYPE_SOCKHASH:
 		if (func_id != BPF_FUNC_sk_redirect_hash &&
 		    func_id != BPF_FUNC_sock_hash_update &&
-		    func_id != BPF_FUNC_map_delete_elem &&
 		    func_id != BPF_FUNC_msg_redirect_hash &&
 		    func_id != BPF_FUNC_sk_select_reuseport &&
 		    func_id != BPF_FUNC_map_lookup_elem &&
-- 
2.43.0



