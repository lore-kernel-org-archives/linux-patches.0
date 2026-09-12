Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6823A7591;
	Sat, 12 Sep 2026 18:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239091; cv=none; b=lf+3p8XIJBU3V56mFbhQv1crQThEcwjEIKEOzFR1rdBapn32+m2uWHid9BgIse9ieO/2KVptV3SfN7GQIEdr2gYqnBuQsB2Z/8vLAqqV6yWy51fXrFw0CwR0lJz9tBczWm8v8duMaKsPh3dngiexaM2O4tWkeKKTMCXJ4gLOLgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239091; c=relaxed/simple;
	bh=shLcvVQVQxryzVG4vcXQuzOdP4hbPRPqhfArI332jlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kgJ/5h4FBrcdLcVkw6Of8NXPGuJjAj9T0DltbaPzzfitOjWTh3S4sWlZkkeQFd4xvynnErf9Xa4ROvYPJRa0TccES57sxydEK8bQO3iRjkIQPbbm7PvMn8DjkRqofnJGK1qHYK3jjFAF5crtyRlIsh+hrJuQryD/fKS959bApQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hiLGLS2M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hiLGLS2M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 711571F000FF;
	Sat, 12 Sep 2026 18:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239090;
	bh=zDvrM5lLq7sPhME4gVzLR5gXY1aADX9rWKwkW8FGshQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hiLGLS2Mc0w3+Kshtuyv9RfBtbD8Rx7HOTjiN7wfsagZTlMnEFrspZKcr0N/BX+8P
	 EDIq/M7EOjfTsgNtJOrJVbjTWKe2Ad9Krvb97Dk0O2LoBA2cxDfXBSKpBF3TkPgBOi
	 K1NO2tnwp7cv2PSowzLzR5ZvgqlebYrIK7rVBAPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Wu <weiming3@asu.edu>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 595/935] fs/ntfs3: fix out-of-bounds read of INDEX_ROOT in reparse/objid init
Date: Sat, 12 Sep 2026 09:00:25 +0200
Message-ID: <20260912065540.487261126@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

From: Weiming Wu <weiming3@asu.edu>

[ Upstream commit 2064bc663f89e61b8681c1fb9d1ce445de72063d ]

ntfs_reparse_init() and ntfs_objid_init() parse the index root of the
$Extend/$Reparse and $Extend/$ObjId metafiles (the INDEX_ROOT attributes
named $R and $O). They read its type and rule fields through
resident_data(), which does not check that the resident attribute is
large enough to hold them.

mi_enum_attr() accepts a resident attribute with data_off == asize and
data_size == 0. For such an attribute placed last in its MFT record,
resident_data() returns a pointer to the end of the record_size buffer,
so reading root->type / root->rule reads past the allocation.

Use resident_data_ex(attr, sizeof(struct INDEX_ROOT)) and bail out when
it returns NULL, as ntfs_security_init() already does for $SDH / $SII.

The attribute is only parsed while mounting a crafted image, so this
needs CAP_SYS_ADMIN.

 BUG: KASAN: slab-out-of-bounds in ntfs_reparse_init (fs/ntfs3/fsntfs.c:2306)
 Read of size 4 at addr ffff88801219dc00 by task mount
  ntfs_reparse_init (fs/ntfs3/fsntfs.c:2306)
  ntfs_fill_super (fs/ntfs3/super.c:1604)
  get_tree_bdev_flags (fs/super.c:1703)
  vfs_get_tree (fs/super.c:1758)
  path_mount (fs/namespace.c:4131)
  __x64_sys_mount (fs/namespace.c:4360)

Fixes: 82cae269cfa9 ("fs/ntfs3: Add initialization of super block")
Reported-by: Xiang Mei <xmei5@asu.edu>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Weiming Wu <weiming3@asu.edu>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/fsntfs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ntfs3/fsntfs.c b/fs/ntfs3/fsntfs.c
index ab9c75e092c29..cab0679c978c3 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -2310,8 +2310,8 @@ int ntfs_reparse_init(struct ntfs_sb_info *sbi)
 		goto out;
 	}
 
-	root_r = resident_data(attr);
-	if (root_r->type != ATTR_ZERO ||
+	root_r = resident_data_ex(attr, sizeof(struct INDEX_ROOT));
+	if (!root_r || root_r->type != ATTR_ZERO ||
 	    root_r->rule != NTFS_COLLATION_TYPE_UINTS) {
 		err = -EINVAL;
 		goto out;
@@ -2348,8 +2348,8 @@ int ntfs_objid_init(struct ntfs_sb_info *sbi)
 		goto out;
 	}
 
-	root = resident_data(attr);
-	if (root->type != ATTR_ZERO ||
+	root = resident_data_ex(attr, sizeof(struct INDEX_ROOT));
+	if (!root || root->type != ATTR_ZERO ||
 	    root->rule != NTFS_COLLATION_TYPE_UINTS) {
 		err = -EINVAL;
 		goto out;
-- 
2.53.0



