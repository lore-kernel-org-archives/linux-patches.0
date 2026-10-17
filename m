Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB1838654F;
	Sat, 17 Oct 2026 16:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254559; cv=none; b=s80b6qMijiB/krmvoR56wvzioCKFC1kWCck6aY0+yVF97QytQpuwyto7dO8018OutC4V4CCSYZ12MzG8svrJOf8MMmzjfekwom+oTVQivLUmYApG/lTvzAYXRc0CAMcYiq5rJQcIMO6qILKXdol482nfB8vXcVJnenNP28CzoGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254559; c=relaxed/simple;
	bh=gQ/Etbd/JdeCK38gW7f3w0r2Un46fsED/sx2HjxbN9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XGoPtTW+GPgWG/HTY/Kfqo29vbslxhgXwQKS8TRbCy/Qa9Xmg4Adi2l/p1BiJskDulS4pgIPlRpoGODYrsSRluSXStI7x/x6mRUHFHviVhaJPdnTAyOp7neEc32OfJ61wtryyXzEN0sqL1TbWDLekbeS8m8wEVnT8kEHLtFv9HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vfxk+g3x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vfxk+g3x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17DB01F000C4;
	Sat, 17 Oct 2026 16:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254558;
	bh=sdw1xyItov8MXqUhqAbC5E1JyVYvxrJ9Rq+v4N5M+Uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vfxk+g3xaLnYCWl7FJLyXN0AeRvcw4fLcgQ5xnHwhjNmYAv48+NMaljwOqCE0Rhk9
	 zeE31PSl5ANyM6Ebbm6cOwTIBlNLikPjuPNQD1OjRuzPk3144tgs3KoX3OlScbG0hA
	 /tZjJs4ExzS6vv31SxJt9HTR4psQAUGuKDspxu5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 487/869] s390/zcrypt: Rework domain processing within zcrypt device driver
Date: Sat, 17 Oct 2026 17:55:28 +0200
Message-ID: <20261017160049.602094642@linuxfoundation.org>
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

[ Upstream commit e2c6d91eb8b1533753755f07803e47eceed263d0 ]

Slight rework of the domain handling within the zcrypt dd:
Remove this curious construct to give a pointer to the
domain field within the CPRB struct to the zcrypt API and
later fill in the target domain via this pointer.
Now the domain is filled in with the send function when
the ready constructed AP message is about to be pushed
down into the software queue for AP queue processing.
So now the domain handling for CCA, EP11 and (internal) rng
CPRBs is the same. With this comes a slight reshuffle of the
code related to domain processing in the zcrypt API and the
message type 60 protocol implementation code.

Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Stable-dep-of: e935cd525af4 ("s390/zcrypt: Close speculative mem read possibility")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/zcrypt_api.c      | 36 +++++++++++----------------
 drivers/s390/crypto/zcrypt_msgtype6.c | 22 ++++++++++------
 drivers/s390/crypto/zcrypt_msgtype6.h |  2 +-
 3 files changed, 29 insertions(+), 31 deletions(-)

