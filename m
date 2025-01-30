Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE1D1E6DCF;
	Thu, 30 Jan 2025 14:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247180; cv=none; b=efZiH6IOyAdMb6E+Ynl+jjvDJ6E9Fm/9nY3nqsGtQDuJFSG6rrvnNnx6C8c/GaW33Fd5rSsIMyK+9DSNXyGRmW9artT7d5tWFPLK41EOH79AiWyZUibfGeCfDg7DTHH4AKe53IDDdi3FxwEL1pXvooMm4hLOTXohCIsgMcsSWl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247180; c=relaxed/simple;
	bh=fa/zWRuCudoT732iosczLnGzUFll5/ItHGkjhX6RwUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OolBv4xB+uKNp7wQ3WYFdhgXLSkGCDDqw9ocZN8jGOU/wudX4+vpmac1WvMVhVoJWjn+qEXzIj0C+LJ9WYjRKAp6lnU+vBCty5/w86Q3x2eim7tmJVzcwb16Rz8NE805kDJF2sjZ5B6zzJlP581sWArFxsETLFCDlnBJb1SIyq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JGb54TGr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JGb54TGr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236A2C4CED2;
	Thu, 30 Jan 2025 14:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247180;
	bh=fa/zWRuCudoT732iosczLnGzUFll5/ItHGkjhX6RwUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JGb54TGr1cCCnUKdNatMImWIcehIzTU5VZrxC7/SrtVt4brMa0fB8VsLIX1LPR0vB
	 GucToAGNt2WcMY8RF0UOsBddSNFkzjF+jnoj0AZ+daFWQ2jq9BkmArji+x9eWTRGjH
	 PhRCCPmhVPTqhjaos7C01Hl5yN2XYm5EXBv4rD9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <v4bel@theori.io>,
	Wongi Lee <qwerty@theori.io>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 110/133] vsock/virtio: discard packets if the transport changes
Date: Thu, 30 Jan 2025 15:01:39 +0100
Message-ID: <20250130140146.965543328@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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
@@ -1171,8 +1171,11 @@ void virtio_transport_recv_pkt(struct vi
 
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


