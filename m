Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8D7393DD1;
	Tue, 26 Aug 2025 11:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208699; cv=none; b=YnGq93TvmbMV+4+0G1Sxiis/YYYTnx2CbcA78dWNRLYiT68kMZ/YGmDASPOW3z8H+p5Lg3FAAh6kIeCA7jJqkfZNEeUwqqFF9jPCOha/xnAr8TdEIlyylKlOfdXt3+aDG+nAAfuD/sfUC+inNOMZV6n0T95FKrRlj5s56wXORiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208699; c=relaxed/simple;
	bh=gP3GJgvwMM1tyQNcKNqmElsYgz+kLiaSyt4JXc2RA74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vAHZvj5OThQzBHD30EcVNkzIRjRH0bbWLA2Fv/eiO9JTjVc6vwaK6ER0dqIRnzIINRPISGW1UsumkhSz2NM/v4jBU/Run2gUG8OvWXlZt0mNVY1U2eCCjbQlMCRfiolnYgDInZUS4J0KoWYh6SkLX3ctRlVoLjr/QZph5lwX3xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qvJd1v9f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qvJd1v9f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E706AC4CEF1;
	Tue, 26 Aug 2025 11:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208699;
	bh=gP3GJgvwMM1tyQNcKNqmElsYgz+kLiaSyt4JXc2RA74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qvJd1v9fi1WCYV48O2Osz8Shy7zzpjJH65mDN0WC+hVLo//3N9xsTCVMrUZH5KFbR
	 jDw1R5RPwF8tOfoPVtrbnX5eBiu+7o1L7hMdP0T6mgXstf9PVo+9bNwrQxsyU3NJ+x
	 EK8Pug4Gl6mjj1TzoB5JA1DhciD0G0qSDEdKUUnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Scott GUO <scottzhguo@tencent.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 171/322] squashfs: fix memory leak in squashfs_fill_super
Date: Tue, 26 Aug 2025 13:09:46 +0200
Message-ID: <20250826110920.075331258@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phillip Lougher <phillip@squashfs.org.uk>

commit b64700d41bdc4e9f82f1346c15a3678ebb91a89c upstream.

If sb_min_blocksize returns 0, squashfs_fill_super exits without freeing
allocated memory (sb->s_fs_info).

Fix this by moving the call to sb_min_blocksize to before memory is
allocated.

Link: https://lkml.kernel.org/r/20250811223740.110392-1-phillip@squashfs.org.uk
Fixes: 734aa85390ea ("Squashfs: check return result of sb_min_blocksize")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Reported-by: Scott GUO <scottzhguo@tencent.com>
Closes: https://lore.kernel.org/all/20250811061921.3807353-1-scott_gzh@163.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/squashfs/super.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -187,10 +187,15 @@ static int squashfs_fill_super(struct su
 	unsigned short flags;
 	unsigned int fragments;
 	u64 lookup_table_start, xattr_id_table_start, next_table;
-	int err;
+	int err, devblksize = sb_min_blocksize(sb, SQUASHFS_DEVBLK_SIZE);
 
 	TRACE("Entered squashfs_fill_superblock\n");
 
+	if (!devblksize) {
+		errorf(fc, "squashfs: unable to set blocksize\n");
+		return -EINVAL;
+	}
+
 	sb->s_fs_info = kzalloc(sizeof(*msblk), GFP_KERNEL);
 	if (sb->s_fs_info == NULL) {
 		ERROR("Failed to allocate squashfs_sb_info\n");
@@ -201,12 +206,7 @@ static int squashfs_fill_super(struct su
 
 	msblk->panic_on_errors = (opts->errors == Opt_errors_panic);
 
-	msblk->devblksize = sb_min_blocksize(sb, SQUASHFS_DEVBLK_SIZE);
-	if (!msblk->devblksize) {
-		errorf(fc, "squashfs: unable to set blocksize\n");
-		return -EINVAL;
-	}
-
+	msblk->devblksize = devblksize;
 	msblk->devblksize_log2 = ffz(~msblk->devblksize);
 
 	mutex_init(&msblk->meta_index_mutex);


