Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5E551A752;
	Wed, 30 Sep 2026 17:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788443; cv=none; b=DZ7kgS8bcJQBYRa9a9SkzpdBz9KwwTgbSKLXv5ZVDX+kjNXEstd18szvzt5HMGlfTkFia6HMJwpITjZJHjClmwZkPMvSOKPAne1Iv9/oGRgBS+68OV1PVQlNBmdt5MRgWoXdlC3BXd4Ues6xWs49ZfzeQo0S58zOk/unfnPj3jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788443; c=relaxed/simple;
	bh=Yluq8jXkkvba7SIgd4Tj9oqkh241nOwSZw+cOmr86dI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cpYl8YjNDzxVjMm+PjoKiCBW+Kk5J1eWHTpC5mBHWvlDYXWCKWujJkhRh7jHC6GEaKiUiC7pLB/p4LVNwRVz93Qbfyq03z1IRiEyn5aypPnSn3CV3JmV4Jz2R4fjGGPvjC7mlm8/JslLib48ZhYT2uzobSbBWs52gaG9QGFc6sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uzrceZjv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uzrceZjv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8571F000FF;
	Wed, 30 Sep 2026 17:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788442;
	bh=xNbYoPcBQmKlxSbWW+UXZBOqj6X8b95CVtNNga4IUhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uzrceZjvDkYfo0jeNkjFtuasTGP9ItsclQ0TMr84s81DCG+b098EIJ41uhQ6RuLB5
	 +OEWLfWUJaNCG/ttnSdHpC8ZFAjIMnengpEZYduRw6Qo9ekCUOBTZCKLFF2pDHxMR4
	 ounAAkzOZulNL9SsSFv50TYVHXVbp2gh8ajip0lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 127/877] ksmbd: fix partial file information responses
Date: Wed, 30 Sep 2026 17:17:18 +0200
Message-ID: <20260930152417.477832333@linuxfoundation.org>
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
index b12dad36bb574..af3178031c1ee 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5019,7 +5019,6 @@ static int get_file_all_info(struct ksmbd_work *work,
 	char *filename;
 	u64 time;
 	int ret, buf_free_len, filename_len;
-	struct smb2_query_info_req *req = ksmbd_req_buf_next(work);
 
 	if (!(fp->daccess & FILE_READ_ATTRIBUTES_LE)) {
 		ksmbd_debug(SMB, "no right to read the attributes : 0x%x\n",
@@ -5032,10 +5031,9 @@ static int get_file_all_info(struct ksmbd_work *work,
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
@@ -5120,7 +5118,6 @@ static int get_file_stream_info(struct ksmbd_work *work,
 	ssize_t xattr_list_len;
 	int nbytes = 0, streamlen, stream_name_len, next, idx = 0;
 	int buf_free_len;
-	struct smb2_query_info_req *req = ksmbd_req_buf_next(work);
 	int ret;
 
 	ret = vfs_getattr(&fp->filp->f_path, &stat, STATX_BASIC_STATS,
@@ -5130,10 +5127,8 @@ static int get_file_stream_info(struct ksmbd_work *work,
 
 	file_info = (struct smb2_file_stream_info *)rsp->Buffer;
 
-	buf_free_len =
-		smb2_calc_max_out_buf_len(work,
-				offsetof(struct smb2_query_info_rsp, Buffer),
-				le32_to_cpu(req->OutputBufferLength));
+	buf_free_len = smb2_resp_buf_len(work,
+			offsetof(struct smb2_query_info_rsp, Buffer));
 	if (buf_free_len < 0)
 		goto out;
 
@@ -5429,6 +5424,7 @@ static int smb2_get_info_file(struct ksmbd_work *work,
 	struct ksmbd_file *fp;
 	int fileinfoclass = 0;
 	int rc = 0;
+	unsigned int fixed_len;
 	unsigned int id = KSMBD_NO_FID, pid = KSMBD_NO_FID;
 
 	if (test_share_config_flag(work->tcon->share_conf,
@@ -5532,10 +5528,23 @@ static int smb2_get_info_file(struct ksmbd_work *work,
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



