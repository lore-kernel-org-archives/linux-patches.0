Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E17B527590;
	Wed, 23 Sep 2026 14:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175340; cv=none; b=S6PT9OAiAuR8rn7Pe+F0HQsFw4/+nTI9mUXIG2dYJx0Cuj92ApX/wOvYsdoaup4c/Zwn7EneVdSrEC4G0ftVqC+40M2lQ7PUFl6GBjUVhiQ/zn3EI/KgQsZVkgH2gx7HNPdLZjEqEkWhiTmu+5ZCaKjS3mvHx507kk9b5KBtkyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175340; c=relaxed/simple;
	bh=e/CYtoyy1RcmST78OT6gp6E2eR2u3hUihN10T0BGLww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NLHv1MqkD3Zp5JMIQ8yYzTmzdUty9WaKsnd208OrI7LuLoDRd1m4qLm1PMvxaVRBsBkaN5C3Zj4SNBG4yiJaUIS05sJVZMWaN1h0XXrg7Gm1tzI7w7cgP0Atcvd01c7k+caJCNJczF7mukZqgXOT63Y4QMwAyCXRVqWsMK71YuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IRvMA4nT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IRvMA4nT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B09BD1F000FF;
	Wed, 23 Sep 2026 14:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175339;
	bh=Bc4FktaRDarXLJf26jjXcMxsYyBZTZ9WmMr8kIUJkho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IRvMA4nTq7e/VW0iJMHA9As9Vxc/vPsfTbE7B+k7r31bxTAt2jN1o78K2x+rq30LT
	 FV9WtbiATlPntF7mW6fm2+4NBUqE9/5+RF2mhOYEf3DnHt6lWcmUVv5nM8Fsh7oLgL
	 CeFsHs9ZVR1MNyqyzzAyT81KhsVgxJqBL0RWCXjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"stable@vger.kernel.org, Namjae Jeon" <linkinjeon@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.18 397/398] Revert "ksmbd: Fix to handle removal of rfc1002 header from smb_hdr"
Date: Wed, 23 Sep 2026 16:07:51 +0200
Message-ID: <20260923140653.759668377@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

Revert commit 29dbb4e29e1f197172b1a0513f65c3ff6ec4fbc8 which is commit
0a70cac7896712a08e3cd22c16f44be976d40dbf upstream.

Commit 29dbb4e29e1f ("ksmbd: Fix to handle removal of rfc1002 header
from smb_hdr") is a backport of upstream commit 0a70cac78967.

The upstream commit depends on SMB1 header refactoring which removed the
RFC1002 length field from struct smb_hdr. Those prerequisite changes are
not present in the 6.18.y stable tree, where ksmbd still defines struct
smb_hdr with the smb_buf_length field.

As a result, smb_get_msg() advances the buffer by four bytes before it is
cast to a structure that already includes the RFC1002 field. This causes a
four-byte offset mismatch while parsing and constructing the initial SMB1
multi-protocol negotiate response.

Windows clients then receive a malformed negotiate response and abort the
connection.

This reverts commit 29dbb4e29e1f ("ksmbd: Fix to handle removal of
rfc1002 header from smb_hdr").

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/server.c     |    2 +-
 fs/smb/server/smb_common.c |   20 ++++++++++----------
 2 files changed, 11 insertions(+), 11 deletions(-)

--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -95,7 +95,7 @@ static inline int check_conn_state(struc
 
 	if (ksmbd_conn_exiting(work->conn) ||
 	    ksmbd_conn_need_reconnect(work->conn)) {
-		rsp_hdr = smb_get_msg(work->response_buf);
+		rsp_hdr = work->response_buf;
 		rsp_hdr->Status.CifsError = STATUS_CONNECTION_DISCONNECTED;
 		return 1;
 	}
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -140,7 +140,7 @@ int ksmbd_verify_smb_message(struct ksmb
 	if (smb2_hdr->ProtocolId == SMB2_PROTO_NUMBER)
 		return ksmbd_smb2_check_message(work);
 
-	hdr = smb_get_msg(work->request_buf);
+	hdr = work->request_buf;
 	if (*(__le32 *)hdr->Protocol == SMB1_PROTO_NUMBER &&
 	    hdr->Command == SMB_COM_NEGOTIATE) {
 		work->conn->outstanding_credits++;
@@ -278,14 +278,15 @@ static int ksmbd_negotiate_smb_dialect(v
 						  req->DialectCount);
 	}
 
+	proto = *(__le32 *)((struct smb_hdr *)buf)->Protocol;
 	if (proto == SMB1_PROTO_NUMBER) {
 		struct smb_negotiate_req *req;
 
-		req = (struct smb_negotiate_req *)smb_get_msg(buf);
+		req = (struct smb_negotiate_req *)buf;
 		if (le16_to_cpu(req->ByteCount) < 2)
 			goto err_out;
 
-		if (offsetof(struct smb_negotiate_req, DialectsArray) +
+		if (offsetof(struct smb_negotiate_req, DialectsArray) - 4 +
 			le16_to_cpu(req->ByteCount) > smb_buf_length) {
 			goto err_out;
 		}
@@ -319,8 +320,8 @@ static u16 get_smb1_cmd_val(struct ksmbd
  */
 static int init_smb1_rsp_hdr(struct ksmbd_work *work)
 {
-	struct smb_hdr *rsp_hdr = (struct smb_hdr *)smb_get_msg(work->response_buf);
-	struct smb_hdr *rcv_hdr = (struct smb_hdr *)smb_get_msg(work->request_buf);
+	struct smb_hdr *rsp_hdr = (struct smb_hdr *)work->response_buf;
+	struct smb_hdr *rcv_hdr = (struct smb_hdr *)work->request_buf;
 
 	rsp_hdr->Command = SMB_COM_NEGOTIATE;
 	*(__le32 *)rsp_hdr->Protocol = SMB1_PROTO_NUMBER;
@@ -411,10 +412,9 @@ static int init_smb1_server(struct ksmbd
 
 int ksmbd_init_smb_server(struct ksmbd_conn *conn)
 {
-	struct smb_hdr *rcv_hdr = (struct smb_hdr *)smb_get_msg(conn->request_buf);
 	__le32 proto;
 
-	proto = *(__le32 *)rcv_hdr->Protocol;
+	proto = *(__le32 *)((struct smb_hdr *)conn->request_buf)->Protocol;
 	if (conn->need_neg == false) {
 		if (proto == SMB1_PROTO_NUMBER)
 			return -EINVAL;
@@ -572,12 +572,12 @@ static int __smb2_negotiate(struct ksmbd
 
 static int smb_handle_negotiate(struct ksmbd_work *work)
 {
-	struct smb_negotiate_rsp *neg_rsp = smb_get_msg(work->response_buf);
+	struct smb_negotiate_rsp *neg_rsp = work->response_buf;
 
 	ksmbd_debug(SMB, "Unsupported SMB1 protocol\n");
 
-	if (ksmbd_iov_pin_rsp(work, (void *)neg_rsp,
-			      sizeof(struct smb_negotiate_rsp)))
+	if (ksmbd_iov_pin_rsp(work, (void *)neg_rsp + 4,
+			      sizeof(struct smb_negotiate_rsp) - 4))
 		return -ENOMEM;
 
 	neg_rsp->hdr.Status.CifsError = STATUS_SUCCESS;


