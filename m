Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F67D63BB
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 14:01:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB67CC433EF;
	Mon, 20 Feb 2023 14:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901707;
	bh=jmb8EOHrGLpjFoT+w709u7XwQTNBnJU+UM0zIiYSFmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qq04gRjuTfK80bQaUGSFwO/znb3E3+gl7n38DMiBzrqRsSx3hECHnRjA0XT9L3EEs
	 rzl8yJdEc8kwCB+CANxJwdbSs0tLZcurWLpFdmt8MwVLOL5iPA2yfIf1x4zdrmtBqG
	 2QFTz6+Gz6A+fDEZ6d2VLHia2l0PunjYOtvIhFGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d43608d061e8847ec9f3@syzkaller.appspotmail.com,
	Jon Maloy <jmaloy@redhat.com>,
	Tung Nguyen <tung.q.nguyen@dektech.com.au>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 098/118] tipc: fix kernel warning when sending SYN message
Date: Mon, 20 Feb 2023 14:36:54 +0100
Message-Id: <20230220133604.314511548@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tung Nguyen <tung.q.nguyen@dektech.com.au>

commit 11a4d6f67cf55883dc78e31c247d1903ed7feccc upstream.

When sending a SYN message, this kernel stack trace is observed:

...
[   13.396352] RIP: 0010:_copy_from_iter+0xb4/0x550
...
[   13.398494] Call Trace:
[   13.398630]  <TASK>
[   13.398630]  ? __alloc_skb+0xed/0x1a0
[   13.398630]  tipc_msg_build+0x12c/0x670 [tipc]
[   13.398630]  ? shmem_add_to_page_cache.isra.71+0x151/0x290
[   13.398630]  __tipc_sendmsg+0x2d1/0x710 [tipc]
[   13.398630]  ? tipc_connect+0x1d9/0x230 [tipc]
[   13.398630]  ? __local_bh_enable_ip+0x37/0x80
[   13.398630]  tipc_connect+0x1d9/0x230 [tipc]
[   13.398630]  ? __sys_connect+0x9f/0xd0
[   13.398630]  __sys_connect+0x9f/0xd0
[   13.398630]  ? preempt_count_add+0x4d/0xa0
[   13.398630]  ? fpregs_assert_state_consistent+0x22/0x50
[   13.398630]  __x64_sys_connect+0x16/0x20
[   13.398630]  do_syscall_64+0x42/0x90
[   13.398630]  entry_SYSCALL_64_after_hwframe+0x63/0xcd

It is because commit a41dad905e5a ("iov_iter: saner checks for attempt
to copy to/from iterator") has introduced sanity check for copying
from/to iov iterator. Lacking of copy direction from the iterator
viewpoint would lead to kernel stack trace like above.

This commit fixes this issue by initializing the iov iterator with
the correct copy direction when sending SYN or ACK without data.

Fixes: f25dcc7687d4 ("tipc: tipc ->sendmsg() conversion")
Reported-by: syzbot+d43608d061e8847ec9f3@syzkaller.appspotmail.com
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
Link: https://lore.kernel.org/r/20230214012606.5804-1-tung.q.nguyen@dektech.com.au
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/socket.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -2614,6 +2614,7 @@ static int tipc_connect(struct socket *s
 		/* Send a 'SYN-' to destination */
 		m.msg_name = dest;
 		m.msg_namelen = destlen;
+		iov_iter_kvec(&m.msg_iter, ITER_SOURCE, NULL, 0, 0);
 
 		/* If connect is in non-blocking case, set MSG_DONTWAIT to
 		 * indicate send_msg() is never blocked.
@@ -2776,6 +2777,7 @@ static int tipc_accept(struct socket *so
 		__skb_queue_head(&new_sk->sk_receive_queue, buf);
 		skb_set_owner_r(buf, new_sk);
 	}
+	iov_iter_kvec(&m.msg_iter, ITER_SOURCE, NULL, 0, 0);
 	__tipc_sendstream(new_sock, &m, 0);
 	release_sock(new_sk);
 exit:


