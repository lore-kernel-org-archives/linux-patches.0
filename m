Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C081341AB8;
	Sat, 30 May 2026 17:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162378; cv=none; b=o78sA+17ewwt9YP9zxiElddQT3vv2DWR+VGfaA1b9+IGaVxwE1aU+eKtKtKlSu3+hCrO86uye+MguZqsvO5D+sMb2nrP9+z731o+6F230ldxiA3cIiUpiZQdHITOphzxGlPSkcvm8YJ80GEprMx9K2p0Gqcj5HzqRz+2b1V5eEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162378; c=relaxed/simple;
	bh=p18zNCR7TS4wqYh2j5Pz847LResno5VJqKJqOZs/S84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hNyXBsfXsZ/DesYLvjC4zR2Df46Ljsk/fJl/0u4nitslgrFauJxM4JeQ9KsiDKOkRaqSWfrTH3p4oMOW1BbX3IaHSRpfaKyf5bk/cgoA+kAZYiR85Fu8N4oCeH+HOlbKQkkzaqrx4P8rUkOI5wU9SZBpCa6TIwMB1znOC7+oEtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tMu7BdHW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tMu7BdHW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7187A1F00893;
	Sat, 30 May 2026 17:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162377;
	bh=0/VYM5ZEtI1lvGUe13Ay198vkcVEDCSI+u6KjgRdtDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tMu7BdHWjgzKL30py/aTejQiIoFjcmeKGriSxlCj8kvGzbJ/KbajBKjBtfFveDcxl
	 HBFHMj9pNEN9dkoed6MR+GMN4IvjbOp51MV1/H3RBApO8TodMSr5Qs+qtZsAZFD0yR
	 +5V0uKpoBELFfdQorWhnM/hFgbruBZvqhW7c2GaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 864/969] cifs: Fix busy dentry used after unmounting
Date: Sat, 30 May 2026 18:06:28 +0200
Message-ID: <20260530160324.533276294@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Zhihao Cheng <chengzhihao1@huawei.com>

commit c68337442f03953237a94577beb468ab2662a851 upstream.

Since commit 340cea84f691c ("cifs: open files should not hold ref on
superblock"), cifs file only holds the dentry ref_cnt, the cifs file
close work(cfile->deferred) could be executed after unmounting, which
will trigger a warning in generic_shutdown_super:
 BUG: Dentry 00000000a14a6845{i=c,n=file}  still in use (1) [unmount of
 cifs cifs]

The detailed processs is:
   process A           process B           kworker
 fd = open(PATH)
  vfs_open
   file->__f_path = *path // dentry->d_lockref.count = 1
   cifs_open
    cifs_new_fileinfo
     cfile->dentry = dget(dentry) // dentry->d_lockref.count = 2
 close(fd)
  __fput
  cifs_close
   queue_delayed_work(deferredclose_wq, cfile->deferred)
  dput(dentry) // dentry->d_lockref.count = 1
			                 smb2_deferred_work_close
					  _cifsFileInfo_put
					   list_del(&cifs_file->flist)
                    umount
		     cleanup_mnt
		      deactivate_super
		       cifs_kill_sb
		        cifs_close_all_deferred_files_sb
			 cifs_close_all_deferred_files
			  // cannot find cfile, skip _cifsFileInfo_put
			kill_anon_super
			 generic_shutdown_super
			  shrink_dcache_for_umount
			   umount_check
			    WARN ! // dentry->d_lockref.count = 1
					   cifsFileInfo_put_final
					    dput(cifs_file->dentry)
		                            // dentry->d_lockref.count = 0

Fix it by flushing 'deferredclose_wq' before calling kill_anon_super.

Fetch a reproducer in https://bugzilla.kernel.org/show_bug.cgi?id=221548.

Fixes: 340cea84f691c ("cifs: open files should not hold ref on superblock")
Cc: stable@vger.kernel.org
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsfs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -296,6 +296,8 @@ static void cifs_kill_sb(struct super_bl
 
 		/* Wait for all pending oplock breaks to complete */
 		flush_workqueue(cifsoplockd_wq);
+		/* Wait for all opened files to release */
+		flush_workqueue(deferredclose_wq);
 
 		/* finally release root dentry */
 		dput(cifs_sb->root);


