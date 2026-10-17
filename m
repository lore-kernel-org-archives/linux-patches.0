Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40BA5384CED;
	Sat, 17 Oct 2026 16:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254206; cv=none; b=P0GEX14BPi+ShP7SKFv33SiAPtK2RYziOc6EUjA/hQY9MnM9hNqVahj3NX0z0TW0kL6T60r/rWnShuQedF3ncPqvToVAbADStAp9cT8NOwew1CPrTOd7mgqsMuwwRU4ZM3El7rqcQdYbx6qmNBuMPeK4ROOCB1ZGvGL+c5P5AhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254206; c=relaxed/simple;
	bh=gsDojwKxI70e0ZCNcPBMapCORGx0bHSuXG9JwElvGlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ncNI2+1f9rGYz7gbC2JiiFVyshsT/vhqU5pZtmBZeJq6NcQgzWavuRWD6Z6r1tGMQPsbHQ269jg5VCP8YeyseRVa40OU9O6Jo6c9r7HyivLovyDlvSuehfXQQTTVt0cWhpw411QTDOQwtmh7yo/GGr4k4Nyjmo8Hztm4kzRF3T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CNThGhD2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CNThGhD2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473411F000C4;
	Sat, 17 Oct 2026 16:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254204;
	bh=32M2GD13WjL+H7/cRnvJC1LM992X31p0GpFuaCU4FPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CNThGhD2jw/NpMdEVgXZ3vM4carzznLenpiHcro53NLZorXczVI74wId4+nfJhhIB
	 PZW/EjmvGOZAG/+aXRuLuCDNKg2zErXtw4qCsxQSYPN/1TmhDEDLqjY6+dG58R1XMJ
	 jI3GDmYwvBCDM2IlPaAcJw+bsI8pLHXO7IvGYtI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haofeng Li <lihaofeng@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 369/869] ksmbd: validate NTLMv2 response before updating session key
Date: Sat, 17 Oct 2026 17:53:30 +0200
Message-ID: <20261017160046.570400718@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Haofeng Li <lihaofeng@kylinos.cn>

[ Upstream commit 954d196bebb2b50151cb96454c72dc113b2af1ac ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/auth.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index d0f9403676238..97ffce1ff4176 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -278,15 +278,15 @@ int ksmbd_auth_ntlmv2(struct ksmbd_conn *conn, struct ksmbd_session *sess,
 	ksmbd_release_crypto_ctx(ctx);
 	ctx = NULL;
 
-	rc = ksmbd_gen_sess_key(sess, ntlmv2_hash, ntlmv2_rsp);
-	if (rc) {
-		ksmbd_debug(AUTH, "Could not generate sess key\n");
+	if (crypto_memneq(ntlmv2->ntlmv2_hash, ntlmv2_rsp,
+			  CIFS_HMAC_MD5_HASH_SIZE)) {
+		rc = -EINVAL;
 		goto out;
 	}
 
-	if (crypto_memneq(ntlmv2->ntlmv2_hash, ntlmv2_rsp,
-			  CIFS_HMAC_MD5_HASH_SIZE))
-		rc = -EINVAL;
+	rc = ksmbd_gen_sess_key(sess, ntlmv2_hash, ntlmv2_rsp);
+	if (rc)
+		ksmbd_debug(AUTH, "Could not generate sess key\n");
 out:
 	if (ctx)
 		ksmbd_release_crypto_ctx(ctx);
@@ -348,6 +348,8 @@ int ksmbd_decode_ntlmssp_auth_blob(struct authenticate_message *authblob,
 				nt_len - CIFS_ENCPWD_SIZE,
 				domain_name, conn->ntlmssp.cryptkey);
 	kfree(domain_name);
+	if (ret)
+		return ret;
 
 	/* The recovered secondary session key */
 	if (conn->ntlmssp.client_flags & NTLMSSP_NEGOTIATE_KEY_XCH) {
-- 
2.53.0



