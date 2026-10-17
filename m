Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70F33AA9F3;
	Sat, 17 Oct 2026 16:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256363; cv=none; b=AX3Q/3kR6nMutjfZEY0jUOtiCknBo4bhzHhC5raphw7aVTGTqp5o/MfkO4sQovAODIPIOeojbxsIVgBPdnjpDEFshwymxUcWKMV3bp5Sy4LxYeXL40Cug3JAWDpaGc9hBLGSQRD6jl2yWW4gaN9E+yQJhaQfBDri4Ke5uQplu1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256363; c=relaxed/simple;
	bh=Os9giTYZEI0xJ+MB58cIKHeOTXE376BBNWiVNws+cak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p+rCEXOWBvgjuiiswcrCW+n7GG8M8EeWJnEYSD0DAcDh+A4Nntqzj9u+LeSShZwofZ6FSFL0Xry0NkHZZ4SfjT0M4T0Rkwqz6BGJq9Aa3IS/hwOKnV5d21L1nmx76ABLiR+keNiFcNfm7Lq6l/SRCzALnXb9Gryd5TyyN1q+ruY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YUpS+Zf1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YUpS+Zf1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0588D1F000C4;
	Sat, 17 Oct 2026 16:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256361;
	bh=pYRhXSzc//DPBqcRE9r5YJVKm5qc00v8c3FstYb2ObI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YUpS+Zf1gjj/0elRyzq0T3FRSlyzVHfhfZ2/6v2yTojRWXR0VaP8dJoO7W+nsROZ1
	 nz1OD24iLHv6lUSv9qfRTlM7n6SMkcMwHbmLIJQ5Hzama9UJdR7fYkXT9Hs2362Cyj
	 H4ajUltRnx9EtYmb4BENuFaGDAaim+CA00Xqd/4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0159/1674] smb/client: pass cifs_open_info_data to SMB2_open()
Date: Sat, 17 Oct 2026 17:40:31 +0200
Message-ID: <20261017160435.240440149@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

[ Upstream commit 1f551e407bb49dce0bbd34ed6a499dad69e18020 ]

Let SMB2_open() fill the smb2_file_all_info embedded in cifs_open_info_data
directly. This removes the temporary smb2_file_all_info copy in
smb2_open_file().

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>

For the 6.6 backport, keep the existing retry delay initialization and
header declaration style. Move the existing open-done trace after create
context parsing, retaining the stable six-argument tracepoint signature.
This supplies the context needed to apply the follow-up handle cleanup in
566820af017e ("smb: client: close handle after create-context parsing
failure") without importing the newer tracepoint API.

Stable-dep-of: 566820af017e ("smb: client: close handle after create-context parsing failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/link.c      |  6 +++---
 fs/smb/client/smb2file.c  | 19 ++++++++-----------
 fs/smb/client/smb2pdu.c   | 31 ++++++++++++++++---------------
 fs/smb/client/smb2proto.h |  2 +-
 4 files changed, 28 insertions(+), 30 deletions(-)

diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
index e1b23e7bd1b61..221585e846c1f 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -343,7 +343,7 @@ smb3_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	int buf_type = CIFS_NO_BUFFER;
 	__le16 *utf16_path;
 	__u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
-	struct smb2_file_all_info file_info = {};
+	struct cifs_open_info_data data = {};
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
@@ -359,12 +359,12 @@ smb3_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	if (utf16_path == NULL)
 		return -ENOMEM;
 
-	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, &file_info, NULL,
+	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, &data, NULL,
 		       NULL, NULL);
 	if (rc)
 		goto qmf_out_open_fail;
 
-	if (file_info.EndOfFile != cpu_to_le64(CIFS_MF_SYMLINK_FILE_SIZE)) {
+	if (data.fi.EndOfFile != cpu_to_le64(CIFS_MF_SYMLINK_FILE_SIZE)) {
 		/* it's not a symlink */
 		rc = -ENOENT; /* Is there a better rc to return? */
 		goto qmf_out;
diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
index 134155669a59c..4444eea01e01d 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -111,8 +111,6 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms, __u32
 	__le16 *smb2_path;
 	__u8 smb2_oplock;
 	struct cifs_open_info_data *data = buf;
-	struct smb2_file_all_info file_info = {};
-	struct smb2_file_all_info *smb2_data = data ? &file_info : NULL;
 	struct kvec err_iov = {};
 	int err_buftype = CIFS_NO_BUFFER;
 	struct cifs_fid *fid = oparms->fid;
@@ -129,14 +127,14 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms, __u32
 	}
 	smb2_oplock = SMB2_OPLOCK_LEVEL_BATCH;
 
-	rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, smb2_data, NULL, &err_iov,
+	rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, data, NULL, &err_iov,
 		       &err_buftype);
 	if (rc == -EACCES && retry_without_read_attributes) {
 		free_rsp_buf(err_buftype, err_iov.iov_base);
 		memset(&err_iov, 0, sizeof(err_iov));
 		err_buftype = CIFS_NO_BUFFER;
 		oparms->desired_access &= ~FILE_READ_ATTRIBUTES;
-		rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, smb2_data, NULL, &err_iov,
+		rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, data, NULL, &err_iov,
 			       &err_buftype);
 	}
 	if (rc && data) {
@@ -149,9 +147,9 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms, __u32
 							 oparms->path,
 							 &data->symlink_target);
 			if (!rc) {
-				memset(smb2_data, 0, sizeof(*smb2_data));
+				memset(&data->fi, 0, sizeof(data->fi));
 				oparms->create_options |= OPEN_REPARSE_POINT;
-				rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, smb2_data,
+				rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, data,
 					       NULL, NULL, NULL);
 				oparms->create_options &= ~OPEN_REPARSE_POINT;
 			}
