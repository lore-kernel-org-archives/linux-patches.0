Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5ADC1EEA2A;
	Wed, 19 Feb 2025 08:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955418; cv=none; b=by6yzIzAQdqjy/l1jw6Ft1D2lV3i/Qi1/AzOOsFMS0JsTMQmxJEPHcP9BuVS6TCYNV3JG/1M4IM8R9gzVPKdOOCXd8wHvxih0a+ye9Ewo+m8vgoIIPiWnEZwDKIqoCWspMLpFDrAxnRXR6mzo+x1rvRDEbiYjb6WAtPjTLNc01c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955418; c=relaxed/simple;
	bh=qpl+EJ3bMzfQEY7KsalJ4WfacmRQ6TiAZ5bb3YceV5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ag5VvDA5Pg4sGkJ7YmZJZ6RyRn6C5WaUX5mRbykLl83Cagn8J6z44cLw9pw5tYQa6XzpEsGdO0IfITD+S2PoAOQRxaIOS75msujCIDufO74csiyaL9hu/dK3+QZb7rdwnKeReot5kHVQcor9cVcg2j6lNjyqdcnohIIeKkFEzg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kybU6Lf0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kybU6Lf0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26B34C4CEE7;
	Wed, 19 Feb 2025 08:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955418;
	bh=qpl+EJ3bMzfQEY7KsalJ4WfacmRQ6TiAZ5bb3YceV5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kybU6Lf0WC/g/uxD+MwUKlwT/uhxjg/KI9lq8Rkb05h7PPEAQgGaXHWrW0mwzjh/g
	 7QifxBA8YgTuJDUvKyGX0AaZk0voIZUSXd1X0yg0BngY/Zc0J6WJgHtrcC9b3jNhzF
	 ePOH87DX7lXWZJMWR8FmkCr+kVaAwGvn5HYUCMMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9d55b199192a4be7d02c@syzkaller.appspotmail.com,
	Luigi Leonardi <leonardi@redhat.com>,
	Michal Luczaj <mhal@rbox.co>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 229/230] vsock: Orphan socket after transport release
Date: Wed, 19 Feb 2025 09:29:06 +0100
Message-ID: <20250219082610.640666611@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/af_vsock.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -824,13 +824,19 @@ static void __vsock_release(struct sock
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
 	else if (sock_type_connectible(sk->sk_type))
 		vsock_remove_sock(vsk);
 
+	sock_orphan(sk);
 	sk->sk_shutdown = SHUTDOWN_MASK;
 
 	skb_queue_purge(&sk->sk_receive_queue);


