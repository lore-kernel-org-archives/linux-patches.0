Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD5F2CA9;
	Tue, 12 Aug 2025 18:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025152; cv=none; b=qtUywccnHvEUW/ur4kyokh8sL3ZMrch5SQT0tQtzgDqUbAVB9/nrtS4GV4kupdc/dUSOaWH+dmVBPADvNvLUWkUTY1n/5V+e1zpeCKFq73b13JoFTJ2uBa9ql+ieZYEAqSD4Rmqv0nwKkW6SZjLd2q48emQ2ftcujTxUlKHGFAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025152; c=relaxed/simple;
	bh=oQfu2ei9kSexscdnqO+0Rk5HbXkmwRSnpIjAxApl7Xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J1xsb/HgRWGPSLJiB9AoCc+LHed7agIcZFepaZvvO6RPKQx1igYj82kfitxaSeu8Z7nwW2CJkAIlNxVJsQ3N1qHPeGkiHo8ybFI6Uf0/5L9s364HrfaAb0VOX/DnlxY9am77/JoQ0YBGxxGGLJrwvn+xtPEGgshUR8GYKlybm1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FeKfzgJc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FeKfzgJc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C24F0C4CEF0;
	Tue, 12 Aug 2025 18:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025152;
	bh=oQfu2ei9kSexscdnqO+0Rk5HbXkmwRSnpIjAxApl7Xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FeKfzgJc80LUwGBr+mAQh9V9utisJp8c4FtfTplFgeA++KKN33XBqaXZyxnneQUbk
	 OkPV8sTlrV+KE0lutYeZAsWVcjTp0hZap2T8Ii+XI6AOkTnDcwg37LEtx1CEtAUpkh
	 uzSmL68TaPvUt8TiSelDlBH/2kpcqB68tWqWVFlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.16 584/627] ksmbd: fix null pointer dereference error in generate_encryptionkey
Date: Tue, 12 Aug 2025 19:34:39 +0200
Message-ID: <20250812173454.086984360@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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


