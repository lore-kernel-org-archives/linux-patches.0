Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC3E495D7;
	Wed, 20 Dec 2023 16:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x9g3PDYv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF65C433C7;
	Wed, 20 Dec 2023 16:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088716;
	bh=BNrT+xase34fTr3Dl95SzEEY3DrGQlDk7Dr5E0ziqc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x9g3PDYvXvKlImpMPNNCQ26ZUCM/E+FlYUQsoyp3XiyxehYeXVQevCo1o60jTEAyc
	 GMRGsWJeEhTYfjBPW2ZzJKT5iMiL0I6Sfh5syWEwpWq2SP9ebXNj/jifu54H20j/OZ
	 Z3wxsNCA2eXOxe0DNOSHMvkJ0R9vgmcX0jXSC+Hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 008/159] ksmbd: use oid registry functions to decode OIDs
Date: Wed, 20 Dec 2023 17:07:53 +0100
Message-ID: <20231220160931.673756729@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunchul Lee <hyc.lee@gmail.com>

[ Upstream commit 294277410cf3b46bee2b8282ab754e52975c0a70 ]

Use look_up_OID to decode OIDs rather than
implementing functions.

Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/asn1.c |  142 +++++++-------------------------------------------------
 1 file changed, 19 insertions(+), 123 deletions(-)

--- a/fs/ksmbd/asn1.c
+++ b/fs/ksmbd/asn1.c
@@ -21,101 +21,11 @@
 #include "ksmbd_spnego_negtokeninit.asn1.h"
 #include "ksmbd_spnego_negtokentarg.asn1.h"
 
-#define SPNEGO_OID_LEN 7
 #define NTLMSSP_OID_LEN  10
-#define KRB5_OID_LEN  7
-#define KRB5U2U_OID_LEN  8
-#define MSKRB5_OID_LEN  7
-static unsigned long SPNEGO_OID[7] = { 1, 3, 6, 1, 5, 5, 2 };
-static unsigned long NTLMSSP_OID[10] = { 1, 3, 6, 1, 4, 1, 311, 2, 2, 10 };
-static unsigned long KRB5_OID[7] = { 1, 2, 840, 113554, 1, 2, 2 };
-static unsigned long KRB5U2U_OID[8] = { 1, 2, 840, 113554, 1, 2, 2, 3 };
-static unsigned long MSKRB5_OID[7] = { 1, 2, 840, 48018, 1, 2, 2 };
 
 static char NTLMSSP_OID_STR[NTLMSSP_OID_LEN] = { 0x2b, 0x06, 0x01, 0x04, 0x01,
 	0x82, 0x37, 0x02, 0x02, 0x0a };
 
-static bool
-asn1_subid_decode(const unsigned char **begin, const unsigned char *end,
-		  unsigned long *subid)
-{
-	const unsigned char *ptr = *begin;
-	unsigned char ch;
-
-	*subid = 0;
-
-	do {
-		if (ptr >= end)
-			return false;
-
-		ch = *ptr++;
-		*subid <<= 7;
-		*subid |= ch & 0x7F;
-	} while ((ch & 0x80) == 0x80);
-
-	*begin = ptr;
-	return true;
-}
-
-static bool asn1_oid_decode(const unsigned char *value, size_t vlen,
-			    unsigned long **oid, size_t *oidlen)
-{
-	const unsigned char *iptr = value, *end = value + vlen;
-	unsigned long *optr;
-	unsigned long subid;
-
-	vlen += 1;
-	if (vlen < 2 || vlen > UINT_MAX / sizeof(unsigned long))
-		goto fail_nullify;
-
-	*oid = kmalloc(vlen * sizeof(unsigned long), GFP_KERNEL);
-	if (!*oid)
-		return false;
-
-	optr = *oid;
-
-	if (!asn1_subid_decode(&iptr, end, &subid))
-		goto fail;
-
-	if (subid < 40) {
-		optr[0] = 0;
-		optr[1] = subid;
-	} else if (subid < 80) {
-		optr[0] = 1;
-		optr[1] = subid - 40;
-	} else {
-		optr[0] = 2;
-		optr[1] = subid - 80;
-	}
-
-	*oidlen = 2;
-	optr += 2;
-
-	while (iptr < end) {
-		if (++(*oidlen) > vlen)
-			goto fail;
-
-		if (!asn1_subid_decode(&iptr, end, optr++))
-			goto fail;
-	}
-	return true;
-
-fail:
-	kfree(*oid);
-fail_nullify:
-	*oid = NULL;
-	return false;
-}
-
-static bool oid_eq(unsigned long *oid1, unsigned int oid1len,
-		   unsigned long *oid2, unsigned int oid2len)
-{
-	if (oid1len != oid2len)
-		return false;
-
-	return memcmp(oid1, oid2, oid1len) == 0;
-}
-
 int
 ksmbd_decode_negTokenInit(unsigned char *security_blob, int length,
 			  struct ksmbd_conn *conn)
