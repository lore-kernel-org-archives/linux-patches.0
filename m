Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22DB3212
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:00:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A87C433D2;
	Tue,  7 Feb 2023 13:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675774832;
	bh=nDZ4c6IeAO79IbW260qkxShQNhbumTjmUlSez4ZEPkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nBis5SCSCOSwJKBfbu8bTCitYzZ7JLiuky/llGb8uZz4qvggfuxcN5mBlk8arYxba
	 XzzpszQbwV1ChDdIycWBQkWzRa1iWZJFsL2NUDjsjSdohzYy+WvL9E5k3VLpKIAyTs
	 ih0uCEd0Nxi+MifBKkoJjvyZNM4463vdv+90FXgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+04c21ed96d861dccc5cd@syzkaller.appspotmail.com,
	Jakub Sitnicki <jakub@cloudflare.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 021/208] bpf, sockmap: Check for any of tcp_bpf_prots when cloning a listener
Date: Tue,  7 Feb 2023 13:54:35 +0100
Message-Id: <20230207125635.264501100@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jakub Sitnicki <jakub@cloudflare.com>

[ Upstream commit ddce1e091757d0259107c6c0c7262df201de2b66 ]

A listening socket linked to a sockmap has its sk_prot overridden. It
points to one of the struct proto variants in tcp_bpf_prots. The variant
depends on the socket's family and which sockmap programs are attached.

A child socket cloned from a TCP listener initially inherits their sk_prot.
But before cloning is finished, we restore the child's proto to the
listener's original non-tcp_bpf_prots one. This happens in
tcp_create_openreq_child -> tcp_bpf_clone.

Today, in tcp_bpf_clone we detect if the child's proto should be restored
by checking only for the TCP_BPF_BASE proto variant. This is not
correct. The sk_prot of listening socket linked to a sockmap can point to
to any variant in tcp_bpf_prots.

If the listeners sk_prot happens to be not the TCP_BPF_BASE variant, then
the child socket unintentionally is left if the inherited sk_prot by
tcp_bpf_clone.

This leads to issues like infinite recursion on close [1], because the
child state is otherwise not set up for use with tcp_bpf_prot operations.

Adjust the check in tcp_bpf_clone to detect all of tcp_bpf_prots variants.

Note that it wouldn't be sufficient to check the socket state when
overriding the sk_prot in tcp_bpf_update_proto in order to always use the
TCP_BPF_BASE variant for listening sockets. Since commit
b8b8315e39ff ("bpf, sockmap: Remove unhash handler for BPF sockmap usage")
it is possible for a socket to transition to TCP_LISTEN state while already
linked to a sockmap, e.g. connect() -> insert into map ->
connect(AF_UNSPEC) -> listen().

[1]: https://lore.kernel.org/all/00000000000073b14905ef2e7401@google.com/

Fixes: e80251555f0b ("tcp_bpf: Don't let child socket inherit parent protocol ops on copy")
Reported-by: syzbot+04c21ed96d861dccc5cd@syzkaller.appspotmail.com
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/r/20230113-sockmap-fix-v2-2-1e0ee7ac2f90@cloudflare.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/util_macros.h | 12 ++++++++++++
 net/ipv4/tcp_bpf.c          |  4 ++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/linux/util_macros.h b/include/linux/util_macros.h
index 72299f261b25..43db6e47503c 100644
--- a/include/linux/util_macros.h
+++ b/include/linux/util_macros.h
@@ -38,4 +38,16 @@
  */
 #define find_closest_descending(x, a, as) __find_closest(x, a, as, >=)
 
+/**
+ * is_insidevar - check if the @ptr points inside the @var memory range.
+ * @ptr:	the pointer to a memory address.
+ * @var:	the variable which address and size identify the memory range.
+ *
+ * Evaluates to true if the address in @ptr lies within the memory
+ * range allocated to @var.
+ */
+#define is_insidevar(ptr, var)						\
+	((uintptr_t)(ptr) >= (uintptr_t)(var) &&			\
+	 (uintptr_t)(ptr) <  (uintptr_t)(var) + sizeof(var))
+
 #endif
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 94aad3870c5f..cf26d65ca389 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -6,6 +6,7 @@
 #include <linux/bpf.h>
 #include <linux/init.h>
 #include <linux/wait.h>
+#include <linux/util_macros.h>
 
 #include <net/inet_common.h>
 #include <net/tls.h>
@@ -639,10 +640,9 @@ EXPORT_SYMBOL_GPL(tcp_bpf_update_proto);
  */
 void tcp_bpf_clone(const struct sock *sk, struct sock *newsk)
 {
-	int family = sk->sk_family == AF_INET6 ? TCP_BPF_IPV6 : TCP_BPF_IPV4;
 	struct proto *prot = newsk->sk_prot;
 
-	if (prot == &tcp_bpf_prots[family][TCP_BPF_BASE])
+	if (is_insidevar(prot, tcp_bpf_prots))
 		newsk->sk_prot = sk->sk_prot_creator;
 }
 #endif /* CONFIG_BPF_SYSCALL */
-- 
2.39.0



