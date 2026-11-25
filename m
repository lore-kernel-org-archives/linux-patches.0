Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619798;
	b=oLsBgMhfeslYYdK97gSU5rLxK7Lkd0qmJR1ft3wA4722BZ2HJTyPK5U4t7c21hZHe6kp
	 U+ZM+Twqa0ql0T++u7Qrj4kcjt9p5uhzJ9+1bVcEFizyvWMi2hvL4Mcr+9sHqYy2BOa1C
	 nVI4ZF7pJxSHEI3jN+bpL5LwcEy+AFv64egTGRkT185fXGmrzUiiU+8IsDMbk1BzLGil5
	 wY27cmPsel0JKGWL8XgKLxsx7JZFJU/2Oj0hbj716Hb/bAJD8MeCo4A6xUpC/ONNTWuIx
	 6AgwVy51aWkXFZDS0t9m0dIt7UwZX7JQ5MNODGUSXOFiRJ6Pf7fTFegBMddpYHaZAjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619798;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ti6LIkiWkVkN0RbQSLB5LKSu8jIQBbLgrD2fyCdj/wA=;
	b=sV1MphnkCJz3WzQA/buzruewjfkebPUc6B6En/f5R1brYRE6k4eHsbZM6GjmyD1DXezC
	 JULOGvK5xvuhq0AfqXsn10HmjKMkWYr7N5IPvVuWlCg26cBYl7S3k4pjVTht/Iyj0geeR
	 et14ch4QIbVhvqzToO4Gzwo9fbxSZtmQP6DFhr+gphQkkxjx7lqbEP7vrvn2LJV9eAoZA
	 a5wktbgHQX3UXNzOsDxVLnwRPR7OfDlUTmjW//P6TKk+xPedVg5RHKOQ8jBmx7AKCfqG3
	 eIuhqjCSJ7QZAqtoZ/X6dcu6/AngaGqogEKHrNbTY2Iq+4+CZK0oCxPiTQws5hobjjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="PBsw/Uec";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C67606A321;
	Wed, 25 Nov 2026 15:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PBsw/Uec
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 330D61F000C0;
	Wed, 25 Nov 2026 15:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619797;
	bh=ti6LIkiWkVkN0RbQSLB5LKSu8jIQBbLgrD2fyCdj/wA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PBsw/Uec/twiyf919cftSRvP2S+XsdngFCT6waXo3hZgsJE3/kiao9tpTG++L+5v+
	 V1/eNFeLqTiTrIXqoCw++4+bzNlM+FGr32QdLWb9AkR3eswPQonyMOBvmoLidfxW85
	 Sx1MSD85yigYXGYDGSIp3eyMN8SI4lmXGQsqM0Us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.3 0694/1005] dcache: let d_invalidate() wait for a d_set_mounted() in flight
Date: Wed, 25 Nov 2026 15:33:52 +0100
Message-ID: <20261125143838.011535144@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

commit 20a6a9ec19e522ae85f87337886b3fb47efce5f3 upstream.

d_invalidate() and d_set_mounted() are supposed to exclude each other.
Either the mount fails with -ENOENT because an ancestor of the
mountpoint was unhashed or d_invalidate() finds the mountpoint and
detaches the mount. d_invalidate() unhashes the dentry first and then
searches the subtree with d_walk() which starts out lockless and only
looks at the seqcount of rename_lock.

Since d_set_mounted() switched to read_seqlock_excl() nothing makes that
walk wait or retry:

  CPU0: mount on A/M                 CPU1: d_invalidate(A)
  d_set_mounted(M)
    read_seqlock_excl(&rename_lock)
    A is hashed, go on
                                     __d_drop(A)
                                     shrink_dcache_parent(A)
                                     d_walk(A, find_submount)
                                       read_seqbegin(&rename_lock)
                                       M is not a mountpoint
                                       need_seqretry() == false
                                     return
    M->d_flags |= DCACHE_MOUNTED
    return 0
  mount gets attached to M

The mount ends up below an unhashed dentry. It can't be reached anymore
and pins the subtree until its parent mount or the mount namespace goes
away. The window grows with the depth of the mountpoint. With a FUSE
directory 3000 levels deep a bind mount racing with
FUSE_NOTIFY_INVAL_ENTRY for the parent of the mountpoint survived in 151
of 200 attempts.

Before 5e317d23f6c6 the seqcount bump made the walk wait while
d_set_mounted() ran and retry under the lock when one had run in the
meantime. That was the right thing to wait for on the wrong counter:
every rename_lock reader paid for it, d_lookup(), d_path(), the ".."
step of the RCU walk.

