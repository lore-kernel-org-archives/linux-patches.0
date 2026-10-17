Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C5A314B8F;
	Sat, 17 Oct 2026 16:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254542; cv=none; b=FQbp4qzjy9wAQh4MK4S9Csi/hEIRl9V+vrW4rHwXfxctYVavnsGyQi3SY0PIE1L9KwEtkDGrWZH8RPGXbK5A/pLGLPiZkHTSVsiMJNz4tHq0I+E4LOdOpEaNTrNKxvg8CWitWsb02fMBtZX6cbdk7MAfhtif4IsB7I75EhGqy5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254542; c=relaxed/simple;
	bh=F1PYJGUAsP8JYvmsnemO7J6/sLwA/9OBYx7e8Obye1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jLGj1zuxRvpcnHYaJGxkShr+DbW6bWanhBCzr82Xag29grHgoasyk4m4zwiaJeXN0Lj7ev6aJ69ofgyaohYbrxPL83vTz1cYbXeAaKl5uU7mLIVVEfC5zE2XjVVApCcM7Fq2pi8uLms0Qx9vtsj7X0h4EIoVQuhM85u031ktQLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2OWHeyoQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2OWHeyoQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13EAE1F000C4;
	Sat, 17 Oct 2026 16:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254540;
	bh=sYlhn+wSTbGWEapS5kJm66ajTgtojLobvq2phssUVTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2OWHeyoQsNtBI52ukaiU7rysskVR0U6AvXeSbg87me2eFTqjSwXlZhjYgpvBQOget
	 mTmlBhZ9mpJ12L63IeLE6NIK6sfdzS0XJH3ce9Ki08tSOXL5y4KHOc+kEN687fWQWS
	 UhgWbzrsKazZPPoSBF5fhvptNtsmiM8mpW7CbXig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 482/869] s390/ap: Move response_type struct into ap_msg struct
Date: Sat, 17 Oct 2026 17:55:23 +0200
Message-ID: <20261017160049.477721547@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Harald Freudenberger <freude@linux.ibm.com>

[ Upstream commit 43435495a0f4e3a08792835285901b01e6d5b6da ]

Move the very small response_type struct into struct ap_msg.
So there is no need to kmalloc this tiny struct with each
ap message preparation.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Link: https://lore.kernel.org/r/20250424133619.16495-2-freude@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: e935cd525af4 ("s390/zcrypt: Close speculative mem read possibility")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/ap_bus.h           |  8 ++-
 drivers/s390/crypto/zcrypt_msgtype50.c | 16 ++----
 drivers/s390/crypto/zcrypt_msgtype6.c  | 74 +++++++++-----------------
 3 files changed, 37 insertions(+), 61 deletions(-)

