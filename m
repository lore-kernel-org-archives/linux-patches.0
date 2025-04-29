Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76275240611;
	Tue, 29 Apr 2025 18:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950680; cv=none; b=GyfZbVjFS64QBfUCdb6Uium1wzSpuLEYhLQXlWdiEIItFOKtLRGocl1E3f62rGHAcVASVs/nKtmq21vBSk/IFfE3f84lAiSv1L74PXuS/jj9otLx8GBB4+nGs1FTtBklmedBUObBMyhOu12SVlIaEAtgNNEDLalzlwwZsnC9L5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950680; c=relaxed/simple;
	bh=9v3VJWS6yifLQKNvLwCH2tx0uJW9JK4iCoKrKYDmpE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MA2dF4eofSuLv0v7a9RPcP5m5v7ZES0TlGCNwCrqAQTASWknMyMHZkNMzxHTZsk8Ocfn8q5u9HDFlGU5JgqkRKQnn11up2pNK6Gzaq2Lx5NW5+sjSmr71XrrF3s1cwp8+PY9Qzf6p5VQR2P6lI2NL0DggQ3bQW/KByQDE989Hfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U+rf3IXp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U+rf3IXp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7742CC4CEE3;
	Tue, 29 Apr 2025 18:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950679;
	bh=9v3VJWS6yifLQKNvLwCH2tx0uJW9JK4iCoKrKYDmpE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U+rf3IXpPcx9aaYYPdlk0OKgM/CNQwwHNwO/BelGLq7RvkS0iv72ZYGPmJ4XL3HJC
	 Ju3rhSzDZz2Aaky4lj3r3WHds3lnYpP2zonKNTBP6ibBnnhqq8KY1+OkJB/vs2hN4h
	 aTwp166kGZOnhc8dCZ5T9B6tIlqy2OSFdksmBVNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 172/204] cifs: Fix encoding of SMB1 Session Setup Kerberos Request in non-UNICODE mode
Date: Tue, 29 Apr 2025 18:44:20 +0200
Message-ID: <20250429161106.443051903@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 16cb6b0509b65ac89187e9402e0b7a9ddf1765ef ]

Like in UNICODE mode, SMB1 Session Setup Kerberos Request contains oslm and
domain strings.

Extract common code into ascii_oslm_strings() and ascii_domain_string()
functions (similar to unicode variants) and use these functions in
non-UNICODE code path in sess_auth_kerberos().

Decision if non-UNICODE or UNICODE mode is used is based on the
SMBFLG2_UNICODE flag in Flags2 packed field, and not based on the
capabilities of server. Fix this check too.

Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/sess.c | 60 +++++++++++++++++++++++++++++---------------
 1 file changed, 40 insertions(+), 20 deletions(-)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index c2a98b2736645..f04922eb45d4c 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -732,6 +732,22 @@ unicode_oslm_strings(char **pbcc_area, const struct nls_table *nls_cp)
 	*pbcc_area = bcc_ptr;
 }
 
+static void
+ascii_oslm_strings(char **pbcc_area, const struct nls_table *nls_cp)
+{
+	char *bcc_ptr = *pbcc_area;
+
+	strcpy(bcc_ptr, "Linux version ");
+	bcc_ptr += strlen("Linux version ");
+	strcpy(bcc_ptr, init_utsname()->release);
+	bcc_ptr += strlen(init_utsname()->release) + 1;
+
+	strcpy(bcc_ptr, CIFS_NETWORK_OPSYS);
+	bcc_ptr += strlen(CIFS_NETWORK_OPSYS) + 1;
+
+	*pbcc_area = bcc_ptr;
+}
+
 static void unicode_domain_string(char **pbcc_area, struct cifs_ses *ses,
 				   const struct nls_table *nls_cp)
 {
@@ -756,6 +772,25 @@ static void unicode_domain_string(char **pbcc_area, struct cifs_ses *ses,
 	*pbcc_area = bcc_ptr;
 }
 
+static void ascii_domain_string(char **pbcc_area, struct cifs_ses *ses,
+				const struct nls_table *nls_cp)
+{
+	char *bcc_ptr = *pbcc_area;
+	int len;
+
+	/* copy domain */
+	if (ses->domainName != NULL) {
+		len = strscpy(bcc_ptr, ses->domainName, CIFS_MAX_DOMAINNAME_LEN);
+		if (WARN_ON_ONCE(len < 0))
+			len = CIFS_MAX_DOMAINNAME_LEN - 1;
+		bcc_ptr += len;
+	} /* else we send a null domain name so server will default to its own domain */
+	*bcc_ptr = 0;
+	bcc_ptr++;
+
+	*pbcc_area = bcc_ptr;
+}
+
 static void unicode_ssetup_strings(char **pbcc_area, struct cifs_ses *ses,
 				   const struct nls_table *nls_cp)
 {
@@ -801,25 +836,10 @@ static void ascii_ssetup_strings(char **pbcc_area, struct cifs_ses *ses,
 	*bcc_ptr = 0;
 	bcc_ptr++; /* account for null termination */
 
-	/* copy domain */
-	if (ses->domainName != NULL) {
-		len = strscpy(bcc_ptr, ses->domainName, CIFS_MAX_DOMAINNAME_LEN);
-		if (WARN_ON_ONCE(len < 0))
-			len = CIFS_MAX_DOMAINNAME_LEN - 1;
-		bcc_ptr += len;
-	} /* else we send a null domain name so server will default to its own domain */
-	*bcc_ptr = 0;
-	bcc_ptr++;
-
 	/* BB check for overflow here */
 
-	strcpy(bcc_ptr, "Linux version ");
-	bcc_ptr += strlen("Linux version ");
-	strcpy(bcc_ptr, init_utsname()->release);
-	bcc_ptr += strlen(init_utsname()->release) + 1;
-
-	strcpy(bcc_ptr, CIFS_NETWORK_OPSYS);
-	bcc_ptr += strlen(CIFS_NETWORK_OPSYS) + 1;
+	ascii_domain_string(&bcc_ptr, ses, nls_cp);
+	ascii_oslm_strings(&bcc_ptr, nls_cp);
 
 	*pbcc_area = bcc_ptr;
 }
@@ -1622,7 +1642,7 @@ sess_auth_kerberos(struct sess_data *sess_data)
 	sess_data->iov[1].iov_len = msg->secblob_len;
 	pSMB->req.SecurityBlobLength = cpu_to_le16(sess_data->iov[1].iov_len);
 
-	if (ses->capabilities & CAP_UNICODE) {
+	if (pSMB->req.hdr.Flags2 & SMBFLG2_UNICODE) {
 		/* unicode strings must be word aligned */
 		if (!IS_ALIGNED(sess_data->iov[0].iov_len + sess_data->iov[1].iov_len, 2)) {
 			*bcc_ptr = 0;
@@ -1631,8 +1651,8 @@ sess_auth_kerberos(struct sess_data *sess_data)
 		unicode_oslm_strings(&bcc_ptr, sess_data->nls_cp);
 		unicode_domain_string(&bcc_ptr, ses, sess_data->nls_cp);
 	} else {
-		/* BB: is this right? */
-		ascii_ssetup_strings(&bcc_ptr, ses, sess_data->nls_cp);
+		ascii_oslm_strings(&bcc_ptr, sess_data->nls_cp);
+		ascii_domain_string(&bcc_ptr, ses, sess_data->nls_cp);
 	}
 
 	sess_data->iov[2].iov_len = (long) bcc_ptr -
-- 
2.39.5



