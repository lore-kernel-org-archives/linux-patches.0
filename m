Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC56273D6D;
	Tue,  2 Sep 2025 13:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819405; cv=none; b=qT7ITfFE80rolMKbOBvh/SZ1SOin0MkunvsjuS1A2Z+c53wi+dUK5+0C9E9EHHTjTCA99N3xhlnD570gdbXnQ+CJl74zFatv+PiwCg4z601wSOWAxwQ8JXVLNR5yIO4oAJaAyyygzFzi75qMArvbCPRt8XoTCx9pxHPkuE0LvOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819405; c=relaxed/simple;
	bh=KmkTBbTqJB5qGLsrijsJFeYEQiUJeAg09pdlnDWDw7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBHGWlNiqp/dU/Bqnhy0DzhViJQvOljDRY7cUflVIKPvPbWfwPjpz5qtlHjKTvPBZym4Pmr5n5WITDWaQ5Ogq4rt0VzcSWN06Xl9btRUKX0UmMzvx5EajXiToJbyYSd0a1DTqCTPi21Zp2x6Ker/u4E2WsgHFuF5JgoZIVTSbr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vs6haP+c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vs6haP+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62B4C4CEED;
	Tue,  2 Sep 2025 13:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819402;
	bh=KmkTBbTqJB5qGLsrijsJFeYEQiUJeAg09pdlnDWDw7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vs6haP+c7wggiCxx4iUYHXt6tLi+DiX6GscVBqKpUIgipd+eYABamR8e57uRBmLWC
	 rPzlQZXotmnTNh1bxF89w4bp4ACQwFk1eClYgck3i/XC3g6xJvjUIj//dTIGZe0vYC
	 YjX6i0X5I4e9b75wNka0yA6/GSLRRKP5cgF2EHlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Friendy Su <friendy.su@sony.com>,
	Jacky Cao <jacky.cao@sony.com>,
	Daniel Palmer <daniel.palmer@sony.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 023/142] erofs: Fallback to normal access if DAX is not supported on extra device
Date: Tue,  2 Sep 2025 15:18:45 +0200
Message-ID: <20250902131949.034274321@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

[ Upstream commit c6993c4cb91803fceb82d6b5e0ec5e0aec2d0ad6 ]

If using multiple devices, we should check if the extra device support
DAX instead of checking the primary device when deciding if to use DAX
to access a file.

If an extra device does not support DAX we should fallback to normal
access otherwise the data on that device will be inaccessible.

Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Reviewed-by: Friendy Su <friendy.su@sony.com>
Reviewed-by: Jacky Cao <jacky.cao@sony.com>
Reviewed-by: Daniel Palmer <daniel.palmer@sony.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Hongbo Li <lihongbo22@huawei.com>
Link: https://lore.kernel.org/r/20250804082030.3667257-2-Yuezhang.Mo@sony.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/super.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 799fef437aa8e..cad87e4d66943 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -174,6 +174,11 @@ static int erofs_init_device(struct erofs_buf *buf, struct super_block *sb,
 		if (!erofs_is_fileio_mode(sbi)) {
 			dif->dax_dev = fs_dax_get_by_bdev(file_bdev(file),
 					&dif->dax_part_off, NULL, NULL);
+			if (!dif->dax_dev && test_opt(&sbi->opt, DAX_ALWAYS)) {
+				erofs_info(sb, "DAX unsupported by %s. Turning off DAX.",
+					   dif->path);
+				clear_opt(&sbi->opt, DAX_ALWAYS);
+			}
 		} else if (!S_ISREG(file_inode(file)->i_mode)) {
 			fput(file);
 			return -EINVAL;
@@ -210,8 +215,13 @@ static int erofs_scan_devices(struct super_block *sb,
 			  ondisk_extradevs, sbi->devs->extra_devices);
 		return -EINVAL;
 	}
-	if (!ondisk_extradevs)
+	if (!ondisk_extradevs) {
+		if (test_opt(&sbi->opt, DAX_ALWAYS) && !sbi->dif0.dax_dev) {
+			erofs_info(sb, "DAX unsupported by block device. Turning off DAX.");
+			clear_opt(&sbi->opt, DAX_ALWAYS);
+		}
 		return 0;
+	}
 
 	if (!sbi->devs->extra_devices && !erofs_is_fscache_mode(sb))
 		sbi->devs->flatdev = true;
@@ -330,7 +340,6 @@ static int erofs_read_superblock(struct super_block *sb)
 	if (ret < 0)
 		goto out;
 
-	/* handle multiple devices */
 	ret = erofs_scan_devices(sb, dsb);
 
 	if (erofs_sb_has_48bit(sbi))
@@ -661,14 +670,9 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
 			return invalfc(fc, "cannot use fsoffset in fscache mode");
 	}
 
-	if (test_opt(&sbi->opt, DAX_ALWAYS)) {
-		if (!sbi->dif0.dax_dev) {
-			errorfc(fc, "DAX unsupported by block device. Turning off DAX.");
-			clear_opt(&sbi->opt, DAX_ALWAYS);
-		} else if (sbi->blkszbits != PAGE_SHIFT) {
-			errorfc(fc, "unsupported blocksize for DAX");
-			clear_opt(&sbi->opt, DAX_ALWAYS);
-		}
+	if (test_opt(&sbi->opt, DAX_ALWAYS) && sbi->blkszbits != PAGE_SHIFT) {
+		erofs_info(sb, "unsupported blocksize for DAX");
+		clear_opt(&sbi->opt, DAX_ALWAYS);
 	}
 
 	sb->s_time_gran = 1;
-- 
2.50.1



