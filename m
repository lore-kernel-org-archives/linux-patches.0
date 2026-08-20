Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5601A37FF6A;
	Thu, 20 Aug 2026 15:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239061; cv=none; b=l6Vc+yClXbDPPjgYgKivEq9YynBUcdg+Pe5RdVHGoqRFbuwC+F7zVPEoyni9rZB9xVICc4thC10ojn6LsEJYUPO6HxUXh7IUGnc3CGZzzWTcN9Q89WMPoH9iNGiyKc2Y5RDngBALNqg+Z5XT8Bx33L7C8rVAo5JKKgRc1gqYOU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239061; c=relaxed/simple;
	bh=SQfICwEWPI1TheWkDYCJgP6qLuSMAyZze7acgKR+hUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4Xz/WVuu11K6g9XGCCXOL5gjaexKFd2lGC5FMF8F5Td/cRlBowME5rdTnk/2CeQoScGEH341hiqzNvvWHc7rFWGCqV25hgJTwuylmFgcUqmUYaTX7G93uXmMn/z3XFikUE7icOKiuTC75FAXgdkUoEgZXsHuAkvoYHdoMnlzpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rkFJfRk3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rkFJfRk3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B052E1F000E9;
	Thu, 20 Aug 2026 15:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239060;
	bh=b/6AYVfef8qta5DOYyTCeJEy4x/owC967hSlvHAaaVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rkFJfRk3qyH7vOyEwN6qpSvhntDhoNF1BSm4VAUXjxuLSDMQjSj4T6Wt4ieXyQRod
	 9gvEpk1z5a98Kd9O0NwICof5CElSlt2P0dze5rEkxwPBTc9zdo9+FAmwiVziRwGseB
	 H2Uw/oS84sPkLnTYlzif5l+OwAYrEQA/p6tt+MKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>,
	David Howells <dhowells@redhat.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 137/217] ksmbd: Fix to handle removal of rfc1002 header from smb_hdr
Date: Thu, 20 Aug 2026 16:55:05 +0200
Message-ID: <20260820145241.879391670@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit 0a70cac7896712a08e3cd22c16f44be976d40dbf ]

The commit that removed the RFC1002 header from struct smb_hdr didn't also
fix the places in ksmbd that use it in order to provide graceful rejection
of SMB1 protocol requests.

Fixes: 83bfbd0bb902 ("cifs: Remove the RFC1002 header from smb_hdr")
Reported-by: Namjae Jeon <linkinjeon@kernel.org>
Link: https://lore.kernel.org/r/CAKYAXd9Ju4MFkkH5Jxfi1mO0AWEr=R35M3vQ_Xa7Yw34JoNZ0A@mail.gmail.com/
Cc: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: cfc0b8e5080a ("ksmbd: validate minimum PDU size for transform requests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
-		rsp_hdr = work->response_buf;
+		rsp_hdr = smb2_get_msg(work->response_buf);
 		rsp_hdr->Status.CifsError = STATUS_CONNECTION_DISCONNECTED;
 		return 1;
 	}
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -140,7 +140,7 @@ int ksmbd_verify_smb_message(struct ksmb
 	if (smb2_hdr->ProtocolId == SMB2_PROTO_NUMBER)
 		return ksmbd_smb2_check_message(work);
 
-	hdr = work->request_buf;
+	hdr = smb2_get_msg(work->request_buf);
 	if (*(__le32 *)hdr->Protocol == SMB1_PROTO_NUMBER &&
 	    hdr->Command == SMB_COM_NEGOTIATE) {
 		work->conn->outstanding_credits++;
@@ -278,15 +278,14 @@ static int ksmbd_negotiate_smb_dialect(v
 						  req->DialectCount);
 	}
 
-	proto = *(__le32 *)((struct smb_hdr *)buf)->Protocol;
 	if (proto == SMB1_PROTO_NUMBER) {
 		struct smb_negotiate_req *req;
 
-		req = (struct smb_negotiate_req *)buf;
+		req = (struct smb_negotiate_req *)smb2_get_msg(buf);
 		if (le16_to_cpu(req->ByteCount) < 2)
 			goto err_out;
 
-		if (offsetof(struct smb_negotiate_req, DialectsArray) - 4 +
+		if (offsetof(struct smb_negotiate_req, DialectsArray) +
 			le16_to_cpu(req->ByteCount) > smb_buf_length) {
 			goto err_out;
 		}
@@ -320,8 +319,8 @@ static u16 get_smb1_cmd_val(struct ksmbd
  */
 static int init_smb1_rsp_hdr(struct ksmbd_work *work)
 {
-	struct smb_hdr *rsp_hdr = (struct smb_hdr *)work->response_buf;
-	struct smb_hdr *rcv_hdr = (struct smb_hdr *)work->request_buf;
+	struct smb_hdr *rsp_hdr = (struct smb_hdr *)smb2_get_msg(work->response_buf);
+	struct smb_hdr *rcv_hdr = (struct smb_hdr *)smb2_get_msg(work->request_buf);
 
 	rsp_hdr->Command = SMB_COM_NEGOTIATE;
 	*(__le32 *)rsp_hdr->Protocol = SMB1_PROTO_NUMBER;
@@ -412,9 +411,10 @@ static int init_smb1_server(struct ksmbd
 
 int ksmbd_init_smb_server(struct ksmbd_conn *conn)
 {
+	struct smb_hdr *rcv_hdr = (struct smb_hdr *)smb2_get_msg(conn->request_buf);
 	__le32 proto;
 
-	proto = *(__le32 *)((struct smb_hdr *)conn->request_buf)->Protocol;
+	proto = *(__le32 *)rcv_hdr->Protocol;
 	if (conn->need_neg == false) {
 		if (proto == SMB1_PROTO_NUMBER)
 			return -EINVAL;
@@ -572,12 +572,12 @@ static int __smb2_negotiate(struct ksmbd
 
 static int smb_handle_negotiate(struct ksmbd_work *work)
 {
-	struct smb_negotiate_rsp *neg_rsp = work->response_buf;
+	struct smb_negotiate_rsp *neg_rsp = smb2_get_msg(work->response_buf);
 
 	ksmbd_debug(SMB, "Unsupported SMB1 protocol\n");
 
-	if (ksmbd_iov_pin_rsp(work, (void *)neg_rsp + 4,
-			      sizeof(struct smb_negotiate_rsp) - 4))
+	if (ksmbd_iov_pin_rsp(work, (void *)neg_rsp,
+			      sizeof(struct smb_negotiate_rsp)))
 		return -ENOMEM;
 
 	neg_rsp->hdr.Status.CifsError = STATUS_SUCCESS;


