Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7566B345741;
	Sat, 30 May 2026 17:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163263; cv=none; b=IGYbkJ/mN7oBD3tbAbgamJpEwQrnTUQLlp4qS/Qe9IIZBbVEnpGwrqxOnn1OZSCKF/ksub4HZeWjNLOdn/TVHArubRL4UYa0RF05qzO0M+2nARMUEUm/y5uCpwHPyO21EkB7FIc1Wxjq3gjsHf4RgSvi5FdyIN2JUqPo+iIhFMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163263; c=relaxed/simple;
	bh=aGpUzM44TJ7MeMHUEcZWZt58wV6F9e28ORdyCKh4kvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QBOJ52e3+HTasTDqIPNVkqWEje4m+6/3jbHG/JRniB3v9A9WsZymOpfGf1583ElYv8KBeb13OpnOz2RySsC+6KHFUQo7Z2+qnMtwYJZ7S+aG+qrMzWGRsWSg2Q3UoGLXFd/OLxoBMLYazMts8mXuKcY+dJLaTrGNhErgc+uIsOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XFkB+uI1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XFkB+uI1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0A01F00893;
	Sat, 30 May 2026 17:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163262;
	bh=aMxayEiGrNQru/d+0HgXaYo913Ub9T/MTO3aB+mjQZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XFkB+uI1issn3LmQMq8KXoAU39Os4G2CVHx2PJRpuc6Yr2X7FcT4nslKr/6lXpVxM
	 FLvHRkssrmydXJgoN3O7MTQETgIk0XLi5KygyEaXHemVxZMp3p06s3VHlGaoqIYdSP
	 KCzDWbqaowaciG+esPIM6wdVRjEQ4FeNAswpFfe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 206/776] net: qrtr: ns: Fix use-after-free in driver remove()
Date: Sat, 30 May 2026 17:58:40 +0200
Message-ID: <20260530160245.834580416@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


