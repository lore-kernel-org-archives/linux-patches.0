Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B379018F2FC;
	Tue, 26 Aug 2025 13:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213877; cv=none; b=uxyML9BikJnPI5HK81DXabikqD2gdMJxS1468gsy8GFECPtiM9+n6H3kc6X8zocQF/OUmDlsGycf3Qzm+bjAYSIbqxZ0XuHvdDbFUxois9scxCbf5gLU0zReevM61PcDXUehPXJIi1oJeGzECdCehqLtkbGTPuzZeUg+qIBxbkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213877; c=relaxed/simple;
	bh=nRxttC8r5Rzg9vH1XkZv7NnhqvkPCCxz1/gmVk2UxUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ph25ig3ANkQrq98t85S02XQlQ9gYZiSwQLwpA/amv5LxwkjwblGWooF5zEWIn+k4UTFQo+8bgS9gb3unn/ErNj9tneHAL8194bbt3vga/6NoXydVFCHRdjKHyWXmzcE+paT5o5MjA4rJIVTw1VPbr0BZ1UZn9lYDjOPc/reEqaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IB1J7pwB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IB1J7pwB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 382FCC4CEF1;
	Tue, 26 Aug 2025 13:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213877;
	bh=nRxttC8r5Rzg9vH1XkZv7NnhqvkPCCxz1/gmVk2UxUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IB1J7pwBOz7dUzSmyTh8NkydyZp/VzbPv0o4yszqLoLShL7Wt4vuoRanH9z1njBHk
	 dsMidqPdHnywm8e1B6c3/lrZeuseuIz5vmT/cxNFLZw0kTJ29NcJ66phhjKz0yWiyj
	 ZIlkI5axeHQD2ovgSflpUtq7ge8YG7Mgyl+CXnZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Scott GUO <scottzhguo@tencent.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 482/587] squashfs: fix memory leak in squashfs_fill_super
Date: Tue, 26 Aug 2025 13:10:31 +0200
Message-ID: <20250826111005.235399634@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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


