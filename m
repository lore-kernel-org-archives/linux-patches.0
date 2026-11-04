Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826905;
	b=qvuQsxmj/FwfdGsFBuBzBdd4yP4jnvzJ8Ia/Ws4zZ/xnfL9Fu3LUNhE7rxltvWP2EYsd
	 7hEXVvwe/GJu5w7CwsE5EstsTvZRG9hNeumlmimVdO0NhUkXNEsRhPEB40uvrvRgTAFST
	 nO5nFBC2uzwRCN/Ilk2qjb8kClGA41aMyN5KDa28NEvzz/bpmDzX548nMYrVLYfpyC6bx
	 Tqm2yCXesz9Nh6OlF73XKXbOTHimQ9MmPFyQfmGcUjSElzWMQNo7L6ygCx2cH7PIVl+Xs
	 yMjQDA4jdqfggYPX4WGzfXtTQwlMQQHf5MtRDYy3ABMMugf1HGepdGvA7oKsGgr3THw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826905;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5EvyOArRiFH1h/YbOCyxImxNakbrkxsA5gXGDg6kCQ0=;
	b=ddZhDZHfCICEUYjvZQJRLnGsc0JoMJzEzMnYjd8KzfZsLfVtefpadBQ5grDDpSTxDluw
	 FmXVGmPYkmnSV8SP6gwDq9yFscYMOqf1ePsz+daoEopChXuVNo3k4BRbpCmzq0zmkSV+y
	 RoMAN7Yb145NBi8YPyw5kYradmwgXcV8WM1AJOi11U2rCYoX0aP0RVjUSr2XMVDRwrFOU
	 OWBNQFf20egOxWNivUonFaGUmp2tKopQa18QglHmjNZHhWsxDMAqcP0/dXSzefaYtxYey
	 KN+HN8oj7fRzaRjTS8IVoI2a59NgGxYPX9OR3lUNKIBmGaxlubCz8RkgYh/GXdV4b9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZGORob95;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93046084B5F;
	Wed,  4 Nov 2026 21:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZGORob95
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EAD41F0093A;
	Wed,  4 Nov 2026 21:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826904;
	bh=5EvyOArRiFH1h/YbOCyxImxNakbrkxsA5gXGDg6kCQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZGORob95faErVvN90nrcD7EctTGygrp3cbcsn90hqAscvB6PAroKGnVMxS54LHw51
	 fby/tg4dEH5yHGmO8ZcIXf5g+h5huva6bEC/iVSs22PgYSdQqpYZADs2oGkT4+Oivv
	 gE8AG7h/oWB+p32/0JIysAg55PSRC9s8+iAaDFQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongjun Gwon <d3bugee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.3 076/547] ksmbd: serialize directory emptiness checks with readdir
Date: Wed,  4 Nov 2026 16:04:20 -0500
Message-ID: <20261104211040.417243444@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongjun Gwon <d3bugee@gmail.com>

commit 7220980b2423d06a0604516129bfa4cec8a697ae upstream.

SMB2 QUERY_DIRECTORY holds fp->readdir_lock while it calls iterate_dir()
on fp->filp. An SMB2 SET_INFO request with FILE_DISPOSITION_INFORMATION
can resolve the same FileId and call ksmbd_vfs_empty_dir() on the same
filp without that lock.

iterate_dir()'s inode read lock permits concurrent readers and does not
serialize per-file iterator state. ext4 stores its dx readdir cursor and
fname RB tree in file->private_data. Concurrent reset or refill can
therefore free a fname node while the other worker still traverses it or
retains its RB-tree link, resulting in use-after-free accesses.

An authenticated SMB client with list and delete rights on a directory in
a writable KSMBD share backed by ext4 can trigger this when the directory
takes the dx readdir path. The client overlaps an SMB2 QUERY_DIRECTORY
request with an SMB2 SET_INFO request carrying FILE_DISPOSITION_INFORMATION
on one live FileId.

In one x86_64 SMP KASAN multi-shot guest using ksmbd-for-next at
171df27077fb, the unmodified kernel reported a cross-worker use-after-free
before a panic. The first report's access and free stacks show the two
request paths directly (trimmed):

  BUG: KASAN: slab-use-after-free in ext4_htree_store_dirent+0x488/0x550
  Read of size 8 by task kworker/2:0/29
  Workqueue: ksmbd-io handle_ksmbd_work
  Call Trace:
   ext4_htree_store_dirent+0x488/0x550
   htree_dirblock_to_tree+0x535/0x990
   ext4_htree_fill_tree+0x319/0xba0
   ext4_readdir+0x175a/0x2f40
   iterate_dir+0x1b6/0x630
   smb2_query_dir+0x1003/0x1cc0

  Freed by task 279:
   free_rb_tree_fname+0x67/0xc0
   ext4_readdir+0x13a9/0x2f40
   iterate_dir+0x1b6/0x630
   ksmbd_vfs_empty_dir+0xa2/0x100
   smb2_set_info+0x2ffa/0x45d0

Take fp->readdir_lock across the entire emptiness check. This places both
iterators over that handle's filp in the same lock domain while
preserving the disposition status handling. The exact code change
completed a warning-free x86_64 KASAN bzImage build. Tracing three request
pairs showed that the two iterate_dir() calls no longer overlapped and the
expected statuses were preserved. A further 1,600 reproducer iterations
completed with expected statuses and no KASAN report, Oops, or panic.

The reproducer and complete guest configuration are available privately
to maintainers on request.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Yongjun Gwon <d3bugee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8324,6 +8324,7 @@ static int set_file_disposition_info(str
 				     struct smb2_file_disposition_info *file_info)
 {
 	struct inode *inode;
+	int err;
 
 	if (!(fp->daccess & FILE_DELETE_LE)) {
 		pr_err("no right to delete : 0x%x\n", fp->daccess);
@@ -8338,9 +8339,13 @@ static int set_file_disposition_info(str
 		if (ksmbd_has_stream_without_delete_share(fp))
 			return -ESHARE;
 
-		if (S_ISDIR(inode->i_mode) && !ksmbd_stream_fd(fp) &&
-		    ksmbd_vfs_empty_dir(fp) == -ENOTEMPTY)
-			return -EBUSY;
+		if (S_ISDIR(inode->i_mode) && !ksmbd_stream_fd(fp)) {
+			mutex_lock(&fp->readdir_lock);
+			err = ksmbd_vfs_empty_dir(fp);
+			mutex_unlock(&fp->readdir_lock);
+			if (err == -ENOTEMPTY)
+				return -EBUSY;
+		}
 		smb_break_all_levII_oplock_for_delete(work, fp);
 		ksmbd_fd_set_delete_pending(fp);
 	} else {


