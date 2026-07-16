Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633A7313E30;
	Thu, 16 Jul 2026 14:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210908; cv=none; b=YgLmlGt/PHs3rQVHNlCw7JxcQ/jAtSsOJq9OtEzzt64y2rSA9Y3qNnd/mmy4s32HAo9v/Ds2h9BgHvokLa95PjfOhsCM7t0T9NECw97OTtXIvOaQPZBrxlrx5IHL11I/wrPz4zZN1XGQx8NcBv2yp3p1nki+BNI9jen5goXNVOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210908; c=relaxed/simple;
	bh=qaWZe52QmUjRngTm+HD1SKnxc9AxzB7P6UpEDXPCn5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fYbaHIK7TMMusV6tKkMy1ez07XkHgdrhFw9BsuVA2nIZaNZK78eFWs/k8NamYC7L0ibHATpbVK4E68hebveI37Ck4Pryps6EyA2chJc9jNI9wQqQJ3yqb3KwddMQyzOFyTvKCS8MdJlffpykT6PYRhJCxpU9pTUyZQZCmmKf8y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2vpQWewp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2vpQWewp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97541F000E9;
	Thu, 16 Jul 2026 14:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210907;
	bh=uGrg7yPdOVh+YZw1vL3Kbcn6tRKvo3oiCdDlECXWrPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2vpQWewpr/jODv/Jf2EqJSzhRveNP14xbK7qMYw5AxSXzMWyHxROq4+apBdeVGwLx
	 eIexHq3DS47VjvH2eD5+x9PF9tsSmJ/1pjMpkjJ9/GopSQutrY8Yqw2SOD+/B3E3oa
	 Ne1KYZZlIE9ng+w3P2nc434pMpzu1hN+thCC2mkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Portnoy <dddhkts1@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 224/480] ksmbd: enforce FILE_READ_ATTRIBUTES on SMB_FIND_FILE_POSIX_INFORMATION
Date: Thu, 16 Jul 2026 15:29:31 +0200
Message-ID: <20260716133049.583827913@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5339,6 +5339,12 @@ static int find_file_posix_info(struct s
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


