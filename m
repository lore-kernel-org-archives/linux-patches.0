Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625110;
	b=4/u1QSLCb8BRg6kAeuEeDYH20zaX9yZK8uaTmu1SizgOAu/iz6p95SXUM3eY1Yv42IVy
	 5ZVSJmTSpoMbkCBIogtbiMSbFzxVvLL8RPC44EDwbh5H/zLfJ3j9Nb7MkBaOadlsvDwCv
	 HgMWygnM6vBGnoHbluDAmFVTIwR5bb16V5ISnRGvg379CUkLxhyTsewbc37V+4pSK467v
	 fCHPc8HaVqfzazb1Ijof7udhxmPKoBuJGHxQFIzXEAX4S5hONq51bKNDGLa/KkB8iz/WO
	 CDbODsXE2nBZcw0XhYbHVcL1ChnqUHCXNDt30hAYdVNJyzmV6Ra4sMG01mK7QRDIYzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625110;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TUssAbsPNIycc2i+ypkypmcfM4zNU/N47P1pNHKPgTo=;
	b=O6K/Kn5Tg5s55naQWeCakX3d9cer7PrMdm83a8VqpWbB+YAtp95QbvlGsuWYSQ7ve0T8
	 YUmZcvRLa3PF064pw1R3JsBysGmsnaSvjTmpMsRWoSP986MhpTfFE98DatVL8m4F80zRK
	 QpgqWb7MqwsSf5lscD76cMvMWInyvGEsxXylvWbh2gQxoKGHXxHehRvoGkZItMVbggxxr
	 rJTBV/wr5aFiCQlUsZvoSrGEgaT4az2cN3LUUH7w3x0nrO96BOBu6Jr2SG0qYgboAJffs
	 +rDArotzI3+5BroqRxKSGeBQ/V3GyIzhpHGjABwrJp7njIvgJHPgFr5/fBJXY4dBNwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CB5Q7lvs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7AE0606A329;
	Wed, 25 Nov 2026 16:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CB5Q7lvs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CEC81F000C0;
	Wed, 25 Nov 2026 16:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625110;
	bh=TUssAbsPNIycc2i+ypkypmcfM4zNU/N47P1pNHKPgTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CB5Q7lvsbWB1bbWsX1qC+ErZUYcrT1sz3ArbnuqnsEaDppJfSovVaT8vp03vM/LL6
	 7qVgKLNUj38jJWiv39vIh/rog7jbliJJZCIra2ml8YH1cVY70UMS3FXQkQjlNBT5N3
	 cJ28L4wJA2L8vNndS94ETLF2ApCxsbagT1qvzYWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 408/816] kernfs: dont repeat or skip an entry when readdir resumes
Date: Wed, 25 Nov 2026 15:32:36 +0100
Message-ID: <20261125143858.639386355@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shakeel Butt <shakeel.butt@linux.dev>

[ Upstream commit 5ebcb578adeec7407dd501108ab2f423ca8e3e55 ]

readdir keeps its place as a name hash in ctx->pos and pins the entry in
file->private_data.  If that entry is gone when the listing comes back,
kernfs_dir_pos() searches the rbtree for the hash and keeps whatever
node the descent stopped on.  That is the entry before or after the
missing one, depending on the shape of the tree.

Landing before it repeats an entry the previous getdents(2) call already
reported.  Landing after it, kernfs_dir_next_pos() calls rb_next() and
steps over an unreported entry.

With children A(10), B(20), C(30):

  report A, ctx->pos = 10
                                    A removed
  kernfs_dir_next_pos(10, A)
    A is gone, the search for 10 stops at B
    rb_next(B) -> C, so B is never reported

Only the repeat happens today, between two getdents(2) calls.  The skip
needs the pinned entry to go away inside one call, which the next patch
allows when it drops kernfs_rwsem around dir_emit().

