Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA37E23392F;
	Sun,  7 Jun 2026 10:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827451; cv=none; b=Xe8qcDoW2FtgK6/acPFG2KEulh5bFccTxh6eWfielVFi5Xd2f1eOE7nSeGTyEUpwA/trpyVqdAwr0CnITaXD7U09KWNW3nXg9mGU+2htwyi4LznrMpI2MRxIvvRUChaa+BcBC/Gfc1RIlayPkUO9saJQoSjFNIyU1ROJ80cfVnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827451; c=relaxed/simple;
	bh=8Oa1qA2g1C+FtZ+UnEoGTXhVNBG4KN4hK2OlmnhJGx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eBxWWN54k08Qce2uyuSZi1KjiuHKNFAlwP/8Xr+N19Zypwpi1yp7w342qQxl79BPJH1EvaHGJa55h6A2mGHiswnCYcVfBidr9PWc/x7SfRc9Ce53/Iqsa7eTK/VcFnmblK+HwW2OWWpPJnL6qpQRvInSpJ8MvkDHRWpBd6TSsZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y+ioYBFG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y+ioYBFG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1CC81F00893;
	Sun,  7 Jun 2026 10:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827450;
	bh=owqEWyj51qNfrnpI8BoL67gdKBqfsJSCzmlORibsJy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y+ioYBFGv37y8uvs70S+JcdQZfkFCoAfmSxjVxbREQXEJ9Cm2PLeMeEhe6hiXbIve
	 Cu1chPoQBtcFn2aPAHKKmnTNtzba/g0wvTOqgk+JuFa/ZaWYK7MfFLR4Ag/WZYpKkp
	 Xxif8YdmFu+YhEq4Be0laPKnobPqgqGwS4JYvl1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
	Steve French <smfrench@gmail.com>,
	Sean Shen <grayhat@foxmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 057/315] ksmbd: fix FSCTL permission bypass by adding a permission check for FSCTL_SET_SPARSE
Date: Sun,  7 Jun 2026 11:57:24 +0200
Message-ID: <20260607095729.700717239@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Sean Shen <grayhat@foxmail.com>

[ Upstream commit cc57232cae23c0df91b4a59d0f519141ce9b5b02 ]

FSCTL_SET_SPARSE in fsctl_set_sparse() modifies the file's sparse
attribute and saves it through xattr without any permission checks.

This exposes two issues:

1) A client on a read-only share can change the sparse attribute
   on files it opened, even though the share is read-only.
   Other FSCTL write operations already check
   test_tree_conn_flag(work->tcon, KSMBD_TREE_CONN_FLAG_WRITABLE),
   but FSCTL_SET_SPARSE does not.

2) Even on writable shares, clients without FILE_WRITE_DATA or
   FILE_WRITE_ATTRIBUTES access should not modify the sparse
   attribute. Similar handle-level checks exist in other functions
   but are missing here.

Add both share-level writable check and per-handle access check.
Use goto out on error to avoid leaking file references.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Steve French <smfrench@gmail.com>
Signed-off-by: Sean Shen <grayhat@foxmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index da7b96707186e4..4689aac12c14ea 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8203,9 +8203,20 @@ static inline int fsctl_set_sparse(struct ksmbd_work *work, u64 id,
 	int ret = 0;
 	__le32 old_fattr;
 
+	if (!test_tree_conn_flag(work->tcon, KSMBD_TREE_CONN_FLAG_WRITABLE)) {
+		ksmbd_debug(SMB, "User does not have write permission\n");
+		return -EACCES;
+	}
+
 	fp = ksmbd_lookup_fd_fast(work, id);
 	if (!fp)
 		return -ENOENT;
+
+	if (!(fp->daccess & (FILE_WRITE_DATA_LE | FILE_WRITE_ATTRIBUTES_LE))) {
+		ret = -EACCES;
+		goto out;
+	}
+
 	idmap = file_mnt_idmap(fp->filp);
 
 	old_fattr = fp->f_ci->m_fattr;
-- 
2.53.0



