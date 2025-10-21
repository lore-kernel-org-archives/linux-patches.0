Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF26273D7B;
	Tue, 21 Oct 2025 19:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076628; cv=none; b=GmUWmEcOxjIh3JaLfqehvE5GZ931SlYagXQ13G8i1dd1CqqzZQLbTGxZkky1GzZkXDE7BEYIsmyd2J3Jwaled85RWG7/GDtJNMLkCSlYU7RJ+jr4L9LBGCVQZNxk/6DFzjA7ktsjDhGzwDqAn3Vsb9c43l+Y5EqOIzU7ovThVIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076628; c=relaxed/simple;
	bh=MQki1NXAOynjv83SHOwZihAUKh1yvhz6e7CBlYSU7KU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hzxh/zalCnUWeCZSAN8o6/qqswDqBUmx7piraVpSk6AX3JYHBXLF1bQQ9cQSludMEUgM8kR9IjfyX71dT2pIR0bIofYNqKKc4n3TIxE001uIJO901urzypkeVLznHKTXArDSmYYEdMbJVkfIzMLTci0xyQq2gBIbP8rG1lD08v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XCHc4FJB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XCHc4FJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD40C4CEF1;
	Tue, 21 Oct 2025 19:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076625;
	bh=MQki1NXAOynjv83SHOwZihAUKh1yvhz6e7CBlYSU7KU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XCHc4FJBEbMNcOO/U5VmkIfraLhKoiSGpnYlTMoMFf3aD/vt3WdLBFcKkEM9pkcrv
	 GUqBQ3qWDayQJubjI5WHZ2meLv5j8ZPc/03pA7kvL9xaX4JgZspmZuQiP6Zy7rPBnc
	 MrRfrLPuZ819oaHtBg7/yBj90sWGpIOY7EfhGSLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1d79ebe5383fc016cf07@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 092/105] vfs: Dont leak disconnected dentries on umount
Date: Tue, 21 Oct 2025 21:51:41 +0200
Message-ID: <20251021195023.836449821@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

[ Upstream commit 56094ad3eaa21e6621396cc33811d8f72847a834 ]

When user calls open_by_handle_at() on some inode that is not cached, we
will create disconnected dentry for it. If such dentry is a directory,
exportfs_decode_fh_raw() will then try to connect this dentry to the
dentry tree through reconnect_path(). It may happen for various reasons
(such as corrupted fs or race with rename) that the call to
lookup_one_unlocked() in reconnect_one() will fail to find the dentry we
are trying to reconnect and instead create a new dentry under the
parent. Now this dentry will not be marked as disconnected although the
parent still may well be disconnected (at least in case this
inconsistency happened because the fs is corrupted and .. doesn't point
to the real parent directory). This creates inconsistency in
disconnected flags but AFAICS it was mostly harmless. At least until
commit f1ee616214cb ("VFS: don't keep disconnected dentries on d_anon")
which removed adding of most disconnected dentries to sb->s_anon list.
Thus after this commit cleanup of disconnected dentries implicitely
relies on the fact that dput() will immediately reclaim such dentries.
However when some leaf dentry isn't marked as disconnected, as in the
scenario described above, the reclaim doesn't happen and the dentries
are "leaked". Memory reclaim can eventually reclaim them but otherwise
they stay in memory and if umount comes first, we hit infamous "Busy
inodes after unmount" bug. Make sure all dentries created under a
disconnected parent are marked as disconnected as well.

Reported-by: syzbot+1d79ebe5383fc016cf07@syzkaller.appspotmail.com
Fixes: f1ee616214cb ("VFS: don't keep disconnected dentries on d_anon")
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
[ relocated DCACHE_DISCONNECTED propagation from d_alloc_parallel() to d_alloc() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dcache.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1861,6 +1861,8 @@ struct dentry *d_alloc(struct dentry * p
 	__dget_dlock(parent);
 	dentry->d_parent = parent;
 	list_add(&dentry->d_child, &parent->d_subdirs);
+	if (parent->d_flags & DCACHE_DISCONNECTED)
+		dentry->d_flags |= DCACHE_DISCONNECTED;
 	spin_unlock(&parent->d_lock);
 
 	return dentry;


