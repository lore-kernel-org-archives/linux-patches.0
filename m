Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32CD221DA5;
	Tue, 11 Mar 2025 15:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707674; cv=none; b=eChOcgaduqv1oUiT9s3Sga+C57etZhTBV2lteiLaY3HmWvTYYae8byUdfo2qIhNKApBgoBFIVzU+6nsntj8FYiE3GoyjUAtz9OEZdyUeWSSiKz4JksCJcKGu+IUllYVWfaQXAwUXQk+pqpxR79Nx3CkZY9mHggd12NkM4yFOMmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707674; c=relaxed/simple;
	bh=C6Gf5GyNsYbhLanet8Tmdh2JrfSHH7pBTvEqh6d9umQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t30Ktx/5+rD+qlASBvS/yfLOoZXEmV2B3/4EaHTWJNXdQz2VrdVhPBV4Qj5rbUcBp6xJg6fsWEhSH1hdHbH2QEzVX9KP+iYshmqJiJGinXANQ7e0S49Hg8p+gV0FrtcfsABjPyidY7C8VaotC9ZbLakR6ioI+YZBuI/yiw6nZqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ihvhlv5O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ihvhlv5O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3501EC4CEE9;
	Tue, 11 Mar 2025 15:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707674;
	bh=C6Gf5GyNsYbhLanet8Tmdh2JrfSHH7pBTvEqh6d9umQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ihvhlv5Og8mNQamyc3Mc1/zkT/adMtpYMw635C9+beicRv8lBjaARVFo0xnKsTR68
	 YAQY+kek011zO+y4wsKSMYkmW5hWpZ6NlFJ/lk46eG9b4DXOU4UUlYBChSU8iKmX4m
	 YRSmE5Ky2e0H/Wlb0jFQIcu+Wt/fWsUGXwUmGsqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9d55b199192a4be7d02c@syzkaller.appspotmail.com,
	Luigi Leonardi <leonardi@redhat.com>,
	Michal Luczaj <mhal@rbox.co>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 454/462] vsock: Orphan socket after transport release
Date: Tue, 11 Mar 2025 16:02:00 +0100
Message-ID: <20250311145816.259870399@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Luczaj <mhal@rbox.co>

commit 78dafe1cf3afa02ed71084b350713b07e72a18fb upstream.

During socket release, sock_orphan() is called without considering that it
sets sk->sk_wq to NULL. Later, if SO_LINGER is enabled, this leads to a
null pointer dereferenced in virtio_transport_wait_close().

Orphan the socket only after transport release.

Partially reverts the 'Fixes:' commit.

KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
 lock_acquire+0x19e/0x500
 _raw_spin_lock_irqsave+0x47/0x70
 add_wait_queue+0x46/0x230
 virtio_transport_release+0x4e7/0x7f0
 __vsock_release+0xfd/0x490
 vsock_release+0x90/0x120
 __sock_release+0xa3/0x250
 sock_close+0x14/0x20
 __fput+0x35e/0xa90
 __x64_sys_close+0x78/0xd0
 do_syscall_64+0x93/0x1b0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

Reported-by: syzbot+9d55b199192a4be7d02c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9d55b199192a4be7d02c
Fixes: fcdd2242c023 ("vsock: Keep the binding until socket destruction")
Tested-by: Luigi Leonardi <leonardi@redhat.com>
Reviewed-by: Luigi Leonardi <leonardi@redhat.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Link: https://patch.msgid.link/20250210-vsock-linger-nullderef-v3-1-ef6244d02b54@rbox.co
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Luigi Leonardi <leonardi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/af_vsock.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -785,13 +785,19 @@ static void __vsock_release(struct sock
 	 */
 	lock_sock_nested(sk, level);
 
-	sock_orphan(sk);
+	/* Indicate to vsock_remove_sock() that the socket is being released and
+	 * can be removed from the bound_table. Unlike transport reassignment
+	 * case, where the socket must remain bound despite vsock_remove_sock()
+	 * being called from the transport release() callback.
+	 */
+	sock_set_flag(sk, SOCK_DEAD);
 
 	if (vsk->transport)
 		vsk->transport->release(vsk);
 	else if (sk->sk_type == SOCK_STREAM)
 		vsock_remove_sock(vsk);
 
+	sock_orphan(sk);
 	sk->sk_shutdown = SHUTDOWN_MASK;
 
 	skb_queue_purge(&sk->sk_receive_queue);


