Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622495;
	b=iMu/DLyNnXpThtC4E6cWP0STYIPuj6v3LeTjpUrBPSmwg2CeLJnPbgrNUGyIZVX/6H29
	 rKggNEK73yXEQwDt796G4fZZxq0Scc33yxDe3mAb6MnE/t4AJfg8hMXQ579jL2zcM40rN
	 Ev7E3nnFE+qTiQKl6RPIrb1XYj0EEGvVYorwVVAUkBiBu3CNMSrE5ZYdU7Vo8hNefwJzO
	 t+wuyvHIAmA+FgSN9X12P2yBVAI1T30FYv9i2qXAHcpvBeN1riV36hTfhNRtjrr/QEAZW
	 8cfc4USCs+9h76HVikbiZmcLkolNBToxyOSgNG4QqaQoTYH8b9BOSXWQMNAeP4hiUPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622495;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q47xo1jZne7RoB9Tnfs3Pfw8Koq1kOCSQBz73U7salA=;
	b=WGamvmF4wAJmM+JmqSWHuZgstDMUuY5TDjVVNM9WTLDuQXFVAaU2rh+sw7JvYuOFg7Vw
	 iuvoGc1xgpLdFzT/6syfMv+DKbeozekKnQua8UfRFk/xGMlbrDmt10asoyYV4vs9kOsku
	 9kmGAUl9//tQ4JDhhsJ0t+/p9SGYGlPOBkrTPTRpiDlh/z6YsowJnb5Qo22s9aJKXxhIs
	 U83rYk5I7nFVKm5Kqi1WzOI5Gn33j1a0sDpRxZMawZG+VlSVy5jz8xG8MdQQEzvXA1h4i
	 Y49ifNjdyKk2GhH1WEmQNjE9PJOWGjO8wwvYUn8KCC4ZQW2Cq6msFtZAMj+aEPEI+2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gsFvJQkb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7423606A327;
	Wed, 25 Nov 2026 16:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gsFvJQkb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A041F000D1;
	Wed, 25 Nov 2026 16:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622495;
	bh=Q47xo1jZne7RoB9Tnfs3Pfw8Koq1kOCSQBz73U7salA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gsFvJQkbs0LdoHt28qdo6LezuvaGOmvXF9Tc9TQ1W6eWzFMbKTli+AOK/UNYVtDgK
	 Ci/TIY89HwgbiFC8//BtSKg15muVROW2T8lJhOP9F9zxDowb58mXxNcJvFH51q5Hjk
	 nfexBDWv7TY+rfeyhqPNV7dP8aZTWj4RgM8qb8P0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 557/990] RDMA/bnxt_re: Serialize dcb_wq access against async notifier
Date: Wed, 25 Nov 2026 15:32:04 +0100
Message-ID: <20261125143835.143902929@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 81caf9240dfb082c0eb2b24feef8266268fd152f ]

bnxt_re_async_notifier() runs in NAPI/softirq context via bnxt_en's
RCU-protected ULP ops dispatch, never under rtnl_lock, so it isn't
serialized against bnxt_re_uninit_dcb_wq() destroying rdev->dcb_wq.
A concurrent notifier call can queue_work() on a workqueue that is
being, or has just been, destroyed.

Add a spinlock scoped to dcb_wq: the notifier takes it before
checking dcb_wq and queuing work, and bnxt_re_uninit_dcb_wq() takes
it to atomically clear dcb_wq before destroying it. Initialize the
lock at rdev allocation so it is valid on every teardown path,
including bnxt_re_dev_init()'s early failure labels.

Fixes: 51dc5312dcd9 ("RDMA/bnxt_re: Add support to handle DCB_CONFIG_CHANGE event")
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
[ sashal: Used the branch's kzalloc(sizeof(*dcb_work), GFP_ATOMIC) in place of upstream's kzalloc_obj(*dcb_work, GFP_ATOMIC) in the DCB_CONFIG_CHANGE notifier, to fit the surrounding code. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/bnxt_re.h |  4 ++++
 drivers/infiniband/hw/bnxt_re/main.c    | 24 ++++++++++++++++++++----
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/bnxt_re.h b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
index 3485e495ac6aa..ce3a1fd8aa830 100644
--- a/drivers/infiniband/hw/bnxt_re/bnxt_re.h
+++ b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
@@ -222,6 +222,10 @@ struct bnxt_re_dev {
 	unsigned long			event_bitmap;
 	struct bnxt_qplib_cc_param	cc_param;
 	struct workqueue_struct		*dcb_wq;
+	/* Protects dcb_wq against bnxt_re_uninit_dcb_wq() destroying it
+	 * concurrently with bnxt_re_async_notifier() queuing work on it.
+	 */
+	spinlock_t			dcb_lock;
 	struct dentry                   *cc_config;
 	struct bnxt_re_dbg_cc_config_params *cc_config_params;
 #define BNXT_VPD_FLD_LEN		32
diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index e8a4befd6ca01..690b261b581a5 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -367,9 +367,15 @@ static int bnxt_re_init_dcb_wq(struct bnxt_re_dev *rdev)
 
 static void bnxt_re_uninit_dcb_wq(struct bnxt_re_dev *rdev)
 {
-	if (!rdev->dcb_wq)
-		return;
-	destroy_workqueue(rdev->dcb_wq);
+	struct workqueue_struct *dcb_wq;
+
+	spin_lock_bh(&rdev->dcb_lock);
+	dcb_wq = rdev->dcb_wq;
+	rdev->dcb_wq = NULL;
+	spin_unlock_bh(&rdev->dcb_lock);
+
+	if (dcb_wq)
+		destroy_workqueue(dcb_wq);
 }
 
 static void bnxt_re_dcb_wq_task(struct work_struct *work)
@@ -424,14 +430,23 @@ static void bnxt_re_async_notifier(void *handle, struct hwrm_async_event_cmpl *c
 
 	switch (event_id) {
 	case ASYNC_EVENT_CMPL_EVENT_ID_DCB_CONFIG_CHANGE:
+		spin_lock(&rdev->dcb_lock);
+		if (!rdev->dcb_wq) {
+			spin_unlock(&rdev->dcb_lock);
+			break;
+		}
+
 		dcb_work = kzalloc(sizeof(*dcb_work), GFP_ATOMIC);
-		if (!dcb_work)
+		if (!dcb_work) {
+			spin_unlock(&rdev->dcb_lock);
 			break;
+		}
 
 		dcb_work->rdev = rdev;
 		memcpy(&dcb_work->cmpl, cmpl, sizeof(*cmpl));
 		INIT_WORK(&dcb_work->work, bnxt_re_dcb_wq_task);
 		queue_work(rdev->dcb_wq, &dcb_work->work);
+		spin_unlock(&rdev->dcb_lock);
 		break;
 	default:
 		break;
@@ -1446,6 +1461,7 @@ static struct bnxt_re_dev *bnxt_re_dev_add(struct auxiliary_device *adev,
 	INIT_LIST_HEAD(&rdev->qp_list);
 	mutex_init(&rdev->qp_lock);
 	mutex_init(&rdev->pacing.dbq_lock);
+	spin_lock_init(&rdev->dcb_lock);
 	atomic_set(&rdev->stats.res.qp_count, 0);
 	atomic_set(&rdev->stats.res.cq_count, 0);
 	atomic_set(&rdev->stats.res.srq_count, 0);
-- 
2.53.0



