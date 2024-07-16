Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4639D1DDCE;
	Tue, 16 Jul 2024 16:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145761; cv=none; b=FVVWBT9GL60bllntIySSgjIUqskr+8vWQnlW+C9Icq6gw1/we9mRmmEajXBzctAUaUmpxNUv/kwT6AHgT3qw9KuENvd30VMOHQo7huxqd3BZ/h2BkbY1gwEoipxScapbX+WT2UCBoZOfUyjYmSx22+WcQzNK0tnIzzDFYTM5vhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145761; c=relaxed/simple;
	bh=LygWz2b44bUoQ13FxDO1S+nOGopmHNEaGmzV/5H0oDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZBKrnsWzr/TbRbAUxV1J7c64ltabaeF0m6lhYksrvlNsUStnnu6bcFpIh066mQek+VSyO8XtQj9r2hWMqei3D2Dy9cx8BbkByCu3NxgQRYMv9dncRTBr2iHxmpYfIELIjo7V58RpZ5Fj4RPvftcGbjX1UFjKoAifz3ljUzGq0e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0aeZLl8k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0aeZLl8k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C031DC116B1;
	Tue, 16 Jul 2024 16:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145761;
	bh=LygWz2b44bUoQ13FxDO1S+nOGopmHNEaGmzV/5H0oDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0aeZLl8k1t62mH2kSO6CH7hBAHXNaYYoIx6Ip54vv2QsDM5iLEGVa3Avfmb85e3r9
	 KS0QyTWJtjI/zZ+rAOiHQQwxWsdF2GLrk7WdLDvkhyt32GHPKHdPx7mopCR+x4ERWo
	 pvt+r80MjXjLxaecE9kGUZdpPaVRInwUASNt1wYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yoonho Shin <yoonho.shin@samsung.com>,
	Hobin Woo <hobin.woo@samsung.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 075/121] ksmbd: discard write access to the directory open
Date: Tue, 16 Jul 2024 17:32:17 +0200
Message-ID: <20240716152754.214684943@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2051,15 +2051,22 @@ out_err1:
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
@@ -3167,7 +3174,9 @@ int smb2_open(struct ksmbd_work *work)
 
 	open_flags = smb2_create_open_flags(file_present, daccess,
 					    req->CreateDisposition,
-					    &may_flags);
+					    &may_flags,
+		req->CreateOptions & FILE_DIRECTORY_FILE_LE ||
+		(file_present && S_ISDIR(d_inode(path.dentry)->i_mode)));
 
 	if (!test_tree_conn_flag(tcon, KSMBD_TREE_CONN_FLAG_WRITABLE)) {
 		if (open_flags & (O_CREAT | O_TRUNC)) {


