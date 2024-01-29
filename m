Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD2C157E6A;
	Mon, 29 Jan 2024 17:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548285; cv=none; b=MfIA/+2HdtpnfpkhYTAweEM9+hZOczGPrQ6UxPgNRnZBkJCpL5tehlwt5j54QXMS5xHT1WxqzQaJW7/HlH3X4G8AS/kf1j4sn6RKE8aqfiLyZpW8Ch83+Vm6UFMjqsiSZM4O2z/S7fEZB55yxJc4JoSq8fuYRD2r0G58w3lwFAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548285; c=relaxed/simple;
	bh=qcdoZVbTm3sV/SZ8xa6hnBHRZSx0X1/tV3HeBBNoiJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lvfBQYoNWDAg9KMb9C7CLbbvcHMKJ17EexDcQhoYn8AXSv8WavA8aWefVwUqn8VjVWs8KNrHWutVuUuH7hL8c5XZseoCjmJLLjldLcC2+qu34ApmyTZsVALPyZMD+xcvqfRSxZCQDecACX5FZuZbmKl++lInyKeGL+7t+42D/0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wYfWXHX8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wYfWXHX8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77618C433F1;
	Mon, 29 Jan 2024 17:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548285;
	bh=qcdoZVbTm3sV/SZ8xa6hnBHRZSx0X1/tV3HeBBNoiJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wYfWXHX8P5awf1uy66azZGR4UMs/pBzlW9S9jjRVDVdsp4mZSJnj4TVVsUNdCIVCY
	 cg95Y6w6bQ9Z7bJyPsgkl1Hx3uTJf9F8MZ3MBDm9epJKjrjjAXbWIFcpxVOUwg01Wa
	 NuQFy/QhuChUcOSQacxAi0sNvASPSs1xVCQqDYoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 070/185] ksmbd: fix potential circular locking issue in smb2_set_ea()
Date: Mon, 29 Jan 2024 09:04:30 -0800
Message-ID: <20240129170000.848263803@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 6fc0a265e1b932e5e97a038f99e29400a93baad0 ]

smb2_set_ea() can be called in parent inode lock range.
So add get_write argument to smb2_set_ea() not to call nested
mnt_want_write().

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2321,11 +2321,12 @@ out:
  * @eabuf:	set info command buffer
  * @buf_len:	set info command buffer length
  * @path:	dentry path for get ea
+ * @get_write:	get write access to a mount
  *
  * Return:	0 on success, otherwise error
  */
 static int smb2_set_ea(struct smb2_ea_info *eabuf, unsigned int buf_len,
-		       const struct path *path)
+		       const struct path *path, bool get_write)
 {
 	struct user_namespace *user_ns = mnt_user_ns(path->mnt);
 	char *attr_name = NULL, *value;
@@ -3013,7 +3014,7 @@ int smb2_open(struct ksmbd_work *work)
 
 			rc = smb2_set_ea(&ea_buf->ea,
 					 le32_to_cpu(ea_buf->ccontext.DataLength),
-					 &path);
+					 &path, false);
 			if (rc == -EOPNOTSUPP)
 				rc = 0;
 			else if (rc)
@@ -5990,7 +5991,7 @@ static int smb2_set_info_file(struct ksm
 			return -EINVAL;
 
 		return smb2_set_ea((struct smb2_ea_info *)req->Buffer,
-				   buf_len, &fp->filp->f_path);
+				   buf_len, &fp->filp->f_path, true);
 	}
 	case FILE_POSITION_INFORMATION:
 	{


