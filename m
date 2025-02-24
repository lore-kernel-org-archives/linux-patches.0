Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159AA2571C3;
	Mon, 24 Feb 2025 14:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408639; cv=none; b=dXqPgQDyKBIMkXu+rh+96335STpu+mYj30DISnaaVtKHcDbGsBPS0sbxkMgsnbTq6lvKCnr4pqkJDHLsLyRyuJFpVDjTLoUredGQ/hsJodvZzHYj/MWVV0CTulRfGYdC/84kLR2RZxT9E+LTyxoRCUcTlnq4mS1YPEfuZCJ7uJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408639; c=relaxed/simple;
	bh=s4IDN/uDey13CZJ3FT3kCYnXnBSvQaUfcENdbwTTx6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pdHLw1KWbywLT/EKUASVZoqQuzJMHDp2bDMj4DSXAIPZRVEjwptB7UqOwt574aA15JMpJe74U7idbXjAHodyIvia5/EUu/6U0v+EQllq54k/H7i5FHyLPy4Qz/v6R3w2UaF4HW4R8M52iWQ+7iiw+sCRJIlLP4CWsqCWJbenKps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZsZHFpV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZsZHFpV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 348D7C4CEE6;
	Mon, 24 Feb 2025 14:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408638;
	bh=s4IDN/uDey13CZJ3FT3kCYnXnBSvQaUfcENdbwTTx6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AZsZHFpVJSZtD1E0wrydTVwwmQWjiWn6ovhnNJ3mJ3qD7q+vfiL9L3T9MpDJtXw9J
	 R9qwNc69VYaPAPMGjBP7jpv6a6SVC78g5IKspLp8XbSv1emEdJoJl4pkLf3bvTcQ6B
	 tZAqpGzwiDjFIPS6iJcC3Z4EXL5kZF5nFNpPm8Fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Sumit Garg <sumit.garg@linaro.org>,
	Jens Wiklander <jens.wiklander@linaro.org>
Subject: [PATCH 6.12 116/154] tee: optee: Fix supplicant wait loop
Date: Mon, 24 Feb 2025 15:35:15 +0100
Message-ID: <20250224142611.599695470@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Sumit Garg <sumit.garg@linaro.org>

commit 70b0d6b0a199c5a3ee6c72f5e61681ed6f759612 upstream.

OP-TEE supplicant is a user-space daemon and it's possible for it
be hung or crashed or killed in the middle of processing an OP-TEE
RPC call. It becomes more complicated when there is incorrect shutdown
ordering of the supplicant process vs the OP-TEE client application which
can eventually lead to system hang-up waiting for the closure of the
client application.

Allow the client process waiting in kernel for supplicant response to
be killed rather than indefinitely waiting in an unkillable state. Also,
a normal uninterruptible wait should not have resulted in the hung-task
watchdog getting triggered, but the endless loop would.

This fixes issues observed during system reboot/shutdown when supplicant
got hung for some reason or gets crashed/killed which lead to client
getting hung in an unkillable state. It in turn lead to system being in
hung up state requiring hard power off/on to recover.

Fixes: 4fb0a5eb364d ("tee: add OP-TEE driver")
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Cc: stable@vger.kernel.org
Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tee/optee/supp.c |   35 ++++++++---------------------------
 1 file changed, 8 insertions(+), 27 deletions(-)

--- a/drivers/tee/optee/supp.c
+++ b/drivers/tee/optee/supp.c
@@ -80,7 +80,6 @@ u32 optee_supp_thrd_req(struct tee_conte
 	struct optee *optee = tee_get_drvdata(ctx->teedev);
 	struct optee_supp *supp = &optee->supp;
 	struct optee_supp_req *req;
-	bool interruptable;
 	u32 ret;
 
 	/*
@@ -111,36 +110,18 @@ u32 optee_supp_thrd_req(struct tee_conte
 	/*
 	 * Wait for supplicant to process and return result, once we've
 	 * returned from wait_for_completion(&req->c) successfully we have
-	 * exclusive access again.
+	 * exclusive access again. Allow the wait to be killable such that
+	 * the wait doesn't turn into an indefinite state if the supplicant
+	 * gets hung for some reason.
 	 */
-	while (wait_for_completion_interruptible(&req->c)) {
+	if (wait_for_completion_killable(&req->c)) {
 		mutex_lock(&supp->mutex);
-		interruptable = !supp->ctx;
-		if (interruptable) {
-			/*
-			 * There's no supplicant available and since the
-			 * supp->mutex currently is held none can
-			 * become available until the mutex released
-			 * again.
-			 *
-			 * Interrupting an RPC to supplicant is only
-			 * allowed as a way of slightly improving the user
-			 * experience in case the supplicant hasn't been
-			 * started yet. During normal operation the supplicant
-			 * will serve all requests in a timely manner and
-			 * interrupting then wouldn't make sense.
-			 */
-			if (req->in_queue) {
-				list_del(&req->link);
-				req->in_queue = false;
-			}
+		if (req->in_queue) {
+			list_del(&req->link);
+			req->in_queue = false;
 		}
 		mutex_unlock(&supp->mutex);
-
-		if (interruptable) {
-			req->ret = TEEC_ERROR_COMMUNICATION;
-			break;
-		}
+		req->ret = TEEC_ERROR_COMMUNICATION;
 	}
 
 	ret = req->ret;


