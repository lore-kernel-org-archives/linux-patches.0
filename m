Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C3D7F7C9;
	Wed, 21 Feb 2024 13:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521962; cv=none; b=Qsx6h+GDPd/18h76/QqEG1yIhfw8h/iAaMGTfuguwm3niLTlPLOrEtjMn47zONZp1PsCtl04mM08d/FXs3+lgMOmKmHn5sAtivGIvCxrkCaEmJVwIHow78+Xs1pngmjcLy8qr1swkb7p0mwPGXeUeezBoS/wyLKKl2qK8iagZHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521962; c=relaxed/simple;
	bh=cBiIj3p7q/AQKB6x4VYcsM4ZKGPpRyZit7GK5TkjskY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ivpnp4LzyBTHKpWvkKfaMCjjTmnjys45ivm0+4HDHkjuuacsrS76pArlDOpmbVSAD1Y8Dq52uyZ/lf205hPWwL7ZRM/9WFy/folVY393Al+alCj9oClE/e6jLNasAlrj5Q8Q4u4wksRzFDtEqYCiNAGIN9CsOuaGQe55l5p4C04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wRw0xXgD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wRw0xXgD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C89FC433B1;
	Wed, 21 Feb 2024 13:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521962;
	bh=cBiIj3p7q/AQKB6x4VYcsM4ZKGPpRyZit7GK5TkjskY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wRw0xXgDBe6ih9IIF3SONq8VAp+tDYgoDABypgLZy5kpa04V1oLGZFEoHj+heEDbL
	 jM9aFGi1m96WD3PWlRQPuw4nx8x+1GEDCFumFJdoVb8IMBxCHJvzNBH+PYEYWsSxCY
	 M2jCDcpTRZ/b7sYs0euBZ4wCQRRWfLfjmmznG0Tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 041/476] ksmbd: fix potential circular locking issue in smb2_set_ea()
Date: Wed, 21 Feb 2024 14:01:32 +0100
Message-ID: <20240221130009.459236129@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 6fc0a265e1b932e5e97a038f99e29400a93baad0 ]

smb2_set_ea() can be called in parent inode lock range.
So add get_write argument to smb2_set_ea() not to call nested
mnt_want_write().

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
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
 	struct user_namespace *user_ns = mnt_user_ns(path->mnt);
 	char *attr_name = NULL, *value;
@@ -3012,7 +3013,7 @@ int smb2_open(struct ksmbd_work *work)
 
 			rc = smb2_set_ea(&ea_buf->ea,
 					 le32_to_cpu(ea_buf->ccontext.DataLength),
-					 &path);
+					 &path, false);
 			if (rc == -EOPNOTSUPP)
 				rc = 0;
 			else if (rc)
@@ -5994,7 +5995,7 @@ static int smb2_set_info_file(struct ksm
 			return -EINVAL;
 
 		return smb2_set_ea((struct smb2_ea_info *)req->Buffer,
-				   buf_len, &fp->filp->f_path);
+				   buf_len, &fp->filp->f_path, true);
 	}
 	case FILE_POSITION_INFORMATION:
 	{


