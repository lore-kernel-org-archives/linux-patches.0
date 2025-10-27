Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B1131B83D;
	Mon, 27 Oct 2025 19:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591798; cv=none; b=QI5Q2zgqx32lxbFpMqrNty2+boAMDlRMbO0FTvDnWrAbgbb+UJas9iXwVLYqbYsfgMpyDnGcbZsHjMyzzxsKpCz0EYUozu4Y+qbTEP/FeqPNEwJcXR1VnwRSZ2Kyy/i3fc/0VuXEPHu96+hv1BH14QBWYxxGp7hCugdnwc5sn/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591798; c=relaxed/simple;
	bh=AIFOJbp/nMiAwKcmo4byTYTSZKMohAqn5TY2+adoY/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KVVtopKvrBZEnJPeXB3AaNZ6KTFyrLCHoW/CkgNru2EW+ngerpV/h/IcVGIwH3zK45SsOk1Ql1Tw+nZ/HkataZSywqozEg8RbRYV2fipyRI+xvjOxV1mLv+Mbdye+BB1eS5DaiYyZdNsh8p3vyePWbCRexQcBwcNT0b36p3gQ7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S0cI8tx+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S0cI8tx+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4791C113D0;
	Mon, 27 Oct 2025 19:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591798;
	bh=AIFOJbp/nMiAwKcmo4byTYTSZKMohAqn5TY2+adoY/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S0cI8tx+drpWHcNshEyzUZNIVb0TUUAIT/Sd13ID1fdCNWOioPJmq1jDfVVSqza4b
	 u3Jh0luKy4PMelnhmaus1hDd2dzvfsKYh0ydvK8mvhCfFlEF3nVZxTT3SJ7YZXTjRL
	 TF9gqzEfk95MV0guFeqaqqMTXxF6RtbKknxWwQOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+10e35716f8e4929681fa@syzkaller.appspotmail.com,
	mhal@rbox.co,
	Stefano Garzarella <sgarzare@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 305/332] vsock: fix lock inversion in vsock_assign_transport()
Date: Mon, 27 Oct 2025 19:35:58 +0100
Message-ID: <20251027183532.907140365@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[Stefano: fixed context since 5.10 is missing SEQPACKET support in vsock]
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/af_vsock.c |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -479,12 +479,26 @@ int vsock_assign_transport(struct vsock_
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
 		 * This path can only be taken during vsock_stream_connect(),
 		 * where we have already held the sock lock.
@@ -504,20 +518,6 @@ int vsock_assign_transport(struct vsock_
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
 	ret = new_transport->init(vsk, psk);
 	if (ret) {
 		module_put(new_transport->module);


