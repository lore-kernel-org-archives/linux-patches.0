Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD51A250C0C;
	Tue, 29 Apr 2025 17:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949274; cv=none; b=c36+Df6iFi3h2WCu9LLApktnve8Go3AUkRTuHKBW37Uocc5duN+51KF5DpPesOvH9Jzz8PMWWMC3CASSNIOagBcQKsgXi49JavDSk0lpzvoEhlWisQN4sm/Ak8hob9AQHo95ozX1+hPm/T6bLa6VIAHlMFE1Zp0k/HA4LT4+Ao4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949274; c=relaxed/simple;
	bh=nKNVZd3rBOtYMoShXaJHSVL9NZ3LiBCMHE68hO2xJCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+ZmzpW4uDXcOxwjIVarErgFmuSKxh3H0FN/tCY+pZl9JLWDcEPSU0Vj9iQe0LirHckbQDmVjX7sC+LuLHWs/qUma+DAHVjBoC2Bd92pBCFgGVzqcJHqaLhsETbT24Y0jUe18ok7xykdwdWQJV9URrJa2GQhBJYOespNhrWR/iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jat9IhYI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jat9IhYI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33222C4CEE3;
	Tue, 29 Apr 2025 17:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949274;
	bh=nKNVZd3rBOtYMoShXaJHSVL9NZ3LiBCMHE68hO2xJCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jat9IhYIg3392/pGDzksSqCaHIQNZNzzHWxPP6TDbs+5AUu4OdcMQgYlht1Jx+o2O
	 K2eCYd/2CHx9/XTT4dBaG8ucEoqzKIDRtuQYzavZdmBe6ZTem8351+5SHHa19q3H9y
	 pR1TnZ6wAPOElJhzrdJLuTM0fJoBWigmKrHvgMuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Cliff Liu <donghua.liu@windriver.com>,
	He Zhe <Zhe.He@windriver.com>
Subject: [PATCH 5.15 249/373] f2fs: check validation of fault attrs in f2fs_build_fault_attr()
Date: Tue, 29 Apr 2025 18:42:06 +0200
Message-ID: <20250429161133.366159417@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

commit 4ed886b187f47447ad559619c48c086f432d2b77 upstream.

- It missed to check validation of fault attrs in parse_options(),
let's fix to add check condition in f2fs_build_fault_attr().
- Use f2fs_build_fault_attr() in __sbi_store() to clean up code.

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Cliff Liu <donghua.liu@windriver.com>
Signed-off-by: He Zhe <Zhe.He@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/f2fs.h  |   12 ++++++++----
 fs/f2fs/super.c |   27 ++++++++++++++++++++-------
 fs/f2fs/sysfs.c |   14 ++++++++++----
 3 files changed, 38 insertions(+), 15 deletions(-)

--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -64,7 +64,7 @@ enum {
 
 struct f2fs_fault_info {
 	atomic_t inject_ops;
-	unsigned int inject_rate;
+	int inject_rate;
 	unsigned int inject_type;
 };
 
@@ -4373,10 +4373,14 @@ static inline bool f2fs_need_verity(cons
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
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -61,21 +61,31 @@ const char *f2fs_fault_name[FAULT_MAX] =
 	[FAULT_DQUOT_INIT]	= "dquot initialize",
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
 
@@ -901,14 +911,17 @@ static int parse_options(struct super_bl
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
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -407,10 +407,16 @@ out:
 	if (ret < 0)
 		return ret;
 #ifdef CONFIG_F2FS_FAULT_INJECTION
-	if (a->struct_type == FAULT_INFO_TYPE && t >= (1 << FAULT_MAX))
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


