Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7E91F55E5;
	Tue, 21 Jan 2025 18:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737483148; cv=none; b=n/1zfIenMAKiFrDsj1HnDebv5rlWyfEyKbHKj4Rxl7jWVXSnp2juFiEJJDoV9is0OfVfE0cf/ltYMF5MN1No1suUl1qHXZwJUE41bxcnLWkTuWViT75uHqgIwbpQm2vjpYiqY6QYCK3CEDofuf5pxQNyF4R1XeA+Wi+IzDca9H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737483148; c=relaxed/simple;
	bh=Vm5AL1ED9/HrExBBCcpxiSZEWSKuzYUoKfKpvtXww1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fzYIbWZ0Ln/cEbFz6dmRl5TzOdOmfabzL1GNT89H88w1KUBDCCRJPV+HRVT7NwCqdgV7Rr93Ls6aHOF7YQ+uBcsE2IQVINf/CO+IyMBZ4OIK3BIdx/k9YmDLs2j68KWXtsXlyn+37Co+URcwtPYuhFALgP0MyJ3z6/z7MrWOSno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0FM8BEJ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0FM8BEJ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97736C4CEDF;
	Tue, 21 Jan 2025 18:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737483148;
	bh=Vm5AL1ED9/HrExBBCcpxiSZEWSKuzYUoKfKpvtXww1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0FM8BEJ8ZUWrZ0yt0OZS729CwejWbm7PU2Rae9Yob+jQKTsVebVZxvLZx1YHSeYqr
	 0ScMIZToqDBgRlKYnDL37umHA+Sz7WY1Kr6eFt1FSsgCiLI2PigLJUp8p640eyo2Iy
	 +MX2ayQ1Wvhy7/rB5lUZdpsWPZusWgLy1UyQbnS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 107/127] vsock: reset socket state when de-assigning the transport
Date: Tue, 21 Jan 2025 18:52:59 +0100
Message-ID: <20250121174533.779137083@linuxfoundation.org>
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

commit a24009bc9be60242651a21702609381b5092459e upstream.

Transport's release() and destruct() are called when de-assigning the
vsock transport. These callbacks can touch some socket state like
sock flags, sk_state, and peer_shutdown.

Since we are reassigning the socket to a new transport during
vsock_connect(), let's reset these fields to have a clean state with
the new transport.

Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
Cc: stable@vger.kernel.org
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Luigi Leonardi <leonardi@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/af_vsock.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -482,6 +482,15 @@ int vsock_assign_transport(struct vsock_
 		 */
 		vsk->transport->release(vsk);
 		vsock_deassign_transport(vsk);
+
+		/* transport's release() and destruct() can touch some socket
+		 * state, since we are reassigning the socket to a new transport
+		 * during vsock_connect(), let's reset these fields to have a
+		 * clean state.
+		 */
+		sock_reset_flag(sk, SOCK_DONE);
+		sk->sk_state = TCP_CLOSE;
+		vsk->peer_shutdown = 0;
 	}
 
 	/* We increase the module refcnt to prevent the transport unloading


