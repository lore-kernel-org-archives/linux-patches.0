Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA303DB31A;
	Sat, 12 Sep 2026 12:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215854; cv=none; b=MCntt3Uyjc6mh6SCBA95Gt++ksXO4JDFiH2kpjG86bLZtfd3OiuixW4/X7BsfBMWtAnt7S5/sCiSri4UgUgqZ+LsVOtD4MiOcn6f9taFvRc3ClI4QF8ywCPyoB36+ocqJgYqwc3zP46Vr4PdPtu2b6OaesS5X3ctK/cjWpsFXog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215854; c=relaxed/simple;
	bh=bvK19rhTupwfZdqOwOGymLxvSR2Ku0YN92Fsw6NSo3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DfzbFeHjXPVLkfD806WXU0goe24S4RpyCgkrMHerThR3aKGDak1LcAUNtuGRR0JXs1amguYxKAwR0Q8z95SloHqKM3n9415fJth9ZWwY+hmxAan4PxvQ9M2Z+aaU83cPicBpTEzFFzXV/vGeJCQaRyNMuW5I5+UgUBRLt7alkfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JnFNEclY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JnFNEclY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63CA51F000FF;
	Sat, 12 Sep 2026 12:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215853;
	bh=UZh6eicNNoFbLHh2FAg78LDUO9nmI7MumNiyuuy2Ea4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JnFNEclY+08fP9oesfKl4LtDsAZFAdMxhOLjJhAjC8gLlWe49rzHEECxwlyCLctoe
	 wRoQbuVEigO8xdyPT4wQwwwm7Ti1IwrPjhoQE5xYxOO489lqxD1Vh6hNSysU56it6L
	 FfCNee4uExXxsFyr570ByJsUTBsBT/ka08eTwKcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+212e8f62790f8e0bc63b@syzkaller.appspotmail.com,
	Yun Zhou <yun.zhou@windriver.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0618/1376] ext4: fix circular lock dependency in ext4_ext_migrate
Date: Sat, 12 Sep 2026 08:50:44 +0200
Message-ID: <20260912065621.315195347@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



