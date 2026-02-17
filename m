Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F62D261B70;
	Tue, 17 Feb 2026 20:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361538; cv=none; b=Dd5Gw+X0+tnebBpYnaFX+UUBhPakCKG6ZwPgJr7O1bfoGzFIL5KP6O7jBgjDkG3SiSNRKZA9+CPt3ts70PitL6mPMWdIDOoi4ptqKXwCRpNya8jEmw2oKipA7XzkMw0u/B2IM6/virZQ31GrtbH05HuGt27Ive4BsFZyH6v3Uc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361538; c=relaxed/simple;
	bh=VuMPb1TVjjlfj6Wb4nNSSUbDVLvhy6nJXEoArd+xE6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZNpctr2GTa09xHCy8aq7DgS7//jpCdA5fMSOBTuV1Na/WqVQGCC1O9vA9D/19ZI/+0wqEQwlHReCHrpTO+ew3HCleHci9dy9+ygrnY4YNjpTmyfYwBNMog9OFHBOR4gUWoLmceF84Bx4QbHDloC95MNdq5a1LLY6lH0a+E/z9RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pWmHXpAf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pWmHXpAf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3399C4CEF7;
	Tue, 17 Feb 2026 20:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361538;
	bh=VuMPb1TVjjlfj6Wb4nNSSUbDVLvhy6nJXEoArd+xE6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pWmHXpAfb3TSIICW4OSocr+gxVq81tkrZrHThO4bd2YBisiBxsiqgYkqoZ5A4qB/8
	 JgzD5tSt6Xxtdj6L5KcpvgtVJy5vtr6jzb15vB0CWRassAJAxL+g2Nxdc7crFPkKPm
	 MMDvtGBqU8C9R29ejQbUWc8VJEEvxE3TazFHf3vY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jinbao Liu <liujinbao1@xiaomi.com>,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.18 35/43] f2fs: fix out-of-bounds access in sysfs attribute read/write
Date: Tue, 17 Feb 2026 21:32:15 +0100
Message-ID: <20260217200007.815297155@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200006.470920131@linuxfoundation.org>
References: <20260217200006.470920131@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongpeng Yang <yangyongpeng@xiaomi.com>

commit 98ea0039dbfdd00e5cc1b9a8afa40434476c0955 upstream.

Some f2fs sysfs attributes suffer from out-of-bounds memory access and
incorrect handling of integer values whose size is not 4 bytes.

For example:
vm:~# echo 65537 > /sys/fs/f2fs/vde/carve_out
vm:~# cat /sys/fs/f2fs/vde/carve_out
65537
vm:~# echo 4294967297 > /sys/fs/f2fs/vde/atgc_age_threshold
vm:~# cat /sys/fs/f2fs/vde/atgc_age_threshold
1

carve_out maps to {struct f2fs_sb_info}->carve_out, which is a 8-bit
integer. However, the sysfs interface allows setting it to a value
larger than 255, resulting in an out-of-range update.

atgc_age_threshold maps to {struct atgc_management}->age_threshold,
which is a 64-bit integer, but its sysfs interface cannot correctly set
values larger than UINT_MAX.

The root causes are:
1. __sbi_store() treats all default values as unsigned int, which
prevents updating integers larger than 4 bytes and causes out-of-bounds
writes for integers smaller than 4 bytes.

2. f2fs_sbi_show() also assumes all default values are unsigned int,
leading to out-of-bounds reads and incorrect access to integers larger
than 4 bytes.

This patch introduces {struct f2fs_attr}->size to record the actual size
of the integer associated with each sysfs attribute. With this
information, sysfs read and write operations can correctly access and
update values according to their real data size, avoiding memory
corruption and truncation.

Fixes: b59d0bae6ca3 ("f2fs: add sysfs support for controlling the gc_thread")
Cc: stable@kernel.org
Signed-off-by: Jinbao Liu <liujinbao1@xiaomi.com>
Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/sysfs.c |   60 ++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 52 insertions(+), 8 deletions(-)

--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -58,6 +58,7 @@ struct f2fs_attr {
 			 const char *buf, size_t len);
 	int struct_type;
 	int offset;
+	int size;
 	int id;
 };
 
