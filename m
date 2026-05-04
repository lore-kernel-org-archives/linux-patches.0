Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F2829E116;
	Mon,  4 May 2026 14:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904471; cv=none; b=B8/agoejOmhbHvX3W8Lx2l4Y1ONMhtYbzvVbIDtd7jPyo66HAqMm8pWw4d719kelXdOQkGY/+Ke5SvgDN9PqHTA0l037wa63XvbV/+vWb0qiRwBTKA4GEIbJAKNUhzub1a3tUwHuq7hdFqS2+oIJcd8GRwUri4Iom4YOOn6FwfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904471; c=relaxed/simple;
	bh=aHB9+D6mTqnKgTnrBWGhOQS1Jc3/c/0IsvzJSK0t+yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pzfPtmmSEP5L5CWSGkr+PIip2hu7lYt9OcOdAeJH3xc11Z16GKsUJJvGNjArvGbGSgRXrW4kyr4uBmLDL92K+mYk0ndztniQZN+o1/07afwVU4mHgey/LoGxXaUGJNHvOQqpXMHpUGLBqCuYHfGB4C21HQ+5LhA/WqkliPi9Fo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ShcWo06B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ShcWo06B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709FAC2BCB8;
	Mon,  4 May 2026 14:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904470;
	bh=aHB9+D6mTqnKgTnrBWGhOQS1Jc3/c/0IsvzJSK0t+yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ShcWo06BGr0cdRsJyjx7nX+07rD2KCOWu9hSqbMzQarl8a0ZnWFlBk09nGiu89cNW
	 7sSZ+XCAIBd1Lb8bNGGtuHfTZH680NBWanf5vH63UE8Eu3pJfN3e5h+huN8zSguknC
	 WwbfWAAGyE1PDuOrZU5JAYAg6JOtXUKzYGZ8up34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 051/215] net: qrtr: ns: Fix use-after-free in driver remove()
Date: Mon,  4 May 2026 15:51:10 +0200
Message-ID: <20260504135132.041812751@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 
@@ -709,6 +710,7 @@ int qrtr_ns_init(void)
 		goto err_sock;
 	}
 
+	qrtr_ns.saved_data_ready = qrtr_ns.sock->sk->sk_data_ready;
 	qrtr_ns.sock->sk->sk_data_ready = qrtr_ns_data_ready;
 
 	sq.sq_port = QRTR_PORT_CTRL;
@@ -749,6 +751,10 @@ int qrtr_ns_init(void)
 	return 0;
 
 err_wq:
+	write_lock_bh(&qrtr_ns.sock->sk->sk_callback_lock);
+	qrtr_ns.sock->sk->sk_data_ready = qrtr_ns.saved_data_ready;
+	write_unlock_bh(&qrtr_ns.sock->sk->sk_callback_lock);
+
 	destroy_workqueue(qrtr_ns.workqueue);
 err_sock:
 	sock_release(qrtr_ns.sock);
@@ -758,7 +764,12 @@ EXPORT_SYMBOL_GPL(qrtr_ns_init);
 
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


