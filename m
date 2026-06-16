Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6CAB472798;
	Tue, 16 Jun 2026 18:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636045; cv=none; b=KlRd5o9AxfeKQxX/BjBDM9WA97D8RoErkbJjiCBg4RWWBRA/52LMxpG009DL0mHV6LfhlGRfMBjdNykY+xK7QLWKY/MQWhste3uqRsGl8+6m+ZNA2K2zfLeobFWAxZv6TrK/g9OhsqXBSaSSCha+1zFEYkfQZYUzEqbQ8D6pCes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636045; c=relaxed/simple;
	bh=yfdp/UHccPsqK+TxrI2sq3x6c5iwk9OU3LFh2Yjc0xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hn+oeE3/z8YjHBgeX3Cak5YeHffOHJQ4TgEp9tJt0wPQurv11PWJKYDtDl7qPq5DhodKDglX799kIBpa6az1WoJVbtrWdQEXyTKTqJTX1zfPyfA5q4M8bmiYggrzpzOAua+dlAhZKW9ZmFZAZnQrHpQ3xz3YS4W5tbc1aMkZt9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TWE+J9GZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TWE+J9GZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB121F000E9;
	Tue, 16 Jun 2026 18:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636043;
	bh=dv215WWrXMYmluVj+vBVWfrbuDIMx32Y8qETiyJ+nrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TWE+J9GZDvJgiWrgGnMFTfzfiRjZ6W+KAjKK/t2E9K53kOO7m8N87mohi46zfNpgY
	 834arzvnKefCI9zai5AEnKW78+LdPd+Bd4zfPsTJCReFPIPfUtllAXwoQKnHIuM9a8
	 cdzbvjDfXeFbjIAXNgazmLx0GPMEAmZ3mwndriug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amirreza Zarrabi <amirreza.zarrabi@oss.qualcomm.com>,
	Ox Yeh <ox.yeh@mediatek.com>,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Jens Wiklander <jens.wiklander@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 131/342] tee: optee: prevent use-after-free when the client exits before the supplicant
Date: Tue, 16 Jun 2026 20:27:07 +0530
Message-ID: <20260616145054.299599588@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amirreza Zarrabi <amirreza.zarrabi@oss.qualcomm.com>

[ Upstream commit 387a926ee166814611acecb960207fe2f3c4fd3e ]

Commit 70b0d6b0a199 ("tee: optee: Fix supplicant wait loop") made the
client wait as killable so it can be interrupted during shutdown or
after a supplicant crash. This changes the original lifetime expectations:
the client task can now terminate while the supplicant is still processing
its request.

If the client exits first it removes the request from its queue and
kfree()s it, while the request ID remains in supp->idr. A subsequent
lookup on the supplicant path then dereferences freed memory, leading to
a use-after-free.

Serialise access to the request with supp->mutex:

  * Hold supp->mutex in optee_supp_recv() and optee_supp_send() while
    looking up and touching the request.
  * Let optee_supp_thrd_req() notice that the client has terminated and
    signal optee_supp_send() accordingly.

With these changes the request cannot be freed while the supplicant still
has a reference, eliminating the race.

Fixes: 70b0d6b0a199 ("tee: optee: Fix supplicant wait loop")
Signed-off-by: Amirreza Zarrabi <amirreza.zarrabi@oss.qualcomm.com>
Tested-by: Ox Yeh <ox.yeh@mediatek.com>
Reviewed-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/optee/supp.c | 107 +++++++++++++++++++++++++++------------
 1 file changed, 74 insertions(+), 33 deletions(-)