So give d_set_mounted() a seqlock of its own. It is the only writer and
d_invalidate() is the only reader. After unhashing the dentry
d_invalidate() runs an empty read_seqbegin()/read_seqretry() section on
it. That spins while the count is odd, i.e. while a d_set_mounted() is
between its ancestor check and its flag, and goes round once more if
one started in the meantime. Nobody else retries anything. The ordering
comes from the locks both already take:

- If that d_set_mounted() saw the dentry hashed its check ran under the
  dentry's d_lock before __d_drop() took it. So the count is odd by the
  time d_invalidate() reads it and d_invalidate() waits.

- Once the count is even again the flag has been set under the
  mountpoint's d_lock and the walk takes that lock to look at it.

A d_set_mounted() that starts after the unhash fails its ancestor check
and never touches the flag. So the only flag the walk can pick up
belongs to the one mount that saw the dentry hashed and is still in
flight, and there is at most one of those because namespace_sem
serializes mounts. Either it gets attached and detach_mounts() takes it
off after waiting for namespace_sem or it fails later on and drops the
flag again. In that case the walk goes round once more and finds
nothing. The same goes for the mountpoint that attach_recursive_mnt()
preallocates on the root of the tree it attaches. IOW, d_invalidate()
does at most one extra round, which the removed-name trap (cf. [1])
relies on.

Note that on PREEMPT_RT read_seqbegin() takes the lock instead of
spinning on a preempted d_set_mounted().

The cost is a seqlock around the ancestor walk for every new mountpoint
and two loads of a cacheline that only d_set_mounted() writes for every
d_invalidate() of a positive dentry. Walking the ancestors a second time
after setting the flag would close the race as well but doubles the
cost of d_set_mounted() with the depth of the mountpoint: about 1us at
64 levels and 75us at 4096 levels.

[1]: https://patch.msgid.link/20261028-work-mount-trap-b4-v1-0-f20d9d0730d6@kernel.org

Fixes: 5e317d23f6c6 ("d_set_mounted(): we don't need to bump seqcount component of rename_lock")
Reported-by: Josef Bacik <josef@toxicpanda.com>
Cc: stable@vger.kernel.org # v6.17+
Link: https://patch.msgid.link/20261030-work-dcache-ai-v1-1-cd6b86e0ccc7@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dcache.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1589,21 +1589,25 @@ int path_has_submounts(const struct path
 }
 EXPORT_SYMBOL(path_has_submounts);
 
+/* odd while d_set_mounted() runs, d_invalidate() waits on it */
+static __cacheline_aligned_in_smp DEFINE_SEQLOCK(d_set_mounted_lock);
+
 /*
  * Called by mount code to set a mountpoint and check if the mountpoint is
  * reachable (e.g. NFS can unhash a directory dentry and then the complete
  * subtree can become unreachable).
  *
  * Only one of d_invalidate() and d_set_mounted() must succeed.  For
- * this reason take rename_lock and d_lock on dentry and ancestors.
- * Likewise for dont_mount() which marks a dentry that is being removed
- * under d_lock.
+ * this reason take rename_lock, d_set_mounted_lock and d_lock on dentry
+ * and ancestors.  Likewise for dont_mount() which marks a dentry that
+ * is being removed under d_lock.
  */
 int d_set_mounted(struct dentry *dentry)
 {
 	struct dentry *p;
 	int ret = -ENOENT;
 	read_seqlock_excl(&rename_lock);
+	write_seqlock(&d_set_mounted_lock);
 	for (p = dentry->d_parent; !IS_ROOT(p); p = p->d_parent) {
 		/* Need exclusion wrt. d_invalidate() */
 		spin_lock(&p->d_lock);
@@ -1621,8 +1625,9 @@ int d_set_mounted(struct dentry *dentry)
 			ret = 0;
 		}
 	}
- 	spin_unlock(&dentry->d_lock);
+	spin_unlock(&dentry->d_lock);
 out:
+	write_sequnlock(&d_set_mounted_lock);
 	read_sequnlock_excl(&rename_lock);
 	return ret;
 }
@@ -1875,6 +1880,7 @@ static enum d_walk_ret find_submount(voi
 void d_invalidate(struct dentry *dentry)
 {
 	bool had_submounts = false;
+	unsigned seq;
 	spin_lock(&dentry->d_lock);
 	if (d_unhashed(dentry)) {
 		spin_unlock(&dentry->d_lock);
@@ -1887,6 +1893,11 @@ void d_invalidate(struct dentry *dentry)
 	if (!dentry->d_inode)
 		return;
 
+	/* wait for a d_set_mounted() that saw us hashed to set its flag */
+	do {
+		seq = read_seqbegin(&d_set_mounted_lock);
+	} while (read_seqretry(&d_set_mounted_lock, seq));
+
 	shrink_dcache_parent(dentry);
 	for (;;) {
 		struct dentry *victim = NULL;


