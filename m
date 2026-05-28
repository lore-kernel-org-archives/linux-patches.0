Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E01C2459DD;
	Thu, 28 May 2026 20:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001244; cv=none; b=ecyo7kxSkm0cn5O5jDqMPkmGi7VvRNL3/J0/nnq1q4uLuL5KJfySgWTTKVZT0NQz4xukeYeDPAii1F24MMQp8Jy4CcMsqeAcSpn6NH5Shg8jW2APOTAYqw/0RGX3WLxRgg9UqGDtstL5y3bE4/m9NknQrte7JobJBVHKsPz/m9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001244; c=relaxed/simple;
	bh=GmZ1kpHo1b38vSlXJypGmDqf4lN92UnNqwhfwcxfzec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DelK287xVKZDyH+qo5u7BAYDR1ggINxFprgZm1XbaT9yx/tA/YuJJ3HnakGhFRg77ygOpVD8sqh/uubrvLq7CA6KpgFutGWr7enWcwkfvhyH/jcyW89YVbhMYu3b0suu7di3x8odgeqHGWzDQTOx1zMa5JOA4pQjgXTSDuNin4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WvYisIat; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WvYisIat"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E0701F000E9;
	Thu, 28 May 2026 20:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001242;
	bh=AnMVhRpEpbpz8W99MSL/HTIJlwn04Vzh6rUE3e2wjxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WvYisIatTFfuyMDSkaSCfnhVPnzVc9wfrlgpo/dlMbbJTWXrp7ICtdD8bUQWk5abd
	 dVaxqRcgF+9/YR8CZO1gqAz4FbGPTuIgIVnldJz+lcMKGpQR74oyBmJ4JbgeD2swA6
	 8rBX/3D2z3VITlDOFWafpopmd3J7tl7e/JDhtHZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 057/186] cifs: Fix busy dentry used after unmounting
Date: Thu, 28 May 2026 21:48:57 +0200
Message-ID: <20260528194930.513887355@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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
@@ -298,6 +298,8 @@ static void cifs_kill_sb(struct super_bl
 
 		/* Wait for all pending oplock breaks to complete */
 		flush_workqueue(cifsoplockd_wq);
+		/* Wait for all opened files to release */
+		flush_workqueue(deferredclose_wq);
 
 		/* finally release root dentry */
 		dput(cifs_sb->root);


