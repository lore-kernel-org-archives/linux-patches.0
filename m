Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D631B14533F;
	Tue, 27 Feb 2024 13:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041829; cv=none; b=Hi40W1knhCEEfmxajsoD5GGhV1IfwkaOmHa2cGd1SFU3BcFUFS9Bb/YavYHlJtBa5m4YK000/V9auq5oDCpoJz7vZTRF6PVjn1AGets0953F/ly4S5174nKyMDA9A2/ZWEpC4m2uk/MQtX4l7/g/N9JGD4pz6F+PGbM2U7AFNkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041829; c=relaxed/simple;
	bh=dG9vs8dgF/GJI7msYmFpMrH7uB64/BPp9S1SlZmdfjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LBo0q0Ae0iTQ+qBxv0wXpwRzY+J0JROLSvgnE48Nk2XRxeD6NbGrvkE0xOQh4FUAu3nJS26AcF2jQ+rt8tUbyMlyOViuKI8AvjkAYiv5hAeilzWJP2f0lXxs33FM6qs22NfLa1lwS3X5NY9cFH0Xx3XzuMs3ebBlUUIF2LhgqeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZuVVXb/V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZuVVXb/V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D7CC43390;
	Tue, 27 Feb 2024 13:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041829;
	bh=dG9vs8dgF/GJI7msYmFpMrH7uB64/BPp9S1SlZmdfjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZuVVXb/VFiYbkaMBQ4WXEOn2OTrFHx+LbjrYV1mnUbNEKCsuc4V+PTEk63rqyBOvy
	 9OBdmYAOqVA009Pg8fwegsx3aCOvCZanaqkZf2vPNTfeGm27nAtcydr6Q+btxhNrYw
	 HTu0TPiQoHF3Z3mxnRJQ1D9R8iLCIzuMZryGSyt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 084/299] fs/ntfs3: Use kvfree to free memory allocated by kvmalloc
Date: Tue, 27 Feb 2024 14:23:15 +0100
Message-ID: <20240227131628.623246529@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 86b43051f39cd..a918d7283aca5 100644
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
index 378e261e23b04..eb50602297406 100644
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



