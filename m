Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893B413B2B8;
	Tue, 27 Feb 2024 13:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041328; cv=none; b=GZBUt2Ae4NsT8VBt7/iECABMkT1tPRTqcgy1chFaxfsCm9ikhf38xkDiV8wTxTE0V5lDFAIONoNIje/uVQyIdyzyD+sBJDbnWwhj8qGWVhZIu9sELh0aFYMhtm6tjSbH0sLrE0u6EWhBPPXclNIxqD8vZzMjJT0XB5AHelZzZP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041328; c=relaxed/simple;
	bh=5vOf7dW1vOvYJ2rsnkvPq8jrXtUgLVTyu/XP/8MKFoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mXEiODw6qKs1pETYcnxT5nunz/FH1UHJA0F9a0I4Rvx7dPkFuCM6ecXZDZZC31EdEXDGWx8LqQNBGY79ZCwythJ2Y34q1b7qg+Cy9WaYPPj5pgM77gtD5hWVGfshibrBPnOORcaUv0G/wWRjLy6a8COkSKtXRDTJi26d2KCy0UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e9CWoJxj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e9CWoJxj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF958C433F1;
	Tue, 27 Feb 2024 13:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041328;
	bh=5vOf7dW1vOvYJ2rsnkvPq8jrXtUgLVTyu/XP/8MKFoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e9CWoJxjUjQJYz8WDgnD7HWHYkoLn+Nc8Da5CIBN4AdYrTL7wpaasT46FHtPNZG/Z
	 /9Z49DEVV8WiuwQdwEhD4mzAcRk/vdhlyTgl1yocpSKKz7ATeaQ8qdfDpePXyaTSyr
	 WjHTywBXjWJsR67IAKeyKchGQe87OYAjffx0q0zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+fd7b34375c1c8ce29c93@syzkaller.appspotmail.com,
	Shigeru Yoshida <syoshida@redhat.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 300/334] bpf, sockmap: Fix NULL pointer dereference in sk_psock_verdict_data_ready()
Date: Tue, 27 Feb 2024 14:22:38 +0100
Message-ID: <20240227131640.720755218@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shigeru Yoshida <syoshida@redhat.com>

[ Upstream commit 4cd12c6065dfcdeba10f49949bffcf383b3952d8 ]

syzbot reported the following NULL pointer dereference issue [1]:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  [...]
  RIP: 0010:0x0
  [...]
  Call Trace:
   <TASK>
   sk_psock_verdict_data_ready+0x232/0x340 net/core/skmsg.c:1230
   unix_stream_sendmsg+0x9b4/0x1230 net/unix/af_unix.c:2293
   sock_sendmsg_nosec net/socket.c:730 [inline]
   __sock_sendmsg+0x221/0x270 net/socket.c:745
   ____sys_sendmsg+0x525/0x7d0 net/socket.c:2584
   ___sys_sendmsg net/socket.c:2638 [inline]
   __sys_sendmsg+0x2b0/0x3a0 net/socket.c:2667
   do_syscall_64+0xf9/0x240
   entry_SYSCALL_64_after_hwframe+0x6f/0x77

If sk_psock_verdict_data_ready() and sk_psock_stop_verdict() are called
concurrently, psock->saved_data_ready can be NULL, causing the above issue.

This patch fixes this issue by calling the appropriate data ready function
using the sk_psock_data_ready() helper and protecting it from concurrency
with sk->sk_callback_lock.

Fixes: 6df7f764cd3c ("bpf, sockmap: Wake up polling after data copy")
Reported-by: syzbot+fd7b34375c1c8ce29c93@syzkaller.appspotmail.com
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: syzbot+fd7b34375c1c8ce29c93@syzkaller.appspotmail.com
Acked-by: John Fastabend <john.fastabend@gmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=fd7b34375c1c8ce29c93 [1]
Link: https://lore.kernel.org/bpf/20240218150933.6004-1-syoshida@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skmsg.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 93ecfceac1bc4..4d75ef9d24bfa 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -1226,8 +1226,11 @@ static void sk_psock_verdict_data_ready(struct sock *sk)
 
 		rcu_read_lock();
 		psock = sk_psock(sk);
-		if (psock)
-			psock->saved_data_ready(sk);
+		if (psock) {
+			read_lock_bh(&sk->sk_callback_lock);
+			sk_psock_data_ready(sk, psock);
+			read_unlock_bh(&sk->sk_callback_lock);
+		}
 		rcu_read_unlock();
 	}
 }
-- 
2.43.0



