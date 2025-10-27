Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4A535965;
	Mon, 27 Oct 2025 19:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592643; cv=none; b=XfywQauCItYE1Sus7ELXNFg5PRgLYmBfW3VHbwaIz+XJ3fqq6uU+9Rfdh4jc0A7ac1raajB/DVRfTxCClbj+t+PygDEwepgjFLSqZoVRRgi4fxB6hZRiLKG460C86/xI/xaGvFePptpj25DIb6ADPX9zWlsJyaILDkI8nRXZ0ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592643; c=relaxed/simple;
	bh=GUT1RYcPehOweluoTpH5ArSNGD5ojuPyRFHtPlrVlBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WxLX9PCmRmTW6jW0fcEDtaS3jyAyy6N0xVbOGqpPL5/8eEn0YFWDnPbuII+9uJFajWryu/64n8f03PZ8XcHeoYf6EwYou3BqfRe3LZZ+h0cJyPTQCUAPObAbdEvaRmP68WoATnLuK4Webz2Ji1J198r5jSfjvfrkfHIJcOvvp2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hlru+vQN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hlru+vQN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A297FC4CEF1;
	Mon, 27 Oct 2025 19:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592643;
	bh=GUT1RYcPehOweluoTpH5ArSNGD5ojuPyRFHtPlrVlBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hlru+vQNMSxczR0EMh9fPc8gIIjcgJIp0D6R7Pe7tqAu7LC772XbIeuYqiDodbjlX
	 Ifmrk459vT24BujrtXyqZ1ut+NxDrqXQTLP95jNQWEdBwr8PI8kglN90PauyI7KAQz
	 hcatodwxNjI4+TK61Reg6TpTtqh0uEP6ygFCDlUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+10e35716f8e4929681fa@syzkaller.appspotmail.com,
	mhal@rbox.co,
	Stefano Garzarella <sgarzare@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 42/84] vsock: fix lock inversion in vsock_assign_transport()
Date: Mon, 27 Oct 2025 19:36:31 +0100
Message-ID: <20251027183439.941520724@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
References: <20251027183438.817309828@linuxfoundation.org>
User-Agent: quilt/0.69
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

commit f7c877e7535260cc7a21484c994e8ce7e8cb6780 upstream.

Syzbot reported a potential lock inversion deadlock between
vsock_register_mutex and sk_lock-AF_VSOCK when vsock_linger() is called.

The issue was introduced by commit 687aa0c5581b ("vsock: Fix
transport_* TOCTOU") which added vsock_register_mutex locking in
vsock_assign_transport() around the transport->release() call, that can
call vsock_linger(). vsock_assign_transport() can be called with sk_lock
held. vsock_linger() calls sk_wait_event() that temporarily releases and
re-acquires sk_lock. During this window, if another thread hold
vsock_register_mutex while trying to acquire sk_lock, a circular
dependency is created.

Fix this by releasing vsock_register_mutex before calling
transport->release() and vsock_deassign_transport(). This is safe
because we don't need to hold vsock_register_mutex while releasing the
old transport, and we ensure the new transport won't disappear by
obtaining a module reference first via try_module_get().

Reported-by: syzbot+10e35716f8e4929681fa@syzkaller.appspotmail.com
Tested-by: syzbot+10e35716f8e4929681fa@syzkaller.appspotmail.com
Fixes: 687aa0c5581b ("vsock: Fix transport_* TOCTOU")
Cc: mhal@rbox.co
Cc: stable@vger.kernel.org
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://patch.msgid.link/20251021121718.137668-1-sgarzare@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/af_vsock.c |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -486,12 +486,26 @@ int vsock_assign_transport(struct vsock_
 		goto err;
 	}
 
-	if (vsk->transport) {
-		if (vsk->transport == new_transport) {
-			ret = 0;
-			goto err;
-		}
+	if (vsk->transport && vsk->transport == new_transport) {
+		ret = 0;
+		goto err;
+	}
+
+	/* We increase the module refcnt to prevent the transport unloading
+	 * while there are open sockets assigned to it.
+	 */
+	if (!new_transport || !try_module_get(new_transport->module)) {
+		ret = -ENODEV;
+		goto err;
+	}
+
+	/* It's safe to release the mutex after a successful try_module_get().
+	 * Whichever transport `new_transport` points at, it won't go away until
+	 * the last module_put() below or in vsock_deassign_transport().
+	 */
+	mutex_unlock(&vsock_register_mutex);
 
+	if (vsk->transport) {
 		/* transport->release() must be called with sock lock acquired.
 		 * This path can only be taken during vsock_connect(), where we
 		 * have already held the sock lock. In the other cases, this
@@ -511,20 +525,6 @@ int vsock_assign_transport(struct vsock_
 		vsk->peer_shutdown = 0;
 	}
 
-	/* We increase the module refcnt to prevent the transport unloading
-	 * while there are open sockets assigned to it.
-	 */
-	if (!new_transport || !try_module_get(new_transport->module)) {
-		ret = -ENODEV;
-		goto err;
-	}
-
-	/* It's safe to release the mutex after a successful try_module_get().
-	 * Whichever transport `new_transport` points at, it won't go away until
-	 * the last module_put() below or in vsock_deassign_transport().
-	 */
-	mutex_unlock(&vsock_register_mutex);
-
 	if (sk->sk_type == SOCK_SEQPACKET) {
 		if (!new_transport->seqpacket_allow ||
 		    !new_transport->seqpacket_allow(remote_cid)) {


