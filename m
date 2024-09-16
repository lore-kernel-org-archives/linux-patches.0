Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D6A156238;
	Mon, 16 Sep 2024 12:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488027; cv=none; b=O0is6ch3BsP8ee8OmdNS9+s6l50cQKVYrHr/npnCg1pzIFySvgz9ukmZoGuz9u/uFQjLUAcVr8QsJCXr5lHmTUpgVS+VScImgrXR72iV5+17d4FVOyEoXAfK93QhViTqM2zo25MnI34Kg67RiNu5Bk0tOpsT03dbsU1X0Hhyqks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488027; c=relaxed/simple;
	bh=oVbttgLz8i3k3BrEr1bJruxpen+kMNUhng4yvaloj2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lr6VQrMPZU4/F9YM8ihzN5EvyeGHIYULWkVHgWgVs0Fo0gfwmcowAHAbvyaZALLh1dZSiObzGWbfUedOziff/EGLUuNtaI+3SYK3bnZtONZonqW2z2QLmj3VDP4kHzn4HTMAL1p+dakwWaImHVX651H9m0/Rr+A4+YWOhST7OhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=soTpJ5Xj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="soTpJ5Xj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80494C4CEC4;
	Mon, 16 Sep 2024 12:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488025;
	bh=oVbttgLz8i3k3BrEr1bJruxpen+kMNUhng4yvaloj2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=soTpJ5XjJQknyYQ7gcbE+3owq2AD0cuqLmaxnLG/I8VXUXY+Z/gZV7ixfYaXi/4vT
	 a33Vuhhfa6DAqf6dMUqY1KIgIynCKjBuL9KFKl2jdESNynGmxQYiHm9OVIKBLmMpTY
	 C5tuq/eiV5/BtcfIuQQe+lgbM1AFPDBnE19hlVmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.1 32/63] fs/ntfs3: Use kvfree to free memory allocated by kvmalloc
Date: Mon, 16 Sep 2024 13:44:11 +0200
Message-ID: <20240916114222.210184156@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114221.021192667@linuxfoundation.org>
References: <20240916114221.021192667@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

commit ddb17dc880eeaac37b5a6e984de07b882de7d78d upstream.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/attrlist.c |    4 ++--
 fs/ntfs3/bitmap.c   |    4 ++--
 fs/ntfs3/frecord.c  |    4 ++--
 fs/ntfs3/super.c    |    2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

--- a/fs/ntfs3/attrlist.c
+++ b/fs/ntfs3/attrlist.c
@@ -29,7 +29,7 @@ static inline bool al_is_valid_le(const
 void al_destroy(struct ntfs_inode *ni)
 {
 	run_close(&ni->attr_list.run);
-	kfree(ni->attr_list.le);
+	kvfree(ni->attr_list.le);
 	ni->attr_list.le = NULL;
 	ni->attr_list.size = 0;
 	ni->attr_list.dirty = false;
@@ -318,7 +318,7 @@ int al_add_le(struct ntfs_inode *ni, enu
 		memcpy(ptr, al->le, off);
 		memcpy(Add2Ptr(ptr, off + sz), le, old_size - off);
 		le = Add2Ptr(ptr, off);
-		kfree(al->le);
+		kvfree(al->le);
 		al->le = ptr;
 	} else {
 		memmove(Add2Ptr(le, sz), le, old_size - off);
--- a/fs/ntfs3/bitmap.c
+++ b/fs/ntfs3/bitmap.c
@@ -124,7 +124,7 @@ void wnd_close(struct wnd_bitmap *wnd)
 {
 	struct rb_node *node, *next;
 
-	kfree(wnd->free_bits);
+	kvfree(wnd->free_bits);
 	run_close(&wnd->run);
 
 	node = rb_first(&wnd->start_tree);
@@ -1333,7 +1333,7 @@ int wnd_extend(struct wnd_bitmap *wnd, s
 		memcpy(new_free, wnd->free_bits, wnd->nwnd * sizeof(short));
 		memset(new_free + wnd->nwnd, 0,
 		       (new_wnd - wnd->nwnd) * sizeof(short));
-		kfree(wnd->free_bits);
+		kvfree(wnd->free_bits);
 		wnd->free_bits = new_free;
 	}
 
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -773,7 +773,7 @@ static int ni_try_remove_attr_list(struc
 	run_deallocate(sbi, &ni->attr_list.run, true);
 	run_close(&ni->attr_list.run);
 	ni->attr_list.size = 0;
-	kfree(ni->attr_list.le);
+	kvfree(ni->attr_list.le);
 	ni->attr_list.le = NULL;
 	ni->attr_list.dirty = false;
 
@@ -924,7 +924,7 @@ int ni_create_attr_list(struct ntfs_inod
 	goto out;
 
 out1:
-	kfree(ni->attr_list.le);
+	kvfree(ni->attr_list.le);
 	ni->attr_list.le = NULL;
 	ni->attr_list.size = 0;
 	return err;
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -441,7 +441,7 @@ static noinline void put_ntfs(struct ntf
 {
 	kfree(sbi->new_rec);
 	kvfree(ntfs_put_shared(sbi->upcase));
-	kfree(sbi->def_table);
+	kvfree(sbi->def_table);
 
 	wnd_close(&sbi->mft.bitmap);
 	wnd_close(&sbi->used.bitmap);


