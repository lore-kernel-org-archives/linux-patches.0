Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937AD216605;
	Tue, 29 Apr 2025 17:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948217; cv=none; b=Q4NdSJaJ+acMM5ROwoGyISeDPgOPA7jlQGjhrXsnrqvbf3Nqmpc0GEFeoGUIopi0dLFiZ8b2fRmjveIe4p1DiSVgkRUm2MdcmXGBuQFYf+/aMZh18xE4llLgHOcSutzrc1SrQ68zivGsREAsnIaeaG8nUwT+NthYJ7aHNUnLnZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948217; c=relaxed/simple;
	bh=AW7KdBnG2UEGkfRVzamBX/Ceeg1jQoTv0nbsdIwrwnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nbSFxiXhCV/orWd0wwlUmvcT/jW/mt2hzrYtI0pHHRBJu6I1F2XF7Id7LChIWG1ioyvGieHzxJy5A6ZUwQ4lCMD1Y4Bsow+5uO4Io+ezcpGOBPrSyoSas5Cf4MjIjlOXouyHg945p/d4ZFwwwfP2V6WpMW58LNP6H2poPPRwwfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O1Bu1XCh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O1Bu1XCh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2738BC4CEE3;
	Tue, 29 Apr 2025 17:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948217;
	bh=AW7KdBnG2UEGkfRVzamBX/Ceeg1jQoTv0nbsdIwrwnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O1Bu1XChQeY8J8tEJL3KAbW+p4J/lL1UjQA36SXIgfAol58bafgtbdwBIOShQvqHb
	 0TV2E1w6HT5+Qau2w6lB27aO9Y2o6SceJxLPJxOLzAOWXdx/Ha9MjZ+qxCB6om+9an
	 p4h7DKwZgeZxF2XiSUU3Panm++hOub56cAya6bbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 223/280] cifs: Fix encoding of SMB1 Session Setup Kerberos Request in non-UNICODE mode
Date: Tue, 29 Apr 2025 18:42:44 +0200
Message-ID: <20250429161124.244461100@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2426fa7405173..9b32f7821b718 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -707,6 +707,22 @@ unicode_oslm_strings(char **pbcc_area, const struct nls_table *nls_cp)
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
@@ -731,6 +747,25 @@ static void unicode_domain_string(char **pbcc_area, struct cifs_ses *ses,
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
@@ -776,25 +811,10 @@ static void ascii_ssetup_strings(char **pbcc_area, struct cifs_ses *ses,
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
@@ -1597,7 +1617,7 @@ sess_auth_kerberos(struct sess_data *sess_data)
 	sess_data->iov[1].iov_len = msg->secblob_len;
 	pSMB->req.SecurityBlobLength = cpu_to_le16(sess_data->iov[1].iov_len);
 
-	if (ses->capabilities & CAP_UNICODE) {
+	if (pSMB->req.hdr.Flags2 & SMBFLG2_UNICODE) {
 		/* unicode strings must be word aligned */
 		if (!IS_ALIGNED(sess_data->iov[0].iov_len + sess_data->iov[1].iov_len, 2)) {
 			*bcc_ptr = 0;
@@ -1606,8 +1626,8 @@ sess_auth_kerberos(struct sess_data *sess_data)
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



