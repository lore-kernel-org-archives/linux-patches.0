Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D3C43935B;
	Thu, 30 Jul 2026 14:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421517; cv=none; b=Zsuv3bmEKOOcD9lShZK9Ib1vrWKUJMRXbGmfDhbMlr9ai8y0tlpH9hEo2je5zyRLH+q/entMW72j/oBzIQffNSZ7N7dHMXNQaOYWdJgP5KWPrbVkz0ctoYnKYTZT0LH5n8d5F07eYnQXY4wUk0RRldPBvulAiZYUN3/n1XB9ZcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421517; c=relaxed/simple;
	bh=jdZewM+KuYWkJPTVR6XnUmmkEDEvtnIx/a36KaTJ5xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NHwkjtRcx6ta2W+PZ/VkKiTWNkv1NP1Ak8Ffy/0o0vPb/VO4yFnzZQqQBUBL4dcVePf+AYLpcuWta77gatPWx5XZLRKYqR3XRNtkij/OfpkeZtWuV0ANMhtx513n+qXcxT+QvMH8msHA1U4cFlqxUQG+jUj38ejLJvOfuSq3+t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iqm1NtcM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iqm1NtcM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 474781F000E9;
	Thu, 30 Jul 2026 14:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421515;
	bh=JooOtYleKOBVR9oXW/tlhef9LGjd5pbMeB579GHTBpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iqm1NtcMJPDeI5yIGX9jk/1V4kczCu4TaooaefpGSzzBmWW214S5RzZDT8hUkW87L
	 JGBA3bpIZLEd8KoPlT+Tq6Oj8meMIm/bl43yWQylhP+LMZaLI+qxqG4o/89+90DNte
	 uSmhkc5kf1t9bTEQPcfbZw3DUKyoz7b+ICjDOW/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Bobrowski <mattbobrowski@google.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 085/744] bpf: Fix UAF in sock clone early bailouts
Date: Thu, 30 Jul 2026 16:05:58 +0200
Message-ID: <20260730141446.074896918@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index ecd659f79fd4a0..1d295a8769fad5 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -158,8 +158,6 @@ int bpf_sk_storage_clone(const struct sock *sk, struct sock *newsk)
 	struct bpf_local_storage_elem *selem;
 	int ret = 0;
 
-	RCU_INIT_POINTER(newsk->sk_bpf_storage, NULL);
-
 	rcu_read_lock_dont_migrate();
 	sk_storage = rcu_dereference(sk->sk_bpf_storage);
 
diff --git a/net/core/sock.c b/net/core/sock.c
index cab041b57d2865..1c73b6841d0ae9 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2492,6 +2492,9 @@ struct sock *sk_clone(const struct sock *sk, const gfp_t priority,
 	sock_copy(newsk, sk);
 
 	newsk->sk_prot_creator = prot;
+#ifdef CONFIG_BPF_SYSCALL
+	RCU_INIT_POINTER(newsk->sk_bpf_storage, NULL);
+#endif
 
 	/* SANITY */
 	if (likely(newsk->sk_net_refcnt)) {
-- 
2.53.0



