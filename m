Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50EC82C026C;
	Sat, 17 Oct 2026 16:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254299; cv=none; b=WEWeBY/WNkQoVidjR3+LO86g3rgNGyWo8C4jpGa559IDL0urYRpNjmKlE+G0gURVQQmje93RfSpsGm2OjPxD7qaCjJKSwx1TRmRS9eZx/JNYrKYik7V69xTVb0YU4Fe5XCPeZkW951Ul0keqBxSkjskFW/qL0uI9RkFfqnaE3ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254299; c=relaxed/simple;
	bh=uxG8fMjOPe67d4gKtmHIB670kzHDOWmEDUlsn6jAJ98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r3I8IJUeyaatAqVSqgrOTeLTr28nX5qdouADdMdXBiecu8Dnrgx+FxIc9aZM0l+RnD1DDTgVK3YAGZpF7X2qkJmAC4sihUusvjuQwUckfpVS6exBJmXY9gowEXWRrjGfw4byR94u+yea5YSFISwoE4sANpULojXZ7T3RkZx9S3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vxn5cn9I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vxn5cn9I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75F91F000C4;
	Sat, 17 Oct 2026 16:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254298;
	bh=n97FFr07a+lbgEC6MhtlnjseJImlnc6EYXTjV2mum7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vxn5cn9IpF7Onc8wAzkHu5GZpgP/3d3tYft64Igsr/ViZHudnC+q/0kQOIqXY+KFS
	 ZxdqKWAjuggHi0SAAXUyyIK5RVVgLY/nWYsNpHAl+Mzxuaf3SPcFfX/WzbPoQuT/Gp
	 dV7BTvPHkGkHuigqUmKVWgGrvp9CgvOjxGCmrHM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Bobrowski <mattbobrowski@google.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 401/869] bpf: Fix UAF in sock clone early bailouts
Date: Sat, 17 Oct 2026 17:54:02 +0200
Message-ID: <20261017160047.405477384@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 135570dfcffe6..a09bc55ebd75a 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -157,8 +157,6 @@ int bpf_sk_storage_clone(const struct sock *sk, struct sock *newsk)
 	struct bpf_local_storage_elem *selem;
 	int ret = 0;
 
-	RCU_INIT_POINTER(newsk->sk_bpf_storage, NULL);
-
 	rcu_read_lock_dont_migrate();
 	sk_storage = rcu_dereference(sk->sk_bpf_storage);
 
diff --git a/net/core/sock.c b/net/core/sock.c
index 75db38fdfd35f..181a66488ec21 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2411,6 +2411,9 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 	sock_copy(newsk, sk);
 
 	newsk->sk_prot_creator = prot;
+#ifdef CONFIG_BPF_SYSCALL
+	RCU_INIT_POINTER(newsk->sk_bpf_storage, NULL);
+#endif
 
 	/* SANITY */
 	if (likely(newsk->sk_net_refcnt)) {
-- 
2.53.0



