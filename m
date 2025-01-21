Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8C01F5611;
	Tue, 21 Jan 2025 17:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482146; cv=none; b=d5XpF7rgAfQ1KhaI2JUuH0YmH7S0gSsyvzu7A0OTWsWAbeGBv6DZshf0NiUWRk2Ii2B1c16b9EqykfINqnRuuy0J5Fcg0Du8edJM6YAPgyT+Nl5IvDL518C81WXSs2HPiXQA1vVhmUTEhzMDa7MqbFA1GtsmGucJBILPzim/7vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482146; c=relaxed/simple;
	bh=rGzlink40xaTbaCZAHyczYeBGx1VQKQQL3Q41mP0F+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UnD4mGtFMd0k5ylhEFxqy6FBtU9lkKxK8LSNcjkZc5KJn84RpYMuUgJnZjSk6VY2e4S0wDJ4pFaZxFI/HU1ypE3qjLmQiYCK8jwNp9OzyQpgiaKz2YxNZRouqGxdKJPUgaQW2XI5Pnmy0qQBIpQHiI/2qoTfEQbl3u55Rm063uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jGSRx+4f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jGSRx+4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23F6C4CEDF;
	Tue, 21 Jan 2025 17:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482146;
	bh=rGzlink40xaTbaCZAHyczYeBGx1VQKQQL3Q41mP0F+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jGSRx+4flGGu38Bn65Tf7+Of631VK1ejzBJ2i6LdLXIoVn86/2jteAIu5xFnGxSGB
	 yKxeCKLTw3gW2RosS1PjFpVvsSIGY3/txcG9PA03M3x9Gjrp5ejl1U3yp7uH/kUWAV
	 CTGeynuMxNTk1Ar3H+loiv9NrsMLIqC2RV8SVaXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 48/72] vsock: reset socket state when de-assigning the transport
Date: Tue, 21 Jan 2025 18:52:14 +0100
Message-ID: <20250121174525.275964278@linuxfoundation.org>
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
@@ -490,6 +490,15 @@ int vsock_assign_transport(struct vsock_
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


