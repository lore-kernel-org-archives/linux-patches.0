Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BCE32561AE;
	Tue, 15 Jul 2025 13:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587275; cv=none; b=HdHX9fNHoHbq7v9NKdVLW1uIgNPMgdEZOgUQ1vPPKoHSd7d0G2kr+GB9xFvnjCaRGZiFsYMrZdk0MXDNa0IozQ1Ds+s09oPUy8XcJkeYUVq7bZ/F5uEaAhkqOeGbl93UcdLryHbFAR2tWkxql2nMnaQkrXRmPdHdrEXuRg7Yb9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587275; c=relaxed/simple;
	bh=ZfwB9NZgg5Jp+R0S5eJiJoKfpZShcmc9/0magCCfQ8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SlT9QsQkqRv+H7VJa3I2fAiQ7TbN/9hsz0Pw9DpSkhHRsGfS1EOy3OwdkxVRNksaUShdlPUXV1aCCtGJX96MvDVH3gk0RzLIffeFLnLUD6Kxlf9UneH5mjAXAr6hbNrJ3Z5seKBUMguWRLn9gGqb4nc5vWvipfQoJzjafRLVdDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QVhZx/I6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QVhZx/I6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2513C4CEE3;
	Tue, 15 Jul 2025 13:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587275;
	bh=ZfwB9NZgg5Jp+R0S5eJiJoKfpZShcmc9/0magCCfQ8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QVhZx/I6tNGSdPcvPvPvrM9SIWsk58hXksUFrqSIU7HCoGlwvqLOx9HTm/TAGdS/h
	 eS2hSBDlT8VckhnO0zPs6a/H/EtfsIOzQYYhbhORUVM2lfPhroXCTWPw8XhYbmLt3y
	 AjPJ4ZNwBsjRZI01ULFyiudOfSQDclep8rjHoh+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Michal Luczaj <mhal@rbox.co>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 09/88] vsock: Fix transport_{g2h,h2g} TOCTOU
Date: Tue, 15 Jul 2025 15:13:45 +0200
Message-ID: <20250715130754.881089744@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130754.497128560@linuxfoundation.org>
References: <20250715130754.497128560@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Luczaj <mhal@rbox.co>

[ Upstream commit 209fd720838aaf1420416494c5505096478156b4 ]

vsock_find_cid() and vsock_dev_do_ioctl() may race with module unload.
transport_{g2h,h2g} may become NULL after the NULL check.

Introduce vsock_transport_local_cid() to protect from a potential
null-ptr-deref.

KASAN: null-ptr-deref in range [0x0000000000000118-0x000000000000011f]
RIP: 0010:vsock_find_cid+0x47/0x90
Call Trace:
 __vsock_bind+0x4b2/0x720
 vsock_bind+0x90/0xe0
 __sys_bind+0x14d/0x1e0
 __x64_sys_bind+0x6e/0xc0
 do_syscall_64+0x92/0x1c0
 entry_SYSCALL_64_after_hwframe+0x4b/0x53

KASAN: null-ptr-deref in range [0x0000000000000118-0x000000000000011f]
RIP: 0010:vsock_dev_do_ioctl.isra.0+0x58/0xf0
Call Trace:
 __x64_sys_ioctl+0x12d/0x190
 do_syscall_64+0x92/0x1c0
 entry_SYSCALL_64_after_hwframe+0x4b/0x53

Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Link: https://patch.msgid.link/20250703-vsock-transports-toctou-v4-1-98f0eb530747@rbox.co
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/af_vsock.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index a2271da346d34..42b5ff148d80b 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -527,9 +527,25 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 }
 EXPORT_SYMBOL_GPL(vsock_assign_transport);
 
+/*
+ * Provide safe access to static transport_{h2g,g2h,dgram,local} callbacks.
+ * Otherwise we may race with module removal. Do not use on `vsk->transport`.
+ */
+static u32 vsock_registered_transport_cid(const struct vsock_transport **transport)
+{
+	u32 cid = VMADDR_CID_ANY;
+
+	mutex_lock(&vsock_register_mutex);
+	if (*transport)
+		cid = (*transport)->get_local_cid();
+	mutex_unlock(&vsock_register_mutex);
+
+	return cid;
+}
+
 bool vsock_find_cid(unsigned int cid)
 {
-	if (transport_g2h && cid == transport_g2h->get_local_cid())
+	if (cid == vsock_registered_transport_cid(&transport_g2h))
 		return true;
 
 	if (transport_h2g && cid == VMADDR_CID_HOST)
@@ -2320,18 +2336,17 @@ static long vsock_dev_do_ioctl(struct file *filp,
 			       unsigned int cmd, void __user *ptr)
 {
 	u32 __user *p = ptr;
-	u32 cid = VMADDR_CID_ANY;
 	int retval = 0;
+	u32 cid;
 
 	switch (cmd) {
 	case IOCTL_VM_SOCKETS_GET_LOCAL_CID:
 		/* To be compatible with the VMCI behavior, we prioritize the
 		 * guest CID instead of well-know host CID (VMADDR_CID_HOST).
 		 */
-		if (transport_g2h)
-			cid = transport_g2h->get_local_cid();
-		else if (transport_h2g)
-			cid = transport_h2g->get_local_cid();
+		cid = vsock_registered_transport_cid(&transport_g2h);
+		if (cid == VMADDR_CID_ANY)
+			cid = vsock_registered_transport_cid(&transport_h2g);
 
 		if (put_user(cid, p) != 0)
 			retval = -EFAULT;
-- 
2.39.5



