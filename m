Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216837;
	b=gxoPtWRzQQkHK6NlhcD5bakZ6Lmh4SZvhVC+nE4TVVrIH1gAPUQS0GE1nHeM+V63oMAd
	 VtOOi5NGNguKez+F+ZbEbOz5XMldGDDMJpdGnXyx3LlruhTju7eP9ptD1a3BFaKUQDDNZ
	 xoU8hlVNjev2qyAqs3hMFwKozkfNwT/kEp9YPXJ+dDvktMKEijKVwg8pYiaM28G3repW9
	 2QJ2O0bu5b4TBs+YyRl0DYPT5dqcXF0bDW0XcrsPCjegu8p12kNY/yGQTWuI52Cwjxcvb
	 7phYV57NLqHCxuSj8NfzZVRzn4ShutZ8LSm93Bf7hmDcFN8fw9QoYdfhlYoszUfo7Lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216837;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ha+o8c+gAXfEjj/MMIuHazBx11nkkMxM9KXSK9Dg23E=;
	b=s7BzaE3WZ2/st0d2oVvBD4F7d0HXeH6umkxi0NjFK5Po9A/aHIfYz48MP6t0ByKUjFIh
	 /mhH7QhpggyE8vLO2rEIrTfMwn+mPF8k1sIggphtEn1przYq7vM9tun81d2to6t4uftN+
	 LH5Gkx79mCISu5Sw01UgbmEwmaYt+b9ZBthvWvlWbSGShKTrTqxCMc27PphP1VZ2OZ3uy
	 SHMRkLgETbzSJ4Wbj4n5pXghHSZw/W9jChDf/KyNwDTh0UhJd2U0RKzGBQ4qb8/gVNRLo
	 9wWicn0weqr6XXp4uFIw39i2tyUmbch5RiOr7PlNKUW87KDPqZ2am6a66QMXNBv33zA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k7uxQVch;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D82606A31C;
	Wed, 28 Oct 2026 19:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k7uxQVch
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8311F01825;
	Wed, 28 Oct 2026 19:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216836;
	bh=ha+o8c+gAXfEjj/MMIuHazBx11nkkMxM9KXSK9Dg23E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k7uxQVchQUZ9/VzRDUfGwqT81zLxLALAeUzP/IuZcpGAdjYKfiIpx37xbW/zoNTK8
	 sXLtvUQj66GJ26zmq7WSowdwvQgd4nk0va2R1JIJDglvlsnqrU0VytiRGYB727/XLK
	 VJlIUA4YH8/PKcOxJlYzTcHUwBDeabTJ0bf27frM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+212e8f62790f8e0bc63b@syzkaller.appspotmail.com,
	Yun Zhou <yun.zhou@windriver.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1652/1887] ext4: fix circular lock dependency in ext4_ext_migrate
Date: Wed, 28 Oct 2026 18:02:28 +0100
Message-ID: <20261028170537.055604401@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yun Zhou <yun.zhou@windriver.com>

[ Upstream commit a897682793eba5de51ee6f3152760374afa629cf ]

Move iput(tmp_inode) after ext4_writepages_up_write() to avoid a
circular lock dependency between s_writepages_rwsem and sb_internal
(freeze protection).

The deadlock scenario:

  CPU0 (EXT4_IOC_MIGRATE)        CPU1 (orphan cleanup during mount)
  ----                           ----
  ext4_ext_migrate()
    ext4_writepages_down_write()
      s_writepages_rwsem (write)
                                 ext4_evict_inode()
                                   sb_start_intwrite()   [sb_internal]
                                   ...
                                     ext4_writepages()
                                       s_writepages_rwsem (read) [BLOCKED]
    iput(tmp_inode)
      ext4_evict_inode()
        sb_start_intwrite()         [BLOCKED]

The tmp_inode is a temporary inode with nlink=0 created solely for
building the extent tree.  Its eviction does not require
s_writepages_rwsem protection, so deferring iput() until after
releasing the rwsem is safe.

Reported-by: syzbot+212e8f62790f8e0bc63b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=212e8f62790f8e0bc63b
Fixes: cb85f4d23f79 ("ext4: fix race between writepages and enabling EXT4_EXTENTS_FL")
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260612005330.1930804-1-yun.zhou@windriver.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/migrate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index a5e1492bbaaa5..917e7d9b563ea 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -457,6 +457,7 @@ int ext4_ext_migrate(struct inode *inode)
 	if (IS_ERR(tmp_inode)) {
 		retval = PTR_ERR(tmp_inode);
 		ext4_journal_stop(handle);
+		tmp_inode = NULL;
 		goto out_unlock;
 	}
 	/*
@@ -584,9 +585,9 @@ int ext4_ext_migrate(struct inode *inode)
 	ext4_journal_stop(handle);
 out_tmp_inode:
 	unlock_new_inode(tmp_inode);
-	iput(tmp_inode);
 out_unlock:
 	ext4_writepages_up_write(inode->i_sb, alloc_ctx);
+	iput(tmp_inode);
 	return retval;
 }
 
-- 
2.53.0



