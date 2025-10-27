Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C52931B83D;
	Mon, 27 Oct 2025 19:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591777; cv=none; b=mlsCeU+GANgH+mqEIfcSCveGRCx669qWwZCzYs8vbOAMvw3nrSLhX9L8s+4oHGMzqirlj41WVKl4W4ZQ2OWWv3xYwuQGdBAb6KVVs3KAt6Tmho+Sr3dG21Dgm8KbPiMa/wqGBhYjSzVQYnFCZLg/l0BGWoqfdcfyveq4u3y4bhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591777; c=relaxed/simple;
	bh=OOqFi3/+372UNlKl3m7cl06eDj9R7I4dbVj6XoqD6Ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u9OvPy+9FkhGHH9t34szdvXTcVgB2l/3MSwFwb2Hw3C8Qbsmk9ROuExIXRutLOB96evBXr4NZ91i8p9RDM1Xvpf8zgrffWKF3UB1kjloAa4EdDoxBmrlrbOzZ3K8QJXCO0sNL9urCtxuKWWt2iw1KGJgioTBosg/6ApQPU38WD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OGa6cqJT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OGa6cqJT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C17C4CEF1;
	Mon, 27 Oct 2025 19:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591777;
	bh=OOqFi3/+372UNlKl3m7cl06eDj9R7I4dbVj6XoqD6Ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OGa6cqJTTJp6E89cWFIEhgYNwHnohRVrem3hy3fxvXU59AyBN823UjpE06w78f7xR
	 w2iY4jPgeZe4scxWuYRFvSZwwqGv4+d4i8PdP7wDBZc/y1vlkRXRPP1psyhC6h7eqh
	 lvZUC8FTTc1CdQl63Am8IuzmJQTYmPSyKS72kmX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1d79ebe5383fc016cf07@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 326/332] vfs: Dont leak disconnected dentries on umount
Date: Mon, 27 Oct 2025 19:36:19 +0100
Message-ID: <20251027183533.490457039@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1801,6 +1801,8 @@ struct dentry *d_alloc(struct dentry * p
 	__dget_dlock(parent);
 	dentry->d_parent = parent;
 	list_add(&dentry->d_child, &parent->d_subdirs);
+	if (parent->d_flags & DCACHE_DISCONNECTED)
+		dentry->d_flags |= DCACHE_DISCONNECTED;
 	spin_unlock(&parent->d_lock);
 
 	return dentry;


