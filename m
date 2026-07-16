Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094BC42982C;
	Thu, 16 Jul 2026 14:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212025; cv=none; b=oJoDSQY1L/51zORHRCu1eUf82evNOHaNFvE8eHbzO7TWYr7aH3x+9x4lXHIodeqM7ajm6P3qxs5uu+bR776VkqMnrHDLdqViR35v+JN/7bVeog/yYf1iJ2x1O+X4OSYDFxohQkZKjDeAL9BZz1NCDW4rZQurhVNCqLwVg8w4AKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212025; c=relaxed/simple;
	bh=J4JfN4Nhx8J4/mt34utGqeokVzt1DVO3lBwOWml7/hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EmjE6tBaLM0L5D5zYn91ffBDo5BYfVoHxmlDfNnZsPjbOU8piqjXcNor4JAZmfGLQXYKGIVo2yikwO4cwH/a6g5dxMX1rLi0ztNkmJOQmG0dBgURBLpdU6Ez6H93OXkQ5oOCkPgky7zuW3Hi4Bv/REZKrIhZUYTK0F/uZiiIuWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SLU4xhGA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SLU4xhGA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD2D1F0155A;
	Thu, 16 Jul 2026 14:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212023;
	bh=F44GLWxlV21+EYwRPLNZ/RM0eNIig6ZU7Na8apZT5Dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SLU4xhGA4MRLLH36nPZjqqrgBvAaqZfHUGylWEkAxlWQacOb9L/ZMR6NSviiNCdKj
	 G55FB5JuJ/48tzTLA1W7taXLGZw+GKC0OgY9T4KfJfChfu2VQyzMdmzO5aRZcUopd+
	 MpZUYLCxXLFjIny9x84Bnm1a294KzbtRlXn4/i8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Portnoy <dddhkts1@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 170/349] ksmbd: enforce FILE_READ_ATTRIBUTES on SMB_FIND_FILE_POSIX_INFORMATION
Date: Thu, 16 Jul 2026 15:31:44 +0200
Message-ID: <20260716133037.186647098@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5312,6 +5312,12 @@ static int find_file_posix_info(struct s
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


