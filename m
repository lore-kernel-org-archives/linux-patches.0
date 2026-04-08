Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B8327979A;
	Wed,  8 Apr 2026 18:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673493; cv=none; b=bEcorWZAI4tu3BeDKB+yJHBLrZvlNbHpPIb0kKpRn6Thy6qUu5aiO431Sy3IkrYYZkFfO0nzyztxu3s7wLHrGOVWYeUH6Nubo8OvBTnU003ThvGn49bU+0zOKx7+yu2ONsKQIOSvdTm/8SQMbd8f35ryqLUu8bB63oIWFO3s03I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673493; c=relaxed/simple;
	bh=88GmAjOiyY6Lx6Jj/IZuAyLHq5CYv+VybfAK6FAAUo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FSQwkXZNEf7d6JxgNRXofPtGasTKZLxtKyHiVzAU8TwQkrr12mA/iV9A/MfWH2ivi6qeaCSEILnWQcfMzyOsN0qiEd7nC8amhGid8UvXGdCOX4puZoLRFYlR2e7vAwSOr1eGmayXK5s5T46KeIndZYXCiQvWCsklPfxvK0xXNIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0dCD6y5S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0dCD6y5S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2ADFC19421;
	Wed,  8 Apr 2026 18:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673493;
	bh=88GmAjOiyY6Lx6Jj/IZuAyLHq5CYv+VybfAK6FAAUo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0dCD6y5SVVofdmYNx9Xa93J1Ed2b7//Z6R2s97SaS2HFTTM1TboDRgbSi2lhGBVKu
	 VLJA4dcdkA2sV5OjuL1g0NDm3oGT8bPcZvtmEeAqaHIidO8RKdV/KaI0jkXo1jDt98
	 DB1UxgYasR65jVkq0hgpJwGUlozbFuWBFXb1hkUI=
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
Subject: [PATCH 6.18 221/277] s390/zcrypt: Fix memory leak with CCA cards used as accelerator
Date: Wed,  8 Apr 2026 20:03:26 +0200
Message-ID: <20260408175942.108937150@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -954,6 +954,10 @@ static atomic_t zcrypt_step = ATOMIC_INI
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
@@ -965,21 +969,17 @@ static long zcrypt_msgtype6_modexpo(stru
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
@@ -992,15 +992,17 @@ static long zcrypt_msgtype6_modexpo(stru
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
@@ -1012,21 +1014,17 @@ static long zcrypt_msgtype6_modexpo_crt(
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
@@ -1039,9 +1037,7 @@ static long zcrypt_msgtype6_modexpo_crt(
 		ap_cancel_message(zq->queue, ap_msg);
 	}
 
-out_free:
-	free_page((unsigned long)ap_msg->msg);
-	ap_msg->msg = NULL;
+out:
 	return rc;
 }
 


