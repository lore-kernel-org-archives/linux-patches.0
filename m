Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC54B50128E;
	Tue, 13 Oct 2026 12:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893718; cv=none; b=Ic6Zdw6L1NT8II9sDN3r76IQciaDFwrVcKyC+Tlzk/6y238JKZAb/0KWMDOwIFGuT8LZsnGKi6tOAxhlOsYZ+t2l+FhMvgmHAw2TX/5ruBM4GZHkJYlNCm/H/jsjp2aqgTuk60drYJDSgldWSSPSXUNpE+y77nClP99zvjS82Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893718; c=relaxed/simple;
	bh=i3OA2gp0G7fqTLzqokqQ2sOaUMJbTyAyIV5uVDdBZoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fEE1hrXv8Il9pV2TLhPMcC4KStlVLCtUTxVMfhYaV8bWnuS0QfjOAoRdNzQVymW+v2OcdyIHTKzy2snS1uNkp+giznNFSNFe2flL9FsUPulhnWyGrIFDzrMkeLc4lYJDnJ7gIXwlhf82FkS+3ynk8J5iuMGSRq1j4kWJZnIcwpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YTQeyXCR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YTQeyXCR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06761F000FF;
	Tue, 13 Oct 2026 12:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893716;
	bh=1Xst/Us9nhCHVH1ObiFPPkuxi+4vrGKfKFop62vM/5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YTQeyXCRY8NP0YbWKfZEMJD36O9yvH/vOEElOPQdN/NHCzT3Hdn6WJZ6LuyBHYfoB
	 SUPVTa41OG7FzUuXHnH3/hA5S7Du5P0VlMrkIO4QBKUWsjJpgbAlQRsq9X3xLf/fdr
	 MFJR0fteFwavgiYi2DLXySNIX/gBlqOvrIVwGWb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 319/621] s390/zcrypt: Rework domain processing within zcrypt device driver
Date: Tue, 13 Oct 2026 13:35:14 +0200
Message-ID: <20261013112928.422873554@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index a25b58e06f923..9b705346f845a 100644
--- a/drivers/s390/crypto/zcrypt_api.c
+++ b/drivers/s390/crypto/zcrypt_api.c
@@ -854,13 +854,12 @@ static long _zcrypt_send_cprb(u32 xflags, struct ap_perms *perms,
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
@@ -878,10 +877,9 @@ static long _zcrypt_send_cprb(u32 xflags, struct ap_perms *perms,
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
@@ -894,10 +892,10 @@ static long _zcrypt_send_cprb(u32 xflags, struct ap_perms *perms,
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
@@ -929,8 +927,8 @@ static long _zcrypt_send_cprb(u32 xflags, struct ap_perms *perms,
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
@@ -953,16 +951,11 @@ static long _zcrypt_send_cprb(u32 xflags, struct ap_perms *perms,
 
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
@@ -1218,7 +1211,6 @@ static long zcrypt_rng(char *buffer)
 	unsigned int wgt = 0, pref_wgt = 0;
 	unsigned int func_code = 0;
 	struct ap_message ap_msg;
-	unsigned int domain;
 	int qid = 0, rc = -ENODEV;
 	struct module *mod;
 
@@ -1227,7 +1219,7 @@ static long zcrypt_rng(char *buffer)
 	rc = ap_init_apmsg(&ap_msg, 0);
 	if (rc)
 		goto out;
-	rc = prep_rng_ap_msg(&ap_msg, &func_code, &domain);
+	rc = prep_rng_ap_msg(&ap_msg, &func_code, NULL);
 	if (rc)
 		goto out;
 
diff --git a/drivers/s390/crypto/zcrypt_msgtype6.c b/drivers/s390/crypto/zcrypt_msgtype6.c
index cbf9dc5c71cb7..2578384705592 100644
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
@@ -1053,7 +1055,7 @@ static long zcrypt_msgtype6_modexpo_crt(struct zcrypt_queue *zq,
  */
 int prep_cca_ap_msg(bool userspace, struct ica_xcRB *xcrb,
 		    struct ap_message *ap_msg,
-		    unsigned int *func_code, unsigned short **dom)
+		    unsigned int *func_code, unsigned int *domain)
 {
 	struct ap_response_type *resp_type = &ap_msg->response;
 
@@ -1061,7 +1063,8 @@ int prep_cca_ap_msg(bool userspace, struct ica_xcRB *xcrb,
 	ap_msg->psmid = (((unsigned long)current->pid) << 32) +
 				atomic_inc_return(&zcrypt_step);
 	resp_type->type = CEXXC_RESPONSE_TYPE_XCRB;
-	return xcrb_msg_to_type6cprb_msgx(userspace, ap_msg, xcrb, func_code, dom);
+	return xcrb_msg_to_type6cprb_msgx(userspace, ap_msg,
+					  xcrb, func_code, domain);
 }
 
 /*
@@ -1106,6 +1109,9 @@ static long zcrypt_msgtype6_send_cprb(bool userspace, struct zcrypt_queue *zq,
 		msg->hdr.fromcardlen1 -= delta;
 	}
 
+	/* update domain field within the CPRB struct */
+	msg->cprbx.domain = AP_QID_QUEUE(zq->queue->qid);
+
 	init_completion(&resp_type->work);
 	rc = ap_queue_message(zq->queue, ap_msg);
 	if (rc)
@@ -1211,8 +1217,7 @@ static long zcrypt_msgtype6_send_ep11_cprb(bool userspace, struct zcrypt_queue *
 			lfmt = 1; /* length format #1 */
 		}
 		payload_hdr = (struct pld_hdr *)((&msg->pld_lenfmt) + lfmt);
-		payload_hdr->dom_val = (unsigned int)
-					AP_QID_QUEUE(zq->queue->qid);
+		payload_hdr->dom_val = AP_QID_QUEUE(zq->queue->qid);
 	}
 
 	/*
@@ -1293,7 +1298,8 @@ static inline void rng_type6cprb_msgx(struct ap_message *ap_msg,
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



