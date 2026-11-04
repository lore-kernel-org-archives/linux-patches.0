Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829091;
	b=eqj4rdE2L4dJyw49NPDQtaZF9SkCgTYFT2olTbZ5jSRLktFELB9QU9VDsTlGcMaMkNvj
	 PMm7aK+L/yochKrGKTaBk80Yqp7h1JwBDbMdhq3M02+ED6BQ5sG0KbrpZfXLrO+41B+we
	 BLeOzqFGCR32G5ovIeUmgDdtpK9wUTDUR0npXd522dHl7xckvrdL1eRWqszLuw2HG+wIK
	 B0QqUGUtcGnxEuCcXcpOGD39LyHlBUjZNfHZ8YyQjf+eana9lxstOb43VdWNMCGkkSE4S
	 nSZb8AgZAqyvYpL82iW+a8WaatS5YPprokA94zSC29twxiUaoMgy7eYKPWE3DvzLGsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829091;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6YgWk3DQJNb11cxDgnEdNITjl3jMr27xrFuEtXxSS5Q=;
	b=sbhcnQ0XbdRq9E08QS9KW6g/W1oGKvFByMXs1dWmJBtgLuh07CqkLMFEUiELcpgsOPEh
	 TqlWSBqaXnA+BHklWQzTvv6Y8kGwyukYbU+UpN0Wa0hUXvdOWKeLEs6desk1HFXKTcIqH
	 d0hHURKesSekstY85Zqemkw6WRR9ZuV9tI0vuGtrcviZevCrs0X0un87KhhwD62AdsGet
	 dGT2N0aqYVGRsLy8+Gs15Zz6sYPvY4veZb2LnYp+y+aXviDLbLu1HnqNAPjAbKrcx9qnO
	 DQQdTt8KTBG4442c8i0NSUQehxJGzxYgc8LlVVk+o1Vn7p58p2qUXA3t4pETBJ1fArw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cOC2rUmd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD0D6072FB7;
	Wed,  4 Nov 2026 21:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cOC2rUmd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CB8C1F000C1;
	Wed,  4 Nov 2026 21:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829090;
	bh=6YgWk3DQJNb11cxDgnEdNITjl3jMr27xrFuEtXxSS5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cOC2rUmd0iaV722qoH0DJqbXbQkg0Z8pDhf9czPu8vy7iNQC8O7dbYB1PJXjIo6YU
	 p6addlOhhVM9n4DiGcrO5SBEBY7gMHuu0A2ZthQ3RLIJ+oVQ/ZzpguTJ4KL6PEZ0LT
	 Q2gf+nQT3++RJPekBsIw3J5fhKy33L2xQldvlu7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+54cdc566f64abf51b7f1@syzkaller.appspotmail.com,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.3 440/547] SUNRPC: Reject a socket that already has an svc_sock attached
Date: Wed,  4 Nov 2026 16:10:24 -0500
Message-ID: <20261104211050.853559251@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

commit 0995447b8059c4d23853cdcddbe789c4a2b6bb88 upstream.

Writing the same socket descriptor to /proc/fs/nfsd/portlist twice
attaches a second svc_sock to one socket. svc_setup_socket() saves
the socket's callbacks before installing its own, so the second
attach records svc_write_space() as the old write_space callback.
svc_udp_init() invokes that callback by way of svc_sock_setbufsize(),
and svc_write_space() then calls itself until the kernel stack is
exhausted:

  BUG: TASK stack guard page was hit at ffffc900037d7ff8
   svc_write_space+0x90/0x2b0 net/sunrpc/svcsock.c:429
   svc_write_space+0xe6/0x2b0 net/sunrpc/svcsock.c:430
   ... 700 more ...
   svc_sock_setbufsize+0x18d/0x220 net/sunrpc/svcsock.c:386
   svc_udp_init net/sunrpc/svcsock.c:854 [inline]
   svc_setup_socket+0xb2f/0x1090 net/sunrpc/svcsock.c:1498
   svc_addsock+0x2fd/0x760 net/sunrpc/svcsock.c:1547
   __write_ports_addfd fs/nfsd/nfsctl.c:742 [inline]
   write_ports+0xa5b/0xcc0 fs/nfsd/nfsctl.c:861
   nfsctl_transaction_write+0x106/0x1a0 fs/nfsd/nfsctl.c:112

svc_data_ready() and svc_tcp_state_change() chain through their saved
callbacks the same way, so a TCP descriptor added twice recurses on
the next incoming segment instead. Reaching any of this takes a
writer on portlist, and the nfsd filesystem sets no FS_USERNS_MOUNT,
so the reproducer needs CAP_SYS_ADMIN in the initial user namespace.

Reject a socket that already carries sk_user_data. svc_setup_socket()
overwrites that field unconditionally, so a socket some other
consumer has claimed is one NFSD would corrupt whether or not the
callbacks recurse.

Fixes: b41b66d63c73 ("[PATCH] knfsd: allow sockets to be passed to nfsd via 'portlist'")
Cc: stable@vger.kernel.org
Reported-by: syzbot+54cdc566f64abf51b7f1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=54cdc566f64abf51b7f1
Link: https://patch.msgid.link/20260815162844.8219-1-cel@kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/svcsock.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1546,6 +1546,9 @@ int svc_addsock(struct svc_serv *serv, s
 	err = -EISCONN;
 	if (so->state > SS_UNCONNECTED)
 		goto out;
+	err = -EBUSY;
+	if (so->sk->sk_user_data)
+		goto out;
 	err = -ENOENT;
 	if (!try_module_get(THIS_MODULE))
 		goto out;