Before the commit 4e4d6d860b93 the descent kept a node only on the way
left, which is a search for the first entry at or after the hash.  That
commit moved the assignment to the top of the loop, where it runs on
right turns too.  Restore that search, and step forward only when the
pinned entry is still there rather than when the hash matches, since two
entries in one directory can share a hash.

While here, kernfs_dir_next_pos() called the hash @ino.  It is never an
inode number, so name it @hash.

Fixes: 4e4d6d860b93 ("sysfs: Add s_hash to sysfs_dirent and order directory entries by hash")
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Link: https://patch.msgid.link/20260911182815.1992483-2-shakeel.butt@linux.dev
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ sashal: Adapted to the older base by using const void *ns, direct pos->parent and pos->name access, and dropping the ns_id comparisons that don't exist there. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/kernfs/dir.c | 38 ++++++++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 10 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index c9ba69bc48730..f74dc32f9d3a1 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -1796,27 +1796,42 @@ static int kernfs_dir_fop_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
+/*
+ * Find where a listing left off.  @resumed says whether @pos is still that
+ * entry; if not, the first entry at or after @hash is returned instead.
+ */
 static struct kernfs_node *kernfs_dir_pos(const void *ns,
-	struct kernfs_node *parent, loff_t hash, struct kernfs_node *pos)
+	struct kernfs_node *parent, loff_t hash, struct kernfs_node *pos,
+	bool *resumed)
 {
+	if (resumed)
+		*resumed = false;
 	if (pos) {
 		int valid = kernfs_active(pos) &&
 			pos->parent == parent && hash == pos->hash;
 		kernfs_put(pos);
 		if (!valid)
 			pos = NULL;
+		else if (resumed)
+			*resumed = true;
 	}
 	if (!pos && (hash > 1) && (hash < INT_MAX)) {
 		struct rb_node *node = parent->dir.children.rb_node;
+
+		/*
+		 * Keep a node only on the way left, so the search ends on the
+		 * first entry at or after @hash.  The empty name sorts before
+		 * every entry sharing the hash, so it lands on the first.
+		 */
 		while (node) {
-			pos = rb_to_kn(node);
+			struct kernfs_node *kn = rb_to_kn(node);
 
-			if (hash < pos->hash)
+			if (kernfs_name_compare(hash, "", ns, kn) < 0) {
+				pos = kn;
 				node = node->rb_left;
-			else if (hash > pos->hash)
+			} else {
 				node = node->rb_right;
-			else
-				break;
+			}
 		}
 	}
 	/* Skip over entries which are dying/dead or in the wrong namespace */
@@ -1831,10 +1846,13 @@ static struct kernfs_node *kernfs_dir_pos(const void *ns,
 }
 
 static struct kernfs_node *kernfs_dir_next_pos(const void *ns,
-	struct kernfs_node *parent, ino_t ino, struct kernfs_node *pos)
+	struct kernfs_node *parent, loff_t hash, struct kernfs_node *pos)
 {
-	pos = kernfs_dir_pos(ns, parent, ino, pos);
-	if (pos) {
+	bool resumed;
+
+	pos = kernfs_dir_pos(ns, parent, hash, pos, &resumed);
+	/* Step over @pos only if it survived; two entries can share a hash. */
+	if (pos && resumed) {
 		do {
 			struct rb_node *node = rb_next(&pos->rb);
 			if (!node)
@@ -1863,7 +1881,7 @@ static int kernfs_fop_readdir(struct file *file, struct dir_context *ctx)
 	if (kernfs_ns_enabled(parent))
 		ns = kernfs_info(dentry->d_sb)->ns;
 
-	for (pos = kernfs_dir_pos(ns, parent, ctx->pos, pos);
+	for (pos = kernfs_dir_pos(ns, parent, ctx->pos, pos, NULL);
 	     pos;
 	     pos = kernfs_dir_next_pos(ns, parent, ctx->pos, pos)) {
 		const char *name = pos->name;
-- 
2.53.0



