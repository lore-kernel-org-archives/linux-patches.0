Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213371;
	b=owMcApHRwcwdTFUH0hzEMGjFZvE57Fz1suF9hK8LdB2cyt+hV3Gff8n581dugIN39Xfx
	 9/Sa+1B9Jy6DneulBnRGOaeGSgBsXVY7G4TWSP2Wy9kN1y+JEnFu6QZob/FkdPTteYO+9
	 Oi7g67gUulsBp9rrtuOtNtx/rMynbHIvia+uYkYyN4T6yJ0MmfatTek5uHTNrL4E/Eg71
	 AmdduwNWA5/jofGaaFvegGqHetl/RrS5FwBNODLFDVnrSHJ82kT1QCetso0pMig/FrQO3
	 7S8vFGVSKeZLmwtiYN51ZIVm2OP94ffUJ9V80srow9z1/uqE5CwogeC4ml8QNo35M+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213371;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7peVG/qto0iMICIX1mnBRJpL1r8q4YLCRO8lSPVuYLk=;
	b=2Sf2pSu2JUod4T0Sx/kaJfy14N1f5yUSUex4SzIQI/er1fzCqz6govWbL63lUTQIxRuY
	 SjtrC27qMG+5BWpm6/w3E2oMhkHXs+Y6WZXunlAyHoRjENSqpNevb3Ti6bib3scYs5RWW
	 z5tn4msONXINj6T2yiwCvxKacdYZtKs4VEI9VoIj4V8G3GgqdatFB09RsqmYUPT0jTeo4
	 rTd9kAJyriosP3eWREtwEAxzAzHMMOCdYNLa3c8/4mG92ZDlNNkphmZve0LlpnRojWfLh
	 OAk4QdXVS/pEhIRRm6UWGXf3/A67omzi7rLEzEv1F418QKtI4RSu8jDsXTywSmoz9hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g80fs1bA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F684606A31C;
	Wed, 28 Oct 2026 18:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g80fs1bA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1DD1F01825;
	Wed, 28 Oct 2026 18:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213371;
	bh=7peVG/qto0iMICIX1mnBRJpL1r8q4YLCRO8lSPVuYLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g80fs1bAHDShdUCoMfBcYPgeENplQYFAILEv4AWI7LLb0mSjeVrN58XY0Zw6cuITF
	 sF6O25IIBhcjZVLZPVDRgxCGoyQr9MYpAomi3awHoQArza0RZKaGrJHUnnIyJx3POb
	 0zGGl59xQmqFS3bN38F1Nc44gkr4pV43KQ+eKHxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.1 0480/1887] namespace: check a submount for references right before unmounting it
Date: Wed, 28 Oct 2026 17:42:56 +0100
Message-ID: <20261028170510.177975516@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 32bf92416614a1e3ff3524fc6b780259c7aad3ef upstream.

shrink_submounts() and mark_mounts_for_expiry() first collect all the
mounts they are allowed to unmount and then unmount them.

Whether a mount is busy is decided by propagate_mount_busy() on the
tree. But unmounting the first mount changes the tree that the second
one propagates into. propagate_umount()
moves a surviving overmount off a copy it unmounts and mounts it where
the copy was mounted. If that's where the propagated copy of the second
victim is looked up the overmount becomes a candidate of the second
umount_tree(). It's childless and so trim_one() commits it without
looking at its reference count.

So a synchronous umount pulls out a busy mount that is in use somewhere
else and marks it MNT_SYNC_UMOUNT while it has users:

  umount2(/tmp/plshrink/p1, 0) = 0 errno 0
  cwd is (unreachable)

The same two umounts requested one after the other fail with EBUSY.
This needs a mount with MNT_SHRINKABLE, i.e., automounted submounts of
NFS, AFS and CIFS or the tracefs mount below debugfs. Bind mounts
inherit the flag.

Check each mount right before it is unmounted under the same hold of
namespace_sem and mount_lock as the umount itself. Make sure that the
algorithm stays linear.

