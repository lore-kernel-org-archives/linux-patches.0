Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9C1530DFB;
	Wed, 23 Sep 2026 14:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173184; cv=none; b=kElSZDxSfpsZQSCaJbn9B/n93AbcEgwyvVgjEBL/wCmoT16kYpD8MSq994m2r1xbz6rbJNW7DLbNTU0/y/uu6NiYxNo5qvLKaWhRBNL/QLs8AeiiP5pnp7UqZSG9tq29N6s7gvRZrJahJbzfjF7LOFoG4W7Z2qogYzKB2F3bEeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173184; c=relaxed/simple;
	bh=SNZX4MLwOljJYhqfpY1irnyOipLfUHOnVUUIfQfEAYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=US2K8b2XTo+IS3VkviASgKjPMAMx2pUyQ+YR6MJVSV+wfYiniwO0ekxBks8zLU92RC7O03iQPP6Ul1133qEfTdN2ZEipoTsKNLOnRs3S1oIJnfi4wqV/hR3udTnLuicm2WEGYYJowCZV7jDFog4lb8NzuUkhyNrlzsmSUtGIIME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WZ6xnSO2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WZ6xnSO2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 678711F00898;
	Wed, 23 Sep 2026 14:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173183;
	bh=3fpk393231iYi6TBRCknA4mVgbJfTFnk/3dM06g3oh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WZ6xnSO274XxbG31b5iVWxg+D2KtPCvNyttHaYhqy2HAcoP63PpiL9jEOQ3RsVIq0
	 vSyescaLbZiCU410vv9tcjYb0Q0xZYXDjtlOp6fsu4xcYsJ2p4LbcXIfv+2TVJGQ39
	 JjNHHjgMJ5OxUCbHrt/Cm3FLu1MotExhDB8RfCZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mobin Aydinfar <mobin@mobintestserver.ir>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 166/438] ksmbd: keep compound responses on query info errors
Date: Wed, 23 Sep 2026 16:03:07 +0200
Message-ID: <20260923140649.073660394@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index f6b9a0ad922ff..5312ae3fc5023 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5624,21 +5624,18 @@ int smb2_query_dir(struct ksmbd_work *work)
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
 
@@ -5649,8 +5646,7 @@ static int buffer_check_err(int reqOutputBufferLength,
 	return 0;
 }
 
-static void get_standard_info_pipe(struct smb2_query_info_rsp *rsp,
-				   void *rsp_org)
+static void get_standard_info_pipe(struct smb2_query_info_rsp *rsp)
 {
 	struct smb2_file_standard_info *sinfo;
 
@@ -5665,8 +5661,7 @@ static void get_standard_info_pipe(struct smb2_query_info_rsp *rsp,
 		cpu_to_le32(sizeof(struct smb2_file_standard_info));
 }
 
-static void get_internal_info_pipe(struct smb2_query_info_rsp *rsp, u64 num,
-				   void *rsp_org)
+static void get_internal_info_pipe(struct smb2_query_info_rsp *rsp, u64 num)
 {
 	struct smb2_file_internal_info *file_info;
 
@@ -5680,8 +5675,7 @@ static void get_internal_info_pipe(struct smb2_query_info_rsp *rsp, u64 num,
 
 static int smb2_get_info_file_pipe(struct ksmbd_session *sess,
 				   struct smb2_query_info_req *req,
-				   struct smb2_query_info_rsp *rsp,
-				   void *rsp_org)
+				   struct smb2_query_info_rsp *rsp)
 {
 	u64 id;
 	int rc;
@@ -5706,16 +5700,16 @@ static int smb2_get_info_file_pipe(struct ksmbd_session *sess,
 
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
@@ -6431,8 +6425,7 @@ static int smb2_get_info_file(struct ksmbd_work *work,
 	if (test_share_config_flag(work->tcon->share_conf,
 				   KSMBD_SHARE_FLAG_PIPE)) {
 		/* smb2 info file called for pipe */
-		rc = smb2_get_info_file_pipe(work->sess, req, rsp,
-					       work->response_buf);
+		rc = smb2_get_info_file_pipe(work->sess, req, rsp);
 		goto iov_pin_out;
 	}
 
@@ -6544,7 +6537,7 @@ static int smb2_get_info_file(struct ksmbd_work *work,
 		}
 		rc = buffer_check_err(le32_to_cpu(req->OutputBufferLength),
 				      fixed_len,
-				      rsp, work->response_buf);
+				      rsp);
 	}
 	ksmbd_fd_put(work, fp);
 
@@ -6806,7 +6799,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 	}
 	rc = buffer_check_err(le32_to_cpu(req->OutputBufferLength),
 			      fixed_len,
-			      rsp, work->response_buf);
+			      rsp);
 	path_put(&path);
 
 	if (!rc)
@@ -6908,7 +6901,7 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
 	rsp->OutputBufferLength = cpu_to_le32(secdesclen);
 	rc = buffer_check_err(le32_to_cpu(req->OutputBufferLength),
 			      le32_to_cpu(rsp->OutputBufferLength),
-			      rsp, work->response_buf);
+			      rsp);
 	if (rc)
 		goto err_out;
 
-- 
2.53.0



