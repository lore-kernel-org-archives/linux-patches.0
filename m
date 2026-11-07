Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064140;
	b=EEX/sw5FnQ/OXCIGq8iJz5rxZaG//q0l7BeNbhNL7R5aILABRzyyc5K/cmFn2GW8NGZC
	 lScz7F6X/IVxROQ1pmhwDrZSsUghfyRhFJvbuXMXjzGJPp6JPU4y3Yh/ULRYjkld+bn24
	 d6w+ecQBd337ERyhxBCIM11qSE/zOYOIHWNu/O6CJX/igz8n4qCNDcH18ZoMSG/ke5yJK
	 zgf+9YE3/K7XGuDQyVCejjYSpjM4kIVBnVOuegN24zGgTE1nXYfzIMbhs89maBLYJ2wUN
	 SqkJ0tDOUfNw2anogzLE3PgrW/BAUqJxnMIXw3Dc8i47ljKU7XJH8uF2rnPNE+fx/CQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064140;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=66IkLSn9Mysq2BTqiEX3OqT79g3rLG7lWpN2T0dVkt4=;
	b=l/JT3ZeD8SsJQDh7BRSCB7Rfh4MNokhuRHgaplUn3O0btvjCFbCsWr8ej2AX70v8bBZ3
	 ZJnDkZf4tw9ehwgiVVQjiUNHOLy8ZC91tsKpog2OsOVRuaTvewYEALF9p8BZmJOEM/HCB
	 41sLGnOHJz5K5Bc8XqyOBDVpERJynHCgZzYF+vLI9AbmZihxsmI/xKm8VOc+A8juNm5OQ
	 c1b9xRU3GDsGaTPhw/TWzR8jSlToEr53SEHAC3sQm4Jn2viAjouMduku/mFBrpeMr/4DO
	 tlkjKTtZbTPzdW9vBzkHjYWb85+OBB5ySfpYQvAGXMcHiIbUoCleXEydXME+JE27COA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mHl6Ln2z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDFE606B89A;
	Sat,  7 Nov 2026 15:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mHl6Ln2z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EC501F0089F;
	Sat,  7 Nov 2026 15:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064140;
	bh=66IkLSn9Mysq2BTqiEX3OqT79g3rLG7lWpN2T0dVkt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mHl6Ln2zUGdr+yaXV92n5w6ku9a8QHd9kLH8yMoiQgsF4xXpUm3DmMhoucpcrG0gM
	 chtBUiDfdtoTTI2DjE9+HWHdBRwnk7fZGsPqhzKvv/bjzjf7u1DE6dphb1cigmBqPz
	 Y/LeCgnQ3Mqka+/F54y9+ldtlPLVKH1POwPBFzIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6646318bbcf419411bc5@syzkaller.appspotmail.com,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0289/1257] nilfs2: fix deadlock between nilfs_evict_inode() and find_inode()
Date: Sat,  7 Nov 2026 08:43:05 -0500
Message-ID: <20261107134947.449731305@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 64437aed83903..33490e8063ebd 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -895,13 +895,7 @@ void nilfs_evict_inode(struct inode *inode)
 
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



