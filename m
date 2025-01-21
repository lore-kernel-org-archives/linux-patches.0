Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67651F667C;
	Tue, 21 Jan 2025 18:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482994; cv=none; b=VLyLC0s9YB7lKT2vfOcbhKSsEqkR4HfTJFNfUVkpv3S3/ejumeEfExv+ev3Db978P2I1XIRG7q9QBXJhvqKViiQCTWDLAeSrsaOWUArW3jX9WSXEZs9tgSBYphwYgCmY3OZ4jbXN7w9u66BRHw82rMzzvZGZRr51SkgqK/z8jvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482994; c=relaxed/simple;
	bh=aPaGfQW9//d91fy3Ulbjp1JNUdq8dLzb9iaFO/KuoFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aXa0CxTOaoQV8ss5KDp3pEqNNpO5wqomybrKGvwUautAf4eYOewm3CCEbVsUDiAcPCC71w7qNbD68yo+q+WthV1n6VZleUEvxIgu8aNA4yS1bh2hHhUdAM1MalQzjYzc1542UAtHBGQU/+KTiUHO8P2OrxZ/ie2S/glnCEYcb7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ITUIWqaw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ITUIWqaw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09F4C4CEDF;
	Tue, 21 Jan 2025 18:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482994;
	bh=aPaGfQW9//d91fy3Ulbjp1JNUdq8dLzb9iaFO/KuoFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ITUIWqawVZgjSptgpEws1omYNiG2tcnA6M01ijpQZwq9jp3CwrDfeSUgMRWmYlKDd
	 Krj43cbUEB9yUb6Dxx7OtWMLVRjxugK/RPhiM1jNYdgKlBmI0FJ2U0b2D58TJBbSMq
	 LHEeHsPg7ug7tfNqA3C+9DLUBaKpTG0+Mj7pmprY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Luczaj <mhal@rbox.co>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 080/127] bpf: Fix bpf_sk_select_reuseport() memory leak
Date: Tue, 21 Jan 2025 18:52:32 +0100
Message-ID: <20250121174532.740869715@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Luczaj <mhal@rbox.co>

[ Upstream commit b3af60928ab9129befa65e6df0310d27300942bf ]

As pointed out in the original comment, lookup in sockmap can return a TCP
ESTABLISHED socket. Such TCP socket may have had SO_ATTACH_REUSEPORT_EBPF
set before it was ESTABLISHED. In other words, a non-NULL sk_reuseport_cb
does not imply a non-refcounted socket.

Drop sk's reference in both error paths.

unreferenced object 0xffff888101911800 (size 2048):
  comm "test_progs", pid 44109, jiffies 4297131437
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    80 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc 9336483b):
    __kmalloc_noprof+0x3bf/0x560
    __reuseport_alloc+0x1d/0x40
    reuseport_alloc+0xca/0x150
    reuseport_attach_prog+0x87/0x140
    sk_reuseport_attach_bpf+0xc8/0x100
    sk_setsockopt+0x1181/0x1990
    do_sock_setsockopt+0x12b/0x160
    __sys_setsockopt+0x7b/0xc0
    __x64_sys_setsockopt+0x1b/0x30
    do_syscall_64+0x93/0x180
    entry_SYSCALL_64_after_hwframe+0x76/0x7e

Fixes: 64d85290d79c ("bpf: Allow bpf_map_lookup_elem for SOCKMAP and SOCKHASH")
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Reviewed-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://patch.msgid.link/20250110-reuseport-memleak-v1-1-fa1ddab0adfe@rbox.co
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index d6042d285aa21..84ec1b14b23f3 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -10509,6 +10509,7 @@ BPF_CALL_4(sk_select_reuseport, struct sk_reuseport_kern *, reuse_kern,
 	bool is_sockarray = map->map_type == BPF_MAP_TYPE_REUSEPORT_SOCKARRAY;
 	struct sock_reuseport *reuse;
 	struct sock *selected_sk;
+	int err;
 
 	selected_sk = map->ops->map_lookup_elem(map, key);
 	if (!selected_sk)
@@ -10516,10 +10517,6 @@ BPF_CALL_4(sk_select_reuseport, struct sk_reuseport_kern *, reuse_kern,
 
 	reuse = rcu_dereference(selected_sk->sk_reuseport_cb);
 	if (!reuse) {
-		/* Lookup in sock_map can return TCP ESTABLISHED sockets. */
-		if (sk_is_refcounted(selected_sk))
-			sock_put(selected_sk);
-
 		/* reuseport_array has only sk with non NULL sk_reuseport_cb.
 		 * The only (!reuse) case here is - the sk has already been
 		 * unhashed (e.g. by close()), so treat it as -ENOENT.
@@ -10527,24 +10524,33 @@ BPF_CALL_4(sk_select_reuseport, struct sk_reuseport_kern *, reuse_kern,
 		 * Other maps (e.g. sock_map) do not provide this guarantee and
 		 * the sk may never be in the reuseport group to begin with.
 		 */
-		return is_sockarray ? -ENOENT : -EINVAL;
+		err = is_sockarray ? -ENOENT : -EINVAL;
+		goto error;
 	}
 
 	if (unlikely(reuse->reuseport_id != reuse_kern->reuseport_id)) {
 		struct sock *sk = reuse_kern->sk;
 
-		if (sk->sk_protocol != selected_sk->sk_protocol)
-			return -EPROTOTYPE;
-		else if (sk->sk_family != selected_sk->sk_family)
-			return -EAFNOSUPPORT;
-
-		/* Catch all. Likely bound to a different sockaddr. */
-		return -EBADFD;
+		if (sk->sk_protocol != selected_sk->sk_protocol) {
+			err = -EPROTOTYPE;
+		} else if (sk->sk_family != selected_sk->sk_family) {
+			err = -EAFNOSUPPORT;
+		} else {
+			/* Catch all. Likely bound to a different sockaddr. */
+			err = -EBADFD;
+		}
+		goto error;
 	}
 
 	reuse_kern->selected_sk = selected_sk;
 
 	return 0;
+error:
+	/* Lookup in sock_map can return TCP ESTABLISHED sockets. */
+	if (sk_is_refcounted(selected_sk))
+		sock_put(selected_sk);
+
+	return err;
 }
 
 static const struct bpf_func_proto sk_select_reuseport_proto = {
-- 
2.39.5



