Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E14C33DEF7;
	Fri,  7 Aug 2026 15:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116230; cv=none; b=U2iHkNEypYCw78jWAO/FllA1IWIarOzUBo6iFDwQ60UkWtoIk4MM2LlS6sfHS8yZ9Z/jWCGCd89cM5MonOhUkGtxeqHG1d1gJw63orIGV3/leqKVuxWsfU3/bfYhf40fIOkqIRcMOolDLgxz1wlheYYNOtqAuI23SrQiIf20WK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116230; c=relaxed/simple;
	bh=S0WhwCSeNV5iddZOD44AX2sHK3oVdZbWygB1cxUY5Ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SbbZzRpt8nXJjrptSg77gVKudDElivuriTxmSIsiCyfLXYjx9TeAWMTQ6v5x58lI1VcU4r5HovpOmRPo1EYRWaLVJttIbPiFTjzPLYhCSF8bDjtcEhieS9jSSB/j4GnDvh7GxLdkxIQ9iq7FT5aNdlXGqcJ5Js54rzaSTJ44IV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VBB6kHWS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VBB6kHWS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987461F000E9;
	Fri,  7 Aug 2026 15:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116229;
	bh=BkRYmRCK2uO/cWt68xGdrWEBTcjvdxjQ/Wr98tDCSfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VBB6kHWSTBYNFSNttJsJgrkr14491vqAsljp3mXt1awgYUF8yz2b8pm1WSqkmglas
	 O1Z9q13R+hBWtAIWMBvTApIqVIsjFyZ47DxbO4/O7Q4K3KmwhQ8qgtPmKJFMLFYqGc
	 jLVnL/Z6b5M/sK/kFe4uOzQEqnUle7bLCDQgYS+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Finn Callies <fcallies@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.6 156/261] s390/zcrypt: Fix wrong domain value verification with EP11 CPRBs
Date: Fri,  7 Aug 2026 16:38:33 +0200
Message-ID: <20260807143418.733999118@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1048,7 +1048,7 @@ static long _zcrypt_send_ep11_cprb(bool
 	if (rc)
 		goto out_free;
 
-	if (perms != &ap_perms && domain < AUTOSEL_DOM) {
+	if (perms != &ap_perms && domain < AP_DOMAINS) {
 		if (ap_msg.flags & AP_MSG_FLAG_ADMIN) {
 			if (!test_bit_inv(domain, perms->adm)) {
 				rc = -ENODEV;


