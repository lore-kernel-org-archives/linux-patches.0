Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13F14772A7;
	Thu, 20 Aug 2026 17:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247953; cv=none; b=dDAKbVxmt2VYn/ToQ7xQwepyHNkLitp9eXmNi0Yb8K1/ovGcQJMEJmXpP2EdJlnSsI9K21KQr60ahW3RdKuA480br6I8Yfm/ERZERYJH6ld9V4qjFmx03rjQiny5HU7HUPYod0cuAJD0HbCXPF+dqrgTqubTuEbBvbb+aQX9lrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247953; c=relaxed/simple;
	bh=boQn3yRxtwM4D9e9fKY2qiZiAVJkxIwTMe2ZLRAldB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aLJNxWheQziNRQAinNKA2tFKVLBNdkWOmTaa0YAd6LYD3QfrAe3p5Z2fY2DS3IxgKPt/MdY0mEtVhVBdFQeyuFXq2d7hvh52MAjVz7TMXSNzP0mIOILtTSbmRKcLE6Zk6qV6Rgoh5/Cfj1s/7w5kj6QN/4fZ7nQptd77+mFaXP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=id5uqO5o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="id5uqO5o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2277F1F000E9;
	Thu, 20 Aug 2026 17:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247951;
	bh=sD5lMYUntVq2WrwqpHBe0672nre+H32e4ZyhjcBjO4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=id5uqO5o+NtJw5wlUXK1Q/LRtwkprGtcSvZNNqyt2SbC7Mi37MK7QyHdCvvix827k
	 /f+UuWrFFGBXMubY/xm34YRC9bIwr/m72QTIfS/N/JBSMrtZUZSh6t7ZAAMNr2/VHy
	 Ze3Ks7qJrhvylX68CkHwEgJYnrDe5M3WmaKQfV4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pedro Falcato <pfalcato@suse.de>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jann Horn <jannh@google.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 057/303] mm: do file ownership checks with the proper mount idmap
Date: Thu, 20 Aug 2026 16:53:13 +0200
Message-ID: <20260820145254.879654206@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

From: Pedro Falcato <pfalcato@suse.de>

[ Upstream commit e187bc02f8fa4226d62814592cf064ee4557c470 ]

Ever since idmapped mounts were introduced, inode ownership checks (for
side-channel protection) in mincore() and madvise(MADV_PAGEOUT) were done
against the nop_mnt_idmap, which completely ignores the file's mount's
idmap.  This results in odd edgecases like:

1) mount/bind-mount with an idmap userA:userB:1
2) userB runs an owner_or_capable() check on file that is owned by userA
on-disk/in-memory, but owned by userB after idmap translation
3) owner_or_capable() mysteriously fails as the correct idmap wasn't supplied

In the case of mincore/madvise MADV_PAGEOUT, this is usually benign,
because file_permission(file, MAY_WRITE) will probably succeed, as it uses
the proper idmap internally, but it does not need to be the case on e.g a
0444 file where even the owner itself doesn't have permissions to write to
it.

Since this is clearly not trivial to get right, introduce a
file_owner_or_capable() that can carry the correct semantics, and switch
the various users in mm to it.

The issue was found by manual code inspection & an off-list discussion
with Jan Kara.

Link: https://lore.kernel.org/20260625153853.913949-1-pfalcato@suse.de
Fixes: 9caccd41541a ("fs: introduce MOUNT_ATTR_IDMAP")
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christian Brauner (Amutable) <brauner@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/fs.h |    5 +++++
 mm/madvise.c       |    3 +--
 mm/mincore.c       |    3 +--
 3 files changed, 7 insertions(+), 4 deletions(-)

--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2811,6 +2811,11 @@ static inline struct user_namespace *fil
 	return mnt_user_ns(file->f_path.mnt);
 }
 
+static inline bool file_owner_or_capable(struct file *file)
+{
+	return inode_owner_or_capable(file_mnt_user_ns(file), file_inode(file));
+}
+
 /**
  * is_idmapped_mnt - check whether a mount is mapped
  * @mnt: the mount to check
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -565,8 +565,7 @@ static inline bool can_do_pageout(struct
 	 * otherwise we'd be including shared non-exclusive mappings, which
 	 * opens a side channel.
 	 */
-	return inode_owner_or_capable(&init_user_ns,
-				      file_inode(vma->vm_file)) ||
+	return file_owner_or_capable(vma->vm_file) ||
 	       file_permission(vma->vm_file, MAY_WRITE) == 0;
 }
 
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -168,8 +168,7 @@ static inline bool can_do_mincore(struct
 	 * for writing; otherwise we'd be including shared non-exclusive
 	 * mappings, which opens a side channel.
 	 */
-	return inode_owner_or_capable(&init_user_ns,
-				      file_inode(vma->vm_file)) ||
+	return file_owner_or_capable(vma->vm_file) ||
 	       file_permission(vma->vm_file, MAY_WRITE) == 0;
 }
 


