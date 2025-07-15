Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982EF2E7BC0;
	Tue, 15 Jul 2025 13:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586743; cv=none; b=g2V+WpHpKCOMANZIG7F3LTPn9o4a2iFWHJGR8m57A81uO8iNYx4HEcT5Sz6dqXir5AlIwvD1kcoV6aNE+zH9h+o/3yGI0or9nIwNeDwiBD1ButO6ixA5tYnr9ezHFuIKWkNWZw1e91LCKkP7eIVdBiXCWhU/FUkCyA/gVohpAB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586743; c=relaxed/simple;
	bh=2oC2TIWPYuBtRWBIJ6hFLiUC4z/EgWPSIwHj5BujCrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iHiWX5iNdxZt+3gXbDPB0b1Wq9J8SjuRkD0oypRVkkB+IwOOrmE4Q9gUxdy1BuGMrjspXECjDa3ioJXPRxMBRMrMs3MNTnIy4EfmZI0Ij6T42dCBij/goiGsEyQQAijtlf0JZ8MjAf1zDM58U7TAwBp8Pzm6faKHq1Es7exACe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=plFmit7Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="plFmit7Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CFAFC4CEE3;
	Tue, 15 Jul 2025 13:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586743;
	bh=2oC2TIWPYuBtRWBIJ6hFLiUC4z/EgWPSIwHj5BujCrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=plFmit7Y11Qd18QXatcP4TbrVqk9QKMKxNRFSu0PoxOwdk+wPASh+UihbjXj3l2pg
	 nJ1fVySdX+cbAf61lh30cWNL0yr5+hBORYBAkY4Jddfges/U+xCTqVybrVayvQdeJi
	 lQALbVUz7JJtoHkhrYR3msWzEAxa3hH3keRwNpHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Michal Luczaj <mhal@rbox.co>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 032/192] vsock: Fix transport_{g2h,h2g} TOCTOU
Date: Tue, 15 Jul 2025 15:12:07 +0200
Message-ID: <20250715130816.148644462@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index fc6afbc8d6806..43be340233dae 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -531,9 +531,25 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
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
@@ -2503,18 +2519,17 @@ static long vsock_dev_do_ioctl(struct file *filp,
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



