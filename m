Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A801B15703D;
	Mon, 29 Jan 2024 17:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548129; cv=none; b=UNeyA230iszm/73TTImokilKAsN9l03nuYNjCGuYmMrYtcFWkMLupdCrnb4xvwZ/fJr4jPwIZ0Pt7gJMuwtH3SSpgO5wNConD7ap/nqZ6hZhaA1Bc/p/4s9OJ+cnV5RqeshBV7pCtKDagJboTfq4pvGqfa64yxB43N/Rvc4QKi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548129; c=relaxed/simple;
	bh=ksfPhhVaNGK/khoobvqi3NbeDFI/Mxc+M4Sk5BBz98c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Olm5vrshOmo+sZpWvE/Mfqx9+tlkAKqOu/dwF4FMa8WX6rn1rdiWQcw9omLlH7TWhPZa0kSp30oWtWt1yI97XXfqjht+Mz/sFTRkpAniPDb6arNp2K+F8qLTaEZrBg876S5/RoloxZWKQ6IX9/FXtH+OwfR8n5BG/t9fZyitUIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DzysQdo7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DzysQdo7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 700A8C433C7;
	Mon, 29 Jan 2024 17:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548129;
	bh=ksfPhhVaNGK/khoobvqi3NbeDFI/Mxc+M4Sk5BBz98c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DzysQdo73Xz2U7SbbPTIUUu1+zvohZXpOps/RrZES8piWQjnpuU8PI7UaDHAzfqL3
	 RjH9nUqCCKrRZuGr8/XbSTdSdt2xCq71l+H2ZwFAhknltS3DbuJX1OtyGkBBmqGTdA
	 Vf3qTjqMC+VNM9jDlYVJFlFZr4kIM8AByMbvIEeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.7 141/346] ksmbd: fix potential circular locking issue in smb2_set_ea()
Date: Mon, 29 Jan 2024 09:02:52 -0800
Message-ID: <20240129170020.548624773@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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
@@ -2323,11 +2323,12 @@ out:
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
 	struct mnt_idmap *idmap = mnt_idmap(path->mnt);
 	char *attr_name = NULL, *value;
@@ -3015,7 +3016,7 @@ int smb2_open(struct ksmbd_work *work)
 
 			rc = smb2_set_ea(&ea_buf->ea,
 					 le32_to_cpu(ea_buf->ccontext.DataLength),
-					 &path);
+					 &path, false);
 			if (rc == -EOPNOTSUPP)
 				rc = 0;
 			else if (rc)
@@ -5992,7 +5993,7 @@ static int smb2_set_info_file(struct ksm
 			return -EINVAL;
 
 		return smb2_set_ea((struct smb2_ea_info *)req->Buffer,
-				   buf_len, &fp->filp->f_path);
+				   buf_len, &fp->filp->f_path, true);
 	}
 	case FILE_POSITION_INFORMATION:
 	{


