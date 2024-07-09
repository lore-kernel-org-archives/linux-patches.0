Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173FF27713;
	Tue,  9 Jul 2024 11:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524471; cv=none; b=TfnlNXARbcBVVDVphxWrktrsbyoFcr6GRAkiW7X/TU3O495KtOzDg5UuIBGjDjzDmvm3ONSMnjORkQQwThummbQOdmeqONp+K6j0i3FLn2kJIDG43/rmpid6NIjIzYCz40wCYYBIR2WpBuNy9wMMRLu6mO5JR2OcxlfVm1IGvjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524471; c=relaxed/simple;
	bh=uBxQbphDlobqikN7cxKA7DoAu/FnbypC0kOhmaTo5EY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XFG7s6PtzSAVwVRAI4mu4eqphokbrk6iu07dp6egCmNeCRKeXsLUfb4M4k9o2bebCpLBUWT7R+dQv+EhToiLY5p5qBEBAfYtQg+isXIYjpASkK4ZPlW8VuGc7yabvDVbLxQL5q/afhJOq34mPShj70XWNqkMUjwoCtT0imi3u+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gy7QZ2v9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gy7QZ2v9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88ABEC3277B;
	Tue,  9 Jul 2024 11:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524470;
	bh=uBxQbphDlobqikN7cxKA7DoAu/FnbypC0kOhmaTo5EY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gy7QZ2v9QwurIkji3q7sYW4PHWEyPtx8GybkpTQsx+6vbbF/3ExYbn+YjGxkb29WE
	 z1VfGeBs4KpPuY3EGVSCZ1rScC+eyoShvOPHaaumas2RZfA0+kI3UYxWVcEFzXRU/M
	 RD0j4q//H7JgHPHufFLWUHdbEfrpDqiwimuFJREg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.9 164/197] fs: dont misleadingly warn during thaw operations
Date: Tue,  9 Jul 2024 13:10:18 +0200
Message-ID: <20240709110715.299865586@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 2ae4db5647d807efb6a87c09efaa6d1db9c905d7 upstream.

The block device may have been frozen before it was claimed by a
filesystem. Concurrently another process might try to mount that
frozen block device and has temporarily claimed the block device for
that purpose causing a concurrent fs_bdev_thaw() to end up here. The
mounter is already about to abort mounting because they still saw an
elevanted bdev->bd_fsfreeze_count so get_bdev_super() will return
NULL in that case.

For example, P1 calls dm_suspend() which calls into bdev_freeze() before
the block device has been claimed by the filesystem. This brings
bdev->bd_fsfreeze_count to 1 and no call into fs_bdev_freeze() is
required.

Now P2 tries to mount that frozen block device. It claims it and checks
bdev->bd_fsfreeze_count. As it's elevated it aborts mounting.

In the meantime P3 called dm_resume(). P3 sees that the block device is
already claimed by a filesystem and calls into fs_bdev_thaw().

P3 takes a passive reference and realizes that the filesystem isn't
ready yet. P3 puts itself to sleep to wait for the filesystem to become
ready.

P2 now puts the last active reference to the filesystem and marks it as
dying. P3 gets woken, sees that the filesystem is dying and
get_bdev_super() fails.

Fixes: 49ef8832fb1a ("bdev: implement freeze and thaw holder operations")
Cc: <stable@vger.kernel.org>
Reported-by: Theodore Ts'o <tytso@mit.edu>
Link: https://lore.kernel.org/r/20240611085210.GA1838544@mit.edu
Link: https://lore.kernel.org/r/20240613-lackmantel-einsehen-90f0d727358d@brauner
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/super.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/fs/super.c
+++ b/fs/super.c
@@ -1501,8 +1501,17 @@ static int fs_bdev_thaw(struct block_dev
 
 	lockdep_assert_held(&bdev->bd_fsfreeze_mutex);
 
+	/*
+	 * The block device may have been frozen before it was claimed by a
+	 * filesystem. Concurrently another process might try to mount that
+	 * frozen block device and has temporarily claimed the block device for
+	 * that purpose causing a concurrent fs_bdev_thaw() to end up here. The
+	 * mounter is already about to abort mounting because they still saw an
+	 * elevanted bdev->bd_fsfreeze_count so get_bdev_super() will return
+	 * NULL in that case.
+	 */
 	sb = get_bdev_super(bdev);
-	if (WARN_ON_ONCE(!sb))
+	if (!sb)
 		return -EINVAL;
 
 	if (sb->s_op->thaw_super)


