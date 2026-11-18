Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017797;
	b=CKFuM04P7X9PvcKshE8KskiKmIZWBdeNWqFKEo30sC/+BsJNjfMpww7aSU60JG36FcfZ
	 bKPfCjU4+6eerdYomDkJvTAZzktZKLea+mnnHZbAdOJKfl9Z0f48NlIj1EYktTTnkUD+2
	 xLHlvNLWftsJQJsCG+OR0K0uKbZ0iisXGkX99Dtb0ag54wLPqQh1g6eC56J8qKLIQ3jBb
	 nUY8+kvd+y4smDNkH5W34W67NbVIKJ6uyRzsqvuf9pgVwBn8CvTAp5+V1gdZn9EJjRrI9
	 6RXOjEMGekWvEv1s1QJOH4tx6aavkXTEPSzp2eyRee6TFgx7uBW65aePn7H2MmtJ2Hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017797;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SP654UOOtzwdxjUeQxudvD3exJ+4xmjzVlcNWStLJAs=;
	b=aOYU1BLd6NVmwP19uk4UvI4g7Ypg9poUYj/1EEbkmrzV5+xEsKJYbFmeGhB6AW8/D4km
	 VztaB7PXhNTwggB4m/pJI0syXP2wxaTCmHskbef2j9ZSM4gh9+c1a+dFEFFpZKYc1iALV
	 N9uetKc64079uNkC2S1FunN/u1u6CaGCsK2Sm0rq/19d8V5C7frOpvfUpZaswihHS4Yox
	 r1+SCizk/GwJKYGHlSE8OMMGbu6JtilyJEHrcRDeFPpDZuhui2JgJR89JOdNyLqleeDp3
	 a7w+07xFvKjS3UzrH9RJYyk7DA9IpfIfn8Rk501T5Jlj6+RRUMnhuQcyXutnkDe0wcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HUyMx8bP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FAA8606A31C;
	Wed, 18 Nov 2026 16:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HUyMx8bP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DDB61F000C4;
	Wed, 18 Nov 2026 16:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017797;
	bh=SP654UOOtzwdxjUeQxudvD3exJ+4xmjzVlcNWStLJAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HUyMx8bPhAvyBfekYIHIOdgffRJzDIqSNN6Sh2AiFYEIuNz+HZm24yOnqGv0COeJH
	 5IHvM0Yt5KkaCNyn49DZcv75x5h8XXpooosFr/06voU+bOEVbThrwHRbJSHCDI+zZe
	 Vb9CYv3B4HWpFIBBcCgU/llswVGyG0l6s/E6I3gE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1013/2651] RDMA/bnxt_re: Serialize dcb_wq access against async notifier
Date: Wed, 18 Nov 2026 15:37:33 +0100
Message-ID: <20261118150324.392438949@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/bnxt_re.h |  4 ++++
 drivers/infiniband/hw/bnxt_re/main.c    | 24 ++++++++++++++++++++----
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/bnxt_re.h b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
index a43e678151d3b..da471c63a3ba1 100644
--- a/drivers/infiniband/hw/bnxt_re/bnxt_re.h
+++ b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
@@ -216,6 +216,10 @@ struct bnxt_re_dev {
 	unsigned long			event_bitmap;
 	struct bnxt_qplib_cc_param	cc_param;
 	struct workqueue_struct		*dcb_wq;
+	/* Protects dcb_wq against bnxt_re_uninit_dcb_wq() destroying it
+	 * concurrently with bnxt_re_async_notifier() queuing work on it.
+	 */
+	spinlock_t			dcb_lock;
 	struct dentry                   *cc_config;
 	struct bnxt_re_dbg_cc_config_params *cc_config_params;
 	struct dentry			*cq_coal_cfg;
diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 17654a9e23fed..fa0e1323a3266 100644
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
 		dcb_work = kzalloc_obj(*dcb_work, GFP_ATOMIC);
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
@@ -1448,6 +1463,7 @@ static struct bnxt_re_dev *bnxt_re_dev_add(struct auxiliary_device *adev,
 	INIT_LIST_HEAD(&rdev->qp_list);
 	mutex_init(&rdev->qp_lock);
 	mutex_init(&rdev->pacing.dbq_lock);
+	spin_lock_init(&rdev->dcb_lock);
 	atomic_set(&rdev->stats.res.qp_count, 0);
 	atomic_set(&rdev->stats.res.cq_count, 0);
 	atomic_set(&rdev->stats.res.srq_count, 0);
-- 
2.53.0



