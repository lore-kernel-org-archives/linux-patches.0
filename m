Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF5B25DB1C;
	Mon,  9 Feb 2026 14:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648357; cv=none; b=MYNp7LPrDBRZxipGZEAYVoI40490LoY5H4jH1ljW1fzuhgbmMEsOf1sGNyUenw72liF0HPJxZt3MzkMzP3hKDikQvmwB5Fl8ngVs4chjiHKdbED0D2Q1RyWkKXUHJd2d6z/pjnCj4jFuHNXAMk0AajuOrWxhhy0XaA/Jw+phz9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648357; c=relaxed/simple;
	bh=rr3kHeRDJXNWt9qHbi3NPKFGz85Y0J51ljnxSo9V6Uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e6XYxae3nUxKbTO/WCOViOCk+uNzKQC0Fep62TrMvSjn9b285m8BQKp67bilWM3ioJf5YhZ68Zili7z26vm7ZJb8ypanl2EEvlQQmPazHyhr5ylj7XfYRgrElFcUniAmvnryf+5gYse55UojHLTYoAemHecC8grZosS/iJ1iDrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lSXF4VFO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lSXF4VFO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05341C116C6;
	Mon,  9 Feb 2026 14:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648357;
	bh=rr3kHeRDJXNWt9qHbi3NPKFGz85Y0J51ljnxSo9V6Uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lSXF4VFOSFojIri2uAGqiRyHN91/E+Ho1uukfB0ciHzVOTpWuLvNohvRrmZtvhDoo
	 +8ekojlAFVOq9TuYbVDFtSNHt3VSGTDztmSyqjwXUlfcJdKrtIqNVV5agzb9Cyp7h4
	 6ZZJ+RFnHFrhCaAcB+Pw3WwnHNBHUKLs1p5aEN/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kang Chen <k.chen@smail.nju.edu.cn>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Jianqiang kang <jianqkang@sina.cn>
Subject: [PATCH 6.6 14/86] hfsplus: fix slab-out-of-bounds read in hfsplus_uni2asc()
Date: Mon,  9 Feb 2026 15:23:37 +0100
Message-ID: <20260209142305.291513604@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
References: <20260209142304.770150175@linuxfoundation.org>
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

From: Kang Chen <k.chen@smail.nju.edu.cn>

commit bea3e1d4467bcf292c8e54f080353d556d355e26 upstream.

BUG: KASAN: slab-out-of-bounds in hfsplus_uni2asc+0xa71/0xb90 fs/hfsplus/unicode.c:186
Read of size 2 at addr ffff8880289ef218 by task syz.6.248/14290

CPU: 0 UID: 0 PID: 14290 Comm: syz.6.248 Not tainted 6.16.4 #1 PREEMPT(full)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1b0 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xca/0x5f0 mm/kasan/report.c:482
 kasan_report+0xca/0x100 mm/kasan/report.c:595
 hfsplus_uni2asc+0xa71/0xb90 fs/hfsplus/unicode.c:186
 hfsplus_listxattr+0x5b6/0xbd0 fs/hfsplus/xattr.c:738
 vfs_listxattr+0xbe/0x140 fs/xattr.c:493
 listxattr+0xee/0x190 fs/xattr.c:924
 filename_listxattr fs/xattr.c:958 [inline]
 path_listxattrat+0x143/0x360 fs/xattr.c:988
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcb/0x4c0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe0e9fae16d
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fe0eae67f98 EFLAGS: 00000246 ORIG_RAX: 00000000000000c3
RAX: ffffffffffffffda RBX: 00007fe0ea205fa0 RCX: 00007fe0e9fae16d
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000200000000000
RBP: 00007fe0ea0480f0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fe0ea206038 R14: 00007fe0ea205fa0 R15: 00007fe0eae48000
 </TASK>

Allocated by task 14290:
 kasan_save_stack+0x24/0x50 mm/kasan/common.c:47
 kasan_save_track+0x14/0x30 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
 __kasan_kmalloc+0xaa/0xb0 mm/kasan/common.c:394
 kasan_kmalloc include/linux/kasan.h:260 [inline]
 __do_kmalloc_node mm/slub.c:4333 [inline]
 __kmalloc_noprof+0x219/0x540 mm/slub.c:4345
 kmalloc_noprof include/linux/slab.h:909 [inline]
 hfsplus_find_init+0x95/0x1f0 fs/hfsplus/bfind.c:21
 hfsplus_listxattr+0x331/0xbd0 fs/hfsplus/xattr.c:697
 vfs_listxattr+0xbe/0x140 fs/xattr.c:493
 listxattr+0xee/0x190 fs/xattr.c:924
 filename_listxattr fs/xattr.c:958 [inline]
 path_listxattrat+0x143/0x360 fs/xattr.c:988
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcb/0x4c0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

When hfsplus_uni2asc is called from hfsplus_listxattr,
it actually passes in a struct hfsplus_attr_unistr*.
The size of the corresponding structure is different from that of hfsplus_unistr,
so the previous fix (94458781aee6) is insufficient.
The pointer on the unicode buffer is still going beyond the allocated memory.

This patch introduces two warpper functions hfsplus_uni2asc_xattr_str and
hfsplus_uni2asc_str to process two unicode buffers,
struct hfsplus_attr_unistr* and struct hfsplus_unistr* respectively.
When ustrlen value is bigger than the allocated memory size,
the ustrlen value is limited to an safe size.

