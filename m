Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEFF61684A3;
	Tue, 15 Oct 2024 11:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992162; cv=none; b=otOG4v0/RFTTOlVvFPCLOmggq4bT6voMpL8sJUmY2QNAVBbv0UgQYcUGMIp2P0GQwToLPBuwDaPpmzTyAkk0TcAgJqOVjOu2IUw+hxwq4piUGYPEMaNRsh0dPFoolFLbP8hA68TESQktLM0bBhssuc12OElAxEIPiqIjTTGdEwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992162; c=relaxed/simple;
	bh=eiH5NKNk2R6M5lUauimTUnDMNmkNxMdkDpBWyeX4qqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AmIBEDA8NLl9tfKolJqUXjDxOfDUlQt84mK8B2skw1cRZY0+d61UdKFucu3i33yM7Q3HZ4EppT8J5TXwg7YdoWXakLxDOav8NBNX6YsvJbhWPdNO6xcCDnfH2hcZKo3FsiI82rxYNY8NLhaAEzme+UboD1cO1OTOZpYVxCm3Xxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Kh4YiuJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Kh4YiuJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EDE1C4CEC6;
	Tue, 15 Oct 2024 11:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992162;
	bh=eiH5NKNk2R6M5lUauimTUnDMNmkNxMdkDpBWyeX4qqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Kh4YiuJ4X0OM/i6S0ThXr/sW4yTjsG6dgRSwH3fJfG9yKZgkC/ES6pHTFwNvWHX6
	 BszkMxz/kAYU+aWMSDDNODUDSyJiUkvO4GSb3fLm07j3q6Jo2rzFrxcDSLT+OOd3Nu
	 TVXEe/XvHcY3Y4WbK3RW8Ipz+FLc4bMwwbbjY6wU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 5.15 036/691] fs/ntfs3: Use kvfree to free memory allocated by kvmalloc
Date: Tue, 15 Oct 2024 13:19:44 +0200
Message-ID: <20241015112441.771581052@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -129,7 +129,7 @@ void wnd_close(struct wnd_bitmap *wnd)
 {
 	struct rb_node *node, *next;
 
-	kfree(wnd->free_bits);
+	kvfree(wnd->free_bits);
 	run_close(&wnd->run);
 
 	node = rb_first(&wnd->start_tree);
@@ -1340,7 +1340,7 @@ int wnd_extend(struct wnd_bitmap *wnd, s
 			       wnd->nwnd * sizeof(short));
 		memset(new_free + wnd->nwnd, 0,
 		       (new_wnd - wnd->nwnd) * sizeof(short));
-		kfree(wnd->free_bits);
+		kvfree(wnd->free_bits);
 		wnd->free_bits = new_free;
 	}
 
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -750,7 +750,7 @@ static int ni_try_remove_attr_list(struc
 	run_deallocate(sbi, &ni->attr_list.run, true);
 	run_close(&ni->attr_list.run);
 	ni->attr_list.size = 0;
-	kfree(ni->attr_list.le);
+	kvfree(ni->attr_list.le);
 	ni->attr_list.le = NULL;
 	ni->attr_list.dirty = false;
 
@@ -899,7 +899,7 @@ int ni_create_attr_list(struct ntfs_inod
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


