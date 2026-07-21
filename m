Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFCA46D57E;
	Tue, 21 Jul 2026 15:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648644; cv=none; b=nIFpyGp68aBsJlneTldGdtN0aarG6/O2cMAnD8Y+eNwcyWaznlExjaT/JrHG7vkqcmrFHgUs6bhxTwSCuFUqc5NmeSfDE19eoID2YGYL+CUM82jl3JBSvGGgbjJzSCJK8uSWaHlpQyqZW8XlHOIDpdVwS+BdSZQapD/sFTTPnI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648644; c=relaxed/simple;
	bh=HgOifuwG6vaINmKGfUrNgmJICZ3IsvnDSORb8bsLuf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kuNF58uQb2rJLjgU3g3zpmv+Tu6orCrKcYtGPOn/Osp3LNWeGXrGVNiDbBrTCNMUh/3jgq757A8cRYNlSOoUOcFv+evGWfTABoAlKqGyRBn/waEm9XuUKB1EUTnNdBz95cHUYBif6iU8yzUDPFEpl2/v36OzULP4JDXSSzSAwWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xzRzoLe+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xzRzoLe+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B461F000E9;
	Tue, 21 Jul 2026 15:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648642;
	bh=adzqu1U8KVUAKR2FCvc0ufM8nqu7by5XRG4A29WvGjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xzRzoLe+fgskFI0dlsve891miFdyOtYWHxdSsXyu6amN54xyLFEForzDDvuGRIwpa
	 p/XAJzfsFFxhEvbkkrm13O4Z4N8kTHIzRftMDFYV4lpYUZTRNmxxzXpefC7ZQJDn2J
	 XWDF8TN2ymHYEUF36dXsXiEuV8TgzoESQ4AWijsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0dfe499ea713e0a15bec@syzkaller.appspotmail.com,
	Conor Kotwasinski <conorkotwasinski2024@u.northwestern.edu>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0278/2077] kernfs: fix suspicious RCU usage in kernfs_put()
Date: Tue, 21 Jul 2026 16:59:11 +0200
Message-ID: <20260721152559.240222672@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Conor Kotwasinski <conorkotwasinski2024@u.northwestern.edu>

[ Upstream commit 0fdde3f2aeadcf8d090ee3edee0aad73fb91f690 ]

Commit 741c10b096bc ("kernfs: Use RCU to access kernfs_node::name.")
converted the WARN_ONCE() in kernfs_put() to read kn->name and
parent->name via rcu_dereference(), but kernfs_put() has callers that
hold neither kernfs_rwsem nor the RCU read lock. The inode eviction
path driven by memory reclaim is one such case:

  kernfs_put+0x53/0x60 fs/kernfs/dir.c:602
  evict+0x3c2/0xad0 fs/inode.c:846
  iput_final fs/inode.c:1966 [inline]
  iput.part.0+0x605/0xf50 fs/inode.c:2015
  iput+0x35/0x40 fs/inode.c:1981
  dentry_unlink_inode+0x2a1/0x490 fs/dcache.c:467
  __dentry_kill+0x1d0/0x600 fs/dcache.c:670
  shrink_dentry_list+0x180/0x5e0 fs/dcache.c:1174
  prune_dcache_sb+0xea/0x150 fs/dcache.c:1256
  super_cache_scan+0x328/0x550 fs/super.c:223
  ...
  kswapd+0x556/0xba0 mm/vmscan.c:7343

lockdep complains with "suspicious RCU usage" whenever the WARN
fires from such a context.

Wrap the rcu_dereference() calls in an RCU read-side critical section.
Gate on the active-ref check so the lock is only taken when the WARN
is about to fire.

Note that this does not address the underlying imbalance in
kn->active that triggers the WARN.

Fixes: 741c10b096bc ("kernfs: Use RCU to access kernfs_node::name.")
Reported-by: syzbot+0dfe499ea713e0a15bec@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0dfe499ea713e0a15bec
Signed-off-by: Conor Kotwasinski <conorkotwasinski2024@u.northwestern.edu>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://patch.msgid.link/20260416134315.1474726-1-conorkotwasinski2024@u.northwestern.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/kernfs/dir.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 4f9ade82b08abd..e88b71607f1e51 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -597,10 +597,13 @@ void kernfs_put(struct kernfs_node *kn)
 	 */
 	parent = kernfs_parent(kn);
 
-	WARN_ONCE(atomic_read(&kn->active) != KN_DEACTIVATED_BIAS,
-		  "kernfs_put: %s/%s: released with incorrect active_ref %d\n",
-		  parent ? rcu_dereference(parent->name) : "",
-		  rcu_dereference(kn->name), atomic_read(&kn->active));
+	if (atomic_read(&kn->active) != KN_DEACTIVATED_BIAS) {
+		guard(rcu)();
+		WARN_ONCE(1,
+			  "kernfs_put: %s/%s: released with incorrect active_ref %d\n",
+			  parent ? rcu_dereference(parent->name) : "",
+			  rcu_dereference(kn->name), atomic_read(&kn->active));
+	}
 
 	if (kernfs_type(kn) == KERNFS_LINK)
 		kernfs_put(kn->symlink.target_kn);
-- 
2.53.0



