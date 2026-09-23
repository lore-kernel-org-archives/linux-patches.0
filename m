Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F5D5326B7;
	Wed, 23 Sep 2026 14:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173559; cv=none; b=Bkgxu+qwzfGosdeSK61A0SG3ARp4+BfGgA/HWss3q9N/4l7Xry/5AIJsjL80NlTi6F84mGPLgQw0rxtvbVWbLG79c6vv8m+Y5jyRm7HsSz53wBcyz0/Gm+PHC1V1HjfdVSbck2R3ThtzpZnQjiL6VpQ4Sz7mFOSJjjCvSnUm/Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173559; c=relaxed/simple;
	bh=FSgug/RHFZHrxPYNblR2Yf5V6Jjy17h3EpmJpHMnveA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ys+QGcN/n0cpZ9jhr9SUiLCVf7Aaw9rMr0Hyrs9G2yxUHAGhIvLAPCTmF0CsCoaKOvWL2JG1J4Ahk54g9x2bOuYRWw6QRF9p/Qa50OloYvM3YZCmnLRghWuyHS/fMIQhCy8t8331MD7RgaNLpDV0eG3xG0u09kTflhYkpecbPTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dxrJjGKI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dxrJjGKI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B8201F000FF;
	Wed, 23 Sep 2026 14:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173557;
	bh=2gZZYEf782Bm9rfA555RvBWWAdQZX8bUgfbQJ0NXsN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dxrJjGKIqYCioK/pRGpjriZsReOgxb8kkCJhfq5MW0CAwzHU0Ls/vgqRr2MMwFbuX
	 5uCQydvWdhS5hYVoejdK4BCDvhi1EyTryUeAQ8Tgpj8B+dBItHBz4xlb5KdgtlAro6
	 aLJQV/MCCciBURE8CyvyDuBJ/sQxbRNI/b2DzFhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@intel.com>,
	Anand Jain <asj@kernel.org>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 7.2 284/438] btrfs: derive f_fsid with dev_t only when temp_fsid is active
Date: Wed, 23 Sep 2026 16:05:05 +0200
Message-ID: <20260923140652.134540027@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anand Jain <asj@kernel.org>

commit 72de4807ba84da485dda1a91572d66da9149e95a upstream.

Commit c2a74ed0494c ("btrfs: derive f_fsid from on-disk fsid and dev_t")
mixed dev_t into f_fsid for all single-device setups to avoid f_fsid
collisions with cloned filesystems.

However, doing this unconditionally breaks backward compatibility.
statfs(2) f_fsid changes after a kernel upgrade, and also can shift
across reboots or dev re-attaches as dev_t values change.

Fix this by only mixing dev_t when temp_fsid is active.  This means for
non-temp_fsid setups or the original mount, we use the old method of
deriving fsid based on the UUID.

So in the case of a cloned Btrfs filesystem, we won't be able to
maintain the same fsid across mount recycle if the mount order changes.

Reported-by: Dave Hansen <dave.hansen@intel.com>
Link: https://lore.kernel.org/linux-btrfs/be0c08f5-2f31-40f5-8a3b-f2f58b3e00ff@intel.com
Fixes: c2a74ed0494c ("btrfs: derive f_fsid from on-disk fsid and dev_t")
CC: stable@vger.kernel.org # 7.2
Signed-off-by: Anand Jain <asj@kernel.org>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/super.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1845,8 +1845,12 @@ static int btrfs_statfs(struct dentry *d
 	f_fsid.val[0] ^= btrfs_root_id(BTRFS_I(d_inode(dentry))->root) >> 32;
 	f_fsid.val[1] ^= btrfs_root_id(BTRFS_I(d_inode(dentry))->root);
 
-	/* Hash dev_t to avoid f_fsid collision with cloned filesystems. */
-	if (fs_info->fs_devices->total_devices == 1) {
+	/*
+	 * Hash dev_t to avoid f_fsid collisions with cloned filesystems.
+	 * Only do this when a clone is present so the original filesystem
+	 * (mounted first) maintains backward-compatible f_fsid behavior.
+	 */
+	if (fs_info->fs_devices->temp_fsid) {
 		__kernel_fsid_t dev_fsid =
 			u64_to_fsid(huge_encode_dev(fs_info->fs_devices->latest_dev->bdev->bd_dev));
 


