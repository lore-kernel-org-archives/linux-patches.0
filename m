Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3E843ACE
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dLezU1kS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 884F2C4E664;
	Wed, 15 Nov 2023 20:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081444;
	bh=2nvLBgJmhv4GlQpD3mKuc4tYTdBQIG8k4jawe2CPpG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dLezU1kS/iYMcelzz9LXQIMjQclrzYlzbOeIrcsswsAH8hEQrr2EFXgMLck/vZVer
	 OKP5Eix0rc4TDVWj7G7aX2zKVvyb4iOYgwUeXND3MrgsTyLWSW8GZ+TPMIJKaBjyk3
	 BpY7DwIcSvk4yy4168I+7ZHVkP3ZT9VC7W6Ay8XI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 157/244] crypto: qat - fix deadlock in backlog processing
Date: Wed, 15 Nov 2023 15:35:49 -0500
Message-ID: <20231115203557.765945503@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115203548.387164783@linuxfoundation.org>
References: <20231115203548.387164783@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit 203b01001c4d741205b9c329acddc5193ed56fbd ]

If a request has the flag CRYPTO_TFM_REQ_MAY_BACKLOG set, the function
qat_alg_send_message_maybacklog(), enqueues it in a backlog list if
either (1) there is already at least one request in the backlog list, or
(2) the HW ring is nearly full or (3) the enqueue to the HW ring fails.
If an interrupt occurs right before the lock in qat_alg_backlog_req() is
taken and the backlog queue is being emptied, then there is no request
in the HW queues that can trigger a subsequent interrupt that can clear
the backlog queue. In addition subsequent requests are enqueued to the
backlog list and not sent to the hardware.

Fix it by holding the lock while taking the decision if the request
needs to be included in the backlog queue or not. This synchronizes the
flow with the interrupt handler that drains the backlog queue.

For performance reasons, the logic has been changed to try to enqueue
first without holding the lock.

Fixes: 386823839732 ("crypto: qat - add backlog mechanism")
Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Closes: https://lore.kernel.org/all/af9581e2-58f9-cc19-428f-6f18f1f83d54@redhat.com/T/
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/qat_algs_send.c | 46 ++++++++++---------
 1 file changed, 25 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs_send.c b/drivers/crypto/qat/qat_common/qat_algs_send.c
index ff5b4347f7831..607ed88f4b197 100644
--- a/drivers/crypto/qat/qat_common/qat_algs_send.c
+++ b/drivers/crypto/qat/qat_common/qat_algs_send.c
@@ -39,40 +39,44 @@ void qat_alg_send_backlog(struct qat_instance_backlog *backlog)
 	spin_unlock_bh(&backlog->lock);
 }
 
-static void qat_alg_backlog_req(struct qat_alg_req *req,
-				struct qat_instance_backlog *backlog)
-{
-	INIT_LIST_HEAD(&req->list);
-
-	spin_lock_bh(&backlog->lock);
-	list_add_tail(&req->list, &backlog->list);
-	spin_unlock_bh(&backlog->lock);
-}
-
-static int qat_alg_send_message_maybacklog(struct qat_alg_req *req)
+static bool qat_alg_try_enqueue(struct qat_alg_req *req)
 {
 	struct qat_instance_backlog *backlog = req->backlog;
 	struct adf_etr_ring_data *tx_ring = req->tx_ring;
 	u32 *fw_req = req->fw_req;
 
-	/* If any request is already backlogged, then add to backlog list */
+	/* Check if any request is already backlogged */
 	if (!list_empty(&backlog->list))
-		goto enqueue;
+		return false;
 
-	/* If ring is nearly full, then add to backlog list */
+	/* Check if ring is nearly full */
 	if (adf_ring_nearly_full(tx_ring))
-		goto enqueue;
+		return false;
 
-	/* If adding request to HW ring fails, then add to backlog list */
+	/* Try to enqueue to HW ring */
 	if (adf_send_message(tx_ring, fw_req))
-		goto enqueue;
+		return false;
 
-	return -EINPROGRESS;
+	return true;
+}
 
-enqueue:
-	qat_alg_backlog_req(req, backlog);
 
-	return -EBUSY;
+static int qat_alg_send_message_maybacklog(struct qat_alg_req *req)
+{
+	struct qat_instance_backlog *backlog = req->backlog;
+	int ret = -EINPROGRESS;
+
+	if (qat_alg_try_enqueue(req))
+		return ret;
+
+	spin_lock_bh(&backlog->lock);
+	if (!qat_alg_try_enqueue(req)) {
+		list_add_tail(&req->list, &backlog->list);
+		ret = -EBUSY;
+	}
+	spin_unlock_bh(&backlog->lock);
+
+	return ret;
 }
 
 int qat_alg_send_message(struct qat_alg_req *req)
-- 
2.42.0



