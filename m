Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52CB1F55F7;
	Tue, 21 Jan 2025 18:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482464; cv=none; b=JbIhIAadxbHVgdvI7/jenW/d0MS7xZuXc4gWrqIRh9lb0KXNI2AhVuHRfS+SBmHmhcD04CYmtv+IvqFEz6nBOJr2l4ilWeFayc84stVJBWsN2d4Wxu/J1tpP/2aKDA9KaIHS2Dl4pLz+8/grcePK0p9qkVLxUsXhXgB9ucFsL24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482464; c=relaxed/simple;
	bh=1RDcraMVFqwQaRIDSwoxBi6jaEeWwbPwrNSP5cSi/eA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GGo28aDl+QB3pWhNv7MSige/oS1yFpr6xfo6zH9dTufb7DnuTwSk9MQHo3TN3VZOci2gDMzA3bjqmblPVL+x4B3Q7CY2jF0wq5eg/uifGlfjxt46KJkmJRnLpRVZq+BjK4on7ThCgu0D2YcQnnKvnhGoEMRuy2GNKkDVtT23hzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p/Guwcy2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p/Guwcy2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C696C4CEDF;
	Tue, 21 Jan 2025 18:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482463;
	bh=1RDcraMVFqwQaRIDSwoxBi6jaEeWwbPwrNSP5cSi/eA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p/Guwcy2BiLhTUW20i//EaktM2hbbbDkqmjmbEONagvWHNYcSWS6KxChK6BGuZ0le
	 oI7/2pKqdeYkRVek5CrL423+FET4n2CmqjeUNDD2Haxva4SWhXVKlEoU8jlkzmFb5K
	 FJftN9u5mzOTw8CURbrpQdB6/rGFVVHwCFnwByd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <v4bel@theori.io>,
	Wongi Lee <qwerty@theori.io>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 085/122] vsock/virtio: discard packets if the transport changes
Date: Tue, 21 Jan 2025 18:52:13 +0100
Message-ID: <20250121174536.289361114@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/virtio_transport_common.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1628,8 +1628,11 @@ void virtio_transport_recv_pkt(struct vi
 
 	lock_sock(sk);
 
-	/* Check if sk has been closed before lock_sock */
-	if (sock_flag(sk, SOCK_DONE)) {
+	/* Check if sk has been closed or assigned to another transport before
+	 * lock_sock (note: listener sockets are not assigned to any transport)
+	 */
+	if (sock_flag(sk, SOCK_DONE) ||
+	    (sk->sk_state != TCP_LISTEN && vsk->transport != &t->transport)) {
 		(void)virtio_transport_reset_no_sock(t, skb);
 		release_sock(sk);
 		sock_put(sk);


