Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F48471250;
	Tue, 21 Jul 2026 18:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658971; cv=none; b=WN8/bVwciPLDKH/3WItBp96O/E7jDSSJsT1BtnsY81RYfHFoFugMlcwegCVzUStrNI04vih8CxwMDNFrnYIofR9waMFgf9XGPMcfN/TUcpibAhO+uHsWS/pfjp9cHqnO/dr5pnW6wkl+3MX8DS9eGj/XpkFu7U60bUOeyIQLaMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658971; c=relaxed/simple;
	bh=9EsRJhinwwk585h1m8M1cIIqg1sCxef9GaDDjkcN0iQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KD2o5wuNnGaHGKm49IKGJzG4tnl3tVqLrpQKD3cieo7sKSShRLhcKBA6vjbw6Rx2sBqEdWrU1vR7FyZN/RFDN5dS0cJBL0v3yjn04KLZgbZtAyA2kt1yOJb78DLmcIxVDF5Z9/RoKsF+YXavYthybzeyWpce/g9E1VaAaQ9GyUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hjErBZHh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hjErBZHh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 266891F000E9;
	Tue, 21 Jul 2026 18:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658970;
	bh=XEmUUXRTe0osEb1TlSEluVsVueLb9GmpPGSBWnide04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hjErBZHhydUDbj/6L4vw2zaUF1vuIlPx0Up9tdxSNPGaQL4nKBMj4lr9dNMFTq6sN
	 1GiW7Z88xAE4vvWGltYgYRV6r9u4CvkjvBDtjbsF1OBt2SpIvH1mrIkPYD3QkRZs6q
	 6kqSJbxCHfHKr0Ho+Bbq87uSVWuUolYRMjFTyRK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Franzki <ifranzki@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	stable@kernel.org
Subject: [PATCH 6.18 1302/1611] pkey: Move keytype check from pkey api to handler
Date: Tue, 21 Jul 2026 17:23:38 +0200
Message-ID: <20260721152544.732585376@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Holger Dengler <dengler@linux.ibm.com>

commit 754e9e49b76fd5be339172aa98544182ed3ca75e upstream.

The PKEY_VERIFYPROTK ioctl takes data from user-space and verifies the
contained protected key. While checking the integrity of the ioctl
request structure is the responsibility of the generic pkey_api code,
the verification of the contained protected key is the responsibility
of the pkey handler.

The keytype verification (based on the calculated bitsize of the key)
is part of the protected key verification and therefore the
responsibility of the pkey handler (which already verifies
it). Therefore the keytype verification is removed from the generic
pkey_api code.

As the calculation of the key bitsize is currently wrong, the removal
of the keytype check in pkey_api also removes this wrong
calculation. For this reason, the commit is flagged with the Fixes:
tag.

Cc: stable@kernel.org # 6.12+
Fixes: 8fcc231ce3be ("s390/pkey: Introduce pkey base with handler registry and handler modules")
Reviewed-by: Ingo Franzki <ifranzki@linux.ibm.com>
Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/pkey_api.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/drivers/s390/crypto/pkey_api.c
+++ b/drivers/s390/crypto/pkey_api.c
@@ -328,7 +328,6 @@ static int pkey_ioctl_verifyprotk(struct
 {
 	struct pkey_verifyprotk kvp;
 	struct protaeskeytoken *t;
-	u32 keytype;
 	u8 *tmpbuf;
 	int rc;
 
@@ -342,14 +341,6 @@ static int pkey_ioctl_verifyprotk(struct
 		return -EINVAL;
 	}
 
-	keytype = pkey_aes_bitsize_to_keytype(8 * kvp.protkey.len);
-	if (!keytype) {
-		PKEY_DBF_ERR("%s unknown/unsupported protkey length %u\n",
-			     __func__, kvp.protkey.len);
-		memzero_explicit(&kvp, sizeof(kvp));
-		return -EINVAL;
-	}
-
 	/* build a 'protected key token' from the raw protected key */
 	tmpbuf = kzalloc(sizeof(*t), GFP_KERNEL);
 	if (!tmpbuf) {
@@ -359,7 +350,7 @@ static int pkey_ioctl_verifyprotk(struct
 	t = (struct protaeskeytoken *)tmpbuf;
 	t->type = TOKTYPE_NON_CCA;
 	t->version = TOKVER_PROTECTED_KEY;
-	t->keytype = keytype;
+	t->keytype = kvp.protkey.type;
 	t->len = kvp.protkey.len;
 	memcpy(t->protkey, kvp.protkey.protkey, kvp.protkey.len);
 


