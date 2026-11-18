Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020982;
	b=elsASEbNNzzHbIZ7X19QJoS+NAklX51LWRAVmx1owe5dPeAAow7Sd0OWqzAzx6waaHth
	 fk6vCuhvbUquDmTurMBLSirV29aeKJD/++5o5kj0aZh+OITX6yMYRnWW3HlnixdogM5Ue
	 SW0asd37GAhtu1UAJm6K3T7AYTpd74Jov6fJ7km7JMzWpkOUFehRqU/at9MB+lWb4/fv0
	 NjQyWINqtw2B7Ere2VhmWO3EZuvKM4HBxuM7dJR4Oh4PxxUSaX1GhDLoQHokumN6m0RCg
	 C9K5hFNjNwJ3Ai8aZQ2sP8dWdWK2KThLBtXiGCQm/ma14rGif932H0z0MDY4L7jX43g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020982;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VINsW03Oz3KYydkrKb0izNIHHp/utP1G7ikCKPJ09o0=;
	b=iWQqcubST9TIHkfI3HcZ1Q1CLx1rOvuDz6aO1g243pIi2VGCC9ZfudKOSgFh4VKoT+HA
	 kgJY9elED8xI2vahZCodew7gIvmPH60fwP1LqJ1L1g6fH2+7mMyqVg/DxumbGoWkOAZT9
	 0tXgtxByZzuhSt3GZb0qyg/Z2hJRg0iq8np96iuDNJ11GIROc6bbskoYSKAcckxEylLj6
	 hcL4Kxzx0R+OVauAGvsq+aWdT6tNnA0Ny7aDT1V90jzFWFclrfrbASBytG7rxB3ym1fVR
	 ciVwWc8GznpxHPYzFHCKxcXbi3MSInmsAuXj9Yw+Fhw0mXy9yoOrpq1I+WA2vz+qUFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ejXFUDfH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD02606A32A;
	Wed, 18 Nov 2026 16:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ejXFUDfH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6309D1F000C4;
	Wed, 18 Nov 2026 16:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020981;
	bh=VINsW03Oz3KYydkrKb0izNIHHp/utP1G7ikCKPJ09o0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ejXFUDfH/rMe1H3uGGt5glRDos5hPfaMrNFHCsa6q+d+T2sBe3AGpStPkaKzulNe6
	 5JW+QjIi+Co7/pjtlMQn8QrVc7G11i+oilkg/JazONBaPme0stBoQAGcPZfF7Kx2fx
	 maSLl0qARnUrGjJmRGsE63787ygZTCT7lFawjS4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2105/2651] bpf: Hold the socket in the sk_storage map iterator
Date: Wed, 18 Nov 2026 15:55:45 +0100
Message-ID: <20261118150401.753944305@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 070a96b2a98f66087797d8a31d53126de7a5208f ]

The iterator over a sk_storage map passes the owner of an element to its
program as ctx->sk, without a reference. All that it holds is the RCU read
lock, which keeps the element and the storage, not the socket.

An element is unlinked by bpf_sk_storage_free(), which __sk_destruct()
calls right before it frees the socket. That is no better for a socket
with SOCK_RCU_FREE: the grace period comes in front of __sk_destruct(),
so a reader which starts behind call_rcu() still finds the element. The
program and the helpers it hands ctx->sk to, such as
bpf_sk_storage_get() or bpf_sk_storage_delete(), use a socket which is
being freed on another CPU. It takes nothing but reading the iterator
while sockets with an element in the map are closed, by whomever.

Take a reference for the time of the program, and skip the element if
there is none to be had. To look at the owner at all, do what
bpf_selem_unlink_nofail() does for bpf_local_storage_map_free(): as long
as the element is linked under the lock of the storage,
bpf_local_storage_destroy() has not got past it, unless it has given up
on the lock, and then it waits for owner_refcnt.

The last reference may now be dropped by the iterator. The end of a socket
may want process context: rfcomm_sock_destruct() takes a mutex. So only
drop the reference under RCU, and free a socket whose last one it was when
the RCU read lock has been released, which is at the end of a bucket and
of every read() at the latest.

Fixes: c69d2ddb2072 ("bpf: Using rcu_read_lock for bpf_sk_storage_map iterator")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017163745.3341787-18-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/bpf_sk_storage.c | 73 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 68 insertions(+), 5 deletions(-)

diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index aea67b446c7c4..ea22ec5ef5b19 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -699,8 +699,37 @@ struct bpf_iter_seq_sk_storage_map_info {
 	struct bpf_map *map;
 	unsigned int bucket_id;
 	unsigned skip_elems;
+	struct rcu_head *dead_sks;
 };
 
