Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0434F13B798;
	Tue, 27 Feb 2024 13:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040827; cv=none; b=U3ovN8YnG/4qPI9BIuNqiFcReK/LQkXOMZ1q9OP0iLhrhSRPLSNmcJa0PF78kivvU9bh+JsLghrZd8RJl/iHF64t3pSQqO/GO1zRj9k0GS4U/FSMWXzFrwmHSZtfSAqS9dV/Ndg6UMDwu8Pj/cfu2We4dTAyd8UR6kkNI8dKsHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040827; c=relaxed/simple;
	bh=oR2R5vIoMyaWCadg4RMMXyvQmQzmLuM+2InKOm6UvOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n94FY3P9Iha83jTomma9RzHGa51zFDJzhELNsnJFMqXhCacT9HXFjS1X09iwJES/IrWdCBniWWzg+eQmSRvns4rJTm1ygGWJkJVRrxDWQk9cB/5AUcC6pCNIB7OgZMnx3etXdxghI4OfyLL3yEwMgSmA2G0W9zAx8A5bkxWKnHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vUv6t/4b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vUv6t/4b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76E8FC433C7;
	Tue, 27 Feb 2024 13:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040826;
	bh=oR2R5vIoMyaWCadg4RMMXyvQmQzmLuM+2InKOm6UvOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vUv6t/4bMBqp2M0yTH2WN+zgFT0CuQ6hL7GPRQ4ljl/SjwjAbDWyyuHzkHOxWvjXN
	 H+kTVQzLHJX81O02wmZFqxvmM4AVnqJalK8Typ8ZwT7hkDsZOK/IZFKgj2FS7IeB0l
	 aF2OFMFBWuPwSfzCG7u8RJRSeKl2b0sIGWiujXaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 093/334] fs/ntfs3: Use kvfree to free memory allocated by kvmalloc
Date: Tue, 27 Feb 2024 14:19:11 +0100
Message-ID: <20240227131633.513867259@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit ddb17dc880eeaac37b5a6e984de07b882de7d78d ]

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/attrlist.c | 4 ++--
 fs/ntfs3/bitmap.c   | 4 ++--
 fs/ntfs3/frecord.c  | 4 ++--
 fs/ntfs3/super.c    | 2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ntfs3/attrlist.c b/fs/ntfs3/attrlist.c
index 48e7da47c6b71..9f4bd8d260901 100644
--- a/fs/ntfs3/attrlist.c
+++ b/fs/ntfs3/attrlist.c
@@ -29,7 +29,7 @@ static inline bool al_is_valid_le(const struct ntfs_inode *ni,
 void al_destroy(struct ntfs_inode *ni)
 {
 	run_close(&ni->attr_list.run);
-	kfree(ni->attr_list.le);
+	kvfree(ni->attr_list.le);
 	ni->attr_list.le = NULL;
 	ni->attr_list.size = 0;
 	ni->attr_list.dirty = false;
@@ -318,7 +318,7 @@ int al_add_le(struct ntfs_inode *ni, enum ATTR_TYPE type, const __le16 *name,
 		memcpy(ptr, al->le, off);
 		memcpy(Add2Ptr(ptr, off + sz), le, old_size - off);
 		le = Add2Ptr(ptr, off);
-		kfree(al->le);
+		kvfree(al->le);
 		al->le = ptr;
 	} else {
 		memmove(Add2Ptr(le, sz), le, old_size - off);
diff --git a/fs/ntfs3/bitmap.c b/fs/ntfs3/bitmap.c
index 63f14a0232f6a..845f9b22deef0 100644
--- a/fs/ntfs3/bitmap.c
+++ b/fs/ntfs3/bitmap.c
@@ -124,7 +124,7 @@ void wnd_close(struct wnd_bitmap *wnd)
 {
 	struct rb_node *node, *next;
 
-	kfree(wnd->free_bits);
+	kvfree(wnd->free_bits);
 	wnd->free_bits = NULL;
 	run_close(&wnd->run);
 
@@ -1360,7 +1360,7 @@ int wnd_extend(struct wnd_bitmap *wnd, size_t new_bits)
 		memcpy(new_free, wnd->free_bits, wnd->nwnd * sizeof(short));
 		memset(new_free + wnd->nwnd, 0,
 		       (new_wnd - wnd->nwnd) * sizeof(short));
-		kfree(wnd->free_bits);
+		kvfree(wnd->free_bits);
 		wnd->free_bits = new_free;
 	}
 
diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 6ff4f70ba0775..2636ab7640ace 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -778,7 +778,7 @@ static int ni_try_remove_attr_list(struct ntfs_inode *ni)
 	run_deallocate(sbi, &ni->attr_list.run, true);
 	run_close(&ni->attr_list.run);
 	ni->attr_list.size = 0;
-	kfree(ni->attr_list.le);
+	kvfree(ni->attr_list.le);
 	ni->attr_list.le = NULL;
 	ni->attr_list.dirty = false;
 
@@ -927,7 +927,7 @@ int ni_create_attr_list(struct ntfs_inode *ni)
 	return 0;
 
 out:
-	kfree(ni->attr_list.le);
+	kvfree(ni->attr_list.le);
 	ni->attr_list.le = NULL;
 	ni->attr_list.size = 0;
 	return err;
diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index 65ef4b57411f0..c55a29793a8d8 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -625,7 +625,7 @@ static void ntfs3_free_sbi(struct ntfs_sb_info *sbi)
 {
 	kfree(sbi->new_rec);
 	kvfree(ntfs_put_shared(sbi->upcase));
-	kfree(sbi->def_table);
+	kvfree(sbi->def_table);
 	kfree(sbi->compress.lznt);
 #ifdef CONFIG_NTFS3_LZX_XPRESS
 	xpress_free_decompressor(sbi->compress.xpress);
-- 
2.43.0



