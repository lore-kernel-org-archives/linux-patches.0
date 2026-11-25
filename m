Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622280;
	b=g8dTxzTBg/D+K3PohtxS5Ihn5AgXh2CsjxH7quQmKbjPd9szDikSKHC/CNIOO0dt0R9S
	 BaHpj9ep2WeIN6e9qV8MSqRVLp5D5g1CMl7KT7DpFco0gI6J0ndwo3OTEYm3nkCdoTUKp
	 9ng7Np9LJemXUChBeGmD/9vZR4QhGaPVbs+ZyzjeKHP68cLQujqWxzjbJ3NZtpUwmpYfc
	 6Fl/QFS6dirjRZkHFUjhlIgggcTV0vvonCEWbfCnuLQV6s+z5Ye1GAOFjsF4ONyt1ffO7
	 HtrssCEriG4lkYN/zhWf4OCPCi7Sh6fojDJOd++fmPKz/kgr9Uxjjr+R/3rDnpreVrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622280;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n5ioSjBVeZHt/5xHR7Hwi3FTQlYvd0lIDIZeMOGB4s0=;
	b=wi2uQ30vOiZdJvoOCuZSZQZrp9nqrTQBA0yK00yoesJfvf0AL4mzlwY2iIdU4r1eoAyr
	 n7yjeFnotW2tSi2su/WO0/KeRifeR8C9KcLfpGLPrEaFCoyjXLD62GqXGgMW68Of7XFnO
	 zqjNW50DE3SOB+q5B65JUapEDBADN1ily5ylCMfYd7cz8iR4TJu2rjeQhRfpvRGPQQYxF
	 26n+NWLO/e1m3rlu3zINZJ0mqW0phRZowPzOkbcerzpLeAZ1Fm98YryXS4b9ogMK2zsPA
	 oVOLCznGyqLMjiZpMPc9SD1IrdSNR6OzbXmfk8tVW0zdrmF68d5Ga4Bb8z7tH6C1/fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e3PsR2pC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415D6606A321;
	Wed, 25 Nov 2026 15:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e3PsR2pC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F9C1F000C6;
	Wed, 25 Nov 2026 15:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622280;
	bh=n5ioSjBVeZHt/5xHR7Hwi3FTQlYvd0lIDIZeMOGB4s0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e3PsR2pCZkQzvBi7Pu1NL2PcyvgpvMimenAX4yRCkSAPUwuV1R914ZaD46zZq6wxt
	 945HUrm7WvVUSFzyGytVayO+NYJbqhUC5tKyyiY85wjfVq+yq+m1dqF04EgFpp1l6o
	 NgSr5wzrQHz+DLExKEA/3EtUpjK/ZD/oD58clsY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 486/990] s390/zcrypt: Guard domain index uses against speculative bypass
Date: Wed, 25 Nov 2026 15:30:53 +0100
Message-ID: <20261125143833.478630393@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harald Freudenberger <freude@linux.ibm.com>

[ Upstream commit 7b88e8b6d714cd1b2b6185e2963c8ec4d98542d0 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/zcrypt_api.c | 35 +++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/drivers/s390/crypto/zcrypt_api.c b/drivers/s390/crypto/zcrypt_api.c
index 640a5b35081f6..bcdfb7cb2fd52 100644
--- a/drivers/s390/crypto/zcrypt_api.c
+++ b/drivers/s390/crypto/zcrypt_api.c
@@ -854,7 +854,7 @@ static long _zcrypt_send_cprb(u32 xflags, struct ap_perms *perms,
 			      struct ica_xcRB *xcrb)
 {
 	bool userspace = xflags & ZCRYPT_XFLAG_USERSPACE;
-	unsigned int card, domain, func_code = 0;
+	unsigned int card, domain, _dom, func_code = 0;
 	unsigned int wgt = 0, pref_wgt = 0;
 	struct zcrypt_queue *zq, *pref_zq;
 	struct zcrypt_card *zc, *pref_zc;
@@ -877,10 +877,17 @@ static long _zcrypt_send_cprb(u32 xflags, struct ap_perms *perms,
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
@@ -893,10 +900,11 @@ static long _zcrypt_send_cprb(u32 xflags, struct ap_perms *perms,
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
@@ -1040,7 +1048,7 @@ static long _zcrypt_send_ep11_cprb(u32 xflags, struct ap_perms *perms,
 	struct ep11_target_dev *targets = NULL;
 	unsigned short target_num;
 	unsigned int wgt = 0, pref_wgt = 0;
-	unsigned int func_code = 0, domain;
+	unsigned int func_code = 0, domain, _dom;
 	struct ap_message ap_msg;
 	int cpen, qpen, qid = 0, rc;
 	struct module *mod;
@@ -1077,10 +1085,17 @@ static long _zcrypt_send_ep11_cprb(u32 xflags, struct ap_perms *perms,
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
-- 
2.53.0



