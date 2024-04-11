Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060DE149E10;
	Thu, 11 Apr 2024 10:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831824; cv=none; b=c9YF/tEZKXqxrhzK6LaJGA9vazKXJxlNNeQtdohQ/gDHcfyNG4nqE9nQjx0gX6K+UfF9ciByelL/1wDMy/sqQMf5ubDDC13hi0zTWjMXH5zQBkPNa+jpbIEUAQtPFAJ9necaG0KBXJrfDenuIUx/+24blppWkMw9Z4Q9dL/jB2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831824; c=relaxed/simple;
	bh=apl9hV3l8GLwtYF4wuY1SrtUhLn4WMotOgmwGImkHDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BNfdkSa+zay7IZwRVdn2kYgKuTkHCP0PGDTS39mQTdABX3tKJvT0hSbaZ0skvGoYVzl+z/4YSdN1Gvr8SABQvflQR6uCEuivbtvsYzYTYguJYF4Ot+sGHxeBAX0O5K8xAXbkn8EBd3bYyPbkiSwy3dsxG2ixPi2b9diOV0JpnOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FJgpFcDg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FJgpFcDg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811C7C433C7;
	Thu, 11 Apr 2024 10:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831823;
	bh=apl9hV3l8GLwtYF4wuY1SrtUhLn4WMotOgmwGImkHDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FJgpFcDgF5u2YnZhd9ksYpVhkv9+mLlsOcGFvd4UPv7BpaVusYMPhLsjq3QV0YfKS
	 eRiGv0jN/WmEJcV/MHDbrHvSc8NPl9zxup+cdZkBlIeDFTu1MOQ0sAT4fz0QsyPxzt
	 P1ETg8WKgswKcPi1osrkqaESypbR31f8aUk5Fqvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Jain <anand.jain@oracle.com>,
	Goldwyn Rodrigues <rgoldwyn@suse.com>,
	David Sterba <dsterba@suse.com>,
	Maximilian Heyne <mheyne@amazon.de>
Subject: [PATCH 5.10 137/294] btrfs: allocate btrfs_ioctl_defrag_range_args on stack
Date: Thu, 11 Apr 2024 11:55:00 +0200
Message-ID: <20240411095439.778563481@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3148,7 +3148,7 @@ static int btrfs_ioctl_defrag(struct fil
 {
 	struct inode *inode = file_inode(file);
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct btrfs_ioctl_defrag_range_args *range;
+	struct btrfs_ioctl_defrag_range_args range = {0};
 	int ret;
 
 	ret = mnt_want_write_file(file);
@@ -3180,37 +3180,28 @@ static int btrfs_ioctl_defrag(struct fil
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


