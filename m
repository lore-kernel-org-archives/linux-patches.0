Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827114;
	b=VF5m2yjPVi4+Si8+yk1cox2/b5pjDosXf8n18jpUesZQV+15iIHQThnIOWyTDoW08HhP
	 x/OiprrKfITsmyU4Lyvse4WF06SvXAgf0Rnp1JSCrudYHBlwTB+Co1nS8s9gESw3SXs/j
	 BR8k0OFIq1Bh3H/d/Hu/ogwumTzVqCuDPqBGRdKgZga9k0hPhZY/uV50WGUstprinqT6V
	 FrKOXnA3sXtH1IOK5EZRFVEKVYOsb2QDVjWIKRSporhJBBEdSuraIOOKjxpUB+G0ifGIJ
	 /vlbc6cEnq9l0PnZw9QmMZiHnqHjCe2nzLKTGih7GqaL5IBaSzg7K0klwezpZDzW1qQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827114;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q1I9B1YC8fn/z1Dv+9pP37iLTHnOLmt9Uo1solpIGnM=;
	b=065zZALCEt/ts9eUvviEf2C7jj2G22/cUcUmLJaIodCjP7aiiHBhXQ46vdNVmJ/jGaV7
	 KMCEj24CfzEqQGG1/B0nJQrUfdOgxHkVuxKcNHXzw9+dIpMpAkitnJbhkZXUvOTfnibMa
	 lkxAcwThR6lRamAjKENoFoCCEbuSWdjURSa0Mcf6jbFzBy79eXJ7SqnX+KMhw1NyZwHyB
	 r0zv1p3MgG/sBDnu9P5wZvcl8eTswV5MEoo+11FhJvsNNbVtqS/EQM2YIJVF0GyIlu0tN
	 /UVt4rZwulcpMxQZz+BvZhd8GsW4um3hMScV2Kr8BKArYY4kqTtEdH38xwXhPNXHaFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MZ8Hdsqs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F25606A847;
	Wed,  4 Nov 2026 21:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MZ8Hdsqs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C362E1F00A18;
	Wed,  4 Nov 2026 21:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827114;
	bh=Q1I9B1YC8fn/z1Dv+9pP37iLTHnOLmt9Uo1solpIGnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MZ8HdsqsYWPUyznTx6GBY5Gpba0t/5H3K4xb6jvCbbU0tsoO3+mazBGo89tcGsA58
	 UjGxpLwvcu6Af5BShc+5TGjxdu4SEhDHpi7AKDv0R3xiqAtIADdnirWnDsy5we5Ltj
	 tucKn8pWhA1axuGIhMH1/yqflBAu0sUvaAgi7lHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 7.3 182/547] s390/zcrypt: Guard domain index uses against speculative bypass
Date: Wed,  4 Nov 2026 16:06:06 -0500
Message-ID: <20261104211043.318444214@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Harald Freudenberger <freude@linux.ibm.com>

commit 7b88e8b6d714cd1b2b6185e2963c8ec4d98542d0 upstream.

The previous array_index_nospec() placement only covered the admin
permission check, leaving ap_test_config_usage_domain() and
ap_test_config_ctrl_domain() in the CCA path exposed to speculative
execution.

Move the sanitization to before all permission and config checks in
both the CCA and EP11 paths. Hold the sanitized domain value in
another variable so that the later use can choose to use either the
original value (subject to speculative execution) or the sanitized
value (which may in case of AUTOSEL_DOM reflect the wrong
value). Before that, check the domain value to be either AUTOSEL_DOM
or in range 0...AP_DOMAINS-1 and return with -EINVAL in case this check
does not pass.

Fixes: e935cd525af4 ("s390/zcrypt: Close speculative mem read possibility")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Cc: stable@vger.kernel.org
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/zcrypt_api.c |   35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