@@ -252,26 +162,18 @@ int build_spnego_ntlmssp_auth_blob(unsig
 int ksmbd_gssapi_this_mech(void *context, size_t hdrlen, unsigned char tag,
 			   const void *value, size_t vlen)
 {
-	unsigned long *oid;
-	size_t oidlen;
-	int err = 0;
-
-	if (!asn1_oid_decode(value, vlen, &oid, &oidlen)) {
-		err = -EBADMSG;
-		goto out;
-	}
+	enum OID oid;
 
-	if (!oid_eq(oid, oidlen, SPNEGO_OID, SPNEGO_OID_LEN))
-		err = -EBADMSG;
-	kfree(oid);
-out:
-	if (err) {
+	oid = look_up_OID(value, vlen);
+	if (oid != OID_spnego) {
 		char buf[50];
 
 		sprint_oid(value, vlen, buf, sizeof(buf));
 		ksmbd_debug(AUTH, "Unexpected OID: %s\n", buf);
+		return -EBADMSG;
 	}
-	return err;
+
+	return 0;
 }
 
 int ksmbd_neg_token_init_mech_type(void *context, size_t hdrlen,
@@ -279,37 +181,31 @@ int ksmbd_neg_token_init_mech_type(void
 				   size_t vlen)
 {
 	struct ksmbd_conn *conn = context;
-	unsigned long *oid;
-	size_t oidlen;
+	enum OID oid;
 	int mech_type;
-	char buf[50];
-
-	if (!asn1_oid_decode(value, vlen, &oid, &oidlen))
-		goto fail;
 
-	if (oid_eq(oid, oidlen, NTLMSSP_OID, NTLMSSP_OID_LEN))
+	oid = look_up_OID(value, vlen);
+	if (oid == OID_ntlmssp) {
 		mech_type = KSMBD_AUTH_NTLMSSP;
-	else if (oid_eq(oid, oidlen, MSKRB5_OID, MSKRB5_OID_LEN))
+	} else if (oid == OID_mskrb5) {
 		mech_type = KSMBD_AUTH_MSKRB5;
-	else if (oid_eq(oid, oidlen, KRB5_OID, KRB5_OID_LEN))
+	} else if (oid == OID_krb5) {
 		mech_type = KSMBD_AUTH_KRB5;
-	else if (oid_eq(oid, oidlen, KRB5U2U_OID, KRB5U2U_OID_LEN))
+	} else if (oid == OID_krb5u2u) {
 		mech_type = KSMBD_AUTH_KRB5U2U;
-	else
-		goto fail;
+	} else {
+		char buf[50];
+
+		sprint_oid(value, vlen, buf, sizeof(buf));
+		ksmbd_debug(AUTH, "Unexpected OID: %s\n", buf);
+		return -EBADMSG;
+	}
 
 	conn->auth_mechs |= mech_type;
 	if (conn->preferred_auth_mech == 0)
 		conn->preferred_auth_mech = mech_type;
 
-	kfree(oid);
 	return 0;
-
-fail:
-	kfree(oid);
-	sprint_oid(value, vlen, buf, sizeof(buf));
-	ksmbd_debug(AUTH, "Unexpected OID: %s\n", buf);
-	return -EBADMSG;
 }
 
 int ksmbd_neg_token_init_mech_token(void *context, size_t hdrlen,


