Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551334266B2;
	Tue, 21 Jul 2026 21:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668356; cv=none; b=lrR9Wwg1fn5cbVrbio8vKHn0depMAR1rfl+8eFmKMwDke/R0zYwOkeSudgqE/65Cwr5EdyO5eRDTs593jEvjOXJKXoUe6p03jRTchC0FcsS9HSlw84rJNsFf328q+Zh/VYhd7rMhr4qmGO5/t1FBsYkNjYc6H8nPmCxqE7A8+JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668356; c=relaxed/simple;
	bh=EiJuq+IyHqXFSzBzSL/2qenl2e14bFBUpmx38udNUV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lK9+5ythmRtHQXPwrtpqhpWTJ8R59eEuXqhh6/54HtKyqTKYUYLqRfTZTP4/zzCMA+qXBlDUprzmTLgGjF7Crmn0D3EOAZlw0K5ChrF0NRyi6XBOYbdlrwoG+tGUvzJxtDIRd0LHQu0eSU8aeNoit5cH7tfrEC6WBki1WbIG24k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wQWm/bgI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wQWm/bgI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A312D1F00A3A;
	Tue, 21 Jul 2026 21:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668354;
	bh=dFNjOa4zU21TrzmcgkQ3SwbfV9W4hRBYxXctqeaY/20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wQWm/bgIpffa/P2La5+8BHoMm+pof9yz/K8Mq0k1mMS7eznPRDfz4uaK93kIJqQxp
	 LMJbudQ28MIaQAPHBEU0dItmx94gXRChp3jgp35f9oNvyqdKUghTbwRJbT8fucRCRG
	 kw/o8ERfgMMbSUHunkAqhnt7hmXbCVWUPV+aXbfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Portnoy <dddhkts1@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 0142/1067] ksmbd: add per-handle permission check to FILE_LINK_INFORMATION
Date: Tue, 21 Jul 2026 17:12:23 +0200
Message-ID: <20260721152427.771670999@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6060,6 +6060,11 @@ static int smb2_set_info_file(struct ksm
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
 