diff --git a/drivers/tee/optee/supp.c b/drivers/tee/optee/supp.c
index d0f397c9024201..2386bbd38ce78b 100644
--- a/drivers/tee/optee/supp.c
+++ b/drivers/tee/optee/supp.c
@@ -10,7 +10,11 @@
 struct optee_supp_req {
 	struct list_head link;
 
+	int id;
+
 	bool in_queue;
+	bool processed;
+
 	u32 func;
 	u32 ret;
 	size_t num_params;
@@ -19,6 +23,9 @@ struct optee_supp_req {
 	struct completion c;
 };
 
+/* It is temporary request used for revoked pending request in supp->idr. */
+#define INVALID_REQ_PTR ((struct optee_supp_req *)ERR_PTR(-EBADF))
+
 void optee_supp_init(struct optee_supp *supp)
 {
 	memset(supp, 0, sizeof(*supp));
@@ -39,21 +46,23 @@ void optee_supp_release(struct optee_supp *supp)
 {
 	int id;
 	struct optee_supp_req *req;
-	struct optee_supp_req *req_tmp;
 
 	mutex_lock(&supp->mutex);
 
-	/* Abort all request retrieved by supplicant */
+	/* Abort all request */
 	idr_for_each_entry(&supp->idr, req, id) {
 		idr_remove(&supp->idr, id);
-		req->ret = TEEC_ERROR_COMMUNICATION;
-		complete(&req->c);
-	}
+		/* Skip if request was already marked invalid */
+		if (IS_ERR(req))
+			continue;
 
-	/* Abort all queued requests */
-	list_for_each_entry_safe(req, req_tmp, &supp->reqs, link) {
-		list_del(&req->link);
-		req->in_queue = false;
+		/* For queued requests where supplicant has not seen it */
+		if (req->in_queue) {
+			list_del(&req->link);
+			req->in_queue = false;
+		}
+
+		req->processed = true;
 		req->ret = TEEC_ERROR_COMMUNICATION;
 		complete(&req->c);
 	}
@@ -100,8 +109,16 @@ u32 optee_supp_thrd_req(struct tee_context *ctx, u32 func, size_t num_params,
 
 	/* Insert the request in the request list */
 	mutex_lock(&supp->mutex);
+	req->id = idr_alloc(&supp->idr, req, 1, 0, GFP_KERNEL);
+	if (req->id < 0) {
+		mutex_unlock(&supp->mutex);
+		kfree(req);
+		return TEEC_ERROR_OUT_OF_MEMORY;
+	}
+
 	list_add_tail(&req->link, &supp->reqs);
 	req->in_queue = true;
+	req->processed = false;
 	mutex_unlock(&supp->mutex);
 
 	/* Tell an eventual waiter there's a new request */
@@ -117,21 +134,43 @@ u32 optee_supp_thrd_req(struct tee_context *ctx, u32 func, size_t num_params,
 	if (wait_for_completion_killable(&req->c)) {
 		mutex_lock(&supp->mutex);
 		if (req->in_queue) {
+			/* Supplicant has not seen this request yet. */
+			idr_remove(&supp->idr, req->id);
 			list_del(&req->link);
 			req->in_queue = false;
+
+			ret = TEEC_ERROR_COMMUNICATION;
+		} else if (req->processed) {
+			/*
+			 * Supplicant has processed this request. Ignore the
+			 * kill signal for now and submit the result. req is not
+			 * in supp->reqs (removed by supp_pop_entry()) nor in
+			 * supp->idr (removed by supp_pop_req()).
+			 */
+			ret = req->ret;
+		} else {
+			/*
+			 * Supplicant is in the middle of processing this
+			 * request. Replace req with INVALID_REQ_PTR so that
+			 * the ID remains busy, causing optee_supp_send() to
+			 * fail on the next call to supp_pop_req() with this ID.
+			 */
+			idr_replace(&supp->idr, INVALID_REQ_PTR, req->id);
+			ret = TEEC_ERROR_COMMUNICATION;
 		}
+
 		mutex_unlock(&supp->mutex);
-		req->ret = TEEC_ERROR_COMMUNICATION;
+	} else {
+		ret = req->ret;
 	}
 
-	ret = req->ret;
 	kfree(req);
 
 	return ret;
 }
 
 static struct optee_supp_req  *supp_pop_entry(struct optee_supp *supp,
-					      int num_params, int *id)
+					      int num_params)
 {
 	struct optee_supp_req *req;
 
@@ -153,10 +192,6 @@ static struct optee_supp_req  *supp_pop_entry(struct optee_supp *supp,
 		return ERR_PTR(-EINVAL);
 	}
 
-	*id = idr_alloc(&supp->idr, req, 1, 0, GFP_KERNEL);
-	if (*id < 0)
-		return ERR_PTR(-ENOMEM);
-
 	list_del(&req->link);
 	req->in_queue = false;
 
@@ -214,7 +249,6 @@ int optee_supp_recv(struct tee_context *ctx, u32 *func, u32 *num_params,
 	struct optee *optee = tee_get_drvdata(teedev);
 	struct optee_supp *supp = &optee->supp;
 	struct optee_supp_req *req = NULL;
-	int id;
 	size_t num_meta;
 	int rc;
 
@@ -224,15 +258,11 @@ int optee_supp_recv(struct tee_context *ctx, u32 *func, u32 *num_params,
 
 	while (true) {
 		mutex_lock(&supp->mutex);
-		req = supp_pop_entry(supp, *num_params - num_meta, &id);
+		req = supp_pop_entry(supp, *num_params - num_meta);
+		if (req)
+			break; /* Keep mutex held. */
 		mutex_unlock(&supp->mutex);
 
-		if (req) {
-			if (IS_ERR(req))
-				return PTR_ERR(req);
-			break;
-		}
-
 		/*
 		 * If we didn't get a request we'll block in
 		 * wait_for_completion() to avoid needless spinning.
@@ -245,6 +275,13 @@ int optee_supp_recv(struct tee_context *ctx, u32 *func, u32 *num_params,
 			return -ERESTARTSYS;
 	}
 
+	/* supp->mutex held and req != NULL. */
+
+	if (IS_ERR(req)) {
+		mutex_unlock(&supp->mutex);
+		return PTR_ERR(req);
+	}
+
 	if (num_meta) {
 		/*
 		 * tee-supplicant support meta parameters -> requsts can be
@@ -252,13 +289,11 @@ int optee_supp_recv(struct tee_context *ctx, u32 *func, u32 *num_params,
 		 */
 		param->attr = TEE_IOCTL_PARAM_ATTR_TYPE_VALUE_INOUT |
 			      TEE_IOCTL_PARAM_ATTR_META;
-		param->u.value.a = id;
+		param->u.value.a = req->id;
 		param->u.value.b = 0;
 		param->u.value.c = 0;
 	} else {
-		mutex_lock(&supp->mutex);
-		supp->req_id = id;
-		mutex_unlock(&supp->mutex);
+		supp->req_id = req->id;
 	}
 
 	*func = req->func;
@@ -266,6 +301,7 @@ int optee_supp_recv(struct tee_context *ctx, u32 *func, u32 *num_params,
 	memcpy(param + num_meta, req->param,
 	       sizeof(struct tee_param) * req->num_params);
 
+	mutex_unlock(&supp->mutex);
 	return 0;
 }
 
@@ -297,12 +333,17 @@ static struct optee_supp_req *supp_pop_req(struct optee_supp *supp,
 	if (!req)
 		return ERR_PTR(-ENOENT);
 
+	/* optee_supp_thrd_req() already returned to optee. */
+	if (IS_ERR(req))
+		goto failed_req;
+
 	if ((num_params - nm) != req->num_params)
 		return ERR_PTR(-EINVAL);
 
+	*num_meta = nm;
+failed_req:
 	idr_remove(&supp->idr, id);
 	supp->req_id = -1;
-	*num_meta = nm;
 
 	return req;
 }
@@ -328,10 +369,9 @@ int optee_supp_send(struct tee_context *ctx, u32 ret, u32 num_params,
 
 	mutex_lock(&supp->mutex);
 	req = supp_pop_req(supp, num_params, param, &num_meta);
-	mutex_unlock(&supp->mutex);
-
 	if (IS_ERR(req)) {
-		/* Something is wrong, let supplicant restart. */
+		mutex_unlock(&supp->mutex);
+		/* Something is wrong, let supplicant handel it. */
 		return PTR_ERR(req);
 	}
 
@@ -355,9 +395,10 @@ int optee_supp_send(struct tee_context *ctx, u32 ret, u32 num_params,
 		}
 	}
 	req->ret = ret;
-
+	req->processed = true;
 	/* Let the requesting thread continue */
 	complete(&req->c);
+	mutex_unlock(&supp->mutex);
 
 	return 0;
 }
-- 
2.53.0