Fixes: 94458781aee6 ("hfsplus: fix slab-out-of-bounds read in hfsplus_uni2asc()")
Signed-off-by: Kang Chen <k.chen@smail.nju.edu.cn>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/20250909031316.1647094-1-k.chen@smail.nju.edu.cn
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Jianqiang kang <jianqkang@sina.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/hfsplus/dir.c        |    2 +-
 fs/hfsplus/hfsplus_fs.h |    8 ++++++--
 fs/hfsplus/unicode.c    |   24 +++++++++++++++++++-----
 fs/hfsplus/xattr.c      |    6 +++---
 4 files changed, 29 insertions(+), 11 deletions(-)

--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -204,7 +204,7 @@ static int hfsplus_readdir(struct file *
 			fd.entrylength);
 		type = be16_to_cpu(entry.type);
 		len = NLS_MAX_CHARSET_SIZE * HFSPLUS_MAX_STRLEN;
-		err = hfsplus_uni2asc(sb, &fd.key->cat.name, strbuf, &len);
+		err = hfsplus_uni2asc_str(sb, &fd.key->cat.name, strbuf, &len);
 		if (err)
 			goto out;
 		if (type == HFSPLUS_FOLDER) {
--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@ -518,8 +518,12 @@ int hfsplus_strcasecmp(const struct hfsp
 		       const struct hfsplus_unistr *s2);
 int hfsplus_strcmp(const struct hfsplus_unistr *s1,
 		   const struct hfsplus_unistr *s2);
-int hfsplus_uni2asc(struct super_block *sb, const struct hfsplus_unistr *ustr,
-		    char *astr, int *len_p);
+int hfsplus_uni2asc_str(struct super_block *sb,
+			const struct hfsplus_unistr *ustr, char *astr,
+			int *len_p);
+int hfsplus_uni2asc_xattr_str(struct super_block *sb,
+			      const struct hfsplus_attr_unistr *ustr,
+			      char *astr, int *len_p);
 int hfsplus_asc2uni(struct super_block *sb, struct hfsplus_unistr *ustr,
 		    int max_unistr_len, const char *astr, int len);
 int hfsplus_hash_dentry(const struct dentry *dentry, struct qstr *str);
--- a/fs/hfsplus/unicode.c
+++ b/fs/hfsplus/unicode.c
@@ -143,9 +143,8 @@ static u16 *hfsplus_compose_lookup(u16 *
 	return NULL;
 }
 
-int hfsplus_uni2asc(struct super_block *sb,
-		const struct hfsplus_unistr *ustr,
-		char *astr, int *len_p)
+static int hfsplus_uni2asc(struct super_block *sb, const struct hfsplus_unistr *ustr,
+		    int max_len, char *astr, int *len_p)
 {
 	const hfsplus_unichr *ip;
 	struct nls_table *nls = HFSPLUS_SB(sb)->nls;
@@ -158,8 +157,8 @@ int hfsplus_uni2asc(struct super_block *
 	ip = ustr->unicode;
 
 	ustrlen = be16_to_cpu(ustr->length);
-	if (ustrlen > HFSPLUS_MAX_STRLEN) {
-		ustrlen = HFSPLUS_MAX_STRLEN;
+	if (ustrlen > max_len) {
+		ustrlen = max_len;
 		pr_err("invalid length %u has been corrected to %d\n",
 			be16_to_cpu(ustr->length), ustrlen);
 	}
@@ -280,6 +279,21 @@ out:
 	return res;
 }
 
+inline int hfsplus_uni2asc_str(struct super_block *sb,
+			       const struct hfsplus_unistr *ustr, char *astr,
+			       int *len_p)
+{
+	return hfsplus_uni2asc(sb, ustr, HFSPLUS_MAX_STRLEN, astr, len_p);
+}
+
+inline int hfsplus_uni2asc_xattr_str(struct super_block *sb,
+				     const struct hfsplus_attr_unistr *ustr,
+				     char *astr, int *len_p)
+{
+	return hfsplus_uni2asc(sb, (const struct hfsplus_unistr *)ustr,
+			       HFSPLUS_ATTR_MAX_STRLEN, astr, len_p);
+}
+
 /*
  * Convert one or more ASCII characters into a single unicode character.
  * Returns the number of ASCII characters corresponding to the unicode char.
--- a/fs/hfsplus/xattr.c
+++ b/fs/hfsplus/xattr.c
@@ -737,9 +737,9 @@ ssize_t hfsplus_listxattr(struct dentry
 			goto end_listxattr;
 
 		xattr_name_len = NLS_MAX_CHARSET_SIZE * HFSPLUS_ATTR_MAX_STRLEN;
-		if (hfsplus_uni2asc(inode->i_sb,
-			(const struct hfsplus_unistr *)&fd.key->attr.key_name,
-					strbuf, &xattr_name_len)) {
+		if (hfsplus_uni2asc_xattr_str(inode->i_sb,
+					      &fd.key->attr.key_name, strbuf,
+					      &xattr_name_len)) {
 			pr_err("unicode conversion failed\n");
 			res = -EIO;
 			goto end_listxattr;


