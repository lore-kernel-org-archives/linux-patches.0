Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0493D8127;
	Thu, 16 Jul 2026 14:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210904; cv=none; b=YeK5DodP/KWQXJnDUo+KARErFBQnnW74tvX4wCa9Z6eFdKG0SJ9OMrAgRXH6E5p9zUni0ZvMFADUsldMmjA0FUIuUDv4jSCkEwM8CiPonw2hYsuqXWYhVkoQs5ljum6og5paCnUhlAMBEhDK9zvwAWWks8LrnfwMBTAgqEFJY94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210904; c=relaxed/simple;
	bh=AJBTTlN6qAQMLFzOSWyoC4h95MkHUgHNiTc4n7AIAdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JkFHLN4YYz9GPrtL3MxcXv/hyVNUqUveaaAlWmP1Y4gXcG5pYi6VYf9d5XwdwOybp/fR2F4dHWaMJIFFa33gvQEpHlnSQq8jnYEVqvNEtGhg3nsEOHT5yBF5HAzQOaaZEUzhN9yRHkhiWSMh3nngp3/LNnlL3azjhosgXyHil3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DtLQdJs/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DtLQdJs/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F971F00A3A;
	Thu, 16 Jul 2026 14:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210902;
	bh=xyPoUWyuEJcqdESvs4g0yoWKvLgqFymUy76upk2niH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DtLQdJs/5QtMsPwmzSoqoxWCDBzmwBdgKHviymBb8cwYqDo0HBrflZhlsQf51wQiq
	 BAKWYCNo1PD9/N3EXR4EG8fKfOnQ0SgPhf+NVzE2tubjRodJV/68tUw67hhiDq23pc
	 CmDY10+oj9UtWkIxOr1EOBNdKwDhcJG1XYPADgDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Portnoy <dddhkts1@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 222/480] ksmbd: add a WRITE_DAC/WRITE_OWNER check to SMB2 SET_INFO SECURITY
Date: Thu, 16 Jul 2026 15:29:29 +0200
Message-ID: <20260716133049.539168916@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6623,6 +6623,9 @@ static int smb2_set_info_sec(struct ksmb
 
 	fp->saccess |= FILE_SHARE_DELETE_LE;
 
+	if (!(fp->daccess & (FILE_WRITE_DAC_LE | FILE_WRITE_OWNER_LE)))
+		return -EACCES;
+
 	return set_info_sec(fp->conn, fp->tcon, &fp->filp->f_path, pntsd,
 			buf_len, false, true);
 }