diff --git a/drivers/s390/crypto/ap_bus.h b/drivers/s390/crypto/ap_bus.h
index 6111913c858c0..deef76c06f9a9 100644
--- a/drivers/s390/crypto/ap_bus.h
+++ b/drivers/s390/crypto/ap_bus.h
@@ -214,6 +214,11 @@ struct ap_queue {
 
 typedef enum ap_sm_wait (ap_func_t)(struct ap_queue *queue);
 
+struct ap_response_type {
+	struct completion work;
+	int type;
+};
+
 struct ap_message {
 	struct list_head list;		/* Request queueing. */
 	unsigned long psmid;		/* Message id. */
@@ -222,7 +227,7 @@ struct ap_message {
 	size_t bufsize;			/* allocated msg buffer size */
 	u16 flags;			/* Flags, see AP_MSG_FLAG_xxx */
 	int rc;				/* Return code for this message */
-	void *private;			/* ap driver private pointer. */
+	struct ap_response_type response;
 	/* receive is called from tasklet context */
 	void (*receive)(struct ap_queue *, struct ap_message *,
 			struct ap_message *);
@@ -250,7 +255,6 @@ static inline void ap_init_message(struct ap_message *ap_msg)
 static inline void ap_release_message(struct ap_message *ap_msg)
 {
 	kfree_sensitive(ap_msg->msg);
-	kfree_sensitive(ap_msg->private);
 }
 
 enum ap_sm_wait ap_sm_event(struct ap_queue *aq, enum ap_sm_event event);
diff --git a/drivers/s390/crypto/zcrypt_msgtype50.c b/drivers/s390/crypto/zcrypt_msgtype50.c
index adc65eddaa1e3..47c401f5409b3 100644
--- a/drivers/s390/crypto/zcrypt_msgtype50.c
+++ b/drivers/s390/crypto/zcrypt_msgtype50.c
@@ -438,7 +438,7 @@ static void zcrypt_msgtype50_receive(struct ap_queue *aq,
 		msg->len = sizeof(error_reply);
 	}
 out:
-	complete((struct completion *)msg->private);
+	complete(&msg->response.work);
 }
 
 static atomic_t zcrypt_step = ATOMIC_INIT(0);
@@ -454,7 +454,6 @@ static long zcrypt_msgtype50_modexpo(struct zcrypt_queue *zq,
 				     struct ica_rsa_modexpo *mex,
 				     struct ap_message *ap_msg)
 {
-	struct completion work;
 	int rc;
 
 	ap_msg->bufsize = MSGTYPE50_CRB3_MAX_MSG_SIZE;
@@ -464,15 +463,14 @@ static long zcrypt_msgtype50_modexpo(struct zcrypt_queue *zq,
 	ap_msg->receive = zcrypt_msgtype50_receive;
 	ap_msg->psmid = (((unsigned long)current->pid) << 32) +
 		atomic_inc_return(&zcrypt_step);
-	ap_msg->private = &work;
 	rc = ICAMEX_msg_to_type50MEX_msg(zq, ap_msg, mex);
 	if (rc)
 		goto out;
-	init_completion(&work);
+	init_completion(&ap_msg->response.work);
 	rc = ap_queue_message(zq->queue, ap_msg);
 	if (rc)
 		goto out;
-	rc = wait_for_completion_interruptible(&work);
+	rc = wait_for_completion_interruptible(&ap_msg->response.work);
 	if (rc == 0) {
 		rc = ap_msg->rc;
 		if (rc == 0)
@@ -485,7 +483,6 @@ static long zcrypt_msgtype50_modexpo(struct zcrypt_queue *zq,
 	}
 
 out:
-	ap_msg->private = NULL;
 	if (rc)
 		pr_debug("send me cprb at dev=%02x.%04x rc=%d\n",
 			 AP_QID_CARD(zq->queue->qid),
@@ -504,7 +501,6 @@ static long zcrypt_msgtype50_modexpo_crt(struct zcrypt_queue *zq,
 					 struct ica_rsa_modexpo_crt *crt,
 					 struct ap_message *ap_msg)
 {
-	struct completion work;
 	int rc;
 
 	ap_msg->bufsize = MSGTYPE50_CRB3_MAX_MSG_SIZE;
@@ -514,15 +510,14 @@ static long zcrypt_msgtype50_modexpo_crt(struct zcrypt_queue *zq,
 	ap_msg->receive = zcrypt_msgtype50_receive;
 	ap_msg->psmid = (((unsigned long)current->pid) << 32) +
 		atomic_inc_return(&zcrypt_step);
-	ap_msg->private = &work;
 	rc = ICACRT_msg_to_type50CRT_msg(zq, ap_msg, crt);
 	if (rc)
 		goto out;
-	init_completion(&work);
+	init_completion(&ap_msg->response.work);
 	rc = ap_queue_message(zq->queue, ap_msg);
 	if (rc)
 		goto out;
-	rc = wait_for_completion_interruptible(&work);
+	rc = wait_for_completion_interruptible(&ap_msg->response.work);
 	if (rc == 0) {
 		rc = ap_msg->rc;
 		if (rc == 0)
@@ -535,7 +530,6 @@ static long zcrypt_msgtype50_modexpo_crt(struct zcrypt_queue *zq,
 	}
 
 out:
-	ap_msg->private = NULL;
 	if (rc)
 		pr_debug("send crt cprb at dev=%02x.%04x rc=%d\n",
 			 AP_QID_CARD(zq->queue->qid),
diff --git a/drivers/s390/crypto/zcrypt_msgtype6.c b/drivers/s390/crypto/zcrypt_msgtype6.c
index b64c9d9fc6137..09ef91af1e2af 100644
--- a/drivers/s390/crypto/zcrypt_msgtype6.c
+++ b/drivers/s390/crypto/zcrypt_msgtype6.c
@@ -31,11 +31,6 @@
 
 #define CEIL4(x) ((((x) + 3) / 4) * 4)
 
-struct response_type {
-	struct completion work;
-	int type;
-};
-
 #define CEXXC_RESPONSE_TYPE_ICA  0
 #define CEXXC_RESPONSE_TYPE_XCRB 1
 #define CEXXC_RESPONSE_TYPE_EP11 2
@@ -856,7 +851,7 @@ static void zcrypt_msgtype6_receive(struct ap_queue *aq,
 		.type = TYPE82_RSP_CODE,
 		.reply_code = REP82_ERROR_MACHINE_FAILURE,
 	};
-	struct response_type *resp_type = msg->private;
+	struct ap_response_type *resp_type = &msg->response;
 	struct type86x_reply *t86r;
 	int len;
 
@@ -920,7 +915,7 @@ static void zcrypt_msgtype6_receive_ep11(struct ap_queue *aq,
 		.type = TYPE82_RSP_CODE,
 		.reply_code = REP82_ERROR_MACHINE_FAILURE,
 	};
-	struct response_type *resp_type = msg->private;
+	struct ap_response_type *resp_type = &msg->response;
 	struct type86_ep11_reply *t86r;
 	int len;
 
@@ -967,9 +962,7 @@ static long zcrypt_msgtype6_modexpo(struct zcrypt_queue *zq,
 				    struct ica_rsa_modexpo *mex,
 				    struct ap_message *ap_msg)
 {
-	struct response_type resp_type = {
-		.type = CEXXC_RESPONSE_TYPE_ICA,
-	};
+	struct ap_response_type *resp_type = &ap_msg->response;
 	int rc;
 
 	ap_msg->msg = (void *)get_zeroed_page(GFP_KERNEL);
@@ -979,15 +972,15 @@ static long zcrypt_msgtype6_modexpo(struct zcrypt_queue *zq,
 	ap_msg->receive = zcrypt_msgtype6_receive;
 	ap_msg->psmid = (((unsigned long)current->pid) << 32) +
 		atomic_inc_return(&zcrypt_step);
-	ap_msg->private = &resp_type;
 	rc = icamex_msg_to_type6mex_msgx(zq, ap_msg, mex);
 	if (rc)
 		goto out_free;
-	init_completion(&resp_type.work);
+	resp_type->type = CEXXC_RESPONSE_TYPE_ICA;
+	init_completion(&resp_type->work);
 	rc = ap_queue_message(zq->queue, ap_msg);
 	if (rc)
 		goto out_free;
-	rc = wait_for_completion_interruptible(&resp_type.work);
+	rc = wait_for_completion_interruptible(&resp_type->work);
 	if (rc == 0) {
 		rc = ap_msg->rc;
 		if (rc == 0)
@@ -1001,7 +994,6 @@ static long zcrypt_msgtype6_modexpo(struct zcrypt_queue *zq,
 
 out_free:
 	free_page((unsigned long)ap_msg->msg);
-	ap_msg->private = NULL;
 	ap_msg->msg = NULL;
 	return rc;
 }
@@ -1017,9 +1009,7 @@ static long zcrypt_msgtype6_modexpo_crt(struct zcrypt_queue *zq,
 					struct ica_rsa_modexpo_crt *crt,
 					struct ap_message *ap_msg)
 {
-	struct response_type resp_type = {
-		.type = CEXXC_RESPONSE_TYPE_ICA,
-	};
+	struct ap_response_type *resp_type = &ap_msg->response;
 	int rc;
 
 	ap_msg->msg = (void *)get_zeroed_page(GFP_KERNEL);
@@ -1029,15 +1019,15 @@ static long zcrypt_msgtype6_modexpo_crt(struct zcrypt_queue *zq,
 	ap_msg->receive = zcrypt_msgtype6_receive;
 	ap_msg->psmid = (((unsigned long)current->pid) << 32) +
 		atomic_inc_return(&zcrypt_step);
-	ap_msg->private = &resp_type;
 	rc = icacrt_msg_to_type6crt_msgx(zq, ap_msg, crt);
 	if (rc)
 		goto out_free;
-	init_completion(&resp_type.work);
+	resp_type->type = CEXXC_RESPONSE_TYPE_ICA;
+	init_completion(&resp_type->work);
 	rc = ap_queue_message(zq->queue, ap_msg);
 	if (rc)
 		goto out_free;
-	rc = wait_for_completion_interruptible(&resp_type.work);
+	rc = wait_for_completion_interruptible(&resp_type->work);
 	if (rc == 0) {
 		rc = ap_msg->rc;
 		if (rc == 0)
@@ -1051,7 +1041,6 @@ static long zcrypt_msgtype6_modexpo_crt(struct zcrypt_queue *zq,
 
 out_free:
 	free_page((unsigned long)ap_msg->msg);
-	ap_msg->private = NULL;
 	ap_msg->msg = NULL;
 	return rc;
 }
@@ -1069,9 +1058,7 @@ int prep_cca_ap_msg(bool userspace, struct ica_xcRB *xcrb,
 		    struct ap_message *ap_msg,
 		    unsigned int *func_code, unsigned short **dom)
 {
-	struct response_type resp_type = {
-		.type = CEXXC_RESPONSE_TYPE_XCRB,
-	};
+	struct ap_response_type *resp_type = &ap_msg->response;
 
 	ap_msg->bufsize = atomic_read(&ap_max_msg_size);
 	ap_msg->msg = kmalloc(ap_msg->bufsize, GFP_KERNEL);
@@ -1080,9 +1067,7 @@ int prep_cca_ap_msg(bool userspace, struct ica_xcRB *xcrb,
 	ap_msg->receive = zcrypt_msgtype6_receive;
 	ap_msg->psmid = (((unsigned long)current->pid) << 32) +
 				atomic_inc_return(&zcrypt_step);
-	ap_msg->private = kmemdup(&resp_type, sizeof(resp_type), GFP_KERNEL);
-	if (!ap_msg->private)
-		return -ENOMEM;
+	resp_type->type = CEXXC_RESPONSE_TYPE_XCRB;
 	return xcrb_msg_to_type6cprb_msgx(userspace, ap_msg, xcrb, func_code, dom);
 }
 
@@ -1097,7 +1082,7 @@ static long zcrypt_msgtype6_send_cprb(bool userspace, struct zcrypt_queue *zq,
 				      struct ica_xcRB *xcrb,
 				      struct ap_message *ap_msg)
 {
-	struct response_type *rtype = ap_msg->private;
+	struct ap_response_type *resp_type = &ap_msg->response;
 	struct {
 		struct type6_hdr hdr;
 		struct CPRBX cprbx;
@@ -1128,11 +1113,11 @@ static long zcrypt_msgtype6_send_cprb(bool userspace, struct zcrypt_queue *zq,
 		msg->hdr.fromcardlen1 -= delta;
 	}
 
-	init_completion(&rtype->work);
+	init_completion(&resp_type->work);
 	rc = ap_queue_message(zq->queue, ap_msg);
 	if (rc)
 		goto out;
-	rc = wait_for_completion_interruptible(&rtype->work);
+	rc = wait_for_completion_interruptible(&resp_type->work);
 	if (rc == 0) {
 		rc = ap_msg->rc;
 		if (rc == 0)
@@ -1166,9 +1151,7 @@ int prep_ep11_ap_msg(bool userspace, struct ep11_urb *xcrb,
 		     struct ap_message *ap_msg,
 		     unsigned int *func_code, unsigned int *domain)
 {
-	struct response_type resp_type = {
-		.type = CEXXC_RESPONSE_TYPE_EP11,
-	};
+	struct ap_response_type *resp_type = &ap_msg->response;
 
 	ap_msg->bufsize = atomic_read(&ap_max_msg_size);
 	ap_msg->msg = kmalloc(ap_msg->bufsize, GFP_KERNEL);
@@ -1177,9 +1160,7 @@ int prep_ep11_ap_msg(bool userspace, struct ep11_urb *xcrb,
 	ap_msg->receive = zcrypt_msgtype6_receive_ep11;
 	ap_msg->psmid = (((unsigned long)current->pid) << 32) +
 				atomic_inc_return(&zcrypt_step);
-	ap_msg->private = kmemdup(&resp_type, sizeof(resp_type), GFP_KERNEL);
-	if (!ap_msg->private)
-		return -ENOMEM;
+	resp_type->type = CEXXC_RESPONSE_TYPE_EP11;
 	return xcrb_msg_to_type6_ep11cprb_msgx(userspace, ap_msg, xcrb,
 					       func_code, domain);
 }
@@ -1197,7 +1178,7 @@ static long zcrypt_msgtype6_send_ep11_cprb(bool userspace, struct zcrypt_queue *
 {
 	int rc;
 	unsigned int lfmt;
-	struct response_type *rtype = ap_msg->private;
+	struct ap_response_type *resp_type = &ap_msg->response;
 	struct {
 		struct type6_hdr hdr;
 		struct ep11_cprb cprbx;
@@ -1251,11 +1232,11 @@ static long zcrypt_msgtype6_send_ep11_cprb(bool userspace, struct zcrypt_queue *
 	msg->hdr.fromcardlen1 = zq->reply.bufsize -
 		sizeof(struct type86_hdr) - sizeof(struct type86_fmt2_ext);
 
-	init_completion(&rtype->work);
+	init_completion(&resp_type->work);
 	rc = ap_queue_message(zq->queue, ap_msg);
 	if (rc)
 		goto out;
-	rc = wait_for_completion_interruptible(&rtype->work);
+	rc = wait_for_completion_interruptible(&resp_type->work);
 	if (rc == 0) {
 		rc = ap_msg->rc;
 		if (rc == 0)
@@ -1279,9 +1260,7 @@ static long zcrypt_msgtype6_send_ep11_cprb(bool userspace, struct zcrypt_queue *
 int prep_rng_ap_msg(struct ap_message *ap_msg, int *func_code,
 		    unsigned int *domain)
 {
-	struct response_type resp_type = {
-		.type = CEXXC_RESPONSE_TYPE_XCRB,
-	};
+	struct ap_response_type *resp_type = &ap_msg->response;
 
 	ap_msg->bufsize = AP_DEFAULT_MAX_MSG_SIZE;
 	ap_msg->msg = kmalloc(ap_msg->bufsize, GFP_KERNEL);
@@ -1290,9 +1269,8 @@ int prep_rng_ap_msg(struct ap_message *ap_msg, int *func_code,
 	ap_msg->receive = zcrypt_msgtype6_receive;
 	ap_msg->psmid = (((unsigned long)current->pid) << 32) +
 				atomic_inc_return(&zcrypt_step);
-	ap_msg->private = kmemdup(&resp_type, sizeof(resp_type), GFP_KERNEL);
-	if (!ap_msg->private)
-		return -ENOMEM;
+
+	resp_type->type = CEXXC_RESPONSE_TYPE_XCRB;
 
 	rng_type6cprb_msgx(ap_msg, ZCRYPT_RNG_BUFFER_SIZE, domain);
 
@@ -1319,16 +1297,16 @@ static long zcrypt_msgtype6_rng(struct zcrypt_queue *zq,
 		short int verb_length;
 		short int key_length;
 	} __packed * msg = ap_msg->msg;
-	struct response_type *rtype = ap_msg->private;
+	struct ap_response_type *resp_type = &ap_msg->response;
 	int rc;
 
 	msg->cprbx.domain = AP_QID_QUEUE(zq->queue->qid);
 
-	init_completion(&rtype->work);
+	init_completion(&resp_type->work);
 	rc = ap_queue_message(zq->queue, ap_msg);
 	if (rc)
 		goto out;
-	rc = wait_for_completion_interruptible(&rtype->work);
+	rc = wait_for_completion_interruptible(&resp_type->work);
 	if (rc == 0) {
 		rc = ap_msg->rc;
 		if (rc == 0)
-- 
2.53.0



