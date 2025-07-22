Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2AD2EE5FB;
	Tue, 22 Jul 2025 14:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193507; cv=none; b=SaRiuh6iEWWjFSwqlOiSbBK2Ph0zQsRLAoCG4Q4U3vtojHOOF8RIQ9bFhNv2Y5XL5NR/D7cE3C3bhbWhKQ//iT/cPL37L7Cu6rdJV6u6PxMAERqFv1dSphY6ihY9q/9bXROLlLCybJF4BCMCNZ1GHG9XdRFEm3hdVszE8L8v6LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193507; c=relaxed/simple;
	bh=3QZfwlItqeTet+aKIvapjs/qrLQohuJJ67xWhPwIWkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EBabFMdWmrqr2bUR2CC4LBq6IFddyNEDwWS7yPjhE8Nu4B8T+UWYzLXmueJi2tBcg5yAHzguJ3k7mqjmIToAi+jfPQiVVZgj0gL+gBRR5MXwe+ocRYluenbarH8W2icOiGNDTa/CAvMDQb5qO+oWDCMBYrUiEUG0xcIYoiHJH3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x1rVp5R7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x1rVp5R7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62937C4CEEB;
	Tue, 22 Jul 2025 14:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193506;
	bh=3QZfwlItqeTet+aKIvapjs/qrLQohuJJ67xWhPwIWkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x1rVp5R7SYhgam5V3QoTdsooMneP2/IfxKXeRaXMhzR/yxpRn6YY+z9ognGqUETwE
	 pedVxIs4V2gjKqxNjnH9Qha1jlhvUCI9xcmul85Owpk1V8asXnS1vZKRUNpuAnvNGf
	 hdpQxD7Uq6/2ChTGwdWv25M8EJHi3VFpDRA+jMEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Wang Zhaolong <wangzhaolong@huaweicloud.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 114/187] smb: client: fix use-after-free in cifs_oplock_break
Date: Tue, 22 Jul 2025 15:44:44 +0200
Message-ID: <20250722134350.005403265@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9835672267d27..3819378b10129 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -3084,7 +3084,8 @@ void cifs_oplock_break(struct work_struct *work)
 	struct cifsFileInfo *cfile = container_of(work, struct cifsFileInfo,
 						  oplock_break);
 	struct inode *inode = d_inode(cfile->dentry);
-	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct super_block *sb = inode->i_sb;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	struct cifsInodeInfo *cinode = CIFS_I(inode);
 	struct cifs_tcon *tcon;
 	struct TCP_Server_Info *server;
@@ -3094,6 +3095,12 @@ void cifs_oplock_break(struct work_struct *work)
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
 
@@ -3166,6 +3173,7 @@ void cifs_oplock_break(struct work_struct *work)
 	cifs_put_tlink(tlink);
 out:
 	cifs_done_oplock_break(cinode);
+	cifs_sb_deactive(sb);
 }
 
 static int cifs_swap_activate(struct swap_info_struct *sis,
-- 
2.39.5



