Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3BA8473;
	Sat, 30 Dec 2023 12:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HI4ArSmc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 331E4C433C7;
	Sat, 30 Dec 2023 12:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703938162;
	bh=3ya84O3PT3tZhrGBsIgvrYBkI8gQwMrk2s6eYh1CXdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HI4ArSmceix00MAY3JZ9aXQQKUUrB1YMRRnq/mQ2Sc8juCIBGvVRK0Pq4oXgIbfep
	 onUVIf7QdfUFVK+DtMb39Foa6Y4hduHWcqTu016qbFNGAkWlgQDjbT36aUgQo8qOlB
	 oqEzd9T7t8GluM5HXiknFX2B2ld2mTmnWT9DYYHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shigeru Yoshida <syoshida@redhat.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	syzbot+c71bc336c5061153b502@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	syzbot <syzkaller@googlegroups.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 027/112] net: Return error from sk_stream_wait_connect() if sk_wait_event() fails
Date: Sat, 30 Dec 2023 11:59:00 +0000
Message-ID: <20231230115807.628954401@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115806.714618407@linuxfoundation.org>
References: <20231230115806.714618407@linuxfoundation.org>
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

From: Shigeru Yoshida <syoshida@redhat.com>

[ Upstream commit cac23b7d7627915d967ce25436d7aae26e88ed06 ]

The following NULL pointer dereference issue occurred:

BUG: kernel NULL pointer dereference, address: 0000000000000000
<...>
RIP: 0010:ccid_hc_tx_send_packet net/dccp/ccid.h:166 [inline]
RIP: 0010:dccp_write_xmit+0x49/0x140 net/dccp/output.c:356
<...>
Call Trace:
 <TASK>
 dccp_sendmsg+0x642/0x7e0 net/dccp/proto.c:801
 inet_sendmsg+0x63/0x90 net/ipv4/af_inet.c:846
 sock_sendmsg_nosec net/socket.c:730 [inline]
 __sock_sendmsg+0x83/0xe0 net/socket.c:745
 ____sys_sendmsg+0x443/0x510 net/socket.c:2558
 ___sys_sendmsg+0xe5/0x150 net/socket.c:2612
 __sys_sendmsg+0xa6/0x120 net/socket.c:2641
 __do_sys_sendmsg net/socket.c:2650 [inline]
 __se_sys_sendmsg net/socket.c:2648 [inline]
 __x64_sys_sendmsg+0x45/0x50 net/socket.c:2648
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x43/0x110 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x63/0x6b

sk_wait_event() returns an error (-EPIPE) if disconnect() is called on the
socket waiting for the event. However, sk_stream_wait_connect() returns
success, i.e. zero, even if sk_wait_event() returns -EPIPE, so a function
that waits for a connection with sk_stream_wait_connect() may misbehave.

In the case of the above DCCP issue, dccp_sendmsg() is waiting for the
connection. If disconnect() is called in concurrently, the above issue
occurs.

This patch fixes the issue by returning error from sk_stream_wait_connect()
if sk_wait_event() fails.

Fixes: 419ce133ab92 ("tcp: allow again tcp_disconnect() when threads are waiting")
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reported-by: syzbot+c71bc336c5061153b502@syzkaller.appspotmail.com
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/stream.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/stream.c b/net/core/stream.c
index 051aa71a8ad0f..30e7deff4c551 100644
--- a/net/core/stream.c
+++ b/net/core/stream.c
@@ -79,7 +79,7 @@ int sk_stream_wait_connect(struct sock *sk, long *timeo_p)
 		remove_wait_queue(sk_sleep(sk), &wait);
 		sk->sk_write_pending--;
 	} while (!done);
-	return 0;
+	return done < 0 ? done : 0;
 }
 EXPORT_SYMBOL(sk_stream_wait_connect);
 
-- 
2.43.0



