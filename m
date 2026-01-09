Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55BC735A94B;
	Fri,  9 Jan 2026 12:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961239; cv=none; b=ocq9jgXNLhZDIjezj5aSw5YMsQ+hShtx64tEoBkK5omk14DxkUyTLHT9dWsxtcs1VXzE5bh7MVmFMKP18DtSbTPY6/7CPtSCiS1fquzjPuQfTh2uWjFleRCEKVf1Jaw6aTvRgaKBZkiNN30KKMsnTbANMb6BKp3FcdNFiFZmoJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961239; c=relaxed/simple;
	bh=rpuDW2NWkLk1NcVZ1Oymw9CDQWpKmbMnlKJawW/qSlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+Ewu/wHsG39eJJ7awraKVfQsVRY6GrJ2HUFmiLSrkV36XN2motUNTpO8O7wK/oKoblMySU7+jnYBJrUA1AXKBVDbZnugZtgwBWaPc8HDl24ZJW32XqBqfoH7zQEFEIZJY3FFzfCnyQyY5TMWFEaIRskKdUaPwufXhuQcLCsBDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G6lyu7AI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G6lyu7AI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4765C4CEF1;
	Fri,  9 Jan 2026 12:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961239;
	bh=rpuDW2NWkLk1NcVZ1Oymw9CDQWpKmbMnlKJawW/qSlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G6lyu7AIw9rKKiwKse34FY0mQfHxYkskm2izfhNgPr4t3plDawUfMTv0V4pmM0jgx
	 gGxvsTBNs+x1xuOA/CgmTnuieQedzqxZF+Z3qoRJQ3yQHEX/QFXMiChPaA340JNb5l
	 Z21AO4yBmUzdLt6u3uuYkZragP9OnEuAVS6YtF8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 684/737] f2fs: remove unused GC_FAILURE_PIN
Date: Fri,  9 Jan 2026 12:43:43 +0100
Message-ID: <20260109112159.787235721@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 968c4f72b23c0c8f1e94e942eab89b8c5a3022e7 ]

After commit 3db1de0e582c ("f2fs: change the current atomic write way"),
we removed all GC_FAILURE_ATOMIC usage, let's change i_gc_failures[]
array to i_pin_failure for cleanup.

Meanwhile, let's define i_current_depth and i_gc_failures as union
variable due to they won't be valid at the same time.

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 10b591e7fb7c ("f2fs: fix to avoid updating compression context during writeback")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/f2fs.h     |   14 +++++---------
 fs/f2fs/file.c     |   12 +++++-------
 fs/f2fs/inode.c    |    6 ++----
 fs/f2fs/recovery.c |    3 +--
 4 files changed, 13 insertions(+), 22 deletions(-)

