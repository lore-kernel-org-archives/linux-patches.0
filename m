Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47CE3451CF;
	Sat, 12 Sep 2026 14:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223630; cv=none; b=OPj+IMXAI0LuvdGObrGbnRtXXI82agezMEnSIxYutJhHi5hJbYJu+n/ktQjf9IB9no8EKNbSt29dbdHQ9DOwJtDYTh5RAOuGL6gfy59C234wW5SSqzp+TG2D3wp/5z9aYtx6Cj8fq7+aRqVhHWwSEsP1sLL/V/3dGLdlfWb5rIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223630; c=relaxed/simple;
	bh=E2Fp6UP8temNLYHgDt8OmvNtmDwLLIw5mn7mMfg/I30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XzHtXT3Nk6XM8JPysJHMNe/oDSif7WYyagCpH/6zEYL6qmHomItOKZ6EnkjVy/DG7iR2vVfDsUEVOIxx5nq8KP8+GNzrvsvCqMwuH6uT7aJV54rT4JKYxwKk4+qehqt2pGdy1yXUwrQx8+vXEDJYYOQUEjvjGp6bn2cseSB2Czc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sl7ZbY99; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sl7ZbY99"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 128ED1F000FF;
	Sat, 12 Sep 2026 14:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223628;
	bh=8CulzhiOweNL/rSoxaB5uxjIgHPB+iy53BMd1PV4W8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sl7ZbY99bvZZfJd/nXnsMWdtrd8ZcurJkrXP92Lec4JcYGClC5lsehM5Ze29Wwn2E
	 c95SzQTnYZpyFVu/ymjxWi0594NzG4DK0CR+6FMR1QUYFJyS6YmORWk8Q6dH1Uesfp
	 1Qp7SvutDrv/R0W4cZserwnrSEtuFGLTIx+UoduU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+212e8f62790f8e0bc63b@syzkaller.appspotmail.com,
	Yun Zhou <yun.zhou@windriver.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0829/1424] ext4: fix circular lock dependency in ext4_ext_migrate
Date: Sat, 12 Sep 2026 08:54:21 +0200
Message-ID: <20260912065625.873318375@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index 1b0dfd963d3f0..84e3b703ab463 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -458,6 +458,7 @@ int ext4_ext_migrate(struct inode *inode)
 	if (IS_ERR(tmp_inode)) {
 		retval = PTR_ERR(tmp_inode);
 		ext4_journal_stop(handle);
+		tmp_inode = NULL;
 		goto out_unlock;
 	}
 	/*
@@ -585,9 +586,9 @@ int ext4_ext_migrate(struct inode *inode)
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



