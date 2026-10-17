Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC893BAD9A;
	Sat, 17 Oct 2026 16:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255654; cv=none; b=VRJWCDsxmsiIlhrmc2i8vqD0soIEh0hhycIN8YRwriZhJ0nHEklgnapD3mEIS8oPxYCCMmt4nTzREVpzAU7Vd1sXyiynMYLi/QKfAceR7rZM5uDnkpuR6JSQokODCXwfyVmGygO8++f2Cnfz9/IJ3zvmY65Er+RlFk0AVJZuZSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255654; c=relaxed/simple;
	bh=Gw7sKoeQFMzHT4YjfwdJh1hrUHpPcRtcYh4jJ/9+usA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7sR1miaIMu22EpSgN38cfURdHy8MzWuFhocicOAw9a2FftKo+EydBCTKzLplTpV4WWrFZNd8w/BdHcy7Uip+ZNbmGvKLDsEhY01ijCZcEgRDHblDXb8KqjiKE9oDtVrR9q3q2jZ/HRH3Xk2HgZTMueUarghXDThtzLeqyeJ6nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fLRU0tT7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fLRU0tT7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEDED1F000C4;
	Sat, 17 Oct 2026 16:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255653;
	bh=w/4UVAwhaT08TcRu4ghfaffMCjdRoH4478/iVLeH3W4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fLRU0tT7Qk84Cj0pr785rox6g6N+5qxQ6zVtDNRCnjSQ/AfyGII1IOS1af44rMGYi
	 ERE852OcvQOheLEC5ih/a+O+wu1I8KywbGsHB8ntZkkEa81zYl66bHPUWeDFGPGG0P
	 TKBeL/wPnT1x02sPdBAyi1AHV44pPz2C2ICGwl4Q=
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
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 848/869] s390/zcrypt: Fix memory leak with CCA cards used as accelerator
Date: Sat, 17 Oct 2026 18:01:29 +0200
Message-ID: <20261017160058.607249024@linuxfoundation.org>
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

[ Upstream commit c8d46f17c2fc7d25c18e60c008928aecab26184d ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/zcrypt_msgtype6.c | 32 ++++++++++++---------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/s390/crypto/zcrypt_msgtype6.c b/drivers/s390/crypto/zcrypt_msgtype6.c
index 352d5c15f7dcc..2578384705592 100644
--- a/drivers/s390/crypto/zcrypt_msgtype6.c
+++ b/drivers/s390/crypto/zcrypt_msgtype6.c
@@ -956,6 +956,10 @@ static atomic_t zcrypt_step = ATOMIC_INIT(0);
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
@@ -967,21 +971,17 @@ static long zcrypt_msgtype6_modexpo(struct zcrypt_queue *zq,
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
@@ -994,15 +994,17 @@ static long zcrypt_msgtype6_modexpo(struct zcrypt_queue *zq,
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
@@ -1014,21 +1016,17 @@ static long zcrypt_msgtype6_modexpo_crt(struct zcrypt_queue *zq,
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
@@ -1041,9 +1039,7 @@ static long zcrypt_msgtype6_modexpo_crt(struct zcrypt_queue *zq,
 		ap_cancel_message(zq->queue, ap_msg);
 	}
 
-out_free:
-	free_page((unsigned long)ap_msg->msg);
-	ap_msg->msg = NULL;
+out:
 	return rc;
 }
 
-- 
2.53.0



