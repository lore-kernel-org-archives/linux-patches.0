Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056541;
	b=4EOPVHaSDoJGKcSWsQ+y2uGU2Ee9GjcBPY0P5Rcn5LYHp9P0ZK9HNcOAkfFX0IDyRNDx
	 WENrWpW1QZ8IVJPd9aUPXHhQnnqOIn8eDQQwxJTe7oU/s0Czl+RpRD8ohxMsJs8z52K1N
	 drQG+Dk1OAVmExogRpBnlYXhLNM50E5eTDRf3Vp1gxNCf03kjSWrF3Ll16erb2UnWdkl5
	 bKxzpGhUraiCL5rop8rlu7sgykXZJyHttHZDwqhIviQRWbpHSVp1rM9WZmZss1/e8Xaqz
	 5WVwFhkdBxgczph81XgVbVVMggkTtfaWBxJXqvrafOY1+EK3yFEV9cRvXvoiYuj6zpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056541;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iY7TL4PexP+/jJxkqd14HJcpdfWwzB+WrHD+wXDL3K0=;
	b=sph39a2899JfOYSjitJHr/HIo8rbzbFCP2NcjmruaVNCcMtnZeuz903BF1Gjn1xZMh+5
	 /eDtQydEtSuBPFd6P+sqdUX6PeqbGLisRYMRdB+9qxSwpjd0HNLJHlZaDygQZU8yEU9CS
	 JdaecvHzNMzdySGJJ5XCSxCWk/VS+2Vfuf7VxYx4HLNxwVwk4/hlRB0XY7qycbFH9wWQW
	 C/UpLZnD1UpEVdxyJaLz9M4JJBjH+ru081CtVG6pGGHFOAfuS5X4fQLWRxPaYA6LZoEjz
	 oftcomQK9sNwixmNDCDlFyt7pguRriZJRLogvWHPr5ezDb6O/HFTB8CvMRmD7klxLug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QIYT31jo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA8C606A31C;
	Thu, 19 Nov 2026 02:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QIYT31jo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 977691F000C4;
	Thu, 19 Nov 2026 02:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056541;
	bh=iY7TL4PexP+/jJxkqd14HJcpdfWwzB+WrHD+wXDL3K0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QIYT31joNOeVBRs04ieAmwF69ePi09la5DmPHicBCKR/w2pBloGGV5xdmX/0TucKE
	 pTQV6V1UUH6BrXdGeUjvysbquQMNBvC8AUpoll5ztt3NA3iygRTLHJT/UNEAYU9goS
	 u9ALSlt2F2UpxtXpUwnfck2v1uvUs4HdqtwILDMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2023/2214] bpf: Clear sk_refcnt of a clone before its storage is linked
Date: Wed, 18 Nov 2026 16:01:39 +0100
Message-ID: <20261118150131.688072822@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9db272dd1d8af..ca9f74736bf89 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -197,6 +197,13 @@ int bpf_sk_storage_clone(const struct sock *sk, struct sock *newsk)
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



