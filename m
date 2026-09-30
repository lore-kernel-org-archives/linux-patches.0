Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DFC5187DA;
	Wed, 30 Sep 2026 17:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788446; cv=none; b=ClCjfGZriy1kOq6s8+8QtAPTXeMMVUnTecKqYtcAKt3WUl1MOubTIpkpnMEdLlcYxCxN+CmwJMiEXmeTN3DGGFwLlJfIwJuem8wLkC1aQSYC5GGV81AE2iulAYfLvJ3Ybl0VS/NPn77877se635vk6xwfYb9iNsjsgH/aL1JJBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788446; c=relaxed/simple;
	bh=qZE2hBxnVrYWjBegFnFygRy1LC5DclDx2nKPZ8zqy5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKEXxsssdGCOetxc1HAMJgEQ4co6qP30CuVzIjQnLMJq4+e+KMnAbhlO0ggQsHMD7BtrNLfJf6sHi/3UTjLD3EJ3i7tgto4nPH1qaIn87uttdswJIP1/E9PmrEj9bHi2MIKUhCa/L9kbaohOZDi3wtKFmfloM/R2WmaTybO777I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AKC4lTCa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AKC4lTCa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 529461F000FF;
	Wed, 30 Sep 2026 17:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788444;
	bh=hWj7xvKcaOuPYLoFrtIiYf4DoxOq6rpoK1BawlkBbbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AKC4lTCaTt6vDAQBCjU4+NAhUOJpARbn3lrVIHREFpkMYSr2A7rmGwmPGmmKSd0ye
	 HcoHPbFt5ixW4d33i9TFjfuIjlfmBenf0CHBNMiJLf2Eqxx4Fk4Tq/4usRz29nG1Gr
	 uC0kLs5rlrIq6zlD3wHQKeZ4A3Gi8mjNQPiPGJSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mobin Aydinfar <mobin@mobintestserver.ir>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 128/877] ksmbd: keep compound responses on query info errors
Date: Wed, 30 Sep 2026 17:17:19 +0200
Message-ID: <20260930152417.498561628@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 9fa26285ae70ac2d3d1b47459a6b4463ab053e1c ]

Do not reset the RFC1002 length of the complete response when a query
info buffer is too small. The current command will add its error response
through ksmbd_iov_pin_rsp(), while resetting the base length can truncate
earlier responses in a compound request.

This lets ksmbd return the earlier responses and the query-info error
response together. Remove the now-unused rsp_org parameter from the pipe
query-info helpers.

Fixes: e2b76ab8b5c9 ("ksmbd: add support for read compound")
Reported-by: Mobin Aydinfar <mobin@mobintestserver.ir>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 31 ++++++++++++-------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index af3178031c1ee..283160908218e 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4650,21 +4650,18 @@ int smb2_query_dir(struct ksmbd_work *work)
  * @reqOutputBufferLength:	max buffer length expected in command response
  * @fixed_len:			minimum fixed response length
  * @rsp:		query info response buffer contains output buffer length
- * @rsp_org:		base response buffer pointer in case of chained response
  *
  * Return:	0 on success, otherwise error
  */
 static int buffer_check_err(int reqOutputBufferLength,
 			    unsigned int fixed_len,
-			    struct smb2_query_info_rsp *rsp,
-			    void *rsp_org)
+			    struct smb2_query_info_rsp *rsp)
 {
 	unsigned int output_len = le32_to_cpu(rsp->OutputBufferLength);
 
 	if (reqOutputBufferLength < fixed_len) {
 		pr_err("Invalid Buffer Size Requested\n");
 		rsp->hdr.Status = STATUS_INFO_LENGTH_MISMATCH;
-		*(__be32 *)rsp_org = cpu_to_be32(sizeof(struct smb2_hdr));
 		return -EINVAL;
 	}
 
@@ -4675,8 +4672,7 @@ static int buffer_check_err(int reqOutputBufferLength,
 	return 0;
 }
 
-static void get_standard_info_pipe(struct smb2_query_info_rsp *rsp,
-				   void *rsp_org)
+static void get_standard_info_pipe(struct smb2_query_info_rsp *rsp)
 {
 	struct smb2_file_standard_info *sinfo;
 
@@ -4691,8 +4687,7 @@ static void get_standard_info_pipe(struct smb2_query_info_rsp *rsp,
 		cpu_to_le32(sizeof(struct smb2_file_standard_info));
 }
 
-static void get_internal_info_pipe(struct smb2_query_info_rsp *rsp, u64 num,
-				   void *rsp_org)
+static void get_internal_info_pipe(struct smb2_query_info_rsp *rsp, u64 num)
 {
 	struct smb2_file_internal_info *file_info;
 
@@ -4706,8 +4701,7 @@ static void get_internal_info_pipe(struct smb2_query_info_rsp *rsp, u64 num,
 
 static int smb2_get_info_file_pipe(struct ksmbd_session *sess,
 				   struct smb2_query_info_req *req,
-				   struct smb2_query_info_rsp *rsp,
-				   void *rsp_org)
+				   struct smb2_query_info_rsp *rsp)
 {
 	u64 id;
 	int rc;
@@ -4732,16 +4726,16 @@ static int smb2_get_info_file_pipe(struct ksmbd_session *sess,
 
 	switch (req->FileInfoClass) {
 	case FILE_STANDARD_INFORMATION:
-		get_standard_info_pipe(rsp, rsp_org);
+		get_standard_info_pipe(rsp);
 		rc = buffer_check_err(le32_to_cpu(req->OutputBufferLength),
 				      le32_to_cpu(rsp->OutputBufferLength),
-				      rsp, rsp_org);
+				      rsp);
 		break;
 	case FILE_INTERNAL_INFORMATION:
-		get_internal_info_pipe(rsp, id, rsp_org);
+		get_internal_info_pipe(rsp, id);
 		rc = buffer_check_err(le32_to_cpu(req->OutputBufferLength),
 				      le32_to_cpu(rsp->OutputBufferLength),
-				      rsp, rsp_org);
+				      rsp);
 		break;
 	default:
 		ksmbd_debug(SMB, "smb2_info_file_pipe for %u not supported\n",
@@ -5430,8 +5424,7 @@ static int smb2_get_info_file(struct ksmbd_work *work,
 	if (test_share_config_flag(work->tcon->share_conf,
 				   KSMBD_SHARE_FLAG_PIPE)) {
 		/* smb2 info file called for pipe */
-		rc = smb2_get_info_file_pipe(work->sess, req, rsp,
-					       work->response_buf);
+		rc = smb2_get_info_file_pipe(work->sess, req, rsp);
 		goto iov_pin_out;
 	}
 
@@ -5543,7 +5536,7 @@ static int smb2_get_info_file(struct ksmbd_work *work,
 		}
 		rc = buffer_check_err(le32_to_cpu(req->OutputBufferLength),
 				      fixed_len,
-				      rsp, work->response_buf);
+				      rsp);
 	}
 	ksmbd_fd_put(work, fp);
 
@@ -5780,7 +5773,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 	}
 	rc = buffer_check_err(le32_to_cpu(req->OutputBufferLength),
 			      fixed_len,
-			      rsp, work->response_buf);
+			      rsp);
 	path_put(&path);
 
 	if (!rc)
@@ -5895,7 +5888,7 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
 	rsp->OutputBufferLength = cpu_to_le32(secdesclen);
 	rc = buffer_check_err(le32_to_cpu(req->OutputBufferLength),
 			      le32_to_cpu(rsp->OutputBufferLength),
-			      rsp, work->response_buf);
+			      rsp);
 	if (rc)
 		goto err_out;
 
-- 
2.53.0



