Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7166E101C0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:57:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAF5BC433EF;
	Mon, 15 May 2023 17:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173448;
	bh=jtZEkJHMuRm9VeDsyuPMvxwj9ruLpJH1SDbN1rrAzlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZBjHihAmMXRXMceUKKnfSByzvMFo0JpWslRsf/kW911gW3r/usFGV8dyXh5p+e+HP
	 DKGAjJ7wIZgmIlmuMBQom7GrYmzvRyqTh6mJtAPlPc3TbCCjthYn64NzQ5cDSRWHUf
	 JzDBTb/scaTUOCAq0CGZfT1PZnZXxFyYybXbeBUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Wei Hung <hsinweih@uci.edu>,
	Xin Liu <liuxin350@huawei.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 097/282] bpf, sockmap: fix deadlocks in the sockhash and sockmap
Date: Mon, 15 May 2023 18:27:55 +0200
Message-Id: <20230515161725.167075956@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xin Liu <liuxin350@huawei.com>

[ Upstream commit ed17aa92dc56b6d8883e4b7a8f1c6fbf5ed6cd29 ]

When huang uses sched_switch tracepoint, the tracepoint
does only one thing in the mounted ebpf program, which
deletes the fixed elements in sockhash ([0])

It seems that elements in sockhash are rarely actively
deleted by users or ebpf program. Therefore, we do not
pay much attention to their deletion. Compared with hash
maps, sockhash only provides spin_lock_bh protection.
This causes it to appear to have self-locking behavior
in the interrupt context.

  [0]:https://lore.kernel.org/all/CABcoxUayum5oOqFMMqAeWuS8+EzojquSOSyDA3J_2omY=2EeAg@mail.gmail.com/

Reported-by: Hsin-Wei Hung <hsinweih@uci.edu>
Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: Xin Liu <liuxin350@huawei.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/r/20230406122622.109978-1-liuxin350@huawei.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock_map.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 5bce6d4d20573..78f2b6b265b2a 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -322,8 +322,9 @@ static int __sock_map_delete(struct bpf_stab *stab, struct sock *sk_test,
 {
 	struct sock *sk;
 	int err = 0;
+	unsigned long flags;
 
-	raw_spin_lock_bh(&stab->lock);
+	raw_spin_lock_irqsave(&stab->lock, flags);
 	sk = *psk;
 	if (!sk_test || sk_test == sk)
 		sk = xchg(psk, NULL);
@@ -333,7 +334,7 @@ static int __sock_map_delete(struct bpf_stab *stab, struct sock *sk_test,
 	else
 		err = -EINVAL;
 
-	raw_spin_unlock_bh(&stab->lock);
+	raw_spin_unlock_irqrestore(&stab->lock, flags);
 	return err;
 }
 
@@ -655,11 +656,12 @@ static int sock_hash_delete_elem(struct bpf_map *map, void *key)
 	struct bpf_htab_bucket *bucket;
 	struct bpf_htab_elem *elem;
 	int ret = -ENOENT;
+	unsigned long flags;
 
 	hash = sock_hash_bucket_hash(key, key_size);
 	bucket = sock_hash_select_bucket(htab, hash);
 
-	raw_spin_lock_bh(&bucket->lock);
+	raw_spin_lock_irqsave(&bucket->lock, flags);
 	elem = sock_hash_lookup_elem_raw(&bucket->head, hash, key, key_size);
 	if (elem) {
 		hlist_del_rcu(&elem->node);
@@ -667,7 +669,7 @@ static int sock_hash_delete_elem(struct bpf_map *map, void *key)
 		sock_hash_free_elem(htab, elem);
 		ret = 0;
 	}
-	raw_spin_unlock_bh(&bucket->lock);
+	raw_spin_unlock_irqrestore(&bucket->lock, flags);
 	return ret;
 }
 
-- 
2.39.2



