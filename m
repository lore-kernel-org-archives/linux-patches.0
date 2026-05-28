Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8265B3290B0;
	Thu, 28 May 2026 19:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998220; cv=none; b=IGn4hxbaFKc0FusE2Zdv9an5klAWmUyuzkJhvcG8BaVAb/gBAtTaWgIHoDbMc4Mv61N/9m8TjsKlRdFopOpM+UdAhoyjyVo68duKBOG82wsKHLd2wHLwYLDnMvAceQ5kM0Vv2B9smAVvFkmaFumXj9uGoLQ87GJi9fepO3+zY2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998220; c=relaxed/simple;
	bh=cF8XsTBXVSl+oN3ZKEx3br7Yavd+swp3rIH/eLrdLKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZK5nYXfVO3XqE/Rz/RAngU9zA6tIU+iMS654XxEkGm43ByejkXCF2lUf2RYv0McvvdhG1y0WIfWJVOPPH6iA2V49d4d082s0MXPRdfc1Lz/koj5ew9lO001kAG1CK9/QYoRwFwv3Zl5zSe1NVpj/qofo7q38gZ2vdsER+2P5fKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lxDtYfVw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lxDtYfVw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF89C1F000E9;
	Thu, 28 May 2026 19:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998219;
	bh=74OyxaZQq+3/9lhCPlBsUjzz0zqsEzCth5fqmChX3gQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lxDtYfVwJQnqpUbdqcaFN9NMSdhxFfrxBRh9kwLawLTg7PYUahwSkEjVov0h2flcy
	 3y80OQ/IKr0BUPWJbUY/aZ80hPs/v48TMkSaqXtZoVnUJC+qi0RZSmeAAMCYCzj2I1
	 re0JilhEHI1bt05mnAdU40OAeY4DcPsyYjMUKwxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 7.0 096/461] cifs: Fix busy dentry used after unmounting
Date: Thu, 28 May 2026 21:43:45 +0200
Message-ID: <20260528194649.724093823@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -340,6 +340,8 @@ static void cifs_kill_sb(struct super_bl
 
 		/* Wait for all pending oplock breaks to complete */
 		flush_workqueue(cifsoplockd_wq);
+		/* Wait for all opened files to release */
+		flush_workqueue(deferredclose_wq);
 
 		/* finally release root dentry */
 		dput(cifs_sb->root);


