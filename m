Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2AA2F90C8;
	Tue, 12 Aug 2025 18:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021826; cv=none; b=S2bVB90qYfoNUqaxRDirrQrWNBPNyTIaNS+DMea44OaLVG7Q+XJW4Csd3BJw3yJ4sTcaU0G+x4E2EINMPwYh+b5+fxv3xcSzvH/H4RgJ2WjQRQ+2UvmBx/dKOvF6k8AQpEIStgimNNomAc8RuFkCkU0Th3vUrEr4uPbHzOB7bXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021826; c=relaxed/simple;
	bh=f576PLdS0DNQPoBdbz5gmXKaZKwPs7yjHkhantSAWqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GGNpDhi/UBCChVQ+/PmDLT2LdZUbVW+XC/54kwIEhuE1T5kuvjULhPjOER4AB5o3TPcQFmCG327HfCluOPaOIOMtuA1WU7B1K0wv5w/JUC7dL+gtoMV8LHXP19J62PEiS/2+kuDLzTk10wU/bK8aE43GeaqGO1iJMypEo1i1SV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ufqQegPo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ufqQegPo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C08AEC4CEF0;
	Tue, 12 Aug 2025 18:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021826;
	bh=f576PLdS0DNQPoBdbz5gmXKaZKwPs7yjHkhantSAWqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ufqQegPoKITfSPK4FI/QeIP6/Z0p5bWmE1XMvJCoJoJ46K6bMD9F//Hnr3bvG6FRq
	 D11FkrVjkSCa/g2vicvD9sXdqamD4B3mewl0AMcGQ5yjc7whYFS7m0Zu9oyYXEK61w
	 2axf8jUsxkCbRsR3UtrCPtIXflgG69mgNLZGPd7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.6 237/262] ksmbd: fix null pointer dereference error in generate_encryptionkey
Date: Tue, 12 Aug 2025 19:30:25 +0200
Message-ID: <20250812173003.249883520@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1610,11 +1610,24 @@ static int krb5_authenticate(struct ksmb
 
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
@@ -1627,6 +1640,7 @@ static int krb5_authenticate(struct ksmb
 		sess->sign = false;
 	}
 
+binding_session:
 	if (conn->dialect >= SMB30_PROT_ID) {
 		chann = lookup_chann_list(sess, conn);
 		if (!chann) {


