Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB8731D389;
	Mon, 27 Oct 2025 19:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592473; cv=none; b=NeN/jRqz/x89q3MNl1PxqGXWqLZp/GTvtivg3iriH48rGPYfr+4Bk7q6FQ+7LxK18lGxFrdLSa4n3MmNTCK3GgdRvZLznyikQ5h/zPd3e7A8QdIktmgxDOHZ+gbKPKrdVTYuwh++e+6RyKhA1vPJQRzDHG4E//UdYicleLjvLiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592473; c=relaxed/simple;
	bh=MNt6Zmg17xRY0rzjh0eq5nyXhuDIh3ZEDAt9S0oSKp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JFYnuOom9ckPuKKlekGzrQVZzjFw6NViN8j1d8Nz4aKvfT4c/nLjaw4kEDlkn8CQPZG856KSSrCGE/GPZmy/nfet0RHob1II00piSGdp2XU2iPdBGFg1V06agcK1KiIuqpgYkn+4V8tHI5L/jsvhk/FvLowZawFfzS1J5yQFSTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RdN3f3Zh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RdN3f3Zh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40C4C4CEF1;
	Mon, 27 Oct 2025 19:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592473;
	bh=MNt6Zmg17xRY0rzjh0eq5nyXhuDIh3ZEDAt9S0oSKp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RdN3f3ZhJeo7iy47xxj+hlWyf2yXAFvnOa5yXMm/CzLZbCE+WYnauNR3NBvgij7Ko
	 mLc0GZiP1KHT38F1DjYYz4AqztsM8LxUx9x7dF7tpRZ/I1bCN5jeeL9lU4l4OPr36f
	 8W4r4q/MK6tOOY81WhqMv+/Yi752EQXgvoBzEdwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1d79ebe5383fc016cf07@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 134/157] vfs: Dont leak disconnected dentries on umount
Date: Mon, 27 Oct 2025 19:36:35 +0100
Message-ID: <20251027183504.848886794@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1862,6 +1862,8 @@ struct dentry *d_alloc(struct dentry * p
 	__dget_dlock(parent);
 	dentry->d_parent = parent;
 	list_add(&dentry->d_child, &parent->d_subdirs);
+	if (parent->d_flags & DCACHE_DISCONNECTED)
+		dentry->d_flags |= DCACHE_DISCONNECTED;
 	spin_unlock(&parent->d_lock);
 
 	return dentry;


