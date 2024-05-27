Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515E017727;
	Mon, 27 May 2024 19:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838289; cv=none; b=S9Gyh92uS11jUSOv+ISgUrirduC1pUY428bp+CGDke23IK748TwVPP4IOJTD1uw+CujQIcWfKh7Dt/xP2WvoSUeqv2rNR0ZMY2qx+ejvvCGEpdPtKxqyazStPKmyMBxc58JGHuQYHWJuzKttJ2E5ycQKr+2lhASDDqx/H4a4Vw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838289; c=relaxed/simple;
	bh=6kEKVqyf41P5d/PTKVx8KXWoravkm+5eOWJAr31n7oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VXecVKDkw0aPUdYqSqmuieyALAikclsNL9m+H/cZ9tmHOTm4qSZKcALHyoPqRABIK8c6/8VdxRiL16oZ6WfJCnWjbgnCjq6PkhSr8Tj0TxDT9sIrowYMHhT0V2DIk62eJnzM8dzYs1nQEoNk1yTKr5zdV+FBydgNwhOrPUzaWXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dub+8UwJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dub+8UwJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93544C32782;
	Mon, 27 May 2024 19:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838288;
	bh=6kEKVqyf41P5d/PTKVx8KXWoravkm+5eOWJAr31n7oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dub+8UwJobUoa1ejTtBiSGbzuUkwmUdpJOhqEmtMyq3dxTpcpkKWT2K77HavmS3aY
	 Cbqt7TMuUoE7f3eQIDx3P42OPoV/72d4vqbDclf+jj41fbZRvqMG7JoAwfF8151TNH
	 CjqHxi3cWo+/CA684QD6aTRZY2UID4YxhAb4nYeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 309/493] af_unix: Fix data races in unix_release_sock/unix_stream_sendmsg
Date: Mon, 27 May 2024 20:55:11 +0200
Message-ID: <20240527185640.399740396@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 540bf24fba16b88c1b3b9353927204b4f1074e25 ]

A data-race condition has been identified in af_unix. In one data path,
the write function unix_release_sock() atomically writes to
sk->sk_shutdown using WRITE_ONCE. However, on the reader side,
unix_stream_sendmsg() does not read it atomically. Consequently, this
issue is causing the following KCSAN splat to occur:

	BUG: KCSAN: data-race in unix_release_sock / unix_stream_sendmsg

	write (marked) to 0xffff88867256ddbb of 1 bytes by task 7270 on cpu 28:
	unix_release_sock (net/unix/af_unix.c:640)
	unix_release (net/unix/af_unix.c:1050)
	sock_close (net/socket.c:659 net/socket.c:1421)
	__fput (fs/file_table.c:422)
	__fput_sync (fs/file_table.c:508)
	__se_sys_close (fs/open.c:1559 fs/open.c:1541)
	__x64_sys_close (fs/open.c:1541)
	x64_sys_call (arch/x86/entry/syscall_64.c:33)
	do_syscall_64 (arch/x86/entry/common.c:?)
	entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)

	read to 0xffff88867256ddbb of 1 bytes by task 989 on cpu 14:
	unix_stream_sendmsg (net/unix/af_unix.c:2273)
	__sock_sendmsg (net/socket.c:730 net/socket.c:745)
	____sys_sendmsg (net/socket.c:2584)
	__sys_sendmmsg (net/socket.c:2638 net/socket.c:2724)
	__x64_sys_sendmmsg (net/socket.c:2753 net/socket.c:2750 net/socket.c:2750)
	x64_sys_call (arch/x86/entry/syscall_64.c:33)
	do_syscall_64 (arch/x86/entry/common.c:?)
	entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)

	value changed: 0x01 -> 0x03

The line numbers are related to commit dd5a440a31fa ("Linux 6.9-rc7").

Commit e1d09c2c2f57 ("af_unix: Fix data races around sk->sk_shutdown.")
addressed a comparable issue in the past regarding sk->sk_shutdown.
However, it overlooked resolving this particular data path.
This patch only offending unix_stream_sendmsg() function, since the
other reads seem to be protected by unix_state_lock() as discussed in
Link: https://lore.kernel.org/all/20240508173324.53565-1-kuniyu@amazon.com/

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://lore.kernel.org/r/20240509081459.2807828-1-leitao@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 9df15a7bc2569..eb90a255507ef 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2209,7 +2209,7 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 			goto out_err;
 	}
 
-	if (sk->sk_shutdown & SEND_SHUTDOWN)
+	if (READ_ONCE(sk->sk_shutdown) & SEND_SHUTDOWN)
 		goto pipe_err;
 
 	while (sent < len) {
-- 
2.43.0



