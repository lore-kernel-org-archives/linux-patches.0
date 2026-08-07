Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2224756C0;
	Fri,  7 Aug 2026 15:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117505; cv=none; b=HN9QBMq0aAo/Wb426JYerP4kHquu7tzgDrTuiITokmdGTdRk0pu5L9sioiRgE4hQ9kkSM9d9TK+xwtZ1nWJ4PGE+ssMctu9PUUaK5lyI6qI0+kZZJQhAjo4x5gbvATqiDZ2hYlr4pqKInaplEm34UWbSTY5zXqHLfeFRVVEDhtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117505; c=relaxed/simple;
	bh=gAF1pN1TdiAMXT/GCpRsMiXIJIRJNhfd2Ux1F60lqco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YwgtzaoVHD6CxBPZb0/8hj3meS8EUCW+IQikozXQu9ICVL0Hu0VYnvdafjm8+h7SPKbypRQy6kPKzQl6aiiU4NCVM1eAMqk6VlCwEul8oD99surldeMqlLYe91vpzcs6i91hVNK+yu8GK4WuwltJLLoTxnazCNzqfIbrAcFkW6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ituYs+6h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ituYs+6h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69AA31F000E9;
	Fri,  7 Aug 2026 15:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117504;
	bh=nQ8MwjYADp56u7FsPq4Oj/5EHs9uvwdKtGP8gvnxZMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ituYs+6hNBrcjKey9DVLoyOczGNQqACFWnwjAnI4W9zATpVBma1zTxYRAE04M+Bxj
	 mnfU+q+PX/7MonT90EP8iV0bEVOq5uiZz8rNTU0XWxBEemaRPMbDv2+2cGMhvOw4FN
	 rHqm0pZJzhUaNCRbEBnRWW3DAZUWe+oxywjy50Fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Finn Callies <fcallies@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 7.1 341/438] s390/zcrypt: Fix wrong domain value verification with EP11 CPRBs
Date: Fri,  7 Aug 2026 16:38:57 +0200
Message-ID: <20260807143435.242558065@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harald Freudenberger <freude@linux.ibm.com>

commit 983279d7f86ade73db86f886e09172dd567031b5 upstream.

There is a wrong upper limit check for the domain value when an EP11
CPRB is processed for sending to a crypto card. This check is only
active on custom device nodes but may lead to access heap memory
behind perms->adm when an administrative CPRB is sent.
Add correct limit (AP_DOMAINS = 256) checking to fix this.

Fixes: cfd68b33094e ("s390/zcrypt: Filter admin CPRBs on custom devices")
Cc: stable@vger.kernel.org
Reviewed-by: Finn Callies <fcallies@linux.ibm.com>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/zcrypt_api.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/s390/crypto/zcrypt_api.c
+++ b/drivers/s390/crypto/zcrypt_api.c
@@ -1077,7 +1077,7 @@ static long _zcrypt_send_ep11_cprb(u32 x
 	print_hex_dump_debug("ep11req: ", DUMP_PREFIX_ADDRESS, 16, 1,
 			     ap_msg.msg, ap_msg.len, false);
 
-	if (perms != &ap_perms && domain < AUTOSEL_DOM) {
+	if (perms != &ap_perms && domain < AP_DOMAINS) {
 		if (ap_msg.flags & AP_MSG_FLAG_ADMIN) {
 			if (!test_bit_inv(domain, perms->adm)) {
 				rc = -ENODEV;