Fixes: 1064f874abc0 ("mnt: Tuck mounts under others instead of creating shadow/side mounts.")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260930-work-mount-fixes-3-v1-2-be34c83956ae@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namespace.c |   78 ++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 53 insertions(+), 25 deletions(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3198,6 +3198,11 @@ void mark_mounts_for_expiry(struct list_
 	}
 	while (!list_empty(&graveyard)) {
 		mnt = list_first_entry(&graveyard, struct mount, mnt_expire);
+		/* an earlier umount_tree() may have moved a busy mount here */
+		if (propagate_mount_busy(mnt, 1)) {
+			list_move(&mnt->mnt_expire, mounts);
+			continue;
+		}
 		touch_mnt_namespace(mnt->mnt_ns);
 		umount_tree(mnt, UMOUNT_PROPAGATE|UMOUNT_SYNC);
 	}
@@ -3208,16 +3213,36 @@ void mark_mounts_for_expiry(struct list_
 EXPORT_SYMBOL_GPL(mark_mounts_for_expiry);
 
 /*
+ * Unmount @mnt if it's a shrinkable mount without children that nobody uses.
+ *
+ * mount_lock must be held for write
+ */
+static bool shrink_submount(struct mount *mnt)
+{
+	if (propagate_mount_busy(mnt, 1))
+		return false;
+	touch_mnt_namespace(mnt->mnt_ns);
+	umount_tree(mnt, UMOUNT_PROPAGATE|UMOUNT_SYNC);
+	return true;
+}
+
+/*
  * Ripoff of 'select_parent()'
  *
- * search the list of submounts for a given mountpoint, and move any
- * shrinkable submounts to the 'graveyard' list.
+ * unmount the shrinkable submounts of @parent that aren't busy, children
+ * before their parent, and say whether anything went
+ *
+ * The cursor into the children of @this_parent survives the umount of a
+ * child mount without child mounts. The mounts that get umounted together with
+ * it are located under receiving mounts of @this_parent and never under
+ * @this_parent itself. The one exception is @this_parent getting unmounted
+ * then the walk starts over.
  */
-static int select_submounts(struct mount *parent, struct list_head *graveyard)
+static bool __shrink_submounts(struct mount *parent)
 {
 	struct mount *this_parent = parent;
 	struct list_head *next;
-	int found = 0;
+	bool shrunk = false;
 
 repeat:
 	next = this_parent->mnt_mounts.next;
@@ -3236,42 +3261,45 @@ resume:
 			this_parent = mnt;
 			goto repeat;
 		}
-
-		if (!propagate_mount_busy(mnt, 1)) {
-			list_move_tail(&mnt->mnt_expire, graveyard);
-			found++;
-		}
+		if (!shrink_submount(mnt))
+			continue;
+		shrunk = true;
+		if (unlikely(this_parent->mnt.mnt_flags & MNT_UMOUNT))
+			return true;
 	}
 	/*
 	 * All done at this level ... ascend and resume the search
 	 */
 	if (this_parent != parent) {
-		next = this_parent->mnt_child.next;
-		this_parent = this_parent->mnt_parent;
+		struct mount *mnt = this_parent;
+
+		next = mnt->mnt_child.next;
+		this_parent = mnt->mnt_parent;
+		/* its children are gone, maybe it can go as well */
+		if (shrink_submount(mnt)) {
+			shrunk = true;
+			if (unlikely(this_parent->mnt.mnt_flags & MNT_UMOUNT))
+				return true;
+		}
 		goto resume;
 	}
-	return found;
+	return shrunk;
 }
 
 /*
- * process a list of expirable mountpoints with the intent of discarding any
- * submounts of a specific parent mountpoint
+ * unmount the shrinkable submounts of @mnt that aren't busy
+ *
+ * The busy check and the umount of a mount are adjacent. An umount can
+ * still empty or move a mount in a part of the tree that was walked
+ * already, so walk again until nothing goes.
  *
  * mount_lock must be held for write
  */
 static void shrink_submounts(struct mount *mnt)
 {
-	LIST_HEAD(graveyard);
-	struct mount *m;
-
-	/* extract submounts of 'mountpoint' from the expiration list */
-	while (select_submounts(mnt, &graveyard)) {
-		while (!list_empty(&graveyard)) {
-			m = list_first_entry(&graveyard, struct mount,
-						mnt_expire);
-			touch_mnt_namespace(m->mnt_ns);
-			umount_tree(m, UMOUNT_PROPAGATE|UMOUNT_SYNC);
-		}
+	for (;;) {
+		if (!__shrink_submounts(mnt))
+			break;
 	}
 }
 


