Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1CF1F55ED;
	Tue, 21 Jan 2025 17:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482137; cv=none; b=Hxx11yE6fgMY9IqOw5aixAZyqjzQsidOOvgcqCpAgBXYtveE1xsGzrtxePi9iU3HX7gdQOjVcrwFthspV3lOdijG3Y1G0c7wxXMP+HjHfCbpUhXf4PqKd33plQdxi/KWatMtrgHE5fwIZgWB2xB41L4YT3SWEKm05Jbn2exri/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482137; c=relaxed/simple;
	bh=6WW0uPutusef+ZSUr6pWzt/Sj5/USnnBvKYl1tnqbds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y1+sedg/lqnWGKjUKYIzPPuQR+stztmpGWJsMmM3moeYGlAstsZAJPBhmJTn3alvoXYyMwtcH495ZdhDSsohtmqewWPYhfcRXogTTLdcI1XM32NHJSMnIR5kA09d4DZxZLau/WtIHp+Sf5W8Gux73ISVaFtS0jMDddgLsGlb7Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hUdnupYL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hUdnupYL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07ED6C4CEDF;
	Tue, 21 Jan 2025 17:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482137;
	bh=6WW0uPutusef+ZSUr6pWzt/Sj5/USnnBvKYl1tnqbds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hUdnupYL88bSN7qpdZtofFjQpfexz0HkRdt4AR2b1TLOnrUnY0jSqAo4RgQqQXMma
	 oD4lxLRZda63RBFfxnKYfqZDPsO6AwBM4l5PUf4lSnD07POdIWz/9BlZCLXlqRCHay
	 9g/Cel2GvbWb3PkYYZ/Z8cMMnjMB89liihHjW/UU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <v4bel@theori.io>,
	Wongi Lee <qwerty@theori.io>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 46/72] vsock/virtio: discard packets if the transport changes
Date: Tue, 21 Jan 2025 18:52:12 +0100
Message-ID: <20250121174525.196595352@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
References: <20250121174523.429119852@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1428,8 +1428,11 @@ void virtio_transport_recv_pkt(struct vi
 
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


