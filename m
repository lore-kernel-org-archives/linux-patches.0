Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1285544C6F;
	Thu, 13 Jun 2024 12:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281125; cv=none; b=gXquVcgbtLkHR1Z6MpjL0r0G33i0oGatFMoiUx6iRsi1bxcJ+eMIMssrFZehdpDPezsQ2iDDbqi0gM17hRJolS2HXiXnnXEiJ5jJ2XYXwMm221tiMCQCYMXhTTHC0d4kBxRMxyMpiMHaTg7nvABqEdjpU8nWuDYb/0k3Q8wk7VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281125; c=relaxed/simple;
	bh=z3v50TiIDM28UM8DQBHaGs/yJspDOLimtk/QzfMdWsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kckwCe0Yxsa+8Uqt9ixphaSrGqK6Vs0Gg1FGTTUOjbOX+2GtUT27yPwahNvkpHnYz0Iuuu/Khm8xDnco3suxpg5PuDIyNOpXegyNKKEa6QEaUsMNZfIBRgFOHutbJ6MIGdqpDczc+EMFg6Ognf9kTTfvMwtGqWs7Q0HmcYskPuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zpjAD2FP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zpjAD2FP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D70C2BBFC;
	Thu, 13 Jun 2024 12:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281124;
	bh=z3v50TiIDM28UM8DQBHaGs/yJspDOLimtk/QzfMdWsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zpjAD2FPgaxir2bjgKOKTPqNxUxWPDiExnrQCbY65KW33rpcdZYTtGloCcEl5uWOL
	 7hdGUsl8rDVAXbk2eFeN3V/VLlVKghiwQN7pvo23D3Tuwt4BkHPr3EoaYPm0S/QBa3
	 Y6ANgmVXHex1nCGA1BHgArelP4NapitvtQRMcZ/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Chris Lew <quic_clew@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 131/317] net: qrtr: ns: Fix module refcnt
Date: Thu, 13 Jun 2024 13:32:29 +0200
Message-ID: <20240613113252.625412083@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Chris Lew <quic_clew@quicinc.com>

[ Upstream commit fd76e5ccc48f9f54eb44909dd7c0b924005f1582 ]

The qrtr protocol core logic and the qrtr nameservice are combined into
a single module. Neither the core logic or nameservice provide much
functionality by themselves; combining the two into a single module also
prevents any possible issues that may stem from client modules loading
inbetween qrtr and the ns.

Creating a socket takes two references to the module that owns the
socket protocol. Since the ns needs to create the control socket, this
creates a scenario where there are always two references to the qrtr
module. This prevents the execution of 'rmmod' for qrtr.

To resolve this, forcefully put the module refcount for the socket
opened by the nameservice.

Fixes: a365023a76f2 ("net: qrtr: combine nameservice into main module")
Reported-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Tested-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Signed-off-by: Chris Lew <quic_clew@quicinc.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/qrtr/ns.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
index 3376a656da39f..1da34d54092be 100644
--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -815,6 +815,24 @@ int qrtr_ns_init(void)
 	if (ret < 0)
 		goto err_wq;
 
+	/* As the qrtr ns socket owner and creator is the same module, we have
+	 * to decrease the qrtr module reference count to guarantee that it
+	 * remains zero after the ns socket is created, otherwise, executing
+	 * "rmmod" command is unable to make the qrtr module deleted after the
+	 *  qrtr module is inserted successfully.
+	 *
+	 * However, the reference count is increased twice in
+	 * sock_create_kern(): one is to increase the reference count of owner
+	 * of qrtr socket's proto_ops struct; another is to increment the
+	 * reference count of owner of qrtr proto struct. Therefore, we must
+	 * decrement the module reference count twice to ensure that it keeps
+	 * zero after server's listening socket is created. Of course, we
+	 * must bump the module reference count twice as well before the socket
+	 * is closed.
+	 */
+	module_put(qrtr_ns.sock->ops->owner);
+	module_put(qrtr_ns.sock->sk->sk_prot_creator->owner);
+
 	return 0;
 
 err_wq:
@@ -829,6 +847,15 @@ void qrtr_ns_remove(void)
 {
 	cancel_work_sync(&qrtr_ns.work);
 	destroy_workqueue(qrtr_ns.workqueue);
+
+	/* sock_release() expects the two references that were put during
+	 * qrtr_ns_init(). This function is only called during module remove,
+	 * so try_stop_module() has already set the refcnt to 0. Use
+	 * __module_get() instead of try_module_get() to successfully take two
+	 * references.
+	 */
+	__module_get(qrtr_ns.sock->ops->owner);
+	__module_get(qrtr_ns.sock->sk->sk_prot_creator->owner);
 	sock_release(qrtr_ns.sock);
 }
 EXPORT_SYMBOL_GPL(qrtr_ns_remove);
-- 
2.43.0