diff --git a/drivers/s390/crypto/zcrypt_api.c b/drivers/s390/crypto/zcrypt_api.c
index 217664f22714e..df1f9dc6a37ad 100644
--- a/drivers/s390/crypto/zcrypt_api.c
+++ b/drivers/s390/crypto/zcrypt_api.c
@@ -849,13 +849,12 @@ static long _zcrypt_send_cprb(u32 xflags, struct ap_perms *perms,
 			      struct ica_xcRB *xcrb)
 {
 	bool userspace = xflags & ZCRYPT_XFLAG_USERSPACE;
-	struct zcrypt_card *zc, *pref_zc;
-	struct zcrypt_queue *zq, *pref_zq;
-	struct ap_message ap_msg;
+	unsigned int domain, func_code = 0;
 	unsigned int wgt = 0, pref_wgt = 0;
-	unsigned int func_code = 0;
-	unsigned short *domain, tdom;
+	struct zcrypt_queue *zq, *pref_zq;
+	struct zcrypt_card *zc, *pref_zc;
 	int cpen, qpen, qid = 0, rc;
+	struct ap_message ap_msg;
 	struct module *mod;
 
 	trace_s390_zcrypt_req(xcrb, TB_ZSECSENDCPRB);
@@ -873,10 +872,9 @@ static long _zcrypt_send_cprb(u32 xflags, struct ap_perms *perms,
 	print_hex_dump_debug("ccareq: ", DUMP_PREFIX_ADDRESS, 16, 1,
 			     ap_msg.msg, ap_msg.len, false);
 
-	tdom = *domain;
-	if (perms != &ap_perms && tdom < AP_DOMAINS) {
+	if (perms != &ap_perms && domain < AP_DOMAINS) {
 		if (ap_msg.flags & AP_MSG_FLAG_ADMIN) {
-			if (!test_bit_inv(tdom, perms->adm)) {
+			if (!test_bit_inv(domain, perms->adm)) {
 				rc = -ENODEV;
 				goto out;
 			}
@@ -889,10 +887,10 @@ static long _zcrypt_send_cprb(u32 xflags, struct ap_perms *perms,
 	 * If a valid target domain is set and this domain is NOT a usage
 	 * domain but a control only domain, autoselect target domain.
 	 */
-	if (tdom < AP_DOMAINS &&
-	    !ap_test_config_usage_domain(tdom) &&
-	    ap_test_config_ctrl_domain(tdom))
-		tdom = AUTOSEL_DOM;
+	if (domain < AP_DOMAINS &&
+	    !ap_test_config_usage_domain(domain) &&
+	    ap_test_config_ctrl_domain(domain))
+		domain = AUTOSEL_DOM;
 
 	pref_zc = NULL;
 	pref_zq = NULL;
@@ -924,8 +922,8 @@ static long _zcrypt_send_cprb(u32 xflags, struct ap_perms *perms,
 			/* check for device usable and eligible */
 			if (!zq->online || !zq->ops->send_cprb ||
 			    !ap_queue_usable(zq->queue) ||
-			    (tdom != AUTOSEL_DOM &&
-			     tdom != AP_QID_QUEUE(zq->queue->qid)))
+			    (domain != AUTOSEL_DOM &&
+			     domain != AP_QID_QUEUE(zq->queue->qid)))
 				continue;
 			/* check if device node has admission for this queue */
 			if (!zcrypt_check_queue(perms,
@@ -948,16 +946,11 @@ static long _zcrypt_send_cprb(u32 xflags, struct ap_perms *perms,
 
 	if (!pref_zq) {
 		pr_debug("no match for address %02x.%04x => ENODEV\n",
-			 xcrb->user_defined, *domain);
+			 xcrb->user_defined, domain);
 		rc = -ENODEV;
 		goto out;
 	}
 
-	/* in case of auto select, provide the correct domain */
-	qid = pref_zq->queue->qid;
-	if (*domain == AUTOSEL_DOM)
-		*domain = AP_QID_QUEUE(qid);
-
 	rc = pref_zq->ops->send_cprb(userspace, pref_zq, xcrb, &ap_msg);
 	if (!rc) {
 		print_hex_dump_debug("ccarpl: ", DUMP_PREFIX_ADDRESS, 16, 1,
@@ -1217,7 +1210,6 @@ static long zcrypt_rng(char *buffer)
 	unsigned int wgt = 0, pref_wgt = 0;
 	unsigned int func_code = 0;
 	struct ap_message ap_msg;
-	unsigned int domain;
 	int qid = 0, rc = -ENODEV;
 	struct module *mod;
 
@@ -1226,7 +1218,7 @@ static long zcrypt_rng(char *buffer)
 	rc = ap_init_apmsg(&ap_msg, 0);
 	if (rc)
 		goto out;
-	rc = prep_rng_ap_msg(&ap_msg, &func_code, &domain);
+	rc = prep_rng_ap_msg(&ap_msg, &func_code, NULL);
 	if (rc)
 		goto out;
 
diff --git a/drivers/s390/crypto/zcrypt_msgtype6.c b/drivers/s390/crypto/zcrypt_msgtype6.c
index f6adb8ba3f95c..352d5c15f7dcc 100644
--- a/drivers/s390/crypto/zcrypt_msgtype6.c
+++ b/drivers/s390/crypto/zcrypt_msgtype6.c
@@ -329,7 +329,7 @@ struct type86_fmt2_msg {
 static int xcrb_msg_to_type6cprb_msgx(bool userspace, struct ap_message *ap_msg,
 				      struct ica_xcRB *xcrb,
 				      unsigned int *fcode,
-				      unsigned short **dom)
+				      unsigned int *domain)
 {
 	static struct type6_hdr static_type6_hdrX = {
 		.type		=  0x06,
@@ -413,7 +413,8 @@ static int xcrb_msg_to_type6cprb_msgx(bool userspace, struct ap_message *ap_msg,
 	       sizeof(msg->hdr.function_code));
 
 	*fcode = (msg->hdr.function_code[0] << 8) | msg->hdr.function_code[1];
-	*dom = (unsigned short *)&msg->cprbx.domain;
+	if (domain)
+		*domain = msg->cprbx.domain;
 
 	/* check subfunction, US and AU need special flag with NQAP */
 	if (memcmp(function_code, "US", 2) == 0 ||
@@ -530,7 +531,8 @@ static int xcrb_msg_to_type6_ep11cprb_msgx(bool userspace, struct ap_message *ap
 	else
 		ap_msg->flags |= AP_MSG_FLAG_USAGE;
 
-	*domain = msg->cprbx.target_id;
+	if (domain)
+		*domain = msg->cprbx.target_id;
 
 	return 0;
 }
@@ -1057,7 +1059,7 @@ static long zcrypt_msgtype6_modexpo_crt(struct zcrypt_queue *zq,
  */
 int prep_cca_ap_msg(bool userspace, struct ica_xcRB *xcrb,
 		    struct ap_message *ap_msg,
-		    unsigned int *func_code, unsigned short **dom)
+		    unsigned int *func_code, unsigned int *domain)
 {
 	struct ap_response_type *resp_type = &ap_msg->response;
 
@@ -1065,7 +1067,8 @@ int prep_cca_ap_msg(bool userspace, struct ica_xcRB *xcrb,
 	ap_msg->psmid = (((unsigned long)current->pid) << 32) +
 				atomic_inc_return(&zcrypt_step);
 	resp_type->type = CEXXC_RESPONSE_TYPE_XCRB;
-	return xcrb_msg_to_type6cprb_msgx(userspace, ap_msg, xcrb, func_code, dom);
+	return xcrb_msg_to_type6cprb_msgx(userspace, ap_msg,
+					  xcrb, func_code, domain);
 }
 
 /*
@@ -1110,6 +1113,9 @@ static long zcrypt_msgtype6_send_cprb(bool userspace, struct zcrypt_queue *zq,
 		msg->hdr.fromcardlen1 -= delta;
 	}
 
+	/* update domain field within the CPRB struct */
+	msg->cprbx.domain = AP_QID_QUEUE(zq->queue->qid);
+
 	init_completion(&resp_type->work);
 	rc = ap_queue_message(zq->queue, ap_msg);
 	if (rc)
@@ -1215,8 +1221,7 @@ static long zcrypt_msgtype6_send_ep11_cprb(bool userspace, struct zcrypt_queue *
 			lfmt = 1; /* length format #1 */
 		}
 		payload_hdr = (struct pld_hdr *)((&msg->pld_lenfmt) + lfmt);
-		payload_hdr->dom_val = (unsigned int)
-					AP_QID_QUEUE(zq->queue->qid);
+		payload_hdr->dom_val = AP_QID_QUEUE(zq->queue->qid);
 	}
 
 	/*
@@ -1297,7 +1302,8 @@ static inline void rng_type6cprb_msgx(struct ap_message *ap_msg,
 	msg->verb_length = 0x02;
 	msg->key_length = 0x02;
 	ap_msg->len = sizeof(*msg);
-	*domain = (unsigned short)msg->cprbx.domain;
+	if (domain)
+		*domain = msg->cprbx.domain;
 }
 
 /*
diff --git a/drivers/s390/crypto/zcrypt_msgtype6.h b/drivers/s390/crypto/zcrypt_msgtype6.h
index 9f7510019bc45..9cbe6e2b2d33c 100644
--- a/drivers/s390/crypto/zcrypt_msgtype6.h
+++ b/drivers/s390/crypto/zcrypt_msgtype6.h
@@ -96,7 +96,7 @@ struct type86_fmt2_ext {
 
 int prep_cca_ap_msg(bool userspace, struct ica_xcRB *xcrb,
 		    struct ap_message *ap_msg,
-		    unsigned int *fc, unsigned short **dom);
+		    unsigned int *fc, unsigned int *dom);
 int prep_ep11_ap_msg(bool userspace, struct ep11_urb *xcrb,
 		     struct ap_message *ap_msg,
 		     unsigned int *fc, unsigned int *dom);
-- 
2.53.0