@@ -180,23 +178,22 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms, __u32
 		rc = 0;
 	}
 
-	if (smb2_data) {
+	if (data) {
 		/* if open response does not have IndexNumber field - get it */
-		if (smb2_data->IndexNumber == 0) {
+		if (data->fi.IndexNumber == 0) {
 			rc = SMB2_get_srv_num(xid, oparms->tcon,
 				      fid->persistent_fid,
 				      fid->volatile_fid,
-				      &smb2_data->IndexNumber);
+				      &data->fi.IndexNumber);
 			if (rc) {
 				/*
 				 * let get_inode_info disable server inode
 				 * numbers
 				 */
-				smb2_data->IndexNumber = 0;
+				data->fi.IndexNumber = 0;
 				rc = 0;
 			}
 		}
-		memcpy(&data->fi, smb2_data, sizeof(data->fi));
 	}
 
 	*oplock = smb2_oplock;
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 8c593d54fbe34..b831cd1dd3290 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3218,7 +3218,7 @@ SMB2_open_free(struct smb_rqst *rqst)
 
 int
 SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
-	  __u8 *oplock, struct smb2_file_all_info *buf,
+	  __u8 *oplock, struct cifs_open_info_data *buf,
 	  struct create_posix_rsp *posix,
 	  struct kvec *err_iov, int *buftype)
 {
@@ -3233,6 +3233,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	int rc = 0;
 	int flags = 0;
 	int retries = 0, cur_sleep = 1;
+	struct smb2_file_all_info *file_info = buf ? &buf->fi : NULL;
 
 replay_again:
 	/* reinitialize for possible replay */
@@ -3288,9 +3289,6 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 		goto creat_exit;
 	} else if (rsp == NULL) /* unlikely to happen, but safer to check */
 		goto creat_exit;
-	else
-		trace_smb3_open_done(xid, rsp->PersistentFileId, tcon->tid, ses->Suid,
-				     oparms->create_options, oparms->desired_access);
 
 	atomic_inc(&tcon->num_remote_opens);
 	oparms->fid->persistent_fid = rsp->PersistentFileId;
@@ -3300,21 +3298,24 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	oparms->fid->mid = le64_to_cpu(rsp->hdr.MessageId);
 #endif /* CIFS_DEBUG2 */
 
-	if (buf) {
-		buf->CreationTime = rsp->CreationTime;
-		buf->LastAccessTime = rsp->LastAccessTime;
-		buf->LastWriteTime = rsp->LastWriteTime;
-		buf->ChangeTime = rsp->ChangeTime;
-		buf->AllocationSize = rsp->AllocationSize;
-		buf->EndOfFile = rsp->EndofFile;
-		buf->Attributes = rsp->FileAttributes;
-		buf->NumberOfLinks = cpu_to_le32(1);
-		buf->DeletePending = 0;
+	if (file_info) {
+		file_info->CreationTime = rsp->CreationTime;
+		file_info->LastAccessTime = rsp->LastAccessTime;
+		file_info->LastWriteTime = rsp->LastWriteTime;
+		file_info->ChangeTime = rsp->ChangeTime;
+		file_info->AllocationSize = rsp->AllocationSize;
+		file_info->EndOfFile = rsp->EndofFile;
+		file_info->Attributes = rsp->FileAttributes;
+		file_info->NumberOfLinks = cpu_to_le32(1);
+		file_info->DeletePending = 0;
 	}
 
 
 	rc = smb2_parse_contexts(server, &rsp_iov, &oparms->fid->epoch,
-				 oparms->fid->lease_key, oplock, buf, posix);
+				 oparms->fid->lease_key, oplock, file_info, posix);
+
+	trace_smb3_open_done(xid, rsp->PersistentFileId, tcon->tid, ses->Suid,
+			     oparms->create_options, oparms->desired_access);
 creat_exit:
 	SMB2_open_free(&rqst);
 	free_rsp_buf(resp_buftype, rsp);
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index f553e3edd54ec..da0adcb6a06d0 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -154,7 +154,7 @@ extern int SMB2_tcon(const unsigned int xid, struct cifs_ses *ses,
 extern int SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon);
 extern int SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms,
 		     __le16 *path, __u8 *oplock,
-		     struct smb2_file_all_info *buf,
+		     struct cifs_open_info_data *buf,
 		     struct create_posix_rsp *posix,
 		     struct kvec *err_iov, int *resp_buftype);
 extern int SMB2_open_init(struct cifs_tcon *tcon,
-- 
2.53.0



