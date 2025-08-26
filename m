Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BDF635CEB9;
	Tue, 26 Aug 2025 14:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219248; cv=none; b=Ex8hzRC/pnOtR6//8mrgIVpJ7Rb1aYv2bt6QWhFFwseyvOb5DitW3TdH+INwq7+wU0eP3zXsAd1XY33FgTehadoXiH8u0VsSobsPsrQxf2x3M9dE/zLnh2wZ3T+I9NseSNjYJ5o15m1uVN0Q6ZwBbqUmAOMEwkRMD2r9nUMx/rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219248; c=relaxed/simple;
	bh=AUkjyWrCuzcmpZ/6aUAxNfbTvyj1w+dOrVdcbpYei0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VxjO6Pqhzz3fz+LJloB0RP15pyl0cakHGFOn7hoyj5HX2a5+SVCUZxRl3ZzyWi8hCRmuvQEai320bO/jv5gBDobfL9EOvlJu5SRh/JonqAhKXT/4JF3zsIbX0nAyNCwXSGZoLeBm/68G0N+GIXEXoK3RcfUs2fKakZ9i4vEBq54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yv08jTk0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yv08jTk0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1D15C4CEF1;
	Tue, 26 Aug 2025 14:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219248;
	bh=AUkjyWrCuzcmpZ/6aUAxNfbTvyj1w+dOrVdcbpYei0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yv08jTk0aXdOE4ZJ+b4PpxgwQf8jo7LKRmICnL4LtKtlYKtDIuD/s+Zf501659F2V
	 F4Q3UdHZQ50mY8C1Uolb1Fw8eX8PMkLfB2iH5sXIOXS/gIUsZGrlKVhUJEccDnFlmG
	 Mvh/IrI1mswCCPQCvGMzWrn6zpKmizqNdmskVPNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Scott GUO <scottzhguo@tencent.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.4 309/403] squashfs: fix memory leak in squashfs_fill_super
Date: Tue, 26 Aug 2025 13:10:35 +0200
Message-ID: <20250826110915.349104423@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -74,10 +74,15 @@ static int squashfs_fill_super(struct su
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
@@ -85,12 +90,7 @@ static int squashfs_fill_super(struct su
 	}
 	msblk = sb->s_fs_info;
 
-	msblk->devblksize = sb_min_blocksize(sb, SQUASHFS_DEVBLK_SIZE);
-	if (!msblk->devblksize) {
-		errorf(fc, "squashfs: unable to set blocksize\n");
-		return -EINVAL;
-	}
-
+	msblk->devblksize = devblksize;
 	msblk->devblksize_log2 = ffz(~msblk->devblksize);
 
 	mutex_init(&msblk->meta_index_mutex);