+/*
+ * sock_put() in two halves. The end of a socket may want process context:
+ * rfcomm_sock_destruct() takes a mutex. If the iterator drops the last
+ * reference, it keeps the socket until it has left the RCU read side critical
+ * section. Nobody uses sk_rcu before sk_destruct().
+ */
+static void
+bpf_sk_storage_map_seq_put_sk(struct bpf_iter_seq_sk_storage_map_info *info,
+			      struct sock *sk)
+{
+	if (refcount_dec_and_test(&sk->sk_refcnt)) {
+		sk->sk_rcu.next = info->dead_sks;
+		info->dead_sks = &sk->sk_rcu;
+	}
+}
+
+static void
+bpf_sk_storage_map_seq_free_sks(struct bpf_iter_seq_sk_storage_map_info *info)
+{
+	struct sock *sk;
+
+	while (info->dead_sks) {
+		sk = container_of(info->dead_sks, struct sock, sk_rcu);
+		info->dead_sks = sk->sk_rcu.next;
+		sk_free(sk);
+	}
+}
+
 static struct bpf_local_storage_elem *
 bpf_sk_storage_map_seq_find_next(struct bpf_iter_seq_sk_storage_map_info *info,
 				 struct bpf_local_storage_elem *prev_selem)
@@ -729,6 +758,7 @@ bpf_sk_storage_map_seq_find_next(struct bpf_iter_seq_sk_storage_map_info *info,
 			/* not found, unlock and go to the next bucket */
 			b = &smap->buckets[bucket_id++];
 			rcu_read_unlock();
+			bpf_sk_storage_map_seq_free_sks(info);
 			skip_elems = 0;
 			break;
 		}
@@ -796,12 +826,44 @@ DEFINE_BPF_ITER_FUNC(bpf_sk_storage_map, struct bpf_iter_meta *meta,
 		     struct bpf_map *map, struct sock *sk,
 		     void *value)
 
+/*
+ * Take a reference on the socket which owns @selem. RCU keeps the element, not
+ * its owner. As long as the element is linked under the lock of the storage,
+ * the owner has not got past bpf_sk_storage_free(), unless that has given up
+ * on the lock. Then it still waits for owner_refcnt.
+ */
+static struct sock *
+bpf_sk_storage_selem_get_sk(struct bpf_local_storage_elem *selem)
+{
+	struct bpf_local_storage *sk_storage;
+	struct sock *sk = NULL;
+	unsigned long flags;
+
+	sk_storage = rcu_dereference(selem->local_storage);
+	/* reset since ->next() looked: the socket goes away */
+	if (!sk_storage)
+		return NULL;
+
+	if (raw_res_spin_lock_irqsave(&sk_storage->lock, flags))
+		return NULL;
+
+	if (!hlist_unhashed(&selem->snode) &&
+	    refcount_inc_not_zero(&sk_storage->owner_refcnt)) {
+		sk = sk_storage->owner;
+		if (!refcount_inc_not_zero(&sk->sk_refcnt))
+			sk = NULL;
+		bpf_local_storage_unpin_owner(sk_storage);
+	}
+	raw_res_spin_unlock_irqrestore(&sk_storage->lock, flags);
+
+	return sk;
+}
+
 static int __bpf_sk_storage_map_seq_show(struct seq_file *seq,
 					 struct bpf_local_storage_elem *selem)
 {
 	struct bpf_iter_seq_sk_storage_map_info *info = seq->private;
 	struct bpf_iter__bpf_sk_storage_map ctx = {};
-	struct bpf_local_storage *sk_storage;
 	struct bpf_iter_meta meta;
 	struct bpf_prog *prog;
 	int ret = 0;
@@ -812,14 +874,14 @@ static int __bpf_sk_storage_map_seq_show(struct seq_file *seq,
 		ctx.meta = &meta;
 		ctx.map = info->map;
 		if (selem) {
-			sk_storage = rcu_dereference(selem->local_storage);
-			/* reset since ->next() looked: the socket goes away */
-			if (!sk_storage)
+			ctx.sk = bpf_sk_storage_selem_get_sk(selem);
+			if (!ctx.sk)
 				return SEQ_SKIP;
-			ctx.sk = sk_storage->owner;
 			ctx.value = SDATA(selem)->data;
 		}
 		ret = bpf_iter_run_prog(prog, &ctx);
+		if (ctx.sk)
+			bpf_sk_storage_map_seq_put_sk(info, ctx.sk);
 	}
 
 	return ret;
@@ -837,6 +899,7 @@ static void bpf_sk_storage_map_seq_stop(struct seq_file *seq, void *v)
 		(void)__bpf_sk_storage_map_seq_show(seq, v);
 	else
 		rcu_read_unlock();
+	bpf_sk_storage_map_seq_free_sks(seq->private);
 }
 
 static int bpf_iter_init_sk_storage_map(void *priv_data,
-- 
2.53.0



