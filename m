Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680F913DB92;
	Tue, 27 Feb 2024 14:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042856; cv=none; b=cQ0SaLAjRqRxY50vIoN59X1Arj57Km17qMQ8z6qU1k3fL5vMLu1icaXBTFuOb+c6u8wN11XxalHqSQAmXNny9pgu5gaQYiRaCfrxoccafm/gf4TLK8PjNjVxx+zUsvs5jKBXPqs+0LHY2l16rcperBFRU52/CqHGKBJFhSn+6SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042856; c=relaxed/simple;
	bh=8T1d7+5U2L0uiq9wkzKhEnht3jP4TiNe/4djpfbZxbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rYrzmSZF1KqUEVlt2yQ/2A0MXyckVgthUOvPxi4C8efVWsl/CoHO+kJd8JUJUGcP9X0iVTCWOfw068EsxoYcBpoKDB50PUoykiTJpaUYv1GZ7TT+OVzMOSZpvevxh8eDgCJ2qo0a0OekLGZaJajlfg49z1zg0MrvIe+l2eEveRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CPLZhwjO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CPLZhwjO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0EDC433C7;
	Tue, 27 Feb 2024 14:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042856;
	bh=8T1d7+5U2L0uiq9wkzKhEnht3jP4TiNe/4djpfbZxbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CPLZhwjOVPYWYagHOsQqCMEJDhOBMirrd9vFjU3Dk72ZebtZZdKjXtuW2nfQE8JaR
	 t26Pgx/Qnjur6+JwEGZH0qcWG61f2rekfL+xHSnoS9zrBPz5W7YXCOxl7pRyshihOC
	 cToaAlcMOZmJWr3MEsMEoUTBDo765PRF49Ync/18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enzo Matsumiya <ematsumiya@suse.de>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 145/245] cifs: remove useless parameter is_fsctl from SMB2_ioctl()
Date: Tue, 27 Feb 2024 14:25:33 +0100
Message-ID: <20240227131619.931629597@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

From: Enzo Matsumiya <ematsumiya@suse.de>

[ Upstream commit 400d0ad63b190895e29f43bc75b1260111d3fd34 ]

SMB2_ioctl() is always called with is_fsctl = true, so doesn't make any
sense to have it at all.

Thus, always set SMB2_0_IOCTL_IS_FSCTL flag on the request.

Also, as per MS-SMB2 3.3.5.15 "Receiving an SMB2 IOCTL Request", servers
must fail the request if the request flags is zero anyway.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Reviewed-by: Tom Talpey <tom@talpey.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2file.c  |  1 -
 fs/cifs/smb2ops.c   | 35 +++++++++++++----------------------
 fs/cifs/smb2pdu.c   | 20 +++++++++-----------
 fs/cifs/smb2proto.h |  4 ++--
 4 files changed, 24 insertions(+), 36 deletions(-)

diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index f5dcc4940b6da..9dfd2dd612c25 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -61,7 +61,6 @@ smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
 		nr_ioctl_req.Reserved = 0;
 		rc = SMB2_ioctl(xid, oparms->tcon, fid->persistent_fid,
 			fid->volatile_fid, FSCTL_LMR_REQUEST_RESILIENCY,
-			true /* is_fsctl */,
 			(char *)&nr_ioctl_req, sizeof(nr_ioctl_req),
 			CIFSMaxBufSize, NULL, NULL /* no return info */);
 		if (rc == -EOPNOTSUPP) {
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 6f09e889e74d7..a8f33e8261344 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -647,7 +647,7 @@ SMB3_request_interfaces(const unsigned int xid, struct cifs_tcon *tcon)
 	struct cifs_ses *ses = tcon->ses;
 
 	rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
-			FSCTL_QUERY_NETWORK_INTERFACE_INFO, true /* is_fsctl */,
+			FSCTL_QUERY_NETWORK_INTERFACE_INFO,
 			NULL /* no data input */, 0 /* no data input */,
 			CIFSMaxBufSize, (char **)&out_buf, &ret_data_len);
 	if (rc == -EOPNOTSUPP) {
@@ -1582,9 +1582,8 @@ SMB2_request_res_key(const unsigned int xid, struct cifs_tcon *tcon,
 	struct resume_key_req *res_key;
 
 	rc = SMB2_ioctl(xid, tcon, persistent_fid, volatile_fid,
-			FSCTL_SRV_REQUEST_RESUME_KEY, true /* is_fsctl */,
-			NULL, 0 /* no input */, CIFSMaxBufSize,
-			(char **)&res_key, &ret_data_len);
+			FSCTL_SRV_REQUEST_RESUME_KEY, NULL, 0 /* no input */,
+			CIFSMaxBufSize, (char **)&res_key, &ret_data_len);
 
 	if (rc == -EOPNOTSUPP) {
 		pr_warn_once("Server share %s does not support copy range\n", tcon->treeName);
@@ -1726,7 +1725,7 @@ smb2_ioctl_query_info(const unsigned int xid,
 		rqst[1].rq_nvec = SMB2_IOCTL_IOV_SIZE;
 
 		rc = SMB2_ioctl_init(tcon, server, &rqst[1], COMPOUND_FID, COMPOUND_FID,
-				     qi.info_type, true, buffer, qi.output_buffer_length,
+				     qi.info_type, buffer, qi.output_buffer_length,
 				     CIFSMaxBufSize - MAX_SMB2_CREATE_RESPONSE_SIZE -
 				     MAX_SMB2_CLOSE_RESPONSE_SIZE);
 		free_req1_func = SMB2_ioctl_free;
@@ -1902,9 +1901,8 @@ smb2_copychunk_range(const unsigned int xid,
 		retbuf = NULL;
 		rc = SMB2_ioctl(xid, tcon, trgtfile->fid.persistent_fid,
 			trgtfile->fid.volatile_fid, FSCTL_SRV_COPYCHUNK_WRITE,
-			true /* is_fsctl */, (char *)pcchunk,
-			sizeof(struct copychunk_ioctl),	CIFSMaxBufSize,
-			(char **)&retbuf, &ret_data_len);
+			(char *)pcchunk, sizeof(struct copychunk_ioctl),
+			CIFSMaxBufSize, (char **)&retbuf, &ret_data_len);
 		if (rc == 0) {
 			if (ret_data_len !=
 					sizeof(struct copychunk_ioctl_rsp)) {
@@ -2064,7 +2062,6 @@ static bool smb2_set_sparse(const unsigned int xid, struct cifs_tcon *tcon,
 
 	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
 			cfile->fid.volatile_fid, FSCTL_SET_SPARSE,
-			true /* is_fctl */,
 			&setsparse, 1, CIFSMaxBufSize, NULL, NULL);
 	if (rc) {
 		tcon->broken_sparse_sup = true;
@@ -2147,7 +2144,6 @@ smb2_duplicate_extents(const unsigned int xid,
 	rc = SMB2_ioctl(xid, tcon, trgtfile->fid.persistent_fid,
 			trgtfile->fid.volatile_fid,
 			FSCTL_DUPLICATE_EXTENTS_TO_FILE,
-			true /* is_fsctl */,
 			(char *)&dup_ext_buf,
 			sizeof(struct duplicate_extents_to_file),
 			CIFSMaxBufSize, NULL,
@@ -2182,7 +2178,6 @@ smb3_set_integrity(const unsigned int xid, struct cifs_tcon *tcon,
 	return SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
 			cfile->fid.volatile_fid,
 			FSCTL_SET_INTEGRITY_INFORMATION,
-			true /* is_fsctl */,
 			(char *)&integr_info,
 			sizeof(struct fsctl_set_integrity_information_req),
 			CIFSMaxBufSize, NULL,
@@ -2235,7 +2230,6 @@ smb3_enum_snapshots(const unsigned int xid, struct cifs_tcon *tcon,
 	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
 			cfile->fid.volatile_fid,
 			FSCTL_SRV_ENUMERATE_SNAPSHOTS,
-			true /* is_fsctl */,
 			NULL, 0 /* no input data */, max_response_size,
 			(char **)&retbuf,
 			&ret_data_len);
@@ -2920,7 +2914,6 @@ smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
 	do {
 		rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
 				FSCTL_DFS_GET_REFERRALS,
-				true /* is_fsctl */,
 				(char *)dfs_req, dfs_req_size, CIFSMaxBufSize,
 				(char **)&dfs_rsp, &dfs_rsp_size);
 		if (!is_retryable_error(rc))
@@ -3129,8 +3122,7 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 
 	rc = SMB2_ioctl_init(tcon, server,
 			     &rqst[1], fid.persistent_fid,
-			     fid.volatile_fid, FSCTL_GET_REPARSE_POINT,
-			     true /* is_fctl */, NULL, 0,
+			     fid.volatile_fid, FSCTL_GET_REPARSE_POINT, NULL, 0,
 			     CIFSMaxBufSize -
 			     MAX_SMB2_CREATE_RESPONSE_SIZE -
 			     MAX_SMB2_CLOSE_RESPONSE_SIZE);
@@ -3310,8 +3302,7 @@ smb2_query_reparse_tag(const unsigned int xid, struct cifs_tcon *tcon,
 
 	rc = SMB2_ioctl_init(tcon, server,
 			     &rqst[1], COMPOUND_FID,
-			     COMPOUND_FID, FSCTL_GET_REPARSE_POINT,
-			     true /* is_fctl */, NULL, 0,
+			     COMPOUND_FID, FSCTL_GET_REPARSE_POINT, NULL, 0,
 			     CIFSMaxBufSize -
 			     MAX_SMB2_CREATE_RESPONSE_SIZE -
 			     MAX_SMB2_CLOSE_RESPONSE_SIZE);
@@ -3587,7 +3578,7 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	fsctl_buf.BeyondFinalZero = cpu_to_le64(offset + len);
 
 	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
-			cfile->fid.volatile_fid, FSCTL_SET_ZERO_DATA, true,
+			cfile->fid.volatile_fid, FSCTL_SET_ZERO_DATA,
 			(char *)&fsctl_buf,
 			sizeof(struct file_zero_data_information),
 			0, NULL, NULL);
@@ -3648,7 +3639,7 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 
 	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
 			cfile->fid.volatile_fid, FSCTL_SET_ZERO_DATA,
-			true /* is_fctl */, (char *)&fsctl_buf,
+			(char *)&fsctl_buf,
 			sizeof(struct file_zero_data_information),
 			CIFSMaxBufSize, NULL, NULL);
 	filemap_invalidate_unlock(inode->i_mapping);
@@ -3710,7 +3701,7 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 	in_data.length = cpu_to_le64(len);
 	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
 			cfile->fid.volatile_fid,
-			FSCTL_QUERY_ALLOCATED_RANGES, true,
+			FSCTL_QUERY_ALLOCATED_RANGES,
 			(char *)&in_data, sizeof(in_data),
 			1024 * sizeof(struct file_allocated_range_buffer),
 			(char **)&out_data, &out_data_len);
@@ -4022,7 +4013,7 @@ static loff_t smb3_llseek(struct file *file, struct cifs_tcon *tcon, loff_t offs
 
 	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
 			cfile->fid.volatile_fid,
-			FSCTL_QUERY_ALLOCATED_RANGES, true,
+			FSCTL_QUERY_ALLOCATED_RANGES,
 			(char *)&in_data, sizeof(in_data),
 			sizeof(struct file_allocated_range_buffer),
 			(char **)&out_data, &out_data_len);
@@ -4082,7 +4073,7 @@ static int smb3_fiemap(struct cifs_tcon *tcon,
 
 	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
 			cfile->fid.volatile_fid,
-			FSCTL_QUERY_ALLOCATED_RANGES, true,
+			FSCTL_QUERY_ALLOCATED_RANGES,
 			(char *)&in_data, sizeof(in_data),
 			1024 * sizeof(struct file_allocated_range_buffer),
 			(char **)&out_data, &out_data_len);
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index b2b35edd6a310..61b18f802048f 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1152,7 +1152,7 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
 	}
 
 	rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
-		FSCTL_VALIDATE_NEGOTIATE_INFO, true /* is_fsctl */,
+		FSCTL_VALIDATE_NEGOTIATE_INFO,
 		(char *)pneg_inbuf, inbuflen, CIFSMaxBufSize,
 		(char **)&pneg_rsp, &rsplen);
 	if (rc == -EOPNOTSUPP) {
@@ -3013,7 +3013,7 @@ int
 SMB2_ioctl_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 		struct smb_rqst *rqst,
 		u64 persistent_fid, u64 volatile_fid, u32 opcode,
-		bool is_fsctl, char *in_data, u32 indatalen,
+		char *in_data, u32 indatalen,
 		__u32 max_response_size)
 {
 	struct smb2_ioctl_req *req;
@@ -3088,10 +3088,8 @@ SMB2_ioctl_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 	req->sync_hdr.CreditCharge =
 		cpu_to_le16(DIV_ROUND_UP(max(indatalen, max_response_size),
 					 SMB2_MAX_BUFFER_SIZE));
-	if (is_fsctl)
-		req->Flags = cpu_to_le32(SMB2_0_IOCTL_IS_FSCTL);
-	else
-		req->Flags = 0;
+	/* always an FSCTL (for now) */
+	req->Flags = cpu_to_le32(SMB2_0_IOCTL_IS_FSCTL);
 
 	/* validate negotiate request must be signed - see MS-SMB2 3.2.5.5 */
 	if (opcode == FSCTL_VALIDATE_NEGOTIATE_INFO)
@@ -3118,9 +3116,9 @@ SMB2_ioctl_free(struct smb_rqst *rqst)
  */
 int
 SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
-	   u64 volatile_fid, u32 opcode, bool is_fsctl,
-	   char *in_data, u32 indatalen, u32 max_out_data_len,
-	   char **out_data, u32 *plen /* returned data len */)
+	   u64 volatile_fid, u32 opcode, char *in_data, u32 indatalen,
+	   u32 max_out_data_len, char **out_data,
+	   u32 *plen /* returned data len */)
 {
 	struct smb_rqst rqst;
 	struct smb2_ioctl_rsp *rsp = NULL;
@@ -3162,7 +3160,7 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 
 	rc = SMB2_ioctl_init(tcon, server,
 			     &rqst, persistent_fid, volatile_fid, opcode,
-			     is_fsctl, in_data, indatalen, max_out_data_len);
+			     in_data, indatalen, max_out_data_len);
 	if (rc)
 		goto ioctl_exit;
 
@@ -3244,7 +3242,7 @@ SMB2_set_compression(const unsigned int xid, struct cifs_tcon *tcon,
 			cpu_to_le16(COMPRESSION_FORMAT_DEFAULT);
 
 	rc = SMB2_ioctl(xid, tcon, persistent_fid, volatile_fid,
-			FSCTL_SET_COMPRESSION, true /* is_fsctl */,
+			FSCTL_SET_COMPRESSION,
 			(char *)&fsctl_input /* data input */,
 			2 /* in data len */, CIFSMaxBufSize /* max out data */,
 			&ret_data /* out data */, NULL);
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 6c5a4d44b248a..ada1d7338f34f 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -144,13 +144,13 @@ extern int SMB2_open_init(struct cifs_tcon *tcon,
 extern void SMB2_open_free(struct smb_rqst *rqst);
 extern int SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon,
 		     u64 persistent_fid, u64 volatile_fid, u32 opcode,
-		     bool is_fsctl, char *in_data, u32 indatalen, u32 maxoutlen,
+		     char *in_data, u32 indatalen, u32 maxoutlen,
 		     char **out_data, u32 *plen /* returned data len */);
 extern int SMB2_ioctl_init(struct cifs_tcon *tcon,
 			   struct TCP_Server_Info *server,
 			   struct smb_rqst *rqst,
 			   u64 persistent_fid, u64 volatile_fid, u32 opcode,
-			   bool is_fsctl, char *in_data, u32 indatalen,
+			   char *in_data, u32 indatalen,
 			   __u32 max_response_size);
 extern void SMB2_ioctl_free(struct smb_rqst *rqst);
 extern int SMB2_change_notify(const unsigned int xid, struct cifs_tcon *tcon,
-- 
2.43.0