--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -762,11 +762,6 @@ enum {
 
 #define DEF_DIR_LEVEL		0
 
-enum {
-	GC_FAILURE_PIN,
-	MAX_GC_FAILURE
-};
-
 /* used for f2fs_inode_info->flags */
 enum {
 	FI_NEW_INODE,		/* indicate newly allocated inode */
@@ -814,9 +809,10 @@ struct f2fs_inode_info {
 	unsigned long i_flags;		/* keep an inode flags for ioctl */
 	unsigned char i_advise;		/* use to give file attribute hints */
 	unsigned char i_dir_level;	/* use for dentry level for large dir */
-	unsigned int i_current_depth;	/* only for directory depth */
-	/* for gc failure statistic */
-	unsigned int i_gc_failures[MAX_GC_FAILURE];
+	union {
+		unsigned int i_current_depth;	/* only for directory depth */
+		unsigned int i_gc_failures;	/* for gc failure statistic */
+	};
 	unsigned int i_pino;		/* parent inode number */
 	umode_t i_acl_mode;		/* keep file acl mode temporarily */
 
@@ -3173,7 +3169,7 @@ static inline void f2fs_i_depth_write(st
 static inline void f2fs_i_gc_failures_write(struct inode *inode,
 					unsigned int count)
 {
-	F2FS_I(inode)->i_gc_failures[GC_FAILURE_PIN] = count;
+	F2FS_I(inode)->i_gc_failures = count;
 	f2fs_mark_inode_dirty_sync(inode, true);
 }
 
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -3329,13 +3329,11 @@ int f2fs_pin_file_control(struct inode *
 
 	/* Use i_gc_failures for normal file as a risk signal. */
 	if (inc)
-		f2fs_i_gc_failures_write(inode,
-				fi->i_gc_failures[GC_FAILURE_PIN] + 1);
+		f2fs_i_gc_failures_write(inode, fi->i_gc_failures + 1);
 
-	if (fi->i_gc_failures[GC_FAILURE_PIN] > sbi->gc_pin_file_threshold) {
+	if (fi->i_gc_failures > sbi->gc_pin_file_threshold) {
 		f2fs_warn(sbi, "%s: Enable GC = ino %lx after %x GC trials",
-			  __func__, inode->i_ino,
-			  fi->i_gc_failures[GC_FAILURE_PIN]);
+			  __func__, inode->i_ino, fi->i_gc_failures);
 		clear_inode_flag(inode, FI_PIN_FILE);
 		return -EAGAIN;
 	}
@@ -3404,7 +3402,7 @@ static int f2fs_ioc_set_pin_file(struct
 	}
 
 	set_inode_flag(inode, FI_PIN_FILE);
-	ret = F2FS_I(inode)->i_gc_failures[GC_FAILURE_PIN];
+	ret = F2FS_I(inode)->i_gc_failures;
 done:
 	f2fs_update_time(sbi, REQ_TIME);
 out:
@@ -3419,7 +3417,7 @@ static int f2fs_ioc_get_pin_file(struct
 	__u32 pin = 0;
 
 	if (is_inode_flag_set(inode, FI_PIN_FILE))
-		pin = F2FS_I(inode)->i_gc_failures[GC_FAILURE_PIN];
+		pin = F2FS_I(inode)->i_gc_failures;
 	return put_user(pin, (u32 __user *)arg);
 }
 
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -428,8 +428,7 @@ static int do_read_inode(struct inode *i
 	if (S_ISDIR(inode->i_mode))
 		fi->i_current_depth = le32_to_cpu(ri->i_current_depth);
 	else if (S_ISREG(inode->i_mode))
-		fi->i_gc_failures[GC_FAILURE_PIN] =
-					le16_to_cpu(ri->i_gc_failures);
+		fi->i_gc_failures = le16_to_cpu(ri->i_gc_failures);
 	fi->i_xattr_nid = le32_to_cpu(ri->i_xattr_nid);
 	fi->i_flags = le32_to_cpu(ri->i_flags);
 	if (S_ISREG(inode->i_mode))
@@ -691,8 +690,7 @@ void f2fs_update_inode(struct inode *ino
 		ri->i_current_depth =
 			cpu_to_le32(F2FS_I(inode)->i_current_depth);
 	else if (S_ISREG(inode->i_mode))
-		ri->i_gc_failures =
-			cpu_to_le16(F2FS_I(inode)->i_gc_failures[GC_FAILURE_PIN]);
+		ri->i_gc_failures = cpu_to_le16(F2FS_I(inode)->i_gc_failures);
 	ri->i_xattr_nid = cpu_to_le32(F2FS_I(inode)->i_xattr_nid);
 	ri->i_flags = cpu_to_le32(F2FS_I(inode)->i_flags);
 	ri->i_pino = cpu_to_le32(F2FS_I(inode)->i_pino);
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -330,8 +330,7 @@ static int recover_inode(struct inode *i
 	F2FS_I(inode)->i_advise = raw->i_advise;
 	F2FS_I(inode)->i_flags = le32_to_cpu(raw->i_flags);
 	f2fs_set_inode_flags(inode);
-	F2FS_I(inode)->i_gc_failures[GC_FAILURE_PIN] =
-				le16_to_cpu(raw->i_gc_failures);
+	F2FS_I(inode)->i_gc_failures = le16_to_cpu(raw->i_gc_failures);
 
 	recover_inline_flags(inode, raw);
 


