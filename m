Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBA41F55F0;
	Tue, 21 Jan 2025 18:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737483119; cv=none; b=YeTHl92tyvSpIwMyXC6gffnkz4aP1mJbVZok5MkweNcVtr9mAHsXsNys1BO+Cp4dfa4Vj9kff2S4Z4+cWqc0QKOakKrJwnThmIiKrjXrhW8i+RrJ3+xp9bwO4nbb+4d0Deb4UZBgmZMnIZiKwNReTrNs5CT6KusWxLDu7nwdyrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737483119; c=relaxed/simple;
	bh=gWfRR8JChLwGOELKtzvG0hG7LaF/D81V9TZkXEYsMJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qscilHEji8NO9kv0CSnqSqvzuGFbmidNcTRcgCFEZu9SoZ+n6vIf3+xTZ9a+iazIdB6fktxXfPRWGqPqXmYjqWfBJuoHkujL1GEhkfUBfYlLrcrcuSj+ODCimejlVezybtm/9id3Vss9DvzcPvt7jui4CXht0/XKfIQW1JtO++k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iOHnO0nW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iOHnO0nW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B68C4CEDF;
	Tue, 21 Jan 2025 18:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737483119;
	bh=gWfRR8JChLwGOELKtzvG0hG7LaF/D81V9TZkXEYsMJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iOHnO0nWz4/JfJlDgZSIhozlkoox3JUrICqek/LGdWW7KqQ/KA7Hyx9Ww/FT4GBId
	 9E8IrvRTKsOvwkXAV6tYuIDuARL83/31zm5Q3guL/Hp9yn4oSJ+Jnf1J/kgCqhLCe7
	 Vkh8b28mafoywTc0iQUN97q+gbUPf6QqzHTDH698=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <v4bel@theori.io>,
	Wongi Lee <qwerty@theori.io>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 122/127] vsock/virtio: discard packets if the transport changes
Date: Tue, 21 Jan 2025 18:53:14 +0100
Message-ID: <20250121174534.343651220@linuxfoundation.org>
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

From: Stefano Garzarella <sgarzare@redhat.com>

commit 2cb7c756f605ec02ffe562fb26828e4bcc5fdfc1 upstream.

If the socket has been de-assigned or assigned to another transport,
we must discard any packets received because they are not expected
and would cause issues when we access vsk->transport.

A possible scenario is described by Hyunwoo Kim in the attached link,
where after a first connect() interrupted by a signal, and a second
connect() failed, we can find `vsk->transport` at NULL, leading to a
NULL pointer dereference.

Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
Cc: stable@vger.kernel.org
Reported-by: Hyunwoo Kim <v4bel@theori.io>
Reported-by: Wongi Lee <qwerty@theori.io>
Closes: https://lore.kernel.org/netdev/Z2LvdTTQR7dBmPb5@v4bel-B760M-AORUS-ELITE-AX/
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Hyunwoo Kim <v4bel@theori.io>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[SG: fixed context conflict since this tree is missing commit 71dc9ec9ac7d
 ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")]
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/virtio_transport_common.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1317,8 +1317,11 @@ void virtio_transport_recv_pkt(struct vi
 
 	lock_sock(sk);
 
-	/* Check if sk has been closed before lock_sock */
-	if (sock_flag(sk, SOCK_DONE)) {
+	/* Check if sk has been closed or assigned to another transport before
+	 * lock_sock (note: listener sockets are not assigned to any transport)
+	 */
+	if (sock_flag(sk, SOCK_DONE) ||
+	    (sk->sk_state != TCP_LISTEN && vsk->transport != &t->transport)) {
 		(void)virtio_transport_reset_no_sock(t, pkt);
 		release_sock(sk);
 		sock_put(sk);


