Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4C5355819;
	Wed, 30 Sep 2026 19:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796132; cv=none; b=NK1ocFg8vb5Lbx1RHBxpAAPDX/6+HfB6+07ILZ6Ns/wpDDWDUvPOgXezEEuAjCeuCHbrofR9ZHKFcqWU6tM+5Y5d+OQf8BqRL6PPgtxcEwExUThBozwFCvgh7DlMN1gVj7YvpSQ/cbnzeZVfOAin3d28ltmKBlhiisANVQ9JZog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796132; c=relaxed/simple;
	bh=h69jXzMOmSWF6Pf60jf+WC+akL0OfnP9mz79Jp3EwRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZWkhFF/CtahtFfg0xxW92k57HQJB/V1EJpYwLWFpkzzNb1giTn4HUZNpSDQ0CtEvWTwhTRSBu+/I7jz2GvphA1tsIv3okovebfRYgdkj2Iho8BZOj3DEUsoUS1MgpxNRWIOF6hVnJHS8OiZt5i5kEd7OsP4E8s+AW0tY6lmVefc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BEFu21IJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BEFu21IJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E271F000FF;
	Wed, 30 Sep 2026 19:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796131;
	bh=dWd7iQuMvxSq4+3bVh5ISz4tMjjk/XJykiwbwpUQPzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BEFu21IJGiVWh4QUJ65QZHDkH1LS2GQBl30igAhet1pk1drNt4sJVvqEjqYwbxX1g
	 oktve+CoF0nZ6sio6dBTMnEkNvR1WtQ7GLk8zpf8vvmhXQk5cMK3Bo4Z8SXsmd8i74
	 C88TN0m6CYhj0atMcFHr0+04vbeYvrdBIATW1J44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0803/1193] ksmbd: fix partial file information responses
Date: Wed, 30 Sep 2026 17:24:47 +0200
Message-ID: <20260930152452.084018331@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 6b8b79226bc3e0ac3fdd4e91836241af712e8cd1 ]

Variable-length file information handlers use the client output length
while constructing the response. FILE_ALL_INFORMATION can consequently
return -EINVAL before the common buffer check, while stream information
can stop building the complete result too early.

Build the complete response within the available server response buffer
and apply the client output length only when selecting the final status
and transmitted length. Use the protocol-defined fixed sizes for all,
alternate-name, and stream information to distinguish
STATUS_INFO_LENGTH_MISMATCH from STATUS_BUFFER_OVERFLOW.

This fixes smb2.getinfo.qfile_buffercheck.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Stable-dep-of: 9fa26285ae70 ("ksmbd: keep compound responses on query info errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index c85cbfc945cd9..4f33b73724c04 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4997,7 +4997,6 @@ static int get_file_all_info(struct ksmbd_work *work,
 	char *filename;
 	u64 time;
 	int ret, buf_free_len, filename_len;
-	struct smb2_query_info_req *req = ksmbd_req_buf_next(work);
 
 	if (!(fp->daccess & FILE_READ_ATTRIBUTES_LE)) {
 		ksmbd_debug(SMB, "no right to read the attributes : 0x%x\n",
@@ -5010,10 +5009,9 @@ static int get_file_all_info(struct ksmbd_work *work,
 		return PTR_ERR(filename);
 
 	filename_len = strlen(filename);
-	buf_free_len = smb2_calc_max_out_buf_len(work,
+	buf_free_len = smb2_resp_buf_len(work,
 			offsetof(struct smb2_query_info_rsp, Buffer) +
-			offsetof(struct smb2_file_all_info, FileName),
-			le32_to_cpu(req->OutputBufferLength));
+			offsetof(struct smb2_file_all_info, FileName));
 	if (buf_free_len < (filename_len + 1) * 2) {
 		kfree(filename);
 		return -EINVAL;
@@ -5098,7 +5096,6 @@ static int get_file_stream_info(struct ksmbd_work *work,
 	ssize_t xattr_list_len;
 	int nbytes = 0, streamlen, stream_name_len, next, idx = 0;
 	int buf_free_len;
-	struct smb2_query_info_req *req = ksmbd_req_buf_next(work);
 	int ret;
 
 	ret = vfs_getattr(&fp->filp->f_path, &stat, STATX_BASIC_STATS,
@@ -5108,10 +5105,8 @@ static int get_file_stream_info(struct ksmbd_work *work,
 
 	file_info = (struct smb2_file_stream_info *)rsp->Buffer;
 
-	buf_free_len =
-		smb2_calc_max_out_buf_len(work,
-				offsetof(struct smb2_query_info_rsp, Buffer),
-				le32_to_cpu(req->OutputBufferLength));
+	buf_free_len = smb2_resp_buf_len(work,
+			offsetof(struct smb2_query_info_rsp, Buffer));
 	if (buf_free_len < 0)
 		goto out;
 
@@ -5407,6 +5402,7 @@ static int smb2_get_info_file(struct ksmbd_work *work,
 	struct ksmbd_file *fp;
 	int fileinfoclass = 0;
 	int rc = 0;
+	unsigned int fixed_len;
 	unsigned int id = KSMBD_NO_FID, pid = KSMBD_NO_FID;
 
 	if (test_share_config_flag(work->tcon->share_conf,
@@ -5510,10 +5506,23 @@ static int smb2_get_info_file(struct ksmbd_work *work,
 			    fileinfoclass);
 		rc = -EOPNOTSUPP;
 	}
-	if (!rc)
+	if (!rc) {
+		fixed_len = le32_to_cpu(rsp->OutputBufferLength);
+		switch (fileinfoclass) {
+		case FILE_ALL_INFORMATION:
+			fixed_len = FILE_ALL_INFORMATION_SIZE;
+			break;
+		case FILE_ALTERNATE_NAME_INFORMATION:
+			fixed_len = FILE_ALTERNATE_NAME_INFORMATION_SIZE;
+			break;
+		case FILE_STREAM_INFORMATION:
+			fixed_len = FILE_STREAM_INFORMATION_SIZE;
+			break;
+		}
 		rc = buffer_check_err(le32_to_cpu(req->OutputBufferLength),
-				      le32_to_cpu(rsp->OutputBufferLength),
+				      fixed_len,
 				      rsp, work->response_buf);
+	}
 	ksmbd_fd_put(work, fp);
 
 iov_pin_out:
-- 
2.53.0



