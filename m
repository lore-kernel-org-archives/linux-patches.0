Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B8035208F;
	Tue, 26 Aug 2025 14:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216853; cv=none; b=Xw//L3ks9139loMWx9EK0JKgdGuzEmUR0S5oHz4IYxk4ifCXVy7/MZ9Ujzr5E6Qp5LHoMBaARE6sWNDk22nxUfvVcYl9XaJ4ZHc6iJ5C0GvR47XyC0NHvVV7y9yxA/Yq4uQJf+ch6H1bJdkMd2HBfrLWTCghOnP/2OwTecrJUQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216853; c=relaxed/simple;
	bh=hatN0+Iar9G20AdJcSSmjLdelijMvSra6o9Zfzu1kYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PlstxL6e0ZJZBNQUyUUyP33VoexD4sBBh4sw9J/a9akTEMx0injXKapPqrlfPHFOz5TbGCpOZW1m8XWB3mlZKgIpLbIKpXnWWZWHfWpBczEaglZNklkskJEQeIgnryHCM8tq4OKFeBM6v8csua89hXcUEYQJ9CLMve5hoNMZvSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tZh/7ZyB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tZh/7ZyB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9114C4CEF1;
	Tue, 26 Aug 2025 14:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216853;
	bh=hatN0+Iar9G20AdJcSSmjLdelijMvSra6o9Zfzu1kYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tZh/7ZyBGT3EA01Gpl15YIyQA+tGjd36MS7gZTnOF4G/di8mb882QDsRb4XAcpPxE
	 D7ye/yWIoD8s9RsrxJjeg9Ho+xjeebVASF6+PDYlFvU5dwCDn9tmLZuq04O3TCgKMI
	 DqmKAL6FXYMdtf2wr6oQNQpDuowCYElyLRgA1MXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Scott GUO <scottzhguo@tencent.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 566/644] squashfs: fix memory leak in squashfs_fill_super
Date: Tue, 26 Aug 2025 13:10:57 +0200
Message-ID: <20250826111000.556453712@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -122,10 +122,15 @@ static int squashfs_fill_super(struct su
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
@@ -135,12 +140,7 @@ static int squashfs_fill_super(struct su
 
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


