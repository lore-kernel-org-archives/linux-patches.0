Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B1937AA65;
	Sat, 12 Sep 2026 07:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199836; cv=none; b=DTRw3llMQBGZbHco4xgynGkF7DizhJRet1O9ZyTuk7C0NyDAtLC2B/Og2rYYi8MEFdldKdxvvJz2THKSMiNlTZM+Vjj0Uc5yQ8Uu0elfboARP2i6VyeETSo/PkuFKzvOmvEqBOqVdH2yosgfPCTpVilKtXcW9ZTrjjW9raas/bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199836; c=relaxed/simple;
	bh=te1WoRr77PUgnTD1Iv0PFhP7OnVbbPTpyDryZdXYNuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HnTLG7bmbFR4EN5ZwAQLwAxUd6RvTfNrmusSbeYuXw+cUxEPjIPLH0paB/RT/nx8OcNxycmMRbH3VESE1Q0fhV6NlqHT/stbDbWnIEeqx/tSUUP5zosUaJUjxMywakEnFaSjQH17yDF5/erE9QTsE7iqyKYmbNyEgFNNugUR4mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uRiiYlCN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uRiiYlCN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C3291F00893;
	Sat, 12 Sep 2026 07:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199834;
	bh=bhEX1rZRPTVjN7dZXbXidxWSk4qEUuXx3A2mczFZtz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uRiiYlCN+GdKtQQYRalFyh5PPUVXmsvYzGZY9knIom/ZUv3sONGex9MQYXkWT5SMA
	 mCNWTVGbnjoXZnztWGXKVjcbruFtVlmx/5NhtL9dGl+YRLRLyowIHb5xdgm52cG/UC
	 K/SCR43A23sSfAUYshlNcAVhBtR9IrNHEXee119A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Wu <weiming3@asu.edu>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0639/1815] fs/ntfs3: fix out-of-bounds read of INDEX_ROOT in reparse/objid init
Date: Sat, 12 Sep 2026 08:39:49 +0200
Message-ID: <20260912065703.882821324@linuxfoundation.org>
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
index bc7469d0a34d4..7c4db816c43d3 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -2302,8 +2302,8 @@ int ntfs_reparse_init(struct ntfs_sb_info *sbi)
 		goto out;
 	}
 
-	root_r = resident_data(attr);
-	if (root_r->type != ATTR_ZERO ||
+	root_r = resident_data_ex(attr, sizeof(struct INDEX_ROOT));
+	if (!root_r || root_r->type != ATTR_ZERO ||
 	    root_r->rule != NTFS_COLLATION_TYPE_UINTS) {
 		err = -EINVAL;
 		goto out;
@@ -2340,8 +2340,8 @@ int ntfs_objid_init(struct ntfs_sb_info *sbi)
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



