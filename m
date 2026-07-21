Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3EA400DE1;
	Tue, 21 Jul 2026 20:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665248; cv=none; b=fN2xsJ0J1DmMv2BbPGzmWRv/u0rs+AxJZJQRw0sLXX2D0dKuFL6A0fRmqVLbFGLeG4Mp53xYxDBlVGgP57ZB4zhcjG1wP50MBH/FUyRYvym4NwflMafcsBDr2wmQ7yT3ml+yiVXAQrSBOzf0RTsKF/mm/PtL2ZNLOz2EDL+olyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665248; c=relaxed/simple;
	bh=lFPLTblBREeXzN7b3P2ewKCYkUjsJ+/6o+Dnett5QHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPm+mcrVosSQG+BBG9U/mMpYM/NPmR2SPMUU0muApzjJB+TP0XAt7fG6ovHVu+DqRO80z572IIKDt09tk4QVQ8UXNT/amqNfVpOy7FwJb7ITVm1vhZUR6pqMIeKtE7hA6r2oHNx0pL6s12cym+djqAfLE8gll7/dCqEM0KkMPx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0KZIRXXl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0KZIRXXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D611F000E9;
	Tue, 21 Jul 2026 20:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665246;
	bh=bFpX8Iz2u+VZsz6P7lJkl3hg+fnzVlnF2q8hX79/7/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0KZIRXXlLyYxiC57OLf1Qiy7sOsS+dV/Qa8sqIGv83bYwhKJrwZOOJTpruk0Hi4yF
	 jqW6ztRBqlAYW2MZ5fpCSYF+N5AVQXbRxrwDxB1vIwSyl5UnARn+B9v3Y1KI1yXb/0
	 Ngal9eGT3CDI/z5Ln1q2z2b1Z6Bu/mkPSWl9ZIRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Portnoy <dddhkts1@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 0188/1266] ksmbd: enforce FILE_READ_ATTRIBUTES on SMB_FIND_FILE_POSIX_INFORMATION
Date: Tue, 21 Jul 2026 17:10:25 +0200
Message-ID: <20260721152446.012163532@linuxfoundation.org>
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

commit 20c8442dc1003f9f7bb522d3dcd81d09ea59a79e upstream.

find_file_posix_info() in smb2_query_info() returns file metadata (owner
uid, group gid, mode, inode, size, allocation size, hard-link count and all
four timestamps) but performs no per-handle access check. Every sibling
query handler gates on the handle's granted access first --
get_file_basic_info(), get_file_all_info(), get_file_network_open_info()
and get_file_attribute_tag_info() all reject a handle lacking
FILE_READ_ATTRIBUTES_LE with -EACCES. The POSIX handler is gated only by
the connection-scoped tcon->posix_extensions flag, which is not a
per-handle authorization, so a handle opened with only FILE_WRITE_DATA is
correctly denied FileBasicInformation yet is allowed the strict-superset
POSIX info. Mirror the FILE_READ_ATTRIBUTES_LE gate the sibling info
handlers already use.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Gil Portnoy <dddhkts1@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5290,6 +5290,12 @@ static int find_file_posix_info(struct s
 	int out_buf_len = sizeof(struct smb311_posix_qinfo) + 32;
 	int ret;
 
+	if (!(fp->daccess & FILE_READ_ATTRIBUTES_LE)) {
+		pr_err("no right to read the attributes : 0x%x\n",
+		       fp->daccess);
+		return -EACCES;
+	}
+
 	ret = vfs_getattr(&fp->filp->f_path, &stat, STATX_BASIC_STATS,
 			  AT_STATX_SYNC_AS_STAT);
 	if (ret)


