Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2686638F620;
	Sat, 12 Sep 2026 19:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242843; cv=none; b=fVcW0pA2KGlia0MQJxWV1cngbB2FNfadHI6eOEKFhUb1ca6OCvD0/G+V3NPCZbTGt/o5YGhA52I8ND3Hik+Mhmy1n6GUczkhUyJqLe+ejlq9K8wfFmS7/bcJjn8mRswEXW99fZq2+YM4w7/zd/GFDEzFmyA6SJQFGaITBQTReRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242843; c=relaxed/simple;
	bh=oUNBNElPgDX4aKuF150JPyuKKdRetHg6PQveQAgZyLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uOiP0rUo7CGDY+EzoXpjkcdZnv1sreaJmSGBsrEHquocIpYvAj7H4+UVjgMy5bggd4OEC5tG9fe2dzEThYpRGnnC8zb2PVQSfp+vvrT158/+0/JSce4QWEtm0zartX0F7MGhm5/zEbQl5g+17kiQRDFhanJ0dltdOU8yVl72xk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=woXdWdc0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="woXdWdc0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8272E1F000FF;
	Sat, 12 Sep 2026 19:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242842;
	bh=HgYuubpjrGi2eZgVmc+e9HPilq23Nc47AgFpgw5a2Vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=woXdWdc0d0ofadn0kcUwPzcjgfmURjwihBP9dq9dTB23oxZmsgqtkh/zgr1H4hiYl
	 V/21xDWIOY31eSqgEpysqDi5BafROYLZKPgsTowTEIq+iX0gd6NQFCx/W6exymU2pQ
	 fScRR3zD0wmChwmtkWycYjXyx1fr1ytcWt5kaShA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Pu Lehui <pulehui@huawei.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Amery Hung <ameryhung@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 546/798] bpf: Fix potential UAF in bpf_netns_link_update_prog
Date: Sat, 12 Sep 2026 09:02:54 +0200
Message-ID: <20260912065529.640807644@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pu Lehui <pulehui@huawei.com>

[ Upstream commit 5c5997836381010fc5907b36bc17d3b19407e933 ]

In bpf_netns_link_update_prog, the checks for old_prog and prog type
are currently performed locklessly before acquiring netns_bpf_mutex.
This creates a race condition that can lead to a UAF issue.

If two threads concurrently execute BPF_LINK_UPDATE on the same netns
link, the following execution path can trigger a UAF:

CPU0                                          CPU1
bpf_netns_link_update_prog
  if (old_prog && old_prog != link->prog)
    return -EPERM;
                                              bpf_netns_link_update_prog
                                                if (old_prog && old_prog != link->prog)
                                                ...
                                                old_prog = xchg(&link->prog, new_prog);
                                                bpf_prog_put(old_prog);
  if (new_prog->type != link->prog->type) <-- trigger UAF

Fix this by moving the old_prog and prog->type checks inside the
netns_bpf_mutex critical section. Meanwhile, use guard() to simplify
lock management and avoid all the goto jumping.

Fixes: 7f045a49fee0 ("bpf: Add link-based BPF program attachment to network namespace")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Amery Hung <ameryhung@gmail.com>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Link: https://lore.kernel.org/bpf/f87b53c0-8f00-45a6-82db-8242fa9b143f@huaweicloud.com [0]
Link: https://lore.kernel.org/bpf/20260728023259.2813482-1-pulehui@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/net_namespace.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/kernel/bpf/net_namespace.c b/kernel/bpf/net_namespace.c
index 542f275bf2523..ad19cb4008e7c 100644
--- a/kernel/bpf/net_namespace.c
+++ b/kernel/bpf/net_namespace.c
@@ -171,33 +171,28 @@ static int bpf_netns_link_update_prog(struct bpf_link *link,
 	struct net *net;
 	int idx, ret;
 
+	guard(mutex)(&netns_bpf_mutex);
+
 	if (old_prog && old_prog != link->prog)
 		return -EPERM;
 	if (new_prog->type != link->prog->type)
 		return -EINVAL;
 
-	mutex_lock(&netns_bpf_mutex);
-
 	net = net_link->net;
-	if (!net || !check_net(net)) {
+	if (!net || !check_net(net))
 		/* Link auto-detached or netns dying */
-		ret = -ENOLINK;
-		goto out_unlock;
-	}
+		return -ENOLINK;
 
 	run_array = rcu_dereference_protected(net->bpf.run_array[type],
 					      lockdep_is_held(&netns_bpf_mutex));
 	idx = link_index(net, type, net_link);
 	ret = bpf_prog_array_update_at(run_array, idx, new_prog);
 	if (ret)
-		goto out_unlock;
+		return ret;
 
 	old_prog = xchg(&link->prog, new_prog);
 	bpf_prog_put(old_prog);
-
-out_unlock:
-	mutex_unlock(&netns_bpf_mutex);
-	return ret;
+	return 0;
 }
 
 static int bpf_netns_link_fill_info(const struct bpf_link *link,
-- 
2.53.0



