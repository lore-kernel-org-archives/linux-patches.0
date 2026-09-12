Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A73537AA65;
	Sat, 12 Sep 2026 09:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204289; cv=none; b=hFSa3bL6lVHg96DM6xAh84es5Uztc+966mHYeheT3s34IU6/zKCzLdOp3ERCAuEUQeg7DDAtYYaeBf+phb1C/6wbTabYAiqwk085Xl4Z4Lp6+XDqNrL8lgSNJFa1dDrOXlgQAQ1wOGJQBKGHdD228il7tundiZSkEZVgc0JBNUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204289; c=relaxed/simple;
	bh=uPC+vL6AjDxQwz1n7t+LdHQjfv3+EPt97MXWyJ1EwGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oHxh4keeBzb4Psqncb/1dXJglmhHdCi5YDc6CRROLSKnlYUi0D1Z1ugkSfWGT58TdEXY3150khpdpW4TSHUfkbhbB6Y9hLLPwhzGVN0vS2rnb2+OA4Ooz9Hj3+cxZ0q2FSsCwY4Zo/ZxqjAkZqgFyh7OWzP+hBzgpaz8rV5j774=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fbvyYeVl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fbvyYeVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5791F000FF;
	Sat, 12 Sep 2026 09:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204288;
	bh=gc7MRVNd84po7wjpYojUwuh9OMQNBcJa5zx7HO38En0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fbvyYeVlwiRrZgkacrWV6wwBsx1G8a4XzXjbDIcCw5Z+Uujfmi7EXLFW3D/YJuAU7
	 fctaT+CudBRl9UuARJ0ADf9Bk6iMOG7OI406DswwjmAfxOVMg/4cL8CeezMf16xXVi
	 ktPL73mKFxQoxJTS0OXsrdy4MboUbUYR8Yqsd5n8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1582/1815] fs/ntfs3: validate ef->size covers the records name and value
Date: Sat, 12 Sep 2026 08:55:32 +0200
Message-ID: <20260912065726.127445383@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit c22f91d82cb9a29d22bdffdce6c803467984ad0c ]

When an EA record has a non-zero ef->size, ntfs_read_ea() only checks
that the record fits in the remaining buffer (ea_size > bytes), not that
ef->size is large enough to hold the record's own name_len + 1 + elength.

A crafted image can pass validation with, e.g., ef->size = 24 but
elength = 0xffff. ntfs_get_ea() then trusts elength and copies it out of
the undersized record, reading past the kmalloc(info->size) allocation
and leaking heap memory to userspace via getxattr():

 BUG: KASAN: slab-out-of-bounds in ntfs_get_ea (fs/ntfs3/xattr.c:302)
 Read of size 65535 at addr ffff888100794550 by task exploit
  __asan_memcpy (mm/kasan/shadow.c:105)
  ntfs_get_ea (fs/ntfs3/xattr.c:302)
  ntfs_getxattr (fs/ntfs3/xattr.c:848)
  __vfs_getxattr (fs/xattr.c:441)
  vfs_getxattr (fs/xattr.c:474)
  do_getxattr (fs/xattr.c:800)
  path_getxattrat (fs/xattr.c:868)
  do_syscall_64 (arch/x86/entry/syscall_64.c:94)

 The buggy address is located 80 bytes inside of
  allocated 84-byte region in cache kmalloc-96

Compute the size the record needs and require ef->size to cover it.

Fixes: 0e8235d28f3a ("fs/ntfs3: Check fields while reading")
Reported-by: Xiang Mei <xmei5@asu.edu>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/xattr.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/ntfs3/xattr.c b/fs/ntfs3/xattr.c
index 04814dd293752..6697362e655bf 100644
--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -146,26 +146,29 @@ static int ntfs_read_ea(struct ntfs_inode *ni, struct EA_FULL **ea,
 	for (off = 0; off < size; off += ea_size) {
 		const struct EA_FULL *ef = Add2Ptr(ea_p, off);
 		u32 bytes = size - off;
+		size_t need;
 
 		/* Check if we can use field ea->size. */
 		if (bytes < sizeof(ef->size))
 			goto out1;
 
+		/* Check if we can use fields ef->name_len and ef->elength. */
+		if (bytes < offsetof(struct EA_FULL, name))
+			goto out1;
+
+		/* Size needed to hold this record's name and value. */
+		need = struct_size(ef, name,
+				   1 + ef->name_len + le16_to_cpu(ef->elength));
+
 		if (ef->size) {
 			ea_size = le32_to_cpu(ef->size);
-			if (ea_size > bytes)
+			/* ef->size must fit the list and cover the record. */
+			if (ea_size > bytes || ea_size < need)
 				goto out1;
 			continue;
 		}
 
-		/* Check if we can use fields ef->name_len and ef->elength. */
-		if (bytes < offsetof(struct EA_FULL, name))
-			goto out1;
-
-		ea_size = ALIGN(struct_size(ef, name,
-					    1 + ef->name_len +
-						    le16_to_cpu(ef->elength)),
-				4);
+		ea_size = ALIGN(need, 4);
 		if (ea_size > bytes)
 			goto out1;
 	}
-- 
2.53.0



