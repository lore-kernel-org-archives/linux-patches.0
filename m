Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7183D4133;
	Thu, 16 Jul 2026 13:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209553; cv=none; b=EOop/JS/RzR9Rxs8ER1ZzsJYKWvWtbRFIegAeHytHR0CUmCTSJqthz+WTjrU9AOEoedpZCJTJr7eno15LTbk2pCEbmd+8ajc7ksqvctsd0Pju3PkWO/YX2LZWAmuPZIVToVjhDw2FK3g9ghqioAFJQZSfBZ0V2Oy0xnFiea1tkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209553; c=relaxed/simple;
	bh=Uq4VZupN2j8TCXLVMpQLxcCkyrlwCtPCptgBxzmms5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D+V9PSXVApQa/5pw5jOIf1heKetjzs/y+rWky2r/8SrfxcL6ZfcCG2FwsdT1Gn8QNlWBJpdScJF5ft9rOhPZHRQc7sP8RRSPAFzWdFCpeqxynpDCgaqOt/nuurFSjjzulnXli0Lf2OdO97QKug6rrlZxQaal+ZiEyFZEaWgkBgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s5uSPHSI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s5uSPHSI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7512A1F00A3A;
	Thu, 16 Jul 2026 13:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209550;
	bh=tMtpRjxyip4VqEMlJjce8wxX3zZByhpXXiLD28SPlg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s5uSPHSIvohWpgDuEarpo7GVYsDI1Y2op23KvZrv/DGd751HpzIZ4MVphK+qTwS3Y
	 B4b/wJ7oNMKP4RoonSBvGothq3rvZrIyMyL2J1DRuMpyVm0c7zp+jFEq3nExkfW7ct
	 /d89JeJm/eOfAWdXrWjuGId+KiF9GGzfpZv+bIdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haofeng Li <lihaofeng@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 7.1 229/518] ksmbd: validate NTLMv2 response before updating session key
Date: Thu, 16 Jul 2026 15:28:17 +0200
Message-ID: <20260716133052.833313959@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

From: Haofeng Li <lihaofeng@kylinos.cn>

commit 954d196bebb2b50151cb96454c72dc113b2af1ac upstream.

ksmbd_auth_ntlmv2() derives the NTLMv2 session key into
sess->sess_key before it verifies the NTLMv2 response.
ksmbd_decode_ntlmssp_auth_blob() then continues into KEY_XCH even
when ksmbd_auth_ntlmv2() failed.

With SMB3 multichannel binding, the failed authentication operates on
an existing session and the session setup error path does not expire
binding sessions. A client can send a binding session setup with a
bad NT proof and KEY_XCH and still modify sess->sess_key before
STATUS_LOGON_FAILURE is returned.

Relevant path:

  smb2_sess_setup()
    -> conn->binding = true
    -> ntlm_authenticate()
       -> session_user()
       -> ksmbd_decode_ntlmssp_auth_blob()
          -> ksmbd_auth_ntlmv2()
             -> calc_ntlmv2_hash()
             -> hmac_md5_usingrawkey(..., sess->sess_key)
             -> crypto_memneq() returns mismatch
          -> KEY_XCH arc4_crypt(..., sess->sess_key, ...)
    -> out_err without expiring the binding session

Derive the base session key into a local buffer and copy it to
sess->sess_key only after the proof matches. Return immediately on
authentication failure so KEY_XCH is only processed after successful
authentication.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Fixes: f9929ef6a2a5 ("ksmbd: add support for key exchange")
Cc: stable@vger.kernel.org
Signed-off-by: Haofeng Li <lihaofeng@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/auth.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -142,6 +142,7 @@ int ksmbd_auth_ntlmv2(struct ksmbd_conn
 {
 	char ntlmv2_hash[CIFS_ENCPWD_SIZE];
 	char ntlmv2_rsp[CIFS_HMAC_MD5_HASH_SIZE];
+	char sess_key[SMB2_NTLMV2_SESSKEY_SIZE];
 	struct hmac_md5_ctx ctx;
 	int rc;
 
@@ -164,12 +165,21 @@ int ksmbd_auth_ntlmv2(struct ksmbd_conn
 	/* Generate the session key */
 	hmac_md5_usingrawkey(ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE,
 			     ntlmv2_rsp, CIFS_HMAC_MD5_HASH_SIZE,
-			     sess->sess_key);
+			     sess_key);
 
 	if (crypto_memneq(ntlmv2->ntlmv2_hash, ntlmv2_rsp,
-			  CIFS_HMAC_MD5_HASH_SIZE))
-		return -EINVAL;
-	return 0;
+			  CIFS_HMAC_MD5_HASH_SIZE)) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	memcpy(sess->sess_key, sess_key, sizeof(sess_key));
+	rc = 0;
+out:
+	memzero_explicit(ntlmv2_hash, sizeof(ntlmv2_hash));
+	memzero_explicit(ntlmv2_rsp, sizeof(ntlmv2_rsp));
+	memzero_explicit(sess_key, sizeof(sess_key));
+	return rc;
 }
 
 /**
@@ -226,6 +236,8 @@ int ksmbd_decode_ntlmssp_auth_blob(struc
 				nt_len - CIFS_ENCPWD_SIZE,
 				domain_name, conn->ntlmssp.cryptkey);
 	kfree(domain_name);
+	if (ret)
+		return ret;
 
 	/* The recovered secondary session key */
 	if (conn->ntlmssp.client_flags & NTLMSSP_NEGOTIATE_KEY_XCH) {


