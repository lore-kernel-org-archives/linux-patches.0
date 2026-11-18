Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032319;
	b=XWQAmIgRls1JgXXny+tBqQxxWnCc/ywYzlUQgbReACxJwajYYDz5TMH3xeFjLkd6ro3N
	 g/o0rI5JCJL1RY9mQ+godLBJy+6OENZLcL1lO6jLKAsyI0sV9KiZCHrJu4PprZFJ7JJxv
	 17vO3yyc5Vb5u54+1t6N2ONuVrMicpxBvE6etO5OtNRbO3S+b088UzqlePbmKPLtawtO5
	 yRr18PhxUK359iyZf1MglUCypg2A7CHrZWTtGVdAthgPqQMyqw/9z8Gh6BjiyN0igdJiJ
	 gTS0oTKsdickTnXFsBXRTpK6XLwNQDG59TeT9tW/a8BbR3Ol+rHYJfg0e4KZtdA4saQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032319;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Jv4+rI7tSD5SV2V2YAQi2sahGSDV0LKC0NAVM+YXqEw=;
	b=HCKmYHBYO6LpcOP8PfM0Pd7fguUkC87ouaQGveifOAIHJ0eevjgAqQsT+D7FBS1t3OyV
	 FmsoDJdhG9dXCSVrcZIawKw1tnxLz2OxaBOn5QkI40VHBD+SpNDUNXJdu+VMpbupxXDZm
	 8A5p425Xzb8X6a8R9++9SVjQ8SMXU2l6kFRMargA75vvwTlwuwen+M/qnSoguT56R0c5r
	 yRx/HRoIxsp75i/ahM5nRoX8RfJBVIq2NGpJdLGPIFocULxTxXKuUHX1rbhLmtxzxBf0H
	 vIAqWMVvir83abq6phm4oPFJvJxG562XWutp359R+2q6FJ+b2ztNg6ggL1bMULNfk2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="xK/agryS";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97619606A335;
	Wed, 18 Nov 2026 20:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xK/agryS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE1C1F000C5;
	Wed, 18 Nov 2026 20:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032319;
	bh=Jv4+rI7tSD5SV2V2YAQi2sahGSDV0LKC0NAVM+YXqEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xK/agryShej5oHs2pBBmyZL+2nGGLf8nuKOgiI90VKZO7QD7iQsX7JFKuPwvRxeUy
	 LYy1gbugCqoOXBvoASYzaofqMw29yzTP+idylyDg3PzTpBK+VzOKl4lPq7Vpr20xNR
	 ZjyqMLqk4XhH6dLdIaHbR8f1LJS0BIWRI5jHZkdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1368/1756] bpf: Clear sk_refcnt of a clone before its storage is linked
Date: Wed, 18 Nov 2026 15:58:15 +0100
Message-ID: <20261118150103.701716675@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a09bc55ebd75a..aa6022ed1ed0d 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -163,6 +163,13 @@ int bpf_sk_storage_clone(const struct sock *sk, struct sock *newsk)
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



