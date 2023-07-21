Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDDE20F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:17:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48D7C433C8;
	Fri, 21 Jul 2023 19:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967029;
	bh=Evfy/0vkzm/yKk7+pB8pOTjSIqcyEmbffWvNoq7g0MA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k3N2jNY6Ma/rJxb3EWKsr/4ZOOPXtM3T+VotdD8jOys8GlIPLm/CjtGm4SZ2vfYLa
	 PUl7rx3awkYa0JAHTJkEiU2DJZG/+c6VCi6XHA6Ns5ed5lZ25aaiPIVixgUmDk7Ixb
	 6g1jaZtDQqmWMt/A9tE0WolRSNGt7zFa2pLzH46c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.1 007/223] ksmbd: fix out of bounds read in smb2_sess_setup
Date: Fri, 21 Jul 2023 18:04:20 +0200
Message-ID: <20230721160521.186427988@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

commit 98422bdd4cb3ca4d08844046f6507d7ec2c2b8d8 upstream.

ksmbd does not consider the case of that smb2 session setup is
in compound request. If this is the second payload of the compound,
OOB read issue occurs while processing the first payload in
the smb2_sess_setup().

Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-21355
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |   31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1339,9 +1339,8 @@ static int decode_negotiation_token(stru
 
 static int ntlm_negotiate(struct ksmbd_work *work,
 			  struct negotiate_message *negblob,
-			  size_t negblob_len)
+			  size_t negblob_len, struct smb2_sess_setup_rsp *rsp)
 {
-	struct smb2_sess_setup_rsp *rsp = smb2_get_msg(work->response_buf);
 	struct challenge_message *chgblob;
 	unsigned char *spnego_blob = NULL;
 	u16 spnego_blob_len;
@@ -1446,10 +1445,10 @@ static struct ksmbd_user *session_user(s
 	return user;
 }
 
-static int ntlm_authenticate(struct ksmbd_work *work)
+static int ntlm_authenticate(struct ksmbd_work *work,
+			     struct smb2_sess_setup_req *req,
+			     struct smb2_sess_setup_rsp *rsp)
 {
-	struct smb2_sess_setup_req *req = smb2_get_msg(work->request_buf);
-	struct smb2_sess_setup_rsp *rsp = smb2_get_msg(work->response_buf);
 	struct ksmbd_conn *conn = work->conn;
 	struct ksmbd_session *sess = work->sess;
 	struct channel *chann = NULL;
@@ -1582,10 +1581,10 @@ binding_session:
 }
 
 #ifdef CONFIG_SMB_SERVER_KERBEROS5
-static int krb5_authenticate(struct ksmbd_work *work)
+static int krb5_authenticate(struct ksmbd_work *work,
+			     struct smb2_sess_setup_req *req,
+			     struct smb2_sess_setup_rsp *rsp)
 {
-	struct smb2_sess_setup_req *req = smb2_get_msg(work->request_buf);
-	struct smb2_sess_setup_rsp *rsp = smb2_get_msg(work->response_buf);
 	struct ksmbd_conn *conn = work->conn;
 	struct ksmbd_session *sess = work->sess;
 	char *in_blob, *out_blob;
@@ -1662,7 +1661,9 @@ static int krb5_authenticate(struct ksmb
 	return 0;
 }
 #else
-static int krb5_authenticate(struct ksmbd_work *work)
+static int krb5_authenticate(struct ksmbd_work *work,
+			     struct smb2_sess_setup_req *req,
+			     struct smb2_sess_setup_rsp *rsp)
 {
 	return -EOPNOTSUPP;
 }
@@ -1671,8 +1672,8 @@ static int krb5_authenticate(struct ksmb
 int smb2_sess_setup(struct ksmbd_work *work)
 {
 	struct ksmbd_conn *conn = work->conn;
-	struct smb2_sess_setup_req *req = smb2_get_msg(work->request_buf);
-	struct smb2_sess_setup_rsp *rsp = smb2_get_msg(work->response_buf);
+	struct smb2_sess_setup_req *req;
+	struct smb2_sess_setup_rsp *rsp;
 	struct ksmbd_session *sess;
 	struct negotiate_message *negblob;
 	unsigned int negblob_len, negblob_off;
@@ -1680,6 +1681,8 @@ int smb2_sess_setup(struct ksmbd_work *w
 
 	ksmbd_debug(SMB, "Received request for session setup\n");
 
+	WORK_BUFFERS(work, req, rsp);
+
 	rsp->StructureSize = cpu_to_le16(9);
 	rsp->SessionFlags = 0;
 	rsp->SecurityBufferOffset = cpu_to_le16(72);
@@ -1801,7 +1804,7 @@ int smb2_sess_setup(struct ksmbd_work *w
 
 		if (conn->preferred_auth_mech &
 				(KSMBD_AUTH_KRB5 | KSMBD_AUTH_MSKRB5)) {
-			rc = krb5_authenticate(work);
+			rc = krb5_authenticate(work, req, rsp);
 			if (rc) {
 				rc = -EINVAL;
 				goto out_err;
@@ -1815,7 +1818,7 @@ int smb2_sess_setup(struct ksmbd_work *w
 			sess->Preauth_HashValue = NULL;
 		} else if (conn->preferred_auth_mech == KSMBD_AUTH_NTLMSSP) {
 			if (negblob->MessageType == NtLmNegotiate) {
-				rc = ntlm_negotiate(work, negblob, negblob_len);
+				rc = ntlm_negotiate(work, negblob, negblob_len, rsp);
 				if (rc)
 					goto out_err;
 				rsp->hdr.Status =
@@ -1828,7 +1831,7 @@ int smb2_sess_setup(struct ksmbd_work *w
 						le16_to_cpu(rsp->SecurityBufferLength) - 1);
 
 			} else if (negblob->MessageType == NtLmAuthenticate) {
-				rc = ntlm_authenticate(work);
+				rc = ntlm_authenticate(work, req, rsp);
 				if (rc)
 					goto out_err;
 


