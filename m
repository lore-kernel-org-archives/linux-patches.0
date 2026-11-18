Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057710;
	b=kkivFCe8GdiUJSErA3CVqtbckNySqVn6Vb41PvrCI74nXUDBDR262kOKtZ5fyvu8ju7W
	 VwuiIFAFbXxNAD/zqKO2droPUSOdbieecnmFHbH4hyYtgKubTsiPf80Z69eimoXTB4ZTN
	 g/C8Nd1TvUxa/MOWh1Gz2FcEVdryKZJkKK1Iy6Ea/APsbM4sWz970seaEumLuqkJ8pGPp
	 L57jNoZw5Tx3G2Nx8I7jzkPd5u+ppFtFUWwP9Bm1aTZyjdKhS/wnc4/ARllR5ZgtQ0ZTg
	 llMYFui6dNclG1sJGLBbEw0Kso/9yr8b8jPlJPPChs5bnyz+F+aAZIVWlUDQ2VQqCvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057710;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zk8Jm5re7j9N4y1lOKI96+E69L64082I7rJ80yaKRMg=;
	b=ApEPQ0c3hFz+K/IL0WGSN3vSo6S0pcOW7jMtuzKRCrZUAbH2hl9w3lkvcUwuJQ/Au8WJ
	 9xihcqs7ix8NRQZ8zaodtoO0uvIOGe1TgNHGf8C0cnpyzo/rCgIymiz6fQygXFizCzRx6
	 ZHosyx7zZ/5DqEz7PkU5V9qMC4DDcQ0+Vc9vkLVEIiGQEWqca8lHQO0s/ElvT+t4rjnhV
	 uNG1t5yIo3eFHS4btWW9WPaj6xwtQp4hVZXXAfcarxJ2fY0Tpe8c6eScjpZLhxK1AoQYh
	 Tj1BXJyYJGd3xxH89tN0wTHACtfdOirtlZHq5d6sVBSHH1wXVXPTBPmxNZAwFGh7IUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U3lQ87KU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1E3606A325;
	Thu, 19 Nov 2026 03:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U3lQ87KU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 198CE1F000C5;
	Thu, 19 Nov 2026 03:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057710;
	bh=Zk8Jm5re7j9N4y1lOKI96+E69L64082I7rJ80yaKRMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U3lQ87KUr8dEhfdhU33YBTfH5M9xmYFMAjzXiyqyCO0kDoc8DWlVibQXj/EXfyGUg
	 WQK7JIyc6zV7AYtXchANqRkjgXWmQ104r1hAnYALm5Les0Z9VxE3R+xaKcYAjB0wbO
	 IenFl13Y85BNGNDYJtI6cLkSpviafg80I8EcEIvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Bobrowski <mattbobrowski@google.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Imran Khan <imran.f.khan@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0228/1848] bpf: Fix UAF in sock clone early bailouts
Date: Wed, 18 Nov 2026 15:37:46 +0100
Message-ID: <20261118145921.551748409@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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

[ Imran: Backport to linux-5.10.y, linux-5.15.y, linux-6.1.y,
  linux-6.6.y and linux-6.12.y. The same patch applies to all five
  branches. Conflict and context differences:

  - net/core/bpf_sk_storage.c: upstream commit 0db4941d9dae ("bpf: Use
    rcu_read_lock_dont_migrate in bpf_sk_storage.c"), got merged in
    v6.19-rc1, and is not present in these branches. So the line following
    RCU_INIT_POINTER() in bpf_sk_storage_clone() still uses the old RCU
    api (rcu_read_lock()).

  - net/core/sock.c: upstream commit 151b98d10ef7 ("net: Add
    sk_clone()."), merged in v6.19-rc1, moved the body of
    sk_clone_lock() into the new sk_clone(). That commit is not present
    in these branches, and the code relevant to this backport is still
    in sk_clone_lock().

  In all five branches, sk_clone_lock() is the only caller of
  bpf_sk_storage_clone(), so taking the NULL initialisation out of that
  function is safe. ]

Signed-off-by: Imran Khan <imran.f.khan@oracle.com>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/bpf_sk_storage.c | 2 --
 net/core/sock.c           | 3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index a811fe0f0f6fd..d651b3e87875c 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -190,8 +190,6 @@ int bpf_sk_storage_clone(const struct sock *sk, struct sock *newsk)
 	struct bpf_local_storage_elem *selem;
 	int ret = 0;
 
-	RCU_INIT_POINTER(newsk->sk_bpf_storage, NULL);
-
 	rcu_read_lock();
 	sk_storage = rcu_dereference(sk->sk_bpf_storage);
 
diff --git a/net/core/sock.c b/net/core/sock.c
index 07a90a08a4edd..7d645d85da9fd 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1914,6 +1914,9 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 	sock_copy(newsk, sk);
 
 	newsk->sk_prot_creator = prot;
+#ifdef CONFIG_BPF_SYSCALL
+	RCU_INIT_POINTER(newsk->sk_bpf_storage, NULL);
+#endif
 
 	/* SANITY */
 	if (likely(newsk->sk_net_refcnt)) {
-- 
2.53.0



