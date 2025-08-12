Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBCE027FB35;
	Tue, 12 Aug 2025 19:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026916; cv=none; b=hDRg1eJqtSR07HUleFSc1zzapJEY13oGU33qR0lOEmJqXEEUsYEO6dvSL0Q0KdfCk4C+VSbq5F0nNjH1Eh9HsU3o3zuS8DwJHJ3m1Q6iWo4WO1eiPuIOFjiyPYqecDoJYq7XiQVpcRGF9RKUEz0l5L97eKgQ8z49GB/0+balLMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026916; c=relaxed/simple;
	bh=rGDNg7lbjAHy0atLvMF8dxwI0nvrqcz3GjOBx4PR65M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YqvJS0PFeyXV1Ajky6bfgSYre2Nv0g19glVJhYp12g+Hjf4SedBN+qeEsguTvbke2kmQ1CG43cA3c+tjwPo/of3Fov09NlQCyvGTsgLbXa2XouW7ATLtejPR/DC11PLs64Wy8+PFNH+I4s29CA2uKPgscUjp4P6jzBfaqdS3oLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M9RP1EU3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M9RP1EU3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7047BC4CEF0;
	Tue, 12 Aug 2025 19:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026915;
	bh=rGDNg7lbjAHy0atLvMF8dxwI0nvrqcz3GjOBx4PR65M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M9RP1EU3QV6pB0iPTM8KekX/H1Yg1/7Gxx3mr+tNK9a/JjQJMNQszONIBDuYtZqFv
	 zdlPX737Bh6ElpVBA9lmDmw6is/dW6Lvpb6M4YADAthsuPE5LwjCx2IJh3KZ19t2I7
	 cqz+E2qYKd/YSYpywBFe8yehw5r8IL8E/K+JkX/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.15 444/480] ksmbd: fix null pointer dereference error in generate_encryptionkey
Date: Tue, 12 Aug 2025 19:50:52 +0200
Message-ID: <20250812174415.701447841@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 9b493ab6f35178afd8d619800df9071992f715de upstream.

If client send two session setups with krb5 authenticate to ksmbd,
null pointer dereference error in generate_encryptionkey could happen.
sess->Preauth_HashValue is set to NULL if session is valid.
So this patch skip generate encryption key if session is valid.

Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-27654
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1621,11 +1621,24 @@ static int krb5_authenticate(struct ksmb
 
 	rsp->SecurityBufferLength = cpu_to_le16(out_len);
 
-	if ((conn->sign || server_conf.enforced_signing) ||
+	/*
+	 * If session state is SMB2_SESSION_VALID, We can assume
+	 * that it is reauthentication. And the user/password
+	 * has been verified, so return it here.
+	 */
+	if (sess->state == SMB2_SESSION_VALID) {
+		if (conn->binding)
+			goto binding_session;
+		return 0;
+	}
+
+	if ((rsp->SessionFlags != SMB2_SESSION_FLAG_IS_GUEST_LE &&
+	    (conn->sign || server_conf.enforced_signing)) ||
 	    (req->SecurityMode & SMB2_NEGOTIATE_SIGNING_REQUIRED))
 		sess->sign = true;
 
-	if (smb3_encryption_negotiated(conn)) {
+	if (smb3_encryption_negotiated(conn) &&
+	    !(req->Flags & SMB2_SESSION_REQ_FLAG_BINDING)) {
 		retval = conn->ops->generate_encryptionkey(conn, sess);
 		if (retval) {
 			ksmbd_debug(SMB,
@@ -1638,6 +1651,7 @@ static int krb5_authenticate(struct ksmb
 		sess->sign = false;
 	}
 
+binding_session:
 	if (conn->dialect >= SMB30_PROT_ID) {
 		chann = lookup_chann_list(sess, conn);
 		if (!chann) {


