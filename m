Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0C2403AFB;
	Tue, 21 Jul 2026 17:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656042; cv=none; b=f/T5zWYXixqpvc8z9H2L9X1BRbeJe0JZa9L4ejYMNZtpwItJxP2KiBtTPmF23EyAw43thWBS+gJU6axnTdouLGAxW9t/B9VwlO7LbuFXMsx74cqkZilt9U61MC4Yvp7AYm74iIG47oBmudS5aY5NBOoUWX6umvj0QxzaKUU2A7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656042; c=relaxed/simple;
	bh=wXjTMfX+L+gadPVwqYX2mKqDgcfTE6ZAOewuPHEvdrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJu5TDQ2k4URgeYseDlwAuPLPQBj5Q0j3H+TaDiCKdy8doAgvlKqvtTtgSbSh8v/0gmGeEbyCmC6d0jcTiiJcTd8rEftIawmmIfum/qUPjpkr+oS3/Xye0fVxBHKsrEpSjeTKyEc1eg6hU6kXdSyWUUcqCCFCFaBoRmgx26Npaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AHPhraSA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AHPhraSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E21221F000E9;
	Tue, 21 Jul 2026 17:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656041;
	bh=rbloREStEIuqZoJl1JynJ5shWRPh0q6udo/0i/JdVtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AHPhraSAdLKE1h3QIbscUwew8iMrk1ZPpOfCABu7iOCCOW7wjmulP8BirEpuuye/j
	 SDbSh8dvYgXMzrRDhW4uYw0M/0BnWSRMXcS1EnrDHZnbOZ/Wv+/D4kIGnsdHhk5lie
	 zlgM00AXxkEv+j1GIVI/Kt/Y+RIDXipZenuwPBtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0dfe499ea713e0a15bec@syzkaller.appspotmail.com,
	Conor Kotwasinski <conorkotwasinski2024@u.northwestern.edu>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0194/1611] kernfs: fix suspicious RCU usage in kernfs_put()
Date: Tue, 21 Jul 2026 17:05:10 +0200
Message-ID: <20260721152519.310080077@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a670ba3e565e03..360cfbd8dd36e8 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -576,10 +576,13 @@ void kernfs_put(struct kernfs_node *kn)
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



