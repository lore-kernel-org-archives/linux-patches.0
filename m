Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574FF26D4F2;
	Tue, 15 Jul 2025 13:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587788; cv=none; b=OVP83dSpO+SLaUkTC+U+TfKwzCyfwU8ea9pxiKMmoV9GJDEiz0lWkxzf4UzDGAQbKQsGCbclNpjWO4JeIjUOBQKdXYGTexWVoZMEr6JBndJu94kNGgEEFNcIwk5UXNDrTZO/5NqEygTFLlp5d9ug2a7crxRpkN76AFap6eizBPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587788; c=relaxed/simple;
	bh=cyf4YJlBJ2DkmU8h6Q0NRq0jak+nbY1JmLyFPF1EYl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IV6e/ICYd/v3ZAvdDNxoV7GZNXm987aM0Bpn7pPkxPjayYu8Fw7iotOodVPaMXnnr9bej6VPsNZaH6jxAVLoSzL1NJ54UcBNoWDlEJmFPMli8jhrgGNC5PSQRsBP4NX1+vzaVFtD044Gj3p+Cqxp9ttJ5EMmQWUTDR4wQB2CA2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zi3vCeZ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zi3vCeZ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED70C4CEE3;
	Tue, 15 Jul 2025 13:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587788;
	bh=cyf4YJlBJ2DkmU8h6Q0NRq0jak+nbY1JmLyFPF1EYl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zi3vCeZ6TXarnH+vmsLaHRjb6e4zAAhVVBBhKhpmcHVFOlfXWLZvoKzQISUnRfMGl
	 x48pt3KK/6VuLGEqUKHl59QnFv17K7gxsQNkrsYEiXhSfQ3kjsoLQRMRQsp1li57zr
	 w7oeizME3sWXGp9clzoScY7GRYHJrKROAM5fb3co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Michal Luczaj <mhal@rbox.co>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 144/208] vsock: Fix transport_* TOCTOU
Date: Tue, 15 Jul 2025 15:14:13 +0200
Message-ID: <20250715130816.690411228@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

[ Upstream commit 687aa0c5581b8d4aa87fd92973e4ee576b550cdf ]

Transport assignment may race with module unload. Protect new_transport
from becoming a stale pointer.

This also takes care of an insecure call in vsock_use_local_transport();
add a lockdep assert.

BUG: unable to handle page fault for address: fffffbfff8056000
Oops: Oops: 0000 [#1] SMP KASAN
RIP: 0010:vsock_assign_transport+0x366/0x600
Call Trace:
 vsock_connect+0x59c/0xc40
 __sys_connect+0xe8/0x100
 __x64_sys_connect+0x6e/0xc0
 do_syscall_64+0x92/0x1c0
 entry_SYSCALL_64_after_hwframe+0x4b/0x53

Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Link: https://patch.msgid.link/20250703-vsock-transports-toctou-v4-2-98f0eb530747@rbox.co
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/af_vsock.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index beacbe957594a..f65868d2e82c3 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -400,6 +400,8 @@ EXPORT_SYMBOL_GPL(vsock_enqueue_accept);
 
 static bool vsock_use_local_transport(unsigned int remote_cid)
 {
+	lockdep_assert_held(&vsock_register_mutex);
+
 	if (!transport_local)
 		return false;
 
@@ -457,6 +459,8 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 
 	remote_flags = vsk->remote_addr.svm_flags;
 
+	mutex_lock(&vsock_register_mutex);
+
 	switch (sk->sk_type) {
 	case SOCK_DGRAM:
 		new_transport = transport_dgram;
@@ -471,12 +475,15 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 			new_transport = transport_h2g;
 		break;
 	default:
-		return -ESOCKTNOSUPPORT;
+		ret = -ESOCKTNOSUPPORT;
+		goto err;
 	}
 
 	if (vsk->transport) {
-		if (vsk->transport == new_transport)
-			return 0;
+		if (vsk->transport == new_transport) {
+			ret = 0;
+			goto err;
+		}
 
 		/* transport->release() must be called with sock lock acquired.
 		 * This path can only be taken during vsock_stream_connect(),
@@ -500,8 +507,16 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 	/* We increase the module refcnt to prevent the transport unloading
 	 * while there are open sockets assigned to it.
 	 */
-	if (!new_transport || !try_module_get(new_transport->module))
-		return -ENODEV;
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
 
 	ret = new_transport->init(vsk, psk);
 	if (ret) {
@@ -512,6 +527,9 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 	vsk->transport = new_transport;
 
 	return 0;
+err:
+	mutex_unlock(&vsock_register_mutex);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(vsock_assign_transport);
 
-- 
2.39.5



