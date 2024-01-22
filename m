Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA046EB67;
	Tue, 23 Jan 2024 02:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975425; cv=none; b=gpN7tA+qoGCShQJNe6sF5Lf/ZsqobE5hqIp7aNswj3JHwiqpEzkaXrz/i2vk2k+rz1nHOb0LkqVNpg1Z35S1m9P5wYDC7DLTmrlfk64ZuEZbLokFEAtCuciYWFm+mdRjCLLT+1viWvO4yvhngtsHfUjsCxpjHEn6bExtRPcyf4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975425; c=relaxed/simple;
	bh=Q9cBlMkE/gBUhNWPd1bHV/fDRApPa97i9Nfa2mR/J0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sAijrnzO0RC0VoVatZKfyuenStB/MhGzlmvwsZvl0ZYNIbeD1kFu/CrTsdfNPRvy2ojQd+ATmBrj2gcCvUVMfrDp6aSw6yM01dF0OL0j9P5SJowPwENktSDi8dIb66N7n8EL8J7BF/xbDa2/7XnvQIwxuPxjBFw8ZfC9d6ZHuXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WStUAwB9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WStUAwB9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84328C43390;
	Tue, 23 Jan 2024 02:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975425;
	bh=Q9cBlMkE/gBUhNWPd1bHV/fDRApPa97i9Nfa2mR/J0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WStUAwB9AZXmRV/9hRBnj+JnMDMs9tVGUF9ImxGF5lWvuUSaL8v9KWm/8RwUf6kOg
	 bSx6ogFATPPN/AACf7ateaqdnUQtxhULWCXgi3UA7islC1Ken9kif41ryWUjF/5GlL
	 90YnfwJ9XKID4SCpYAekWzVsR3UDEOaHYjMCbuQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.6 383/583] ksmbd: validate mech token in session setup
Date: Mon, 22 Jan 2024 15:57:14 -0800
Message-ID: <20240122235823.717350633@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1414,7 +1414,10 @@ static struct ksmbd_user *session_user(s
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
@@ -1505,7 +1508,10 @@ static int ntlm_authenticate(struct ksmb
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
@@ -1778,8 +1784,7 @@ int smb2_sess_setup(struct ksmbd_work *w
 
 	negblob_off = le16_to_cpu(req->SecurityBufferOffset);
 	negblob_len = le16_to_cpu(req->SecurityBufferLength);
-	if (negblob_off < offsetof(struct smb2_sess_setup_req, Buffer) ||
-	    negblob_len < offsetof(struct negotiate_message, NegotiateFlags)) {
+	if (negblob_off < offsetof(struct smb2_sess_setup_req, Buffer)) {
 		rc = -EINVAL;
 		goto out_err;
 	}
@@ -1788,8 +1793,15 @@ int smb2_sess_setup(struct ksmbd_work *w
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


