Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B3619FA98;
	Tue, 16 Jul 2024 15:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145434; cv=none; b=KtcU/goT+OOohith0SAewTgQK5CYCUIVcTDqatu+8tvTKY2YEeoiWSpFdAGG5J98SDogVBfacNjHIlMcpyAB06rm91Oo6xiZDL7ihY6wzJZ8MSCZwWmskfb89h1dBOjWXGC6zWnTUqDraXFK98uZ08/vDC+E0WxZfQAGPg79oDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145434; c=relaxed/simple;
	bh=/sOL/Ru/5hljYTinAPEVRekUtapfreyqUBgdWw6fD/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/MdKYYLmbhYSoMxdzsaZkhii18k6jdng+0S7pXeP2hyLs8LL1a5B8H6b4jh1DtIuCv8TN+J24TkFjiDirCbln6CBlZJIxuoZppKwWmShtDXMh4c7D/XbzRhVc+GxuLRWkCtA3Zb0EeOgzYjJt3qjmCGidyuDAlPt0xLRBEsaBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q/m1Mp9n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q/m1Mp9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F10C116B1;
	Tue, 16 Jul 2024 15:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145434;
	bh=/sOL/Ru/5hljYTinAPEVRekUtapfreyqUBgdWw6fD/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q/m1Mp9nlIY65holM/5RxAUIwpDBQEdeVeO9lVFiT2kNp4tJrtLLm6+ykXWG1J4H1
	 ffvrIjA3MUWv5jMx+T7CbE2kLwgbn4nIRfHOnfs7k4uNxa7dHoQLx3qQd97Fro4SP9
	 vz+of0oBCj0W6D6HOM53UWuv0ifDz09pX2uQ0o7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yoonho Shin <yoonho.shin@samsung.com>,
	Hobin Woo <hobin.woo@samsung.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 62/96] ksmbd: discard write access to the directory open
Date: Tue, 16 Jul 2024 17:32:13 +0200
Message-ID: <20240716152748.892347656@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hobin Woo <hobin.woo@samsung.com>

commit e2e33caa5dc2eae7bddf88b22ce11ec3d760e5cd upstream.

may_open() does not allow a directory to be opened with the write access.
However, some writing flags set by client result in adding write access
on server, making ksmbd incompatible with FUSE file system. Simply, let's
discard the write access when opening a directory.

list_add corruption. next is NULL.
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:26!
pc : __list_add_valid+0x88/0xbc
lr : __list_add_valid+0x88/0xbc
Call trace:
__list_add_valid+0x88/0xbc
fuse_finish_open+0x11c/0x170
fuse_open_common+0x284/0x5e8
fuse_dir_open+0x14/0x24
do_dentry_open+0x2a4/0x4e0
dentry_open+0x50/0x80
smb2_open+0xbe4/0x15a4
handle_ksmbd_work+0x478/0x5ec
process_one_work+0x1b4/0x448
worker_thread+0x25c/0x430
kthread+0x104/0x1d4
ret_from_fork+0x10/0x20

Cc: stable@vger.kernel.org
Signed-off-by: Yoonho Shin <yoonho.shin@samsung.com>
Signed-off-by: Hobin Woo <hobin.woo@samsung.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2062,15 +2062,22 @@ out_err1:
  * @access:		file access flags
  * @disposition:	file disposition flags
  * @may_flags:		set with MAY_ flags
+ * @is_dir:		is creating open flags for directory
  *
  * Return:      file open flags
  */
 static int smb2_create_open_flags(bool file_present, __le32 access,
 				  __le32 disposition,
-				  int *may_flags)
+				  int *may_flags,
+				  bool is_dir)
 {
 	int oflags = O_NONBLOCK | O_LARGEFILE;
 
+	if (is_dir) {
+		access &= ~FILE_WRITE_DESIRE_ACCESS_LE;
+		ksmbd_debug(SMB, "Discard write access to a directory\n");
+	}
+
 	if (access & FILE_READ_DESIRED_ACCESS_LE &&
 	    access & FILE_WRITE_DESIRE_ACCESS_LE) {
 		oflags |= O_RDWR;
@@ -2983,7 +2990,9 @@ int smb2_open(struct ksmbd_work *work)
 
 	open_flags = smb2_create_open_flags(file_present, daccess,
 					    req->CreateDisposition,
-					    &may_flags);
+					    &may_flags,
+		req->CreateOptions & FILE_DIRECTORY_FILE_LE ||
+		(file_present && S_ISDIR(d_inode(path.dentry)->i_mode)));
 
 	if (!test_tree_conn_flag(tcon, KSMBD_TREE_CONN_FLAG_WRITABLE)) {
 		if (open_flags & (O_CREAT | O_TRUNC)) {


