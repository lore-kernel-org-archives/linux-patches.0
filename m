Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8E822D4F9;
	Mon,  2 Jun 2025 14:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873249; cv=none; b=D5IER42xnifvNl7enkuPURODLHhSJof+WHcgCyA3cGx/0AX6GmEfpdCBj7XoQNYmN4mD6TR125nmPdGiNlQW86xyjrIBm9M2pYdOp1d1g57dHzGzh5jdmlHL1Bs6j9X4ICs6CVg62BjuPSAjSjmX9Gx0xMKhtddb8ICXVzX6adY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873249; c=relaxed/simple;
	bh=7CCKGMo8cLPBN8qJtyMDxAmNIOdVFJ9xBHgt/7owIIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UhjtE+NdJM0P0pPjCQYeGioqfwUNjHYdDRNPvZk5ap2q1ZNoHS1iQ5ek8Tw+ykrbNjudtmdvPxNnqsjCUJhnLj3Rq2ADsH9CTg7eX922J8o/wzx0aF7cXm/svZc/T01Co57hx+YZH9aC3cHrAwybc1EkK1HjZlH7u0tcEExXOmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=13jVHeuV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="13jVHeuV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB82C4CEEB;
	Mon,  2 Jun 2025 14:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873249;
	bh=7CCKGMo8cLPBN8qJtyMDxAmNIOdVFJ9xBHgt/7owIIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=13jVHeuVZmm3zfLnbrThTwwL50ekzeeu4qQbL9Z2CVfVwxohEaJLkvhLCUBTo2t7H
	 CjxrxLvQKoovOcuCV4WPy/pPBIbMRq0ul2rB4u/TJpi9ij49L/e4P/xV5Ikmu/l28S
	 SCZ7dQCFlEDnRLuQ8Y3padSRDuSWnvLYCGGCp+ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 075/444] btrfs: make btrfs_discard_workfn() block_group ref explicit
Date: Mon,  2 Jun 2025 15:42:19 +0200
Message-ID: <20250602134343.955064369@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Boris Burkov <boris@bur.io>

[ Upstream commit 895c6721d310c036dcfebb5ab845822229fa35eb ]

Currently, the async discard machinery owns a ref to the block_group
when the block_group is queued on a discard list. However, to handle
races with discard cancellation and the discard workfn, we have a
specific logic to detect that the block_group is *currently* running in
the workfn, to protect the workfn's usage amidst cancellation.

As far as I can tell, this doesn't have any overt bugs (though
finish_discard_pass() and remove_from_discard_list() racing can have a
surprising outcome for the caller of remove_from_discard_list() in that
it is again added at the end).

But it is needlessly complicated to rely on locking and the nullity of
discard_ctl->block_group. Simplify this significantly by just taking a
refcount while we are in the workfn and unconditionally drop it in both
the remove and workfn paths, regardless of if they race.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/discard.c | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/discard.c b/fs/btrfs/discard.c
index 944a7340f6a44..3981c941f5b55 100644
--- a/fs/btrfs/discard.c
+++ b/fs/btrfs/discard.c
@@ -167,13 +167,7 @@ static bool remove_from_discard_list(struct btrfs_discard_ctl *discard_ctl,
 	block_group->discard_eligible_time = 0;
 	queued = !list_empty(&block_group->discard_list);
 	list_del_init(&block_group->discard_list);
-	/*
-	 * If the block group is currently running in the discard workfn, we
-	 * don't want to deref it, since it's still being used by the workfn.
-	 * The workfn will notice this case and deref the block group when it is
-	 * finished.
-	 */
-	if (queued && !running)
+	if (queued)
 		btrfs_put_block_group(block_group);
 
 	spin_unlock(&discard_ctl->lock);
@@ -260,9 +254,10 @@ static struct btrfs_block_group *peek_discard_list(
 			block_group->discard_cursor = block_group->start;
 			block_group->discard_state = BTRFS_DISCARD_EXTENTS;
 		}
-		discard_ctl->block_group = block_group;
 	}
 	if (block_group) {
+		btrfs_get_block_group(block_group);
+		discard_ctl->block_group = block_group;
 		*discard_state = block_group->discard_state;
 		*discard_index = block_group->discard_index;
 	}
@@ -493,9 +488,20 @@ static void btrfs_discard_workfn(struct work_struct *work)
 
 	block_group = peek_discard_list(discard_ctl, &discard_state,
 					&discard_index, now);
-	if (!block_group || !btrfs_run_discard_work(discard_ctl))
+	if (!block_group)
 		return;
+	if (!btrfs_run_discard_work(discard_ctl)) {
+		spin_lock(&discard_ctl->lock);
+		btrfs_put_block_group(block_group);
+		discard_ctl->block_group = NULL;
+		spin_unlock(&discard_ctl->lock);
+		return;
+	}
 	if (now < block_group->discard_eligible_time) {
+		spin_lock(&discard_ctl->lock);
+		btrfs_put_block_group(block_group);
+		discard_ctl->block_group = NULL;
+		spin_unlock(&discard_ctl->lock);
 		btrfs_discard_schedule_work(discard_ctl, false);
 		return;
 	}
@@ -547,15 +553,7 @@ static void btrfs_discard_workfn(struct work_struct *work)
 	spin_lock(&discard_ctl->lock);
 	discard_ctl->prev_discard = trimmed;
 	discard_ctl->prev_discard_time = now;
-	/*
-	 * If the block group was removed from the discard list while it was
-	 * running in this workfn, then we didn't deref it, since this function
-	 * still owned that reference. But we set the discard_ctl->block_group
-	 * back to NULL, so we can use that condition to know that now we need
-	 * to deref the block_group.
-	 */
-	if (discard_ctl->block_group == NULL)
-		btrfs_put_block_group(block_group);
+	btrfs_put_block_group(block_group);
 	discard_ctl->block_group = NULL;
 	__btrfs_discard_schedule_work(discard_ctl, now, false);
 	spin_unlock(&discard_ctl->lock);
-- 
2.39.5



