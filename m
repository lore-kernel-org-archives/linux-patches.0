Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E272D8766;
	Tue, 22 Jul 2025 13:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192584; cv=none; b=DJQXUoZygafoWNdnty8YyB64SgS1hP6YujKI7Rg4s7Fz9fN07nf98OS3DZ6EdWWbRbLhB8PObAWmQObhgGF1wRJ2ei5Z3mM5DH4l7qiWlcfF3ypV/SklQlqsPvLbxkENwnLOpkgpOCEW+4/AvMWxQg4jlHJd2KTEsk06T+avRCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192584; c=relaxed/simple;
	bh=DOG8uQLQhd1iqjR93VEKGil9QoFGRX0U6KrnpcRhqEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NHyoJPbCc93KhZcUtMtlGORioPH3PphpA8+MozTf+L+/QUHVoV/fiNWhkSqVhJt2BkhjR0UL50//oSNGJ3ppB1jaPlEbLNjgdlfFRJhe3MxurjdVe56d9Hzt8+8qNmkeV4e8fJD0UJAG2yCVzFHzJtidY0eToQYq6wDwX4SzgNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k44Hr6+P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k44Hr6+P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B6BC4CEF1;
	Tue, 22 Jul 2025 13:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192584;
	bh=DOG8uQLQhd1iqjR93VEKGil9QoFGRX0U6KrnpcRhqEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k44Hr6+PmoYuv4ihPwRWwQMzR4wzM6DRNqFrQvbAuOo6Hp+aJNXB0azjgKrKWp5NC
	 crCGZiolFaMbT+06f7jG86rFP3hMSE8joJrWQNFn8fUvSPZ/L9i7dfieewfUQmA/th
	 V1vmZWJ500Vom5L/y0dDXNZJeW2RVonirLntchio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Wang Zhaolong <wangzhaolong@huaweicloud.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 067/111] smb: client: fix use-after-free in cifs_oplock_break
Date: Tue, 22 Jul 2025 15:44:42 +0200
Message-ID: <20250722134335.875504056@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Wang Zhaolong <wangzhaolong@huaweicloud.com>

[ Upstream commit 705c79101ccf9edea5a00d761491a03ced314210 ]

A race condition can occur in cifs_oplock_break() leading to a
use-after-free of the cinode structure when unmounting:

  cifs_oplock_break()
    _cifsFileInfo_put(cfile)
      cifsFileInfo_put_final()
        cifs_sb_deactive()
          [last ref, start releasing sb]
            kill_sb()
              kill_anon_super()
                generic_shutdown_super()
                  evict_inodes()
                    dispose_list()
                      evict()
                        destroy_inode()
                          call_rcu(&inode->i_rcu, i_callback)
    spin_lock(&cinode->open_file_lock)  <- OK
                            [later] i_callback()
                              cifs_free_inode()
                                kmem_cache_free(cinode)
    spin_unlock(&cinode->open_file_lock)  <- UAF
    cifs_done_oplock_break(cinode)       <- UAF

The issue occurs when umount has already released its reference to the
superblock. When _cifsFileInfo_put() calls cifs_sb_deactive(), this
releases the last reference, triggering the immediate cleanup of all
inodes under RCU. However, cifs_oplock_break() continues to access the
cinode after this point, resulting in use-after-free.

Fix this by holding an extra reference to the superblock during the
entire oplock break operation. This ensures that the superblock and
its inodes remain valid until the oplock break completes.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220309
Fixes: b98749cac4a6 ("CIFS: keep FileInfo handle live during oplock break")
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Wang Zhaolong <wangzhaolong@huaweicloud.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/file.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index d883ed75022c4..99a8c6fbd41a6 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -5042,7 +5042,8 @@ void cifs_oplock_break(struct work_struct *work)
 	struct cifsFileInfo *cfile = container_of(work, struct cifsFileInfo,
 						  oplock_break);
 	struct inode *inode = d_inode(cfile->dentry);
-	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct super_block *sb = inode->i_sb;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	struct cifsInodeInfo *cinode = CIFS_I(inode);
 	struct cifs_tcon *tcon;
 	struct TCP_Server_Info *server;
@@ -5052,6 +5053,12 @@ void cifs_oplock_break(struct work_struct *work)
 	__u64 persistent_fid, volatile_fid;
 	__u16 net_fid;
 
+	/*
+	 * Hold a reference to the superblock to prevent it and its inodes from
+	 * being freed while we are accessing cinode. Otherwise, _cifsFileInfo_put()
+	 * may release the last reference to the sb and trigger inode eviction.
+	 */
+	cifs_sb_active(sb);
 	wait_on_bit(&cinode->flags, CIFS_INODE_PENDING_WRITERS,
 			TASK_UNINTERRUPTIBLE);
 
@@ -5124,6 +5131,7 @@ void cifs_oplock_break(struct work_struct *work)
 	cifs_put_tlink(tlink);
 out:
 	cifs_done_oplock_break(cinode);
+	cifs_sb_deactive(sb);
 }
 
 /*
-- 
2.39.5



