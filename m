Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215486;
	b=VyB1ilh6kgzOo+1amAV018uDq/fBRujmhd7tn7nlF55QTWL+eLvh+B36KqIHI8xB4iD3
	 pLtjxk88bYJrxpAAldl0yTm4SIrdmoDY21phSnO+rVeruZH0KxNz/8+959fPmH9oqu3Np
	 UzXl6/gbu1tO9qdjXC1hliSVloFq9JzZLfp+9NGsrMjDT3+ImSsuZwfogDNzFf8xoPwuZ
	 RTYhFdnvQLJGzntge0Qk1e7/sjWMQCZs+PtjiCLNOJ9DlGc6zhKqmoDw8PSUfAOFKfpUb
	 K4tJ6gRl4qWkSvALwf/R7oThrl7eJYvL9J23NIOVXOwGzKecMU1oqK8hfMVVerNFiVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215486;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ANqNsrXehiPDce91ME5eV24QaL4k0xyuc2XNs/VgMdw=;
	b=4w/+57X67R0hplK6Lvbk/WJAbBv40hVvvEFktkxTpgJ3KpuN+FFk5lDVkN5L/pH6cQkA
	 w35uVGO733wPC9a2h4MU+xWwa0OqrXVZctYH6KoooaaVptLFeU6HdmrsympLpCtS5lpS9
	 u3nH6AusKlkmmz710hhYS0TV0H0yBRPVwzSjIdVtdthCi40iyqkBrQTR9enpI3y+shIQ5
	 P/TYiwK1nwBTR2W5M+Yo0Fi+bGiOZAxJwhJlNr8vq86jHqi3QByYzLyxNecQ4eXzlHpS2
	 H6TCzSUZzp13uh35BypKsX0/rIZ262vniHg0ep/eJ0SKPoT9fqquY+MtH+bstZ2ft1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1+Nw+fRL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79B9606A31D;
	Wed, 28 Oct 2026 19:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1+Nw+fRL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 247BC1F01825;
	Wed, 28 Oct 2026 19:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215485;
	bh=ANqNsrXehiPDce91ME5eV24QaL4k0xyuc2XNs/VgMdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1+Nw+fRLvPQzMvY2xHgF/KBEbyqbF6ZusYgDxmBUpFi8erkARItyq6XoB6Izxzwj3
	 nU8Y/YYZg02odUuYn4adww1akn96mjtgPMKR5PQyJ6U9KzFNUh63kQixHYLyJ0fZmL
	 RJB4VlMFLuprDYmjNtQkHEsLSb0+BJmEn8e8FxdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Bobrowski <mattbobrowski@google.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1184/1887] bpf: Fix UAF in sock clone early bailouts
Date: Wed, 28 Oct 2026 17:54:40 +0100
Message-ID: <20261028170526.349832668@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Bobrowski <mattbobrowski@google.com>

[ Upstream commit 7cbd0c4cebe4c9f678d15e6b9ba975e1155a107f ]

Similar to recent commit 9b51a6155d14 ("bpf,fork: wipe ->bpf_storage
before bailouts that access it"), sk_clone() performs an initial
shallow copy of the socket field ->sk_bpf_storage via sock_copy()
for the cloned socket newsk.

If sk_clone() bails out early (e.g. if sk_filter_charge() fails) prior
to calling bpf_sk_storage_clone(), newsk->sk_bpf_storage still points
to the parent socket's BPF local storage. When newsk is subsequently
freed via sk_free(), the deallocation path (__sk_destruct() ->
bpf_sk_storage_free()) destroys the parent socket's BPF local storage,
leading to a use-after-free (UAF) on the parent socket.

Fix this by resetting newsk->sk_bpf_storage to NULL immediately after
sock_copy() in sk_clone(), and remove the now redundant initialization
from bpf_sk_storage_clone().

Fixes: 6ac99e8f23d4 ("bpf: Introduce bpf sk local storage")
Fixes: f12dd75959b0 ("bpf: net: Set sk_bpf_storage back to NULL for cloned sk")
Signed-off-by: Matt Bobrowski <mattbobrowski@google.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20260709025316.999913-1-mattbobrowski@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/bpf_sk_storage.c | 2 --
 net/core/sock.c           | 3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index 0124536e8a9db..d4078e288f42b 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -164,8 +164,6 @@ int bpf_sk_storage_clone(const struct sock *sk, struct sock *newsk)
 	struct bpf_local_storage_elem *selem;
 	int ret = 0;
 
-	RCU_INIT_POINTER(newsk->sk_bpf_storage, NULL);
-
 	rcu_read_lock();
 	sk_storage = rcu_dereference(sk->sk_bpf_storage);
 
diff --git a/net/core/sock.c b/net/core/sock.c
index 6f8a15aa4a126..fcd47d51b9f23 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2261,6 +2261,9 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 	sock_copy(newsk, sk);
 
 	newsk->sk_prot_creator = prot;
+#ifdef CONFIG_BPF_SYSCALL
+	RCU_INIT_POINTER(newsk->sk_bpf_storage, NULL);
+#endif
 
 	/* SANITY */
 	if (likely(newsk->sk_net_refcnt)) {
-- 
2.53.0



