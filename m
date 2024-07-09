Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0253A27713;
	Tue,  9 Jul 2024 11:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524592; cv=none; b=d0RVdANIFp+kzYajdcEz4IM5V9qXAJRJG12SI4jlNfPC7skNwVjeAYBzfujxF7pXzwF+087fg0MB6Ldn3M00QhYY+vpqwOEHDDpd0u4MkKqQSEEh2JMu2eCABA/mK/MMsfE+h8q1djzgjDlTHmWOVaro0fzcBKe0Og8XP95JdVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524592; c=relaxed/simple;
	bh=MF3izCBxRj2KypKSPML9okDfke+c/Ed1QUb7gPdvGhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mi4zK0dMUVO8qL7eV8wq4fWT9rvV1XRzQgFW+6Pdpw/KDpBfr5+ALltY15ixmX8Idcgj6fA+77kGJGeoSiUx82jm+Qf5zRpXHnmZcKvNDQUNauuqTSxBWuFRXEbl8TOum9lvXFlbuFXYc6yx3Eu+GJv7AeuaqO/0IHnIF3N9+Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vQSh6Ulf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vQSh6Ulf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A592C3277B;
	Tue,  9 Jul 2024 11:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524591;
	bh=MF3izCBxRj2KypKSPML9okDfke+c/Ed1QUb7gPdvGhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vQSh6Ulfl8TbCStNTuiLEjhMS58Ls3l+4ZgOV1Quqw/kYsIwMRQvVBmR92iaBVBWq
	 PTOpoiPedL9SCUeya3DZegTjFiXzS4FHSnSk+3prQpqgUH0sGCMB8VP67IqdGqfQ/E
	 7vDBeYDPDn7HibeMFmMMyzNO9yJOVhtgcGnqGxZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 035/102] f2fs: check validation of fault attrs in f2fs_build_fault_attr()
Date: Tue,  9 Jul 2024 13:09:58 +0200
Message-ID: <20240709110652.739656674@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 4ed886b187f47447ad559619c48c086f432d2b77 ]

- It missed to check validation of fault attrs in parse_options(),
let's fix to add check condition in f2fs_build_fault_attr().
- Use f2fs_build_fault_attr() in __sbi_store() to clean up code.

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h  | 12 ++++++++----
 fs/f2fs/super.c | 27 ++++++++++++++++++++-------
 fs/f2fs/sysfs.c | 14 ++++++++++----
 3 files changed, 38 insertions(+), 15 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index b54d681c6457d..a1dc08f007dbe 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -68,7 +68,7 @@ enum {
 
 struct f2fs_fault_info {
 	atomic_t inject_ops;
-	unsigned int inject_rate;
+	int inject_rate;
 	unsigned int inject_type;
 };
 
@@ -4530,10 +4530,14 @@ static inline bool f2fs_need_verity(const struct inode *inode, pgoff_t idx)
 }
 
 #ifdef CONFIG_F2FS_FAULT_INJECTION
-extern void f2fs_build_fault_attr(struct f2fs_sb_info *sbi, unsigned int rate,
-							unsigned int type);
+extern int f2fs_build_fault_attr(struct f2fs_sb_info *sbi, unsigned long rate,
+							unsigned long type);
 #else
-#define f2fs_build_fault_attr(sbi, rate, type)		do { } while (0)
+static int f2fs_build_fault_attr(struct f2fs_sb_info *sbi, unsigned long rate,
+							unsigned long type)
+{
+	return 0;
+}
 #endif
 
 static inline bool is_journalled_quota(struct f2fs_sb_info *sbi)
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index f496622921843..6bd8c231069ad 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -63,21 +63,31 @@ const char *f2fs_fault_name[FAULT_MAX] = {
 	[FAULT_LOCK_OP]		= "lock_op",
 };
 
-void f2fs_build_fault_attr(struct f2fs_sb_info *sbi, unsigned int rate,
-							unsigned int type)
+int f2fs_build_fault_attr(struct f2fs_sb_info *sbi, unsigned long rate,
+							unsigned long type)
 {
 	struct f2fs_fault_info *ffi = &F2FS_OPTION(sbi).fault_info;
 
 	if (rate) {
+		if (rate > INT_MAX)
+			return -EINVAL;
 		atomic_set(&ffi->inject_ops, 0);
-		ffi->inject_rate = rate;
+		ffi->inject_rate = (int)rate;
 	}
 
-	if (type)
-		ffi->inject_type = type;
+	if (type) {
+		if (type >= BIT(FAULT_MAX))
+			return -EINVAL;
+		ffi->inject_type = (unsigned int)type;
+	}
 
 	if (!rate && !type)
 		memset(ffi, 0, sizeof(struct f2fs_fault_info));
+	else
+		f2fs_info(sbi,
+			"build fault injection attr: rate: %lu, type: 0x%lx",
+								rate, type);
+	return 0;
 }
 #endif
 
@@ -916,14 +926,17 @@ static int parse_options(struct super_block *sb, char *options, bool is_remount)
 		case Opt_fault_injection:
 			if (args->from && match_int(args, &arg))
 				return -EINVAL;
-			f2fs_build_fault_attr(sbi, arg, F2FS_ALL_FAULT_TYPE);
+			if (f2fs_build_fault_attr(sbi, arg,
+					F2FS_ALL_FAULT_TYPE))
+				return -EINVAL;
 			set_opt(sbi, FAULT_INJECTION);
 			break;
 
 		case Opt_fault_type:
 			if (args->from && match_int(args, &arg))
 				return -EINVAL;
-			f2fs_build_fault_attr(sbi, 0, arg);
+			if (f2fs_build_fault_attr(sbi, 0, arg))
+				return -EINVAL;
 			set_opt(sbi, FAULT_INJECTION);
 			break;
 #else
diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
index 751a108e612ff..06d5791afe90e 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -451,10 +451,16 @@ static ssize_t __sbi_store(struct f2fs_attr *a,
 	if (ret < 0)
 		return ret;
 #ifdef CONFIG_F2FS_FAULT_INJECTION
-	if (a->struct_type == FAULT_INFO_TYPE && t >= BIT(FAULT_MAX))
-		return -EINVAL;
-	if (a->struct_type == FAULT_INFO_RATE && t >= UINT_MAX)
-		return -EINVAL;
+	if (a->struct_type == FAULT_INFO_TYPE) {
+		if (f2fs_build_fault_attr(sbi, 0, t))
+			return -EINVAL;
+		return count;
+	}
+	if (a->struct_type == FAULT_INFO_RATE) {
+		if (f2fs_build_fault_attr(sbi, t, 0))
+			return -EINVAL;
+		return count;
+	}
 #endif
 	if (a->struct_type == RESERVED_BLOCKS) {
 		spin_lock(&sbi->stat_lock);
-- 
2.43.0



