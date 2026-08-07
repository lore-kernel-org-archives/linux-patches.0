Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA662E762C;
	Fri,  7 Aug 2026 14:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114298; cv=none; b=Amfg+JLI0LGFXNGOw/NYhCqt9jF7xZm1WzU552oY9rwkWm2fH7JYl8HVdHzi3D/+aeCrwQRyiOqOPZyDiQkiziWdH7Gd6nI5ZYOVJyttCCSog6Lq556zsvKjrDZfeW0NK7KFtLwW1IQTFsAIdR3dZVxuqqLwJVUacL91fVXhe6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114298; c=relaxed/simple;
	bh=EhIahX4AbRrb2Rr91gRDYtP0z8jyKMbXP9iUS4HrYzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hipg9wWmyZg3MyKYarQC28+wQgD2uyDkg6xG8hiyInvG4kOaEyrOCqvE1PfE3Rrv1TaL/rvZ94iEuHZ1ERygYe8yHt/axtUaYofQ/N0Z7MVWU61tWs/6m8AbWN1Ew3/OVOKNLDrEgEaBfeByXEqO0tNnsuohjO05CeFAHV/V/vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o6VRblwM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o6VRblwM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01CA41F000E9;
	Fri,  7 Aug 2026 14:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114297;
	bh=eQgf8Hy46cq1+WG48jBLsz6vsJBkhN5VZ0fsKNeElYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o6VRblwM4dBxJEkJG+Tk/tBtWWIRaVmSXUaJABD7FIc4sXiupY/bbKWT/GwqJHMX9
	 KnInjzMHgGAjrssmt9IZSqCAm+xmOO3kYgeSVkYgkhMB33FYCVV3kWETh8PK7z5ZtT
	 50+0qrc0iMZdJOgCb2cd6GFEL2vwPqesiRYuEiZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Finn Callies <fcallies@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.12 212/337] s390/zcrypt: Fix wrong domain value verification with EP11 CPRBs
Date: Fri,  7 Aug 2026 16:36:55 +0200
Message-ID: <20260807143423.150604143@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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
@@ -1071,7 +1071,7 @@ static long _zcrypt_send_ep11_cprb(bool
 	print_hex_dump_debug("ep11req: ", DUMP_PREFIX_ADDRESS, 16, 1,
 			     ap_msg.msg, ap_msg.len, false);
 
-	if (perms != &ap_perms && domain < AUTOSEL_DOM) {
+	if (perms != &ap_perms && domain < AP_DOMAINS) {
 		if (ap_msg.flags & AP_MSG_FLAG_ADMIN) {
 			if (!test_bit_inv(domain, perms->adm)) {
 				rc = -ENODEV;


