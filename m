Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020973;
	b=pQBMeIsZNXLERgWYQvjJae2dGb3hZdzt5LJNk7XUaqZKB2IcIVfONDPGGypj7ab/ZmH4
	 lR2ECBejseL6Zs/PHUPlQNRiSX3gCrpdy+7tynKPr5vowE3qhemcymh2UDbBF5ybIf9kr
	 EzkIZfpvL5fYkj5qgEW5fK0ScuJsN1NAjLXiBg7OdaQGUtaYu0HOd7W1/1jwxqPWaorbd
	 kfzsobbgi7rZj5TxTriQXH42FB9DsQqSmZJnNwNe3HDNUykkNik0rI4He2A7nKDj4JfwA
	 VdEuQLqOzobNU32lqKPihFplcgLxUqAM6n7lleYRuCdobguIbQkuU64jERW3aIEjjig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020973;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j7BPWshlE5CJz1ONMUpvvcjAmNKwAl7fu4hn7g5WrhU=;
	b=5ADQRutGtxu5KsDbhL+6tZoZbZSFQq0A/A4Dllo2UXT8xwIK2fwMZ/0aCQoiTmG1onXL
	 N7/9e8f//MAAQueRJJLi6uueheQlLHdNIzyHCkqHjSDGcyi+AL4uSU5yXSDkLMi8S/WkO
	 YTl1FUcV2LL+jZV/+7hoTd1NTUVyW/diGJuisAxbgr76l/SiTwutkwAXTtNU11I9UGXIR
	 I3E3fRHm6OpJfOrzw1cFoV3STdBFxHsVwn6xK7So/YYaJVB+2hgGcjxO9zilCfWSOGgeQ
	 aqGZmSs7zqHeT4nvhV77pMLVdaD4P/tBDE/Wc5stepF6oeYl2O5YchfHcgpxJ/epNSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k2urVOGZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6810606A31C;
	Wed, 18 Nov 2026 16:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k2urVOGZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA5CC1F000C4;
	Wed, 18 Nov 2026 16:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020973;
	bh=j7BPWshlE5CJz1ONMUpvvcjAmNKwAl7fu4hn7g5WrhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k2urVOGZpS911znaY5cYbEFONCUHruEG/+D25lc+H0XAFgqyjm/Mmf/ABg5rZ0vM4
	 +X4bvoJ7bYJ15pF9t+z1JR20ly8UZDoysj99BGVdENnT+MMtRqIXh602q61li0d1Lo
	 15FU7wFIzfcex8pLFvCUywM6Jx5qqEu6SoZPj5co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2102/2651] bpf: Clear sk_refcnt of a clone before its storage is linked
Date: Wed, 18 Nov 2026 15:55:42 +0100
Message-ID: <20261118150401.655408929@linuxfoundation.org>
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

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 22f100bd013458836c3d0eaf8050b854d7534a66 ]

sk_clone() sets sk_refcnt of the new socket some lines behind
bpf_sk_storage_clone(). But the elements which that function copies are
linked to their maps at once, and an element leads to its owner: the
iterator over a sk_storage map hands the owner to its program.
bpf_sk_storage_get() with BPF_SK_STORAGE_GET_F_CREATE and
bpf_sk_storage_delete() rely on refcount_inc_not_zero() to tell whether
they may touch the socket.

sk_refcnt is in the part of struct sock which sock_copy() leaves out, and
sk_prot_alloc() does not clear a clone unless init_on_alloc is on. It is
zero in an object which has been a socket before, and anything in one
which has not. If it is not zero, a helper gets a reference which
refcount_set() wipes out, and the helper's sock_put() then drops one of
the two references of the new socket, which is freed too early:

  IPv4: Attempt to release TCP socket in state 1
  BUG: KASAN: slab-use-after-free in __raw_spin_lock_init+0x47/0x90

In the meantime the helper changes a storage which bpf_sk_storage_clone()
fills without taking its lock.

Nothing else can find the clone at this point. Say that it is not alive
yet, before the first element is linked. Sockets whose parent has no
storage are left alone.

Fixes: a50a85e40c59 ("bpf: Expose bpf_sk_storage_* to iterator programs")
Suggested-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017163745.3341787-15-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/bpf_sk_storage.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index 1d295a8769fad..b5349bec56957 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -164,6 +164,13 @@ int bpf_sk_storage_clone(const struct sock *sk, struct sock *newsk)
 	if (!sk_storage || hlist_empty(&sk_storage->list))
 		goto out;
 
+	/*
+	 * The maps lead to newsk as soon as an element is linked, but
+	 * sk_clone() sets sk_refcnt only later.  Until then it holds whatever
+	 * the slab object held before: no reference can be had yet.
+	 */
+	refcount_set(&newsk->sk_refcnt, 0);
+
 	hlist_for_each_entry_rcu(selem, &sk_storage->list, snode) {
 		struct bpf_local_storage_elem *copy_selem;
 		struct bpf_local_storage_map *smap;
-- 
2.53.0



