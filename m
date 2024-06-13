Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02261448E4;
	Thu, 13 Jun 2024 12:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281092; cv=none; b=Za8yApJFiGQ8uIRKKdpGZlJAxyus/fRVIpWERkScZ7oKU5iXDd3O//Igm7t31HGf/F3MCXJIL3xMrXsACAwpPWdJ2AeHRkkDzTgOTK6W2kC2jY298ApiFC+OmL4i9IOqGTY1EJA0LwBeMzy65emfBI2TpOY5eNlspd+DdsNQtyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281092; c=relaxed/simple;
	bh=3gpZR1/pNCFTb73XeL4b+cGjydice9JV0ob8cOJJbSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NSp0Ho5xatSuNkBYTTHQeoDHtz1+YMPJN8zBM9A+F2DQjxPunHUHTSI4GNg/2b7JsoyT0RdD1ZclH/EPXbtE+oPCAGLgQmfqmCt3eR316fNnJLxepWkDDpj++rNvTfj/m0IZguaF/HUn5C9VEHF7ahxSwcSbgT7uoO7UmEgLk50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hNy1T4bh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hNy1T4bh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D50C2BBFC;
	Thu, 13 Jun 2024 12:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281092;
	bh=3gpZR1/pNCFTb73XeL4b+cGjydice9JV0ob8cOJJbSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hNy1T4bh/TStiYSRNumGk1E7Y1u7gXQrD32T+rrekP+4wRxu7P3sKGg44fCUAal0l
	 P3Zl4GUFqt3SLJVCltEevib+G4b6kBdZ6Ys2hppsOY4AsQIV/V2Ty7Tc8V4Lsat0Pj
	 YpKxq+9q2xVMCXcjmUvmdRiYY51Jjvu0pmw7x7Zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hulk Robot <hulkci@huawei.com>,
	Qinglang Miao <miaoqinglang@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 130/317] net: qrtr: fix null-ptr-deref in qrtr_ns_remove
Date: Thu, 13 Jun 2024 13:32:28 +0200
Message-ID: <20240613113252.587909639@linuxfoundation.org>
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

From: Qinglang Miao <miaoqinglang@huawei.com>

[ Upstream commit 4beb17e553b49c3dd74505c9f361e756aaae653e ]

A null-ptr-deref bug is reported by Hulk Robot like this:
--------------
KASAN: null-ptr-deref in range [0x0000000000000128-0x000000000000012f]
Call Trace:
qrtr_ns_remove+0x22/0x40 [ns]
qrtr_proto_fini+0xa/0x31 [qrtr]
__x64_sys_delete_module+0x337/0x4e0
do_syscall_64+0x34/0x80
entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x468ded
--------------

When qrtr_ns_init fails in qrtr_proto_init, qrtr_ns_remove which would
be called later on would raise a null-ptr-deref because qrtr_ns.workqueue
has been destroyed.

Fix it by making qrtr_ns_init have a return value and adding a check in
qrtr_proto_init.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: fd76e5ccc48f ("net: qrtr: ns: Fix module refcnt")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/qrtr/af_qrtr.c | 16 +++++++++++-----
 net/qrtr/ns.c      |  7 ++++---
 net/qrtr/qrtr.h    |  2 +-
 3 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/net/qrtr/af_qrtr.c b/net/qrtr/af_qrtr.c
index 71c2295d4a573..29c0886eb9efe 100644
--- a/net/qrtr/af_qrtr.c
+++ b/net/qrtr/af_qrtr.c
@@ -1279,13 +1279,19 @@ static int __init qrtr_proto_init(void)
 		return rc;
 
 	rc = sock_register(&qrtr_family);
-	if (rc) {
-		proto_unregister(&qrtr_proto);
-		return rc;
-	}
+	if (rc)
+		goto err_proto;
 
-	qrtr_ns_init();
+	rc = qrtr_ns_init();
+	if (rc)
+		goto err_sock;
 
+	return 0;
+
+err_sock:
+	sock_unregister(qrtr_family.family);
+err_proto:
+	proto_unregister(&qrtr_proto);
 	return rc;
 }
 postcore_initcall(qrtr_proto_init);
diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
index c92dd960bfefa..3376a656da39f 100644
--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -771,7 +771,7 @@ static void qrtr_ns_data_ready(struct sock *sk)
 	queue_work(qrtr_ns.workqueue, &qrtr_ns.work);
 }
 
-void qrtr_ns_init(void)
+int qrtr_ns_init(void)
 {
 	struct sockaddr_qrtr sq;
 	int ret;
@@ -782,7 +782,7 @@ void qrtr_ns_init(void)
 	ret = sock_create_kern(&init_net, AF_QIPCRTR, SOCK_DGRAM,
 			       PF_QIPCRTR, &qrtr_ns.sock);
 	if (ret < 0)
-		return;
+		return ret;
 
 	ret = kernel_getsockname(qrtr_ns.sock, (struct sockaddr *)&sq);
 	if (ret < 0) {
@@ -815,12 +815,13 @@ void qrtr_ns_init(void)
 	if (ret < 0)
 		goto err_wq;
 
-	return;
+	return 0;
 
 err_wq:
 	destroy_workqueue(qrtr_ns.workqueue);
 err_sock:
 	sock_release(qrtr_ns.sock);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(qrtr_ns_init);
 
diff --git a/net/qrtr/qrtr.h b/net/qrtr/qrtr.h
index dc2b67f179271..3f2d28696062a 100644
--- a/net/qrtr/qrtr.h
+++ b/net/qrtr/qrtr.h
@@ -29,7 +29,7 @@ void qrtr_endpoint_unregister(struct qrtr_endpoint *ep);
 
 int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len);
 
-void qrtr_ns_init(void);
+int qrtr_ns_init(void);
 
 void qrtr_ns_remove(void);
 
-- 
2.43.0