@@ -344,11 +345,30 @@ static ssize_t main_blkaddr_show(struct
 			(unsigned long long)MAIN_BLKADDR(sbi));
 }
 
+static ssize_t __sbi_show_value(struct f2fs_attr *a,
+		struct f2fs_sb_info *sbi, char *buf,
+		unsigned char *value)
+{
+	switch (a->size) {
+	case 1:
+		return sysfs_emit(buf, "%u\n", *(u8 *)value);
+	case 2:
+		return sysfs_emit(buf, "%u\n", *(u16 *)value);
+	case 4:
+		return sysfs_emit(buf, "%u\n", *(u32 *)value);
+	case 8:
+		return sysfs_emit(buf, "%llu\n", *(u64 *)value);
+	default:
+		f2fs_bug_on(sbi, 1);
+		return sysfs_emit(buf,
+				"show sysfs node value with wrong type\n");
+	}
+}
+
 static ssize_t f2fs_sbi_show(struct f2fs_attr *a,
 			struct f2fs_sb_info *sbi, char *buf)
 {
 	unsigned char *ptr = NULL;
-	unsigned int *ui;
 
 	ptr = __struct_ptr(sbi, a->struct_type);
 	if (!ptr)
@@ -428,9 +448,30 @@ static ssize_t f2fs_sbi_show(struct f2fs
 				atomic_read(&sbi->cp_call_count[BACKGROUND]));
 #endif
 
-	ui = (unsigned int *)(ptr + a->offset);
+	return __sbi_show_value(a, sbi, buf, ptr + a->offset);
+}
 
-	return sysfs_emit(buf, "%u\n", *ui);
+static void __sbi_store_value(struct f2fs_attr *a,
+			struct f2fs_sb_info *sbi,
+			unsigned char *ui, unsigned long value)
+{
+	switch (a->size) {
+	case 1:
+		*(u8 *)ui = value;
+		break;
+	case 2:
+		*(u16 *)ui = value;
+		break;
+	case 4:
+		*(u32 *)ui = value;
+		break;
+	case 8:
+		*(u64 *)ui = value;
+		break;
+	default:
+		f2fs_bug_on(sbi, 1);
+		f2fs_err(sbi, "store sysfs node value with wrong type");
+	}
 }
 
 static ssize_t __sbi_store(struct f2fs_attr *a,
@@ -906,7 +947,7 @@ out:
 		return count;
 	}
 
-	*ui = (unsigned int)t;
+	__sbi_store_value(a, sbi, ptr + a->offset, t);
 
 	return count;
 }
@@ -1053,24 +1094,27 @@ static struct f2fs_attr f2fs_attr_sb_##_
 	.id	= F2FS_FEATURE_##_feat,				\
 }
 
-#define F2FS_ATTR_OFFSET(_struct_type, _name, _mode, _show, _store, _offset) \
+#define F2FS_ATTR_OFFSET(_struct_type, _name, _mode, _show, _store, _offset, _size) \
 static struct f2fs_attr f2fs_attr_##_name = {			\
 	.attr = {.name = __stringify(_name), .mode = _mode },	\
 	.show	= _show,					\
 	.store	= _store,					\
 	.struct_type = _struct_type,				\
-	.offset = _offset					\
+	.offset = _offset,					\
+	.size = _size						\
 }
 
 #define F2FS_RO_ATTR(struct_type, struct_name, name, elname)	\
 	F2FS_ATTR_OFFSET(struct_type, name, 0444,		\
 		f2fs_sbi_show, NULL,				\
-		offsetof(struct struct_name, elname))
+		offsetof(struct struct_name, elname),		\
+		sizeof_field(struct struct_name, elname))
 
 #define F2FS_RW_ATTR(struct_type, struct_name, name, elname)	\
 	F2FS_ATTR_OFFSET(struct_type, name, 0644,		\
 		f2fs_sbi_show, f2fs_sbi_store,			\
-		offsetof(struct struct_name, elname))
+		offsetof(struct struct_name, elname),		\
+		sizeof_field(struct struct_name, elname))
 
 #define F2FS_GENERAL_RO_ATTR(name) \
 static struct f2fs_attr f2fs_attr_##name = __ATTR(name, 0444, name##_show, NULL)


