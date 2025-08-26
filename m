Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08391D5CD4;
	Tue, 26 Aug 2025 14:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218104; cv=none; b=BCaGjyWO2hPirn8x+PX5X8BACPo+z4dhfS56iCuEw256PFA5ccNiJrCwkimXUM5zMTjESLPKqEsmkL4B/n4etL18nAX3bz1w7/kbFHnOHkQRdIq/7Y0spG3A9wmboUcQzvx0lNW2t56M7ags8X/5PuSPyKs/HGBnuskzH7QxrxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218104; c=relaxed/simple;
	bh=ZeuyGh6RoW66I10tJIJwDpg3qqfIZTm92/4xKanh2jM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hI6tQWmaCFLRO2DOOqycdcTSAVPa8HA/deQwbP+HHc5FPvJuqO/nXNGucfHtQz4hlYuI7kWbLX172HfJ39cnJ7ByTaA+uQPq42RoQiKI0L7lU+wf0a3TRrT7dW1XxWB7dJ4u341rre+8IM9ouVCf8ny6H/0X8sA4RX4Hucb7mgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nK9Pqxnc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nK9Pqxnc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800F9C16AAE;
	Tue, 26 Aug 2025 14:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218103;
	bh=ZeuyGh6RoW66I10tJIJwDpg3qqfIZTm92/4xKanh2jM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nK9PqxnciJkTa6HrFhS2hwTEVuXV5ZF/rzsKkxy3PChkN7LfJhTH3Nsrkaf8OCibx
	 3Vg5cHrCav4wweufZvJqSnQNHWIHWfv5nv7GHcTuSPwXZnCluj94wOdkmlu3O8TZvB
	 rFJyzlfQq9MZsPtm9GB24PC6VioI6VJWVqO/tZxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Scott GUO <scottzhguo@tencent.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 394/523] squashfs: fix memory leak in squashfs_fill_super
Date: Tue, 26 Aug 2025 13:10:04 +0200
Message-ID: <20250826110934.179320792@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


