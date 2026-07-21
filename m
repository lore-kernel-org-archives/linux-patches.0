Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19EB37647B;
	Tue, 21 Jul 2026 17:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654660; cv=none; b=BoB7k58QWr1vqWZMgWzkx1jJ0IcTr7wa0YgHdxOEkJXO93O+EEygOcCqiaFEZtYG9lGY+lDhTUSt4h9Lv4E5webLPNoZgbW9x0TyraTRT8l8dedlUDUYFaggc/1RXyHEE7lCE6R0ay4BFI4Ut9ustibUMjS3b1DvVHOu0wQAALQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654660; c=relaxed/simple;
	bh=rxm10qnquuUddy3ejxtJqtjrN0MW3tqJ8HviF+4HGUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qwTvU0CHIgwgW55l1XlH62R5GKftuXjRdlpMILz+iuvnic9L76zOj/Himh9bOYWZu96H8y5DpYxICH+BuCoH0c8Z1XiGUE088lRsSVWwMVzfEwTSihdXuOkP12YsxQ+ZYevi32t/kkO5o5AF1Th+kKnCitGb7/YegiUDexsFBQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B9HWTJBU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B9HWTJBU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7501F000E9;
	Tue, 21 Jul 2026 17:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654659;
	bh=JRgu6wdsMKguJTek/LwfsnE4604dHRcGm43ySgSWlhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B9HWTJBURtY3H8qFNRTFbZzjYO60frPok/MCysaiPFyg+ld2MTQXkA139D40VeXXr
	 qdiWR9Lp2lQBaQ++/piCMVPoAEi39cyRwkw1/drZSn4zLC3nW4pt1YV0xx7oQXowhN
	 jj6EuwVUT5a78q6f8j+tI0oYTRv3/ZtFSz5/xhts=
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
Subject: [PATCH 7.1 1788/2077] pkey: Move keytype check from pkey api to handler
Date: Tue, 21 Jul 2026 17:24:21 +0200
Message-ID: <20260721152634.917285425@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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
@@ -327,7 +327,6 @@ static int pkey_ioctl_verifyprotk(struct
 {
 	struct pkey_verifyprotk kvp;
 	struct protaeskeytoken *t;
-	u32 keytype;
 	u8 *tmpbuf;
 	int rc;
 
@@ -341,14 +340,6 @@ static int pkey_ioctl_verifyprotk(struct
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
@@ -358,7 +349,7 @@ static int pkey_ioctl_verifyprotk(struct
 	t = (struct protaeskeytoken *)tmpbuf;
 	t->type = TOKTYPE_NON_CCA;
 	t->version = TOKVER_PROTECTED_KEY;
-	t->keytype = keytype;
+	t->keytype = kvp.protkey.type;
 	t->len = kvp.protkey.len;
 	memcpy(t->protkey, kvp.protkey.protkey, kvp.protkey.len);
 


