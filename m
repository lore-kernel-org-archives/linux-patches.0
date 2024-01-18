Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6770822EF7;
	Thu, 18 Jan 2024 10:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575091; cv=none; b=kpDRJD7HwM49ho/VKcA6+Wg8r3BSBIYMaW/g3E75SeR/eafry712CLMrc3kxCCE6y+hsB6vBi1yKuldd1IzDQY2mGTSNVYe1uKY7dU+RDNjsV2MmGdLG5k5JaBMOE+1gE90NNg3f/UjtfMCl0s9TInA7nX1NcPU6EnolygloTMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575091; c=relaxed/simple;
	bh=vO2IGzgcj8+TjO/sBh07c0aGUATKflMb87lwtL5SOkE=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=pk8SgbLc/XzpDc+wxkJbRWH1Tx/UlUx5BjOX0sdSFxYpXJo2XYXY5nYPU7FFg2+Bqmz2FQNgYF3Dc6wt4SgdQP6HLSkzzI6eIV96Cu2YeEn6Fs8oev5024Jk4piC9OriFu/MyeTWuQMhmuLm3WDsJTy5ACaMWTOFFH0Cc+nQfQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SFs7pofN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SFs7pofN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E5EC433F1;
	Thu, 18 Jan 2024 10:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575090;
	bh=vO2IGzgcj8+TjO/sBh07c0aGUATKflMb87lwtL5SOkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SFs7pofNi/yjMoLpwFSFFRXVI+OjpimQwhXxlox3zl2slRsBV3g83c1ijw895b9Xs
	 n8kIA2Wppi6D0b9hYylW974gBh/Bc+pRDdikYdSCT+AduqIgmTA27VMgr9Wae5BCD1
	 7/9XD4tIaMOylbyN94/1gmfOnsHk/GZM6ArTGwrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.7 13/28] ksmbd: dont allow O_TRUNC open on read-only share
Date: Thu, 18 Jan 2024 11:49:03 +0100
Message-ID: <20240118104301.694908338@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104301.249503558@linuxfoundation.org>
References: <20240118104301.249503558@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit d592a9158a112d419f341f035d18d02f8d232def upstream.

When file is changed using notepad on read-only share(read_only = yes in
ksmbd.conf), There is a problem where existing data is truncated.
notepad in windows try to O_TRUNC open(FILE_OVERWRITE_IF) and all data
in file is truncated. This patch don't allow  O_TRUNC open on read-only
share and add KSMBD_TREE_CONN_FLAG_WRITABLE check in smb2_set_info().

Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |   23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2971,7 +2971,7 @@ int smb2_open(struct ksmbd_work *work)
 					    &may_flags);
 
 	if (!test_tree_conn_flag(tcon, KSMBD_TREE_CONN_FLAG_WRITABLE)) {
-		if (open_flags & O_CREAT) {
+		if (open_flags & (O_CREAT | O_TRUNC)) {
 			ksmbd_debug(SMB,
 				    "User does not have write permission\n");
 			rc = -EACCES;
@@ -5943,12 +5943,6 @@ static int smb2_set_info_file(struct ksm
 	}
 	case FILE_RENAME_INFORMATION:
 	{
-		if (!test_tree_conn_flag(work->tcon, KSMBD_TREE_CONN_FLAG_WRITABLE)) {
-			ksmbd_debug(SMB,
-				    "User does not have write permission\n");
-			return -EACCES;
-		}
-
 		if (buf_len < sizeof(struct smb2_file_rename_info))
 			return -EINVAL;
 
@@ -5968,12 +5962,6 @@ static int smb2_set_info_file(struct ksm
 	}
 	case FILE_DISPOSITION_INFORMATION:
 	{
-		if (!test_tree_conn_flag(work->tcon, KSMBD_TREE_CONN_FLAG_WRITABLE)) {
-			ksmbd_debug(SMB,
-				    "User does not have write permission\n");
-			return -EACCES;
-		}
-
 		if (buf_len < sizeof(struct smb2_file_disposition_info))
 			return -EINVAL;
 
@@ -6035,7 +6023,7 @@ int smb2_set_info(struct ksmbd_work *wor
 {
 	struct smb2_set_info_req *req;
 	struct smb2_set_info_rsp *rsp;
-	struct ksmbd_file *fp;
+	struct ksmbd_file *fp = NULL;
 	int rc = 0;
 	unsigned int id = KSMBD_NO_FID, pid = KSMBD_NO_FID;
 
@@ -6055,6 +6043,13 @@ int smb2_set_info(struct ksmbd_work *wor
 		rsp = smb2_get_msg(work->response_buf);
 	}
 
+	if (!test_tree_conn_flag(work->tcon, KSMBD_TREE_CONN_FLAG_WRITABLE)) {
+		ksmbd_debug(SMB, "User does not have write permission\n");
+		pr_err("User does not have write permission\n");
+		rc = -EACCES;
+		goto err_out;
+	}
+
 	if (!has_file_id(id)) {
 		id = req->VolatileFileId;
 		pid = req->PersistentFileId;


