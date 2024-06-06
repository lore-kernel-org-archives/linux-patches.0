Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054771C0DDB;
	Thu,  6 Jun 2024 14:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683560; cv=none; b=cINh5x3M2OKybGZXBzgv4yXZg6H9ovSnort3Ja5PV6wp8DmscrAkWl3izoFwKqBOujhQTU9fEQ+myjINI7s8An9+aZ3L8NUdFPCKkhNdAvEz+NxAzu3/CGQfhH7iwT2KSyju5QXfk4e/kf+LCOikaIPFwWtJEPduOHogzPMFiRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683560; c=relaxed/simple;
	bh=Ig1saU9nRoK4W/zLlfDAtOsjK5YusquLRoLbBU0HmwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W2fdcbMxihjJphFaWkg6uXc05wS3s7rV6g7p45BCKCRwK3YOpiDjx1TPFGJgNfb6Fc4pza5ujbNoqIhAvYUVlgRsGttWDJCep34M4ocI/+APphBufRpS8Ja1HJfR9XMm1IXCQqtORy0ctIzRzXSE9hXD04rTSLVal+XgOOFOmvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2nutQcZk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2nutQcZk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7BA2C32781;
	Thu,  6 Jun 2024 14:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683559;
	bh=Ig1saU9nRoK4W/zLlfDAtOsjK5YusquLRoLbBU0HmwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2nutQcZkQ44ruFzt9UIlt1sPQHthSztPpha3c/vtu4NawHvP541/HYs9ZZEJad6/A
	 lomGxlwLNSqL+YzXu7ngnfRSu2+YkcF5qYm07V0VnB0YuZeqTWIlpmgWDEt4p0ucOg
	 kDAohSYX0VfV0UAYwDkTl1D1YG5KFLTjROBjcLY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzkaller <syzkaller@googlegroups.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 450/473] af_unix: Read sk->sk_hash under bindlock during bind().
Date: Thu,  6 Jun 2024 16:06:19 +0200
Message-ID: <20240606131714.581178121@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 51d1b25a720982324871338b1a36b197ec9bd6f0 ]

syzkaller reported data-race of sk->sk_hash in unix_autobind() [0],
and the same ones exist in unix_bind_bsd() and unix_bind_abstract().

The three bind() functions prefetch sk->sk_hash locklessly and
use it later after validating that unix_sk(sk)->addr is NULL under
unix_sk(sk)->bindlock.

The prefetched sk->sk_hash is the hash value of unbound socket set
in unix_create1() and does not change until bind() completes.

There could be a chance that sk->sk_hash changes after the lockless
read.  However, in such a case, non-NULL unix_sk(sk)->addr is visible
under unix_sk(sk)->bindlock, and bind() returns -EINVAL without using
the prefetched value.

The KCSAN splat is false-positive, but let's silence it by reading
sk->sk_hash under unix_sk(sk)->bindlock.

[0]:
BUG: KCSAN: data-race in unix_autobind / unix_autobind

write to 0xffff888034a9fb88 of 4 bytes by task 4468 on cpu 0:
 __unix_set_addr_hash net/unix/af_unix.c:331 [inline]
 unix_autobind+0x47a/0x7d0 net/unix/af_unix.c:1185
 unix_dgram_connect+0x7e3/0x890 net/unix/af_unix.c:1373
 __sys_connect_file+0xd7/0xe0 net/socket.c:2048
 __sys_connect+0x114/0x140 net/socket.c:2065
 __do_sys_connect net/socket.c:2075 [inline]
 __se_sys_connect net/socket.c:2072 [inline]
 __x64_sys_connect+0x40/0x50 net/socket.c:2072
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0x4f/0x110 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x46/0x4e

read to 0xffff888034a9fb88 of 4 bytes by task 4465 on cpu 1:
 unix_autobind+0x28/0x7d0 net/unix/af_unix.c:1134
 unix_dgram_connect+0x7e3/0x890 net/unix/af_unix.c:1373
 __sys_connect_file+0xd7/0xe0 net/socket.c:2048
 __sys_connect+0x114/0x140 net/socket.c:2065
 __do_sys_connect net/socket.c:2075 [inline]
 __se_sys_connect net/socket.c:2072 [inline]
 __x64_sys_connect+0x40/0x50 net/socket.c:2072
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0x4f/0x110 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x46/0x4e

value changed: 0x000000e4 -> 0x000001e3

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 4465 Comm: syz-executor.0 Not tainted 6.8.0-12822-gcd51db110a7e #12
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014

Fixes: afd20b9290e1 ("af_unix: Replace the big lock with small locks.")
Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://lore.kernel.org/r/20240522154218.78088-1-kuniyu@amazon.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 97d22bdfdc73b..4a8ace9d32391 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1121,8 +1121,8 @@ static struct sock *unix_find_other(struct net *net,
 
 static int unix_autobind(struct sock *sk)
 {
-	unsigned int new_hash, old_hash = sk->sk_hash;
 	struct unix_sock *u = unix_sk(sk);
+	unsigned int new_hash, old_hash;
 	struct net *net = sock_net(sk);
 	struct unix_address *addr;
 	u32 lastnum, ordernum;
@@ -1145,6 +1145,7 @@ static int unix_autobind(struct sock *sk)
 	addr->name->sun_family = AF_UNIX;
 	refcount_set(&addr->refcnt, 1);
 
+	old_hash = sk->sk_hash;
 	ordernum = get_random_u32();
 	lastnum = ordernum & 0xFFFFF;
 retry:
@@ -1185,8 +1186,8 @@ static int unix_bind_bsd(struct sock *sk, struct sockaddr_un *sunaddr,
 {
 	umode_t mode = S_IFSOCK |
 	       (SOCK_INODE(sk->sk_socket)->i_mode & ~current_umask());
-	unsigned int new_hash, old_hash = sk->sk_hash;
 	struct unix_sock *u = unix_sk(sk);
+	unsigned int new_hash, old_hash;
 	struct net *net = sock_net(sk);
 	struct user_namespace *ns; // barf...
 	struct unix_address *addr;
@@ -1227,6 +1228,7 @@ static int unix_bind_bsd(struct sock *sk, struct sockaddr_un *sunaddr,
 	if (u->addr)
 		goto out_unlock;
 
+	old_hash = sk->sk_hash;
 	new_hash = unix_bsd_hash(d_backing_inode(dentry));
 	unix_table_double_lock(net, old_hash, new_hash);
 	u->path.mnt = mntget(parent.mnt);
@@ -1254,8 +1256,8 @@ static int unix_bind_bsd(struct sock *sk, struct sockaddr_un *sunaddr,
 static int unix_bind_abstract(struct sock *sk, struct sockaddr_un *sunaddr,
 			      int addr_len)
 {
-	unsigned int new_hash, old_hash = sk->sk_hash;
 	struct unix_sock *u = unix_sk(sk);
+	unsigned int new_hash, old_hash;
 	struct net *net = sock_net(sk);
 	struct unix_address *addr;
 	int err;
@@ -1273,6 +1275,7 @@ static int unix_bind_abstract(struct sock *sk, struct sockaddr_un *sunaddr,
 		goto out_mutex;
 	}
 
+	old_hash = sk->sk_hash;
 	new_hash = unix_abstract_hash(addr->name, addr->len, sk->sk_type);
 	unix_table_double_lock(net, old_hash, new_hash);
 
-- 
2.43.0