--- a/drivers/s390/crypto/zcrypt_api.c
+++ b/drivers/s390/crypto/zcrypt_api.c
@@ -854,7 +854,7 @@ static long _zcrypt_send_cprb(u32 xflags
 			      struct ica_xcRB *xcrb)
 {
 	bool userspace = xflags & ZCRYPT_XFLAG_USERSPACE;
-	unsigned int card, domain, func_code = 0;
+	unsigned int card, domain, _dom, func_code = 0;
 	unsigned int wgt = 0, pref_wgt = 0;
 	struct zcrypt_queue *zq, *pref_zq;
 	struct zcrypt_card *zc, *pref_zc;
@@ -877,10 +877,17 @@ static long _zcrypt_send_cprb(u32 xflags
 	print_hex_dump_debug("ccareq: ", DUMP_PREFIX_ADDRESS, 16, 1,
 			     ap_msg.msg, ap_msg.len, false);
 
+	/* Check domain for either AUTOSEL_DOM or in range 0...AP_DOMAINS-1 */
+	if (domain != AUTOSEL_DOM && domain >= AP_DOMAINS) {
+		rc = -EINVAL;
+		goto out;
+	}
+	/* Spectre-v1: sanitize domain unconditionally for later use */
+	_dom = array_index_nospec(domain, AP_DOMAINS);
+
 	if (perms != &ap_perms && domain < AP_DOMAINS) {
 		if (ap_msg.flags & AP_MSG_FLAG_ADMIN) {
-			domain = array_index_nospec(domain, AP_DOMAINS);
-			if (!test_bit_inv(domain, perms->adm)) {
+			if (!test_bit_inv(_dom, perms->adm)) {
 				rc = -ENODEV;
 				goto out;
 			}
@@ -893,10 +900,11 @@ static long _zcrypt_send_cprb(u32 xflags
 	 * If a valid target domain is set and this domain is NOT a usage
 	 * domain but a control only domain, autoselect target domain.
 	 */
-	if (domain < AP_DOMAINS &&
-	    !ap_test_config_usage_domain(domain) &&
-	    ap_test_config_ctrl_domain(domain))
-		domain = AUTOSEL_DOM;
+	if (domain < AP_DOMAINS) {
+		if (!ap_test_config_usage_domain(_dom) &&
+		    ap_test_config_ctrl_domain(_dom))
+			domain = AUTOSEL_DOM;
+	}
 
 	pref_zc = NULL;
 	pref_zq = NULL;
@@ -1041,7 +1049,7 @@ static long _zcrypt_send_ep11_cprb(u32 x
 	struct ep11_target_dev *targets = NULL;
 	unsigned short target_num;
 	unsigned int wgt = 0, pref_wgt = 0;
-	unsigned int func_code = 0, domain;
+	unsigned int func_code = 0, domain, _dom;
 	struct ap_message ap_msg;
 	int cpen, qpen, qid = 0, rc;
 	struct module *mod;
@@ -1078,10 +1086,17 @@ static long _zcrypt_send_ep11_cprb(u32 x
 	print_hex_dump_debug("ep11req: ", DUMP_PREFIX_ADDRESS, 16, 1,
 			     ap_msg.msg, ap_msg.len, false);
 
+	/* Check domain for either AUTOSEL_DOM or in range 0...AP_DOMAINS-1 */
+	if (domain != AUTOSEL_DOM && domain >= AP_DOMAINS) {
+		rc = -EINVAL;
+		goto out;
+	}
+	/* Spectre-v1: sanitize domain unconditionally for later use */
+	_dom = array_index_nospec(domain, AP_DOMAINS);
+
 	if (perms != &ap_perms && domain < AP_DOMAINS) {
 		if (ap_msg.flags & AP_MSG_FLAG_ADMIN) {
-			domain = array_index_nospec(domain, AP_DOMAINS);
-			if (!test_bit_inv(domain, perms->adm)) {
+			if (!test_bit_inv(_dom, perms->adm)) {
 				rc = -ENODEV;
 				goto out;
 			}


