Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596A6140E3D;
	Thu, 11 Apr 2024 10:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830730; cv=none; b=TrprqOB55QhxCY6avEoZP8chk94Wf14IFnzMDcZefdHCKGOdDynFH2mfna3VU17HOicTpZXDoWpAu4GFYDbPfy5sTD7sOt/WkaDJQmpwQGbKnk+QnE5gsIWnEBW1yYAFeIMEHftFJBGltCLqQU4wQUTl/xCRw+axjQ0758U0S2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830730; c=relaxed/simple;
	bh=UtbJF9Esk7sePNK0YPnoIi/kCqaZLrVE/M8tTPfcrkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dA8XTwMTAXtH9oqJsTt/sx5x430NrbxayvWjxlo/rWjwRcSHE8REOEBYdrI4qPiCEWaVKZK4DU/qn+pZ6AB2Zb6s5dzahMFBgvPWZ7iUHTlByqXzxUymL5GEhxMM2sf16rbhmgydEozp3H+9XxEZej3WPBgpmlDt3DyZGC6f4Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JrZp0GGr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JrZp0GGr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA141C433F1;
	Thu, 11 Apr 2024 10:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830730;
	bh=UtbJF9Esk7sePNK0YPnoIi/kCqaZLrVE/M8tTPfcrkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JrZp0GGrrF8D7YBN73f9l5nDmrx3oIWi6VPpouY6CrV8M6d8kNDpqCME/6MVKENHY
	 Uy2UYiDyD+Eq2eK1pYYLpUhnsCaForuSE3TMG06AEmkdxrlBs0PUeIwBcdn36Db+pb
	 6NDbpxArtjF2sZB8yHpiUlFl+S42Sf88JnEyHME0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Jain <anand.jain@oracle.com>,
	Goldwyn Rodrigues <rgoldwyn@suse.com>,
	David Sterba <dsterba@suse.com>,
	Maximilian Heyne <mheyne@amazon.de>
Subject: [PATCH 5.4 097/215] btrfs: allocate btrfs_ioctl_defrag_range_args on stack
Date: Thu, 11 Apr 2024 11:55:06 +0200
Message-ID: <20240411095427.815637343@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

commit c853a5783ebe123847886d432354931874367292 upstream.

Instead of using kmalloc() to allocate btrfs_ioctl_defrag_range_args,
allocate btrfs_ioctl_defrag_range_args on stack, the size is reasonably
small and ioctls are called in process context.

sizeof(btrfs_ioctl_defrag_range_args) = 48

Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[ This patch is needed to fix a memory leak of "range" that was
introduced when commit 173431b274a9 ("btrfs: defrag: reject unknown
flags of btrfs_ioctl_defrag_range_args") was backported to kernels
lacking this patch. Now with these two patches applied in reverse order,
range->flags needed to change back to range.flags.
This bug was discovered and resolved using Coverity Static Analysis
Security Testing (SAST) by Synopsys, Inc.]
Signed-off-by: Maximilian Heyne <mheyne@amazon.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |   25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3057,7 +3057,7 @@ static int btrfs_ioctl_defrag(struct fil
 {
 	struct inode *inode = file_inode(file);
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct btrfs_ioctl_defrag_range_args *range;
+	struct btrfs_ioctl_defrag_range_args range = {0};
 	int ret;
 
 	ret = mnt_want_write_file(file);
@@ -3089,37 +3089,28 @@ static int btrfs_ioctl_defrag(struct fil
 			goto out;
 		}
 
-		range = kzalloc(sizeof(*range), GFP_KERNEL);
-		if (!range) {
-			ret = -ENOMEM;
-			goto out;
-		}
-
 		if (argp) {
-			if (copy_from_user(range, argp,
-					   sizeof(*range))) {
+			if (copy_from_user(&range, argp, sizeof(range))) {
 				ret = -EFAULT;
-				kfree(range);
 				goto out;
 			}
-			if (range->flags & ~BTRFS_DEFRAG_RANGE_FLAGS_SUPP) {
+			if (range.flags & ~BTRFS_DEFRAG_RANGE_FLAGS_SUPP) {
 				ret = -EOPNOTSUPP;
 				goto out;
 			}
 			/* compression requires us to start the IO */
-			if ((range->flags & BTRFS_DEFRAG_RANGE_COMPRESS)) {
-				range->flags |= BTRFS_DEFRAG_RANGE_START_IO;
-				range->extent_thresh = (u32)-1;
+			if ((range.flags & BTRFS_DEFRAG_RANGE_COMPRESS)) {
+				range.flags |= BTRFS_DEFRAG_RANGE_START_IO;
+				range.extent_thresh = (u32)-1;
 			}
 		} else {
 			/* the rest are all set to zero by kzalloc */
-			range->len = (u64)-1;
+			range.len = (u64)-1;
 		}
 		ret = btrfs_defrag_file(file_inode(file), file,
-					range, BTRFS_OLDEST_GENERATION, 0);
+					&range, BTRFS_OLDEST_GENERATION, 0);
 		if (ret > 0)
 			ret = 0;
-		kfree(range);
 		break;
 	default:
 		ret = -EINVAL;


