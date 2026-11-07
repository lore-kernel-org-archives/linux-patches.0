Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062082;
	b=IZ2PjQrnQEQRChXhaBzHf7EOJAYu3Ncb3GM+S51rx7t1UvxY1qwUoQm08j98fNIzoH9z
	 hupTXRi9gA1SaP64DR+UjYw8pdckf1HJpULujGUn23fdbF71b/zlPK9uPeeYxknwHMwhC
	 qxvBkJpk4qTWZHKeEdb8R466iETdwAPmhGgvz+2VNC6REhbj5njGg9Hg1mOaLNj1WjJO/
	 Aq9hKpWOuakkuFiE4QOTqSkmABUgQ+M0M5VwQnnnJKxWKDcYp1onv2uwT0FxnkpRb6q5J
	 /wqLsRie8r73IcNFjd3/GZR4y3+NsL3TWb+VrCp9YdGGfzvuaWt07h0zL0Zl4jqSJdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062082;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SGfuvMv+4FcXAe9kPozN1GtDu2kos7Lmb/QWSIrrH4k=;
	b=l40ykCVaIauu2cdOzjU8H9lxhDoTwUDCpQp0NCJlhkCzM61UEGOTtR1es4WP9y22QphV
	 Kqs79RRCsYNOuXXUoO5t4uWC9JN4tLumsznCJxKt9T2Z9fJWPGSjQfyBpdNWEQasVepBI
	 /yQkLbWmeXGG7vKFzZcrl1vf9LtWBuOY8FIexXddKSLTejB8kSNLqruGbkUYP1ER/R9NA
	 vnARM5ky5zT87r0Xak2o6V5v2IF0ezYOnUSq+1jDrlRiJC/LFI6tiBWxazYd8YARJki0e
	 Gj0r85UhCV9Bgw9cMHYwxy/KRxfks/yLh+G29EexhaZoIftiBCunDwQQ0UFPbU/f6Jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XeXlGVow;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1CA606EEBB;
	Sat,  7 Nov 2026 14:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XeXlGVow
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16771F008A2;
	Sat,  7 Nov 2026 14:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062082;
	bh=SGfuvMv+4FcXAe9kPozN1GtDu2kos7Lmb/QWSIrrH4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XeXlGVow+4PqwvmmkJR94oP438DTkyaxYdabdURLVPPz4wzHV+opnKUIuuHOfu1kd
	 Vch+yN/eUOVrMYV8abEcXDj1wgw5T70dnmEJu/rMVoC09Ew2pdOEMohD6gsdggktxl
	 M4CvJeYLk0YrZdu+aMrwhcc8vOAnTeNZ++GlhYS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6646318bbcf419411bc5@syzkaller.appspotmail.com,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1058/1536] nilfs2: fix deadlock between nilfs_evict_inode() and find_inode()
Date: Sat,  7 Nov 2026 08:51:14 -0500
Message-ID: <20261107135027.397505548@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

[ Upstream commit ff1227f70eead8704ecfec69259fb4c041f92cda ]

Syzbot reported a deadlock between nilfs_evict_inode(), executed via
an asynchronous workqueue (kworker) as:

  process_one_work()
    process_scheduled_works()
      nilfs_iput_work_func()
        nilfs_dispose_list()
          iput()
            iput_final()
              evict()
                s_op->evict_inode()
                  nilfs_evict_inode()

and find_inode(), called via

  nilfs_mkdir()
    nilfs_new_inode()
      nilfs_insert_inode_locked()
        insert_inode_locked4()
          inode_insert5()
            find_inode()

When an inode is deleted (i_nlink == 0), nilfs_evict_inode() clears its
ifile bitmap entry and then synchronously triggers the log writer via
nilfs_transaction_commit() if IS_SYNC(inode) is true.

If a concurrent directory creation via nilfs_new_inode() attempts to
allocate the same newly freed inode number, however, find_inode() called
just before inserting it into the inode hash, blocks waiting for the old
inode's evict() to complete.

Meanwhile, the synchronous log writer invoked from nilfs_evict_inode()
tries to acquire a write lock on 'ns_segctor_sem' which is read locked
by the caller of nilfs_new_inode() (in this case, nilfs_mkdir()),
resulting in a deadlock.

The synchronous log writer invocation from nilfs_evict_inode() is a
legacy artifact; it is no longer necessary because the call itself
(triggered by iput()) is now handled asynchronously with a kworker
if i_nlink == 0.  It merely increases the risk of deadlock.

Fix this deadlock by removing the synchronous log writer trigger from
nilfs_evict_inode().

Reported-by: syzbot+6646318bbcf419411bc5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6646318bbcf419411bc5
Fixes: 7ef3ff2fea8b ("nilfs2: fix deadlock of segment constructor over I_SYNC flag")
Tested-by: syzbot+6646318bbcf419411bc5@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/inode.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index afb3b96377409..6932f8daf7d93 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -928,13 +928,7 @@ void nilfs_evict_inode(struct inode *inode)
 
 	nilfs_clear_inode(inode);
 
-	if (IS_SYNC(inode))
-		nilfs_set_transaction_flag(NILFS_TI_SYNC);
 	nilfs_transaction_commit(sb);
-	/*
-	 * May construct a logical segment and may fail in sync mode.
-	 * But delete_inode has no return value.
-	 */
 }
 
 int nilfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
-- 
2.53.0



