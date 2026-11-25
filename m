Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619833;
	b=aEE4lSxchM+hnO/nod+KmV4+xnK8FOJiWwwrJCtwvfAoGF2twj2UBlY34zhbCrHmDyk6
	 W4zdCUtHYv25TWXBSdb/ZlVy46XbOgYWbnyRY2vSqXh3uoP8mMMknnlxlWKIlia38y2WC
	 GevZgSbTSmfaQ07GE9u7paKfiemdIyokT4/EB+iA+M0LF9wVYsrB0ZrIUK2+0ez+CnYj/
	 xsLuka7K9CamtAx47SP3hVkMrDNjgOq7WCg0fuUwZiJt1FYhrNWKfan3uZhpFqB/GR9uY
	 1Fl38KLzANi3OVge8s3OqT4WOaH+i+PvkbzPSt+eUML/HZd4s2KbU2SAcTsopSHd4kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619833;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H6RHCQWpSlSHJyqxWm+8OXWemyOzl2CmBrfccYtuZaw=;
	b=rZ48pUYj38GTzyf62Zx0R32I7hAFwls5byikV3iE191MkmGonrqRJWPixAteqjq+IuSp
	 QOKxcS7UZGSWTdXFGeCZXcCDUeiLZSsUXU6Js+g2jxJYf2JXtcFz0P/N761d0vqR0MAA2
	 PbRBLdiqt4bvN5evVS/fp+/OzlkfuhSOJSAt+eHcrQhRdyMDApNEUAdOowXD4pXu7FUV0
	 +gPIzQPXrUneUVs8CNmpBv4anK3oCi4UzRz62ehA0bcOpRnLNRrlsA5vX9D1o/GL0sxhU
	 3Ru8ZyTnsl/YSj6jVBWQHoJr9VCIQcYfpwj70lU29Hrg8vWrj2TYVoGmqIvV+No3I1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="2GXd1/DK";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A245606A321;
	Wed, 25 Nov 2026 15:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2GXd1/DK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5CAC1F000EF;
	Wed, 25 Nov 2026 15:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619833;
	bh=H6RHCQWpSlSHJyqxWm+8OXWemyOzl2CmBrfccYtuZaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2GXd1/DKyPe3o1Hof0r+3BziurA8GM1+a90VwqKUsm7gaE3E7fkWAou3hLj/HZ2lA
	 gAyKsfvjbCl/7d3q5teLy9bOzr44sFCq5qnSz29lbXBMCEfwJRE9zIw9l80nGg1jv3
	 v8K+/LEpuSTXYWY7Vn42zGnzvUw8Xa+2W+HvBnwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.3 0695/1005] dcache: wait for a racing eviction of a secondary root
Date: Wed, 25 Nov 2026 15:33:53 +0100
Message-ID: <20261125143838.035237597@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

commit 649918e04e0ead9bfc861aacdd2e5b39b5bdf869 upstream.

Commit e9895609cb7f ("wind ->s_roots via ->d_sib instead of ->d_hash")
keeps a secondary root on ->s_roots until dentry_unlist() so that
shrink_dcache_for_umount() can find one that another thread is evicting
and wait for it. But do_one_tree() takes every root off the list before
its dput() which breaks that:

  thread A                              umount
  dentry_kill(root), refcount is 0
    lock_for_kill()
      spin_trylock(->i_lock) fails
      spin_unlock(->d_lock)
                                        shrink_dcache_for_umount()
                                          dget_dlock(root)
                                          do_one_tree(root)
                                            unlink_secondary_root(root)
      spin_lock(->i_lock)
                                            dput(root), refcount is 0
                                              lock_for_kill()
                                                trylock fails, waits
      spin_lock(->d_lock)
      refcount is 0 again, go on
    lockref_mark_dead()
    dentry_unlink_inode()
      drops both locks
                                                root is dead, give up
                                          ->s_roots is empty, done
                                        evict_inodes()
                                        "Busy inodes after unmount"
      iput()

Thread A evicts without pinning the superblock. namespace_unlock() does
that for old mountpoints after dropping namespace_sem, and a secondary
root goes with its last child.

So only take busy roots off the list. Leave the others to
dentry_unlist() so that shrink_dcache_for_umount() finds them and waits
for an eviction in progress. A root that becomes busy after the check is
picked up again and taken off the list then.

Fixes: 78db93943210 ("dcache: keep shrink_dcache_for_umount() making progress on busy roots")
Cc: stable@vger.kernel.org # v7.2+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261030-work-dcache-ai-v1-2-cd6b86e0ccc7@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dcache.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1816,8 +1816,13 @@ static void do_one_tree(struct dentry *d
 	d_walk(dentry, dentry, umount_check);
 	spin_lock(&dentry->d_lock);
 	__d_drop(dentry);
-	/* A busy root survives the dput() below so don't leave it on ->s_roots. */
-	if (unlikely(!hlist_unhashed(&dentry->d_sib)))
+	/*
+	 * A busy root survives the dput() below so don't leave it on ->s_roots.
+	 * An idle one stays until dentry_unlist() so that umount can wait for
+	 * a racing eviction, see lock_for_kill().
+	 */
+	if (unlikely(dentry->d_lockref.count > 1 &&
+		     !hlist_unhashed(&dentry->d_sib)))
 		unlink_secondary_root(dentry);
 	spin_unlock(&dentry->d_lock);
 	dput(dentry);


