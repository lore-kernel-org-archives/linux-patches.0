Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B90E1F37BE;
	Tue, 17 Dec 2024 17:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455993; cv=none; b=A0UL93nzVtzqoAHBqcJng22yosaI9WgTW7uohj45pGu7spfTHBtDvsxlIEzbXEBs8JzZcZCdlULA5gU7jtjewtHVOOSmWLCyzFo0heNsdFCu0+ZVe43vz+3/h5Iv5o/4BnCdfn+6W80sLMRA/YxtkFW5pKozS7/d2ZVpkGHL3W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455993; c=relaxed/simple;
	bh=wyPWCV69bP/GAMJGxgkPHRIvj6+W3RZfhy8E/9ET9Vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dtZFG5YYNrmYKNXFAuN69amq27hHqH5buu4yn5hYUGGAX0+9XqZ0D+nLL03UmFBGma2ri/Nh1Al4yYRjnrRA+TnECCf9erY+03F4WaShUnljdjQkHBVSfIJ+8zutACFpTNMZhRHaY0V5pWwIPnKO62imizi58TwdYjXeoEYRy3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=15NprSBM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="15NprSBM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5BB0C4CED3;
	Tue, 17 Dec 2024 17:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455993;
	bh=wyPWCV69bP/GAMJGxgkPHRIvj6+W3RZfhy8E/9ET9Vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=15NprSBMJzALbXDca9KHT0rU6rDwG5Sc1qzhAwhEReUFC3gTdBkNsrhyAIWV0Da18
	 zn8LWnOtp5Ih8nCvPmxpbwWmyLseJ8LZ6GANEgFqxrn5iUeqvZKipkdvBobQKOFkK3
	 ctPiSgjHnbyp8+Xf2XRuoHdQIwkANYnZANUhFOtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6.6 024/109] xfs: update btree keys correctly when _insrec splits an inode root block
Date: Tue, 17 Dec 2024 18:07:08 +0100
Message-ID: <20241217170534.378093911@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Darrick J. Wong <djwong@kernel.org>

commit 6d7b4bc1c3e00b1a25b7a05141a64337b4629337 upstream.

In commit 2c813ad66a72, I partially fixed a bug wherein xfs_btree_insrec
would erroneously try to update the parent's key for a block that had
been split if we decided to insert the new record into the new block.
The solution was to detect this situation and update the in-core key
value that we pass up to the caller so that the caller will (eventually)
add the new block to the parent level of the tree with the correct key.

However, I missed a subtlety about the way inode-rooted btrees work.  If
the full block was a maximally sized inode root block, we'll solve that
fullness by moving the root block's records to a new block, resizing the
root block, and updating the root to point to the new block.  We don't
pass a pointer to the new block to the caller because that work has
already been done.  The new record will /always/ land in the new block,
so in this case we need to use xfs_btree_update_keys to update the keys.

This bug can theoretically manifest itself in the very rare case that we
split a bmbt root block and the new record lands in the very first slot
of the new block, though I've never managed to trigger it in practice.
However, it is very easy to reproduce by running generic/522 with the
realtime rmapbt patchset if rtinherit=1.

Cc: <stable@vger.kernel.org> # v4.8
Fixes: 2c813ad66a7218 ("xfs: support btrees with overlapping intervals for keys")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_btree.c |   29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -3429,14 +3429,31 @@ xfs_btree_insrec(
 	xfs_btree_log_block(cur, bp, XFS_BB_NUMRECS);
 
 	/*
-	 * If we just inserted into a new tree block, we have to
-	 * recalculate nkey here because nkey is out of date.
+	 * Update btree keys to reflect the newly added record or keyptr.
+	 * There are three cases here to be aware of.  Normally, all we have to
+	 * do is walk towards the root, updating keys as necessary.
 	 *
-	 * Otherwise we're just updating an existing block (having shoved
-	 * some records into the new tree block), so use the regular key
-	 * update mechanism.
+	 * If the caller had us target a full block for the insertion, we dealt
+	 * with that by calling the _make_block_unfull function.  If the
+	 * "make unfull" function splits the block, it'll hand us back the key
+	 * and pointer of the new block.  We haven't yet added the new block to
+	 * the next level up, so if we decide to add the new record to the new
+	 * block (bp->b_bn != old_bn), we have to update the caller's pointer
+	 * so that the caller adds the new block with the correct key.
+	 *
+	 * However, there is a third possibility-- if the selected block is the
+	 * root block of an inode-rooted btree and cannot be expanded further,
+	 * the "make unfull" function moves the root block contents to a new
+	 * block and updates the root block to point to the new block.  In this
+	 * case, no block pointer is passed back because the block has already
+	 * been added to the btree.  In this case, we need to use the regular
+	 * key update function, just like the first case.  This is critical for
+	 * overlapping btrees, because the high key must be updated to reflect
+	 * the entire tree, not just the subtree accessible through the first
+	 * child of the root (which is now two levels down from the root).
 	 */
-	if (bp && xfs_buf_daddr(bp) != old_bn) {
+	if (!xfs_btree_ptr_is_null(cur, &nptr) &&
+	    bp && xfs_buf_daddr(bp) != old_bn) {
 		xfs_btree_get_keys(cur, block, lkey);
 	} else if (xfs_btree_needs_key_update(cur, optr)) {
 		error = xfs_btree_update_keys(cur, level);


