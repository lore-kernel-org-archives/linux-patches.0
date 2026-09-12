Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E332BDC0E;
	Sat, 12 Sep 2026 10:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208854; cv=none; b=FvNUD34RC89A+QRDGUEUJqoDBJ7L9j9vxaeYYKeF4Hun3MpGxin1gMptQaOtuSTZh5SJFoBrVz5PAERFTIQ2kLmKjbuBtl0if01TxVclSrysIYnaFFJSDT4cugrcoS7Uw5koKBxN91i7md8JyyU7ZIajNoWXPMW9AdKsMjTSR9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208854; c=relaxed/simple;
	bh=vLcylp5ITf3DHPbqz2swS3f3R5PVQ6lIlmbjT8SKtJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S4w7M33zE0ihLqmcX9CNs94x/6u4NzR2Z9gkLv4HvIHVsGr50gaxIqd9XrjtiV0o0P9YRPJLRwsVeDVaVXTSZJqDXmkPMJpCC1oMJ84XHh6RgP+imaSRZMrawoHrA/x/tCoxbdMjMEranIGLSLSgfZWvAX76hrCTLx1yu/py5bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YTBBNllo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YTBBNllo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBBD51F00893;
	Sat, 12 Sep 2026 10:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208852;
	bh=YwLpVB3B5Jw4/GtVJLxqjn5K17krPbKPadAnvYAeJ/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YTBBNlloKUpEd5MR8hPW+10PFn6hUNZfBPtSKeJyrThjH7nmjxpiByv2mjFgn6DOj
	 Ab4kSpIwB0mpoUc9N/vvN1yBKFYwSgYZZ9EqWg5XpmBrTZYuW6G4XRko5drlfGRldM
	 uxeSufWizIo19bJhwVECz+S003a771HEI7LJHP/k=
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
Subject: [PATCH 6.18 0703/1518] bpf: Fix potential UAF in bpf_netns_link_update_prog
Date: Sat, 12 Sep 2026 08:47:52 +0200
Message-ID: <20260912065639.335774706@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 8e88201c98bfe..6599d771e4812 100644
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



