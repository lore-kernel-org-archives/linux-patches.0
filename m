Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FFE3A8724;
	Thu,  2 Jul 2026 16:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009725; cv=none; b=aF1f+8BSIa7OByy2rtDCgwFQSgurFOIclB98FHd1y7g+eR+rxjU+VBryRZ4BnPvQ//emMxJgCJavlkdUXpyVj1KyBgkHwh56cZpBK6VmgkD5DrfVsNrqMHl4M8lI2h1l7RubmHBqv0tAUiEUnEAeDU/xgegX15DgoSBmwBcCad8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009725; c=relaxed/simple;
	bh=Sm3bJJp4ynCYbo4Aj8incrzcWZDAKXBBr6GqZB5RQzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=edM3MWq2NQird2UfyFarnqGmK7178UZCgD9RgF54GXUSHCAS1VAUKwfxw19h7wDOb8frjkaCmd8LdVh8gJwUE5KDt2OKye+ufqEogz381/zhpBKF2rQvTuUfCqbAqeG5dAsxRT7LzGO8k9AnX4zEV4OaKPsuObYqnyL7vHn4WPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FDbZIb26; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FDbZIb26"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB8D1F00A3A;
	Thu,  2 Jul 2026 16:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009722;
	bh=nhneldcc9YWqLoFq4WwZ/WH1q5itqSjO5MuuVOsNe/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FDbZIb26SHa4lt1BZRibFZ848bmpd1lKXl7tbt3Y7ffP3U87eMhZ2wMeFX5Az4zyM
	 DT+oBryujluY3uDWLAyBtgJxHZRvOLumBwQ+QFeHH9Iw4GTMGpMaTyfbPKaXdU6M5O
	 JKZVI3D2Wdhzr40b5kNfEpa8rMJnVzAWrLADAaFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Zhang Cen <rollkingzzc@gmail.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.15 63/95] f2fs: validate ACL entry sizes in f2fs_acl_from_disk()
Date: Thu,  2 Jul 2026 18:20:06 +0200
Message-ID: <20260702155110.537692786@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
References: <20260702155109.196223802@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Cen <rollkingzzc@gmail.com>

commit c4810ada31e80cbe4011467c4f3b1e93f94134f3 upstream.

f2fs_acl_count() only validates the aggregate ACL xattr length. A
malformed ACL can still place ACL_USER or ACL_GROUP in a slot that only
contains struct f2fs_acl_entry_short bytes, and f2fs_acl_from_disk()
then reads entry->e_id before verifying that a full entry fits.

Require a short entry before reading e_tag and e_perm, and require a
full entry before reading e_id for ACL_USER and ACL_GROUP. Return
-EFSCORRUPTED from these new truncated-entry checks, while keeping the
pre-existing -EINVAL paths unchanged.

Validation reproduced this kernel report:
KASAN slab-out-of-bounds in __f2fs_get_acl+0x6fb/0x7e0
RIP: 0033:0x7f4b835ea7aa
The buggy address belongs to the object at ffff888114589960 which belongs
to the cache kmalloc-8 of size 8
The buggy address is located 0 bytes to the right of allocated 8-byte
region [ffff888114589960, ffff888114589968)
Read of size 4
Call trace:
  dump_stack_lvl+0x66/0xa0 (?:?)
  print_report+0xce/0x630 (?:?)
  __f2fs_get_acl+0x6fb/0x7e0 (fs/f2fs/acl.c:169)
  srso_alias_return_thunk+0x5/0xfbef5 (?:?)
  __virt_addr_valid+0x224/0x430 (?:?)
  kasan_report+0xe0/0x110 (?:?)
  __f2fs_get_acl+0x5/0x7e0 (fs/f2fs/acl.c:169)
  __get_acl+0x281/0x380 (?:?)
  vfs_get_acl+0x10b/0x190 (?:?)
  do_get_acl+0x2a/0x410 (?:?)
  do_get_acl+0x9/0x410 (?:?)
  do_getxattr+0xe8/0x260 (?:?)
  filename_getxattr+0xd1/0x140 (?:?)
  do_getname+0x2d/0x2d0 (?:?)
  path_getxattrat+0x16c/0x200 (?:?)
  lock_release+0xc8/0x290 (?:?)
  cgroup_update_frozen+0x9d/0x320 (?:?)
  lockdep_hardirqs_on_prepare+0xea/0x1a0 (?:?)
  trace_hardirqs_on+0x1a/0x170 (?:?)
  _raw_spin_unlock_irq+0x28/0x50 (?:?)
  do_syscall_64+0x115/0x6a0 (arch/x86/entry/syscall_64.c:87)
  entry_SYSCALL_64_after_hwframe+0x77/0x7f (?:?)

Cc: stable@kernel.org
Fixes: af48b85b8cd3 ("f2fs: add xattr and acl functionalities")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/acl.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/fs/f2fs/acl.c
+++ b/fs/f2fs/acl.c
@@ -46,6 +46,7 @@ static inline int f2fs_acl_count(size_t
 static struct posix_acl *f2fs_acl_from_disk(const char *value, size_t size)
 {
 	int i, count;
+	int err = -EINVAL;
 	struct posix_acl *acl;
 	struct f2fs_acl_header *hdr = (struct f2fs_acl_header *)value;
 	struct f2fs_acl_entry *entry = (struct f2fs_acl_entry *)(hdr + 1);
@@ -69,8 +70,11 @@ static struct posix_acl *f2fs_acl_from_d
 
 	for (i = 0; i < count; i++) {
 
-		if ((char *)entry > end)
+		if (unlikely((char *)entry +
+				sizeof(struct f2fs_acl_entry_short) > end)) {
+			err = -EFSCORRUPTED;
 			goto fail;
+		}
 
 		acl->a_entries[i].e_tag  = le16_to_cpu(entry->e_tag);
 		acl->a_entries[i].e_perm = le16_to_cpu(entry->e_perm);
@@ -85,6 +89,11 @@ static struct posix_acl *f2fs_acl_from_d
 			break;
 
 		case ACL_USER:
+			if (unlikely((char *)entry +
+					sizeof(struct f2fs_acl_entry) > end)) {
+				err = -EFSCORRUPTED;
+				goto fail;
+			}
 			acl->a_entries[i].e_uid =
 				make_kuid(&init_user_ns,
 						le32_to_cpu(entry->e_id));
@@ -92,6 +101,11 @@ static struct posix_acl *f2fs_acl_from_d
 					sizeof(struct f2fs_acl_entry));
 			break;
 		case ACL_GROUP:
+			if (unlikely((char *)entry +
+					sizeof(struct f2fs_acl_entry) > end)) {
+				err = -EFSCORRUPTED;
+				goto fail;
+			}
 			acl->a_entries[i].e_gid =
 				make_kgid(&init_user_ns,
 						le32_to_cpu(entry->e_id));
@@ -107,7 +121,7 @@ static struct posix_acl *f2fs_acl_from_d
 	return acl;
 fail:
 	posix_acl_release(acl);
-	return ERR_PTR(-EINVAL);
+	return ERR_PTR(err);
 }
 
 static void *f2fs_acl_to_disk(struct f2fs_sb_info *sbi,


