Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278DA2F25E4;
	Tue, 21 Jul 2026 20:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665131; cv=none; b=nW8f9g6JTJJ0I+P9XiiJWNt87KzuO2BhxHisMrUfRjx18GfscE2HUP3CwXaLeiFGRp1Fc8vBwPVsqzPms8r+a/epc3iw0NoLha26eULBi+JEyAthstQVMYS0syw8xsYuNNuz4w85MGj/nq5tAPI4R1iRPH9i64xLV2ySASplKNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665131; c=relaxed/simple;
	bh=MnKxot8O82WpgWKqFQXHmx8+PU8IBJE4Nf+20j8l97M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AIM02J6KxgWNhboSqmuqlDUZLTG+ikn2TqouleXB1rBSfIOqybTWWY25rfbLrIjRfwewN/VAbhiXaPjLXUujYgCGZGS7TZvK7E5y+dsdJaBOPLGRxjOiOYk00cJPWHxvEAbekkc9HoeZdU2haYL8HM6/JHgIWjSxafarwJfrNJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZPch6Hct; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZPch6Hct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF441F000E9;
	Tue, 21 Jul 2026 20:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665130;
	bh=4wa70wiq8RTeuX5ESpZBzZ/n/URLtcisLzJOp1SpJpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZPch6HctiX0JT0vNxEfO36O+FvwS8Gq8cfMdEJeIAZcGfpX3R+1ajIa5NM7eWyhHw
	 NHPMGF2GDIXOh8KhC8o6WPML6baRHf6G4DDvglVyu7J66aqYkd/qVcM3igIbdrGnDi
	 UuTgUmt/PVFfqtEbMr7vZpJUOdMhH+hdfhkBDoCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Portnoy <dddhkts1@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 0189/1266] ksmbd: add per-handle permission check to FILE_LINK_INFORMATION
Date: Tue, 21 Jul 2026 17:10:26 +0200
Message-ID: <20260721152446.034430782@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Gil Portnoy <dddhkts1@gmail.com>

commit 13f3942f2bf45856bb751faed2f0c4618f41ca20 upstream.

The FILE_LINK_INFORMATION arm of smb2_set_info_file() calls
smb2_create_link() with no per-handle fp->daccess check. On the
ReplaceIfExists path smb2_create_link() unlinks an existing file at the
target name (ksmbd_vfs_remove_file) and creates a hardlink
(ksmbd_vfs_link); neither helper checks daccess. A handle opened with
FILE_READ_DATA only (no FILE_DELETE, no FILE_WRITE_DATA) can therefore
delete an arbitrary file in the share and plant a hardlink over its name.

The sibling delete/move arms in the same switch already gate:
FILE_RENAME_INFORMATION and FILE_DISPOSITION_INFORMATION both require
FILE_DELETE_LE; FILE_FULL_EA_INFORMATION requires FILE_WRITE_EA_LE. Gate
the link arm the same way as its closest analogue (rename), since it
mutates the namespace and, on replace, deletes an existing entry.

This is a sibling of commit cc57232cae23 ("ksmbd: fix FSCTL permission
bypass by adding a permission check for FSCTL_SET_SPARSE").

Cc: stable@vger.kernel.org
Signed-off-by: Gil Portnoy <dddhkts1@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6504,6 +6504,11 @@ static int smb2_set_info_file(struct ksm
 	}
 	case FILE_LINK_INFORMATION:
 	{
+		if (!(fp->daccess & FILE_DELETE_LE)) {
+			pr_err("no right to delete : 0x%x\n", fp->daccess);
+			return -EACCES;
+		}
+
 		if (buf_len < sizeof(struct smb2_file_link_info))
 			return -EINVAL;
 


