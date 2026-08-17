Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB64442FD1;
	Mon, 17 Aug 2026 15:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980049; cv=none; b=WJP9LM3wAw4M0tS0p8c+0maDi+X3CGn6gyG8ZbzKhfOgLQOxYqgZ7fK6GI5Nxhd+ROm9V2+Eq7ILUEJxlvTiy0PRf+FmDzzsjS64k9t/OBiK9GI1RVE5wwoEMvSsifPeRayMEzsbBxKa6k9PqgZkSshxa6e8kpJYNAgMxKK+hl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980049; c=relaxed/simple;
	bh=Nzjx4Pu6L5JzxRAHsLs6LBgKcgqaKRWpwmNlO7ouUow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n5r/qHkfbrrDDGzsx2EmAKBpOFCLO0X79atkzYO1UcoPcjgCc8T+0LJ1qcGgfOI9DXu7e+Pzn84yk0iLpXSdM4N2F1GHglHj74xelSg24+LTuL54TNH6/HlhKT4QLpoyzfZg3DGbrYAbl3I7u8l/Tm/WjP+LcZoEl0X5t70oqxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KinEgCb5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KinEgCb5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B68991F00A3E;
	Mon, 17 Aug 2026 15:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980048;
	bh=wATLH7eqpkZBKCtRBqwOAPV9g0YaUFDpiK8pLpHmsm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KinEgCb58kii4OTmEDfmqu0QbKMuY5QpNaXWZaQPC1xhOEQSusPAX8UQT3dYnBbMp
	 6+rO+5t7iO6vlGa9PCVL52G4SBtkUf3Nf9OUakT9T6SSmGZCpzSKV5K3J1ZnwPCti6
	 XIiiHNhQACPAmAlV2YwJ8bPOOyDmzXXWH6Hahak4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Finn Callies <fcallies@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.1 437/609] s390/zcrypt: Fix wrong domain value verification with EP11 CPRBs
Date: Mon, 17 Aug 2026 15:32:13 +0200
Message-ID: <20260817132558.729724577@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1119,7 +1119,7 @@ static long _zcrypt_send_ep11_cprb(bool
 	if (rc)
 		goto out_free;
 
-	if (perms != &ap_perms && domain < AUTOSEL_DOM) {
+	if (perms != &ap_perms && domain < AP_DOMAINS) {
 		if (ap_msg.flags & AP_MSG_FLAG_ADMIN) {
 			if (!test_bit_inv(domain, perms->adm)) {
 				rc = -ENODEV;


