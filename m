Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80DAD77655;
	Wed, 21 Feb 2024 13:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521874; cv=none; b=SFaJo5Rd7FqNhx09sZyBxVhOaAKjYkClqLi+Z8ywcqzBO777anOA1GxBAlUKZt/VCSSuA/GuE1xZe2rh/AnoEXumf4iIfoaO5kqdpLjj3CyMtk3n1b2RnIW5jh/aUIXTaxb90QQbtPmK65saKnAfzmWTNVlkfGZ7hoIn82IXdMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521874; c=relaxed/simple;
	bh=2eTYr16BTAHa4OCHccI/nZnkClJNlqeyMRIxgWPqEMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cM6KFro0Y5x86GUlKoDyk20BvDGL0sZCpQ5I+DE9ppygF639Vpq0Oq55JlZpq2oAsbiXTsVdhadREG1/XU7jZFcTCfUmVEwIbwa56Az58C3DVEhhYMMBFtib8ugBHqgU6VMBCVjd3i7ALKLxw38pLmM8Nur/d1PROBqztkt5ls8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XBEfVRdM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XBEfVRdM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F9DC43390;
	Wed, 21 Feb 2024 13:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521874;
	bh=2eTYr16BTAHa4OCHccI/nZnkClJNlqeyMRIxgWPqEMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XBEfVRdM7rbnCBXTrGm1gbhHm+qvOHDfwF3vI6yMMQutXCYbEBfiA0KY1iPNZLs3i
	 cHwkQJYTtpdCHbCQz+7sFt/C4LRxvASdjWBpuFzH3Ru7wAyrAfX3o8LZs2e9zaLsJ6
	 m2FqUkEItRPFCtVotQ33ZuHRJyToXq7UFDfl3lzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 5.15 003/476] ksmbd: validate mech token in session setup
Date: Wed, 21 Feb 2024 14:00:54 +0100
Message-ID: <20240221130007.965888688@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 92e470163d96df8db6c4fa0f484e4a229edb903d ]

If client send invalid mech token in session setup request, ksmbd
validate and make the error if it is invalid.

Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-22890
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/asn1.c       |  5 +++++
 fs/ksmbd/connection.h |  1 +
 fs/ksmbd/smb2pdu.c    | 22 +++++++++++++++++-----
 3 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/fs/ksmbd/asn1.c b/fs/ksmbd/asn1.c
index 4a4b2b03ff33..b931a99ab9c8 100644
--- a/fs/ksmbd/asn1.c
+++ b/fs/ksmbd/asn1.c
@@ -214,10 +214,15 @@ static int ksmbd_neg_token_alloc(void *context, size_t hdrlen,
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
 
diff --git a/fs/ksmbd/connection.h b/fs/ksmbd/connection.h
index 3c005246a32e..342f935f5770 100644
--- a/fs/ksmbd/connection.h
+++ b/fs/ksmbd/connection.h
@@ -88,6 +88,7 @@ struct ksmbd_conn {
 	__u16				dialect;
 
 	char				*mechToken;
+	unsigned int			mechTokenLen;
 
 	struct ksmbd_conn_ops	*conn_ops;
 
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index bf3bb37c00a9..92ea42876e75 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1414,7 +1414,10 @@ static struct ksmbd_user *session_user(struct ksmbd_conn *conn,
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
@@ -1505,7 +1508,10 @@ static int ntlm_authenticate(struct ksmbd_work *work,
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
@@ -1778,8 +1784,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 
 	negblob_off = le16_to_cpu(req->SecurityBufferOffset);
 	negblob_len = le16_to_cpu(req->SecurityBufferLength);
-	if (negblob_off < offsetof(struct smb2_sess_setup_req, Buffer) ||
-	    negblob_len < offsetof(struct negotiate_message, NegotiateFlags)) {
+	if (negblob_off < offsetof(struct smb2_sess_setup_req, Buffer)) {
 		rc = -EINVAL;
 		goto out_err;
 	}
@@ -1788,8 +1793,15 @@ int smb2_sess_setup(struct ksmbd_work *work)
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
-- 
2.43.0



