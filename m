Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27A742F6EE;
	Thu, 16 Jul 2026 14:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212020; cv=none; b=qTBIFkOWJROJ0EkRuzwdQa6W+xeaqu218a6DDxbbYpXzOUvnUFJuni0uXI6PELzQbTrtBZXOzAKpF86CnBwvhdwpSWbb5t3V6exFfnbxfH+yb3oQNIXGcckyMLPgfX5toUcS6uknZfvXTyMFNZUOpjsJ/T1SRMtRb4R5EnMWD14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212020; c=relaxed/simple;
	bh=J+viw0JmlMvv8oGiuovPGdgr4I8TsBfek0UBYwZiQbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c2sIXlvgK6hOPDDsKDabLrdWKoClhXYFac4n/oTiluWmQyUkVFVfI8ACxTsyqFF39xrQ+3L8o4+4XFsIpwek5S5Xgw8iv0A5s4dGJgxRgB+/KK07+juooCni4Kj/R0x4sCV6LlEWJgmaWoGxY9BzrtzdSRSeaQSruNe0pQN13Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wI6XTqy3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wI6XTqy3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B57B1F01563;
	Thu, 16 Jul 2026 14:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212018;
	bh=BWDbKhksthGcEHDAsDlJ0PyeguH8AkHk7YHBYpYSMiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wI6XTqy3FBZVsY4Cq0Sw/FUtA3s1dUebNuMtLZ0gYNKZbcK+pPOGo7Pr8SHlQ7+R8
	 8ei0tyCEk8zZ+8kMZqiMkVpsnmMNNr32FgShUExHufyn2D81MIoqmctjjKoLPGxG03
	 bfG0rRD60MYQ3bEow7i2aopVti3I0LVvwQrjAdFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Portnoy <dddhkts1@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 168/349] ksmbd: add a WRITE_DAC/WRITE_OWNER check to SMB2 SET_INFO SECURITY
Date: Thu, 16 Jul 2026 15:31:42 +0200
Message-ID: <20260716133037.141243184@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gil Portnoy <dddhkts1@gmail.com>

commit 44df157a1183a7f746caa970c169255da5ac61f8 upstream.

commit cc57232cae23 ("ksmbd: fix FSCTL permission bypass by adding a
permission check for FSCTL_SET_SPARSE") added a fp->daccess gate to
fsctl_set_sparse and noted that "similar handle-level checks exist in other
functions but are missing here." The SMB2 SET_INFO SECURITY arm is one of
the missing ones, and the most security-relevant: smb2_set_info_sec() calls
set_info_sec() with no per-handle access check.

set_info_sec() (fs/smb/server/smbacl.c) re-permissions the file: it
rewrites owner/group/mode via notify_change(), rewrites the POSIX ACL via
set_posix_acl(), and on KSMBD_SHARE_FLAG_ACL_XATTR shares removes and
rewrites the Windows security descriptor via ksmbd_vfs_set_sd_xattr().
Every other persistent-mutation arm of the sibling handler
smb2_set_info_file() checks fp->daccess first (FILE_WRITE_DATA /
FILE_DELETE / FILE_WRITE_EA / FILE_WRITE_ATTRIBUTES); the SECURITY arm —
which mutates the access control itself — is the only one with no gate.

A client can therefore open a handle with FILE_WRITE_ATTRIBUTES only (no
FILE_WRITE_DAC / FILE_WRITE_OWNER) and use SMB2_SET_INFO with InfoType
SMB2_O_INFO_SECURITY to rewrite the file's DACL and owner, granting itself
access the handle's daccess never carried. Unlike the FSCTL data arms this
is a metadata/xattr operation, so there is no FMODE_WRITE VFS backstop —
the missing fp->daccess check is the entire gate.

Setting a security descriptor is the WRITE_DAC / WRITE_OWNER operation, so
require at least one of those on the handle before re-permissioning the
file. -EACCES is mapped to STATUS_ACCESS_DENIED by smb2_set_info().

Cc: stable@vger.kernel.org
Signed-off-by: Gil Portnoy <dddhkts1@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6577,6 +6577,9 @@ static int smb2_set_info_sec(struct ksmb
 
 	fp->saccess |= FILE_SHARE_DELETE_LE;
 
+	if (!(fp->daccess & (FILE_WRITE_DAC_LE | FILE_WRITE_OWNER_LE)))
+		return -EACCES;
+
 	return set_info_sec(fp->conn, fp->tcon, &fp->filp->f_path, pntsd,
 			buf_len, false, true);
 }


