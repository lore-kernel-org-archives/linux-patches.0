Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D793FF1BE;
	Fri, 15 May 2026 15:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860686; cv=none; b=G1QVfcDAeZ4fxWeowo5BYNy+ygEpB1axEmvhD2l/5rTUPHkvMG3z+kMUBKzrJBrujTuyxb2c2l+ZyZ62sT96e+a5a86jGcguPaY+raoPaNJZY3OqREypQLsDPyQMzF7PYssIP+jD0YATd2mOv5c3lENCjjxSAfmUQg7fUHEvHtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860686; c=relaxed/simple;
	bh=YogRWmp5DyaJmzWM7jVI+rdnR44qYZcQkNrMFpMN4yA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MOmlLtLXQL5NChQBICjSwY635DsSLJRbK4oCwIzocCWX6CmrXD43DbJhfRo0PHm9T6fOoxcYXmWOF9hhRiAzma/V4de6qAM8BsN/9g8DyhHSNwvShJ+rdIV1w7uhUdsBhgM5+P4IoBTci6BIHcJIRxSzjdwlMZPVKt83b2TsiRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nZJUwKT3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nZJUwKT3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A50FC2BCB0;
	Fri, 15 May 2026 15:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860686;
	bh=YogRWmp5DyaJmzWM7jVI+rdnR44qYZcQkNrMFpMN4yA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nZJUwKT3zI83gj+5fB6hpDSPh6IjXN/SWngvlqNSMTsMX9Ofud1vmqNKHcjIW6oYp
	 89ogky3uctIock4rkiH0C1p861TAhWgx0LtC6c0rlnuVoaraBYyEBQhIR3ry0VRwJQ
	 lvuttnbUTGke0Yxjt3WGnp2cVxDpiCKmJHQqKB8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 040/474] net: qrtr: ns: Fix use-after-free in driver remove()
Date: Fri, 15 May 2026 17:42:29 +0200
Message-ID: <20260515154715.916866275@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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
@@ -24,6 +24,7 @@ static struct {
 	struct list_head lookups;
 	struct workqueue_struct *workqueue;
 	struct work_struct work;
+	void (*saved_data_ready)(struct sock *sk);
 	int local_node;
 } qrtr_ns;
 
@@ -706,6 +707,7 @@ int qrtr_ns_init(void)
 		goto err_sock;
 	}
 
+	qrtr_ns.saved_data_ready = qrtr_ns.sock->sk->sk_data_ready;
 	qrtr_ns.sock->sk->sk_data_ready = qrtr_ns_data_ready;
 
 	sq.sq_port = QRTR_PORT_CTRL;
@@ -746,6 +748,10 @@ int qrtr_ns_init(void)
 	return 0;
 
 err_wq:
+	write_lock_bh(&qrtr_ns.sock->sk->sk_callback_lock);
+	qrtr_ns.sock->sk->sk_data_ready = qrtr_ns.saved_data_ready;
+	write_unlock_bh(&qrtr_ns.sock->sk->sk_callback_lock);
+
 	destroy_workqueue(qrtr_ns.workqueue);
 err_sock:
 	sock_release(qrtr_ns.sock);
@@ -755,7 +761,12 @@ EXPORT_SYMBOL_GPL(qrtr_ns_init);
 
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


