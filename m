Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B99332919;
	Sat, 30 May 2026 16:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159933; cv=none; b=uf1BCz8eJgAk8hVz1y05Ma3I2DfBBBAxzRLaCoaCrFHQTbykzU1sboqYCnjPfyE99saXiltbDpLtNNcJpC/2GY9BCk3+Ox4KNiMRmgkntW7ns7x1A0+/s5dhkFRXSM8qWGdqoCyd46/QiW9op3vM2feI+W0W5znqmEOr2Rd9Xzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159933; c=relaxed/simple;
	bh=1c65al4uaQsL/pkR7BL+HZMusmqavpFbLlM9VtxJJZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uc4umD1wBXUSyIHibkNCj+POG+ztmc8GX+yZuumWkICrx4ItV3WhrmswRuiBwjlDQvDS8lY51+Nuu6AOFuHBwRKoALvoYhrJJNzPINK42xtlNVfe05kUoWHK1VQ9UZ0q6s2uhNgMyoR/zYu5iMWUhA9fPcYPNoSG+VhUi/dQG0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hWWDmlk1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hWWDmlk1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE20C1F00893;
	Sat, 30 May 2026 16:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159932;
	bh=eBP9bXrTtGWK4/eBoKijz1yMhf3hsc4XZqQmIajA2J0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hWWDmlk1jFc/IWFDd2Htd/NEiwiUarMFOCGwoZgLSf/YbYqyqpJNvtA7DlLlphNIU
	 O/PZJDlL9EgYXVeRlICHzecV6fr/aFmow5VbvGFNY2U6aW4wucxsNT/mUTxRsefcsj
	 UcgAhwFwf92h/3sRVKiH+TfNyB1RizmEq+XOkMpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 192/969] net: qrtr: ns: Fix use-after-free in driver remove()
Date: Sat, 30 May 2026 17:55:16 +0200
Message-ID: <20260530160305.778462636@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

commit 7809fea20c9404bfcfa6112ec08d1fe1d3520beb upstream.

In the remove callback, if a packet arrives after destroy_workqueue() is
called, but before sock_release(), the qrtr_ns_data_ready() callback will
try to queue the work, causing use-after-free issue.

Fix this issue by saving the default 'sk_data_ready' callback during
qrtr_ns_init() and use it to replace the qrtr_ns_data_ready() callback at
the start of remove(). This ensures that even if a packet arrives after
destroy_workqueue(), the work struct will not be dereferenced.

Note that it is also required to ensure that the RX threads are completed
before destroying the workqueue, because the threads could be using the
qrtr_ns_data_ready() callback.

Cc: stable@vger.kernel.org
Fixes: 0c2204a4ad71 ("net: qrtr: Migrate nameservice to kernel from userspace")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260409-qrtr-fix-v3-5-00a8a5ff2b51@oss.qualcomm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/qrtr/ns.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -23,6 +23,7 @@ static struct {
 	struct list_head lookups;
 	struct workqueue_struct *workqueue;
 	struct work_struct work;
+	void (*saved_data_ready)(struct sock *sk);
 	int local_node;
 } qrtr_ns;
 
@@ -788,6 +789,7 @@ int qrtr_ns_init(void)
 		goto err_sock;
 	}
 
+	qrtr_ns.saved_data_ready = qrtr_ns.sock->sk->sk_data_ready;
 	qrtr_ns.sock->sk->sk_data_ready = qrtr_ns_data_ready;
 
 	sq.sq_port = QRTR_PORT_CTRL;
@@ -828,6 +830,10 @@ int qrtr_ns_init(void)
 	return 0;
 
 err_wq:
+	write_lock_bh(&qrtr_ns.sock->sk->sk_callback_lock);
+	qrtr_ns.sock->sk->sk_data_ready = qrtr_ns.saved_data_ready;
+	write_unlock_bh(&qrtr_ns.sock->sk->sk_callback_lock);
+
 	destroy_workqueue(qrtr_ns.workqueue);
 err_sock:
 	sock_release(qrtr_ns.sock);
@@ -837,7 +843,12 @@ EXPORT_SYMBOL_GPL(qrtr_ns_init);
 
 void qrtr_ns_remove(void)
 {
+	write_lock_bh(&qrtr_ns.sock->sk->sk_callback_lock);
+	qrtr_ns.sock->sk->sk_data_ready = qrtr_ns.saved_data_ready;
+	write_unlock_bh(&qrtr_ns.sock->sk->sk_callback_lock);
+
 	cancel_work_sync(&qrtr_ns.work);
+	synchronize_net();
 	destroy_workqueue(qrtr_ns.workqueue);
 
 	/* sock_release() expects the two references that were put during


