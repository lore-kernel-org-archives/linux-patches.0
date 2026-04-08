Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6323D9DD6;
	Wed,  8 Apr 2026 19:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674863; cv=none; b=OKZejmVsWn4KIhrmnS/DT2bOJHh8IpARly3oF3cSsUphWJ0SxEv3uQUhaqk8An2bk7C2wcRI9jDJsEsjr9EoI+LEdMRMCwkmLaZSFIGNyzrwaejOms5Q5svFa5SOBn4BymkpQa9t2D+gVt+Ec749CnBZNeszX9k8SJUQuNsOjoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674863; c=relaxed/simple;
	bh=Pc64yaId9e8ftOLjVLmMp7Aic8OT3OzW10ORTSqQvyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sL/9NgAKttGGzElMCMyLJkV2fDlA3FMM13D6kfH16a6VeqXdyaYlsY+he4RT7x7PY7o16WCcN5b8uyAkGh0MweSNPfbYVUSDOw+XrI3MR1v5APvL9gC1KGdSuPgLkvJfDD8sYnCxB73I6OFoHjLn7x3cwpsxxQHFsKMXO9Kij4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j9HpuxyY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j9HpuxyY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 436B2C19421;
	Wed,  8 Apr 2026 19:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674863;
	bh=Pc64yaId9e8ftOLjVLmMp7Aic8OT3OzW10ORTSqQvyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j9HpuxyYHYD9HjlB+nVcL2wVqqYkaqs4rJyF89KrGOv1utpR9WJYhfTkUKubQ/E3j
	 ymNHxe2HCkSZAXyq9/Gix5Kockj71uWe06iwTdY+QlnBSm9S3flbHUDRTZeRqFPlwB
	 DX0T2NpssXiOn6X1/nOE1GFKU0Cgao6Ik04Pk2Bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Zhang <yi.zhang@redhat.com>,
	Nadja Hariz <Nadia.Hariz@ibm.com>,
	Ingo Franzki <ifranzki@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.19 262/311] s390/zcrypt: Fix memory leak with CCA cards used as accelerator
Date: Wed,  8 Apr 2026 20:04:22 +0200
Message-ID: <20260408175949.166837126@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harald Freudenberger <freude@linux.ibm.com>

commit c8d46f17c2fc7d25c18e60c008928aecab26184d upstream.

Tests showed that there is a memory leak if CCA cards are used as
accelerator for clear key RSA requests (ME and CRT). With the last
rework for the memory allocation the AP messages are allocated by
ap_init_apmsg() but for some reason on two places (ME and CRT) the
older allocation was still in place. So the first allocation simple
was never freed.

Fixes: 57db62a130ce ("s390/ap/zcrypt: Rework AP message buffer allocation")
Reported-by: Yi Zhang <yi.zhang@redhat.com>
Closes: https://lore.kernel.org/linux-s390/CAHj4cs9H67Uz0iVaRQv447p7JFPRPy3TKAT4=Y6_e=wSHCZM5w@mail.gmail.com/
Reported-by: Nadja Hariz <Nadia.Hariz@ibm.com>
Cc: stable@vger.kernel.org
Reviewed-by: Ingo Franzki <ifranzki@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/zcrypt_msgtype6.c |   32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

--- a/drivers/s390/crypto/zcrypt_msgtype6.c
+++ b/drivers/s390/crypto/zcrypt_msgtype6.c
@@ -953,6 +953,10 @@ static atomic_t zcrypt_step = ATOMIC_INI
 /*
  * The request distributor calls this function if it picked the CEXxC
  * device to handle a modexpo request.
+ * This function assumes that ap_msg has been initialized with
+ * ap_init_apmsg() and thus a valid buffer with the size of
+ * ap_msg->bufsize is available within ap_msg. Also the caller has
+ * to make sure ap_release_apmsg() is always called even on failure.
  * @zq: pointer to zcrypt_queue structure that identifies the
  *	CEXxC device to the request distributor
  * @mex: pointer to the modexpo request buffer
@@ -964,21 +968,17 @@ static long zcrypt_msgtype6_modexpo(stru
 	struct ap_response_type *resp_type = &ap_msg->response;
 	int rc;
 
-	ap_msg->msg = (void *)get_zeroed_page(GFP_KERNEL);
-	if (!ap_msg->msg)
-		return -ENOMEM;
-	ap_msg->bufsize = PAGE_SIZE;
 	ap_msg->receive = zcrypt_msgtype6_receive;
 	ap_msg->psmid = (((unsigned long)current->pid) << 32) +
 		atomic_inc_return(&zcrypt_step);
 	rc = icamex_msg_to_type6mex_msgx(zq, ap_msg, mex);
 	if (rc)
-		goto out_free;
+		goto out;
 	resp_type->type = CEXXC_RESPONSE_TYPE_ICA;
 	init_completion(&resp_type->work);
 	rc = ap_queue_message(zq->queue, ap_msg);
 	if (rc)
-		goto out_free;
+		goto out;
 	rc = wait_for_completion_interruptible(&resp_type->work);
 	if (rc == 0) {
 		rc = ap_msg->rc;
@@ -991,15 +991,17 @@ static long zcrypt_msgtype6_modexpo(stru
 		ap_cancel_message(zq->queue, ap_msg);
 	}
 
-out_free:
-	free_page((unsigned long)ap_msg->msg);
-	ap_msg->msg = NULL;
+out:
 	return rc;
 }
 
 /*
  * The request distributor calls this function if it picked the CEXxC
  * device to handle a modexpo_crt request.
+ * This function assumes that ap_msg has been initialized with
+ * ap_init_apmsg() and thus a valid buffer with the size of
+ * ap_msg->bufsize is available within ap_msg. Also the caller has
+ * to make sure ap_release_apmsg() is always called even on failure.
  * @zq: pointer to zcrypt_queue structure that identifies the
  *	CEXxC device to the request distributor
  * @crt: pointer to the modexpoc_crt request buffer
@@ -1011,21 +1013,17 @@ static long zcrypt_msgtype6_modexpo_crt(
 	struct ap_response_type *resp_type = &ap_msg->response;
 	int rc;
 
-	ap_msg->msg = (void *)get_zeroed_page(GFP_KERNEL);
-	if (!ap_msg->msg)
-		return -ENOMEM;
-	ap_msg->bufsize = PAGE_SIZE;
 	ap_msg->receive = zcrypt_msgtype6_receive;
 	ap_msg->psmid = (((unsigned long)current->pid) << 32) +
 		atomic_inc_return(&zcrypt_step);
 	rc = icacrt_msg_to_type6crt_msgx(zq, ap_msg, crt);
 	if (rc)
-		goto out_free;
+		goto out;
 	resp_type->type = CEXXC_RESPONSE_TYPE_ICA;
 	init_completion(&resp_type->work);
 	rc = ap_queue_message(zq->queue, ap_msg);
 	if (rc)
-		goto out_free;
+		goto out;
 	rc = wait_for_completion_interruptible(&resp_type->work);
 	if (rc == 0) {
 		rc = ap_msg->rc;
@@ -1038,9 +1036,7 @@ static long zcrypt_msgtype6_modexpo_crt(
 		ap_cancel_message(zq->queue, ap_msg);
 	}
 
-out_free:
-	free_page((unsigned long)ap_msg->msg);
-	ap_msg->msg = NULL;
+out:
 	return rc;
 }
 


