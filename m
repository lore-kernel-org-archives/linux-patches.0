Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F6165196;
	Tue, 23 Jan 2024 01:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971635; cv=none; b=DQaGoJf6OUEJ7VY6uDRBJZDK8VO92tISgxe2DhWDjX1xRNQYe+9nsbHaEsbrtv6swsb9Gi1LLZc6WNrFttceq2LY2nrIMiqMZpeR8YjMnbj44IoFZVSUi5Sgv1Brrsv+wT7pxNwUYv+PeDGTrF1T4g1dldDTmVeFD5j8ESXOcYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971635; c=relaxed/simple;
	bh=o7spntYLXdQh+TakOeRE3ihTogUBQHYbL6DxGLHDYhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CVK+8VdtoC2cT7IG9rOiuZbHqpAnARv7ARHa4jxIE31V9f1S9lvLdyN7PmkytvaD3WrwzQR7luBntuI3QwwNWdfoX9MCBeRHRo/pmk3ORJKem4nTsv18MzNYTsrLkvxgo1Hp+EIK1nzg0TsZ5AjJAsAsSkAXkiVRYfMDuasUEbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z73zokxa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z73zokxa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C58B3C433F1;
	Tue, 23 Jan 2024 01:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971635;
	bh=o7spntYLXdQh+TakOeRE3ihTogUBQHYbL6DxGLHDYhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z73zokxaMI7796Sr2VHuaxFrb00l6W00wZ3D2WYYm1RuM7X1dQb/5Rv9wR03ZV7oI
	 Qbj/LbtcTQs17UU+/uP0z7jfGiC2rzfMhfv8RBHXWLyIwMEZacRbK72F9BW5WSldPj
	 ek94eaB2AR1Fz9bdUBnU22BMM/q17onH6qrnWm1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.1 283/417] ksmbd: validate mech token in session setup
Date: Mon, 22 Jan 2024 15:57:31 -0800
Message-ID: <20240122235801.644341066@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 92e470163d96df8db6c4fa0f484e4a229edb903d upstream.

If client send invalid mech token in session setup request, ksmbd
validate and make the error if it is invalid.

Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-22890
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/asn1.c       |    5 +++++
 fs/smb/server/connection.h |    1 +
 fs/smb/server/smb2pdu.c    |   22 +++++++++++++++++-----
 3 files changed, 23 insertions(+), 5 deletions(-)

--- a/fs/smb/server/asn1.c
+++ b/fs/smb/server/asn1.c
@@ -214,10 +214,15 @@ static int ksmbd_neg_token_alloc(void *c
 {
 	struct ksmbd_conn *conn = context;
 
+	if (!vlen)
+		return -EINVAL;
+
 	conn->mechToken = kmemdup_nul(value, vlen, GFP_KERNEL);
 	if (!conn->mechToken)
 		return -ENOMEM;
 
+	conn->mechTokenLen = (unsigned int)vlen;
+
 	return 0;
 }
 
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -88,6 +88,7 @@ struct ksmbd_conn {
 	__u16				dialect;
 
 	char				*mechToken;
+	unsigned int			mechTokenLen;
 
 	struct ksmbd_conn_ops	*conn_ops;
 
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1412,7 +1412,10 @@ static struct ksmbd_user *session_user(s
 	char *name;
 	unsigned int name_off, name_len, secbuf_len;
 
-	secbuf_len = le16_to_cpu(req->SecurityBufferLength);
+	if (conn->use_spnego && conn->mechToken)
+		secbuf_len = conn->mechTokenLen;
+	else
+		secbuf_len = le16_to_cpu(req->SecurityBufferLength);
 	if (secbuf_len < sizeof(struct authenticate_message)) {
 		ksmbd_debug(SMB, "blob len %d too small\n", secbuf_len);
 		return NULL;
@@ -1503,7 +1506,10 @@ static int ntlm_authenticate(struct ksmb
 		struct authenticate_message *authblob;
 
 		authblob = user_authblob(conn, req);
-		sz = le16_to_cpu(req->SecurityBufferLength);
+		if (conn->use_spnego && conn->mechToken)
+			sz = conn->mechTokenLen;
+		else
+			sz = le16_to_cpu(req->SecurityBufferLength);
 		rc = ksmbd_decode_ntlmssp_auth_blob(authblob, sz, conn, sess);
 		if (rc) {
 			set_user_flag(sess->user, KSMBD_USER_FLAG_BAD_PASSWORD);
@@ -1776,8 +1782,7 @@ int smb2_sess_setup(struct ksmbd_work *w
 
 	negblob_off = le16_to_cpu(req->SecurityBufferOffset);
 	negblob_len = le16_to_cpu(req->SecurityBufferLength);
-	if (negblob_off < offsetof(struct smb2_sess_setup_req, Buffer) ||
-	    negblob_len < offsetof(struct negotiate_message, NegotiateFlags)) {
+	if (negblob_off < offsetof(struct smb2_sess_setup_req, Buffer)) {
 		rc = -EINVAL;
 		goto out_err;
 	}
@@ -1786,8 +1791,15 @@ int smb2_sess_setup(struct ksmbd_work *w
 			negblob_off);
 
 	if (decode_negotiation_token(conn, negblob, negblob_len) == 0) {
-		if (conn->mechToken)
+		if (conn->mechToken) {
 			negblob = (struct negotiate_message *)conn->mechToken;
+			negblob_len = conn->mechTokenLen;
+		}
+	}
+
+	if (negblob_len < offsetof(struct negotiate_message, NegotiateFlags)) {
+		rc = -EINVAL;
+		goto out_err;
 	}
 
 	if (server_conf.auth_mechs & conn->auth_mechs) {


