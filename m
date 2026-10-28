Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216703;
	b=vfA5hwNdZ0roUmNluZyLhbKXPnsOgV6n/Wgwnxm3kBCBmF6Qe+x5RX8LEonvFyMvxrc1
	 L+zepMlCVxNiTGvx/PNHaxWIP8iAYBdLwWOhmDAVcAvHLdWeCEzQlH4taOXVbJNzkYOvq
	 YbCXyX/7d8vpEQb+YfJ7GIPuV7nYGP+155zzmVmmB29Ubx8Bvp+DRv/yRsvxEBbhxCJtV
	 135EYdlv2KAY+aRaGXOqNEoCKUILQKzeDXvvDKlBN1g3y5zOkHcl7ji1knqDCf284UAwk
	 6outr/f/aOjvS/rdB65F1gUO/a8JuBYLmW9Xrt6UMr9rpSKi1aIV3IaDknVFdMu+zZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216703;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=04WfB+kvISMn7P3H4UK++thEp8ntnS2muAHASZjq2mk=;
	b=nhlTksJe0ZDNfM2ubQf/O3SL4c6i0GqVQisWj72td6M9a9hP/cFp7sc9voZ32pRemDYI
	 5P9wCeKiQunmp7wDgLhWM/a7DabGUmEukUqr+PoOfg5y0DlwPvNdDUrXxCyJUjAUJ70kA
	 h7+LgB+1cTmk9sdTM6qzUcPKV2qtg0gXduHlra+y7CLea4tlmKQ5YbgaaeVVy/itAZ/pn
	 01TRJwU6odlmEkRXJDnZIkUqmrw67ELj9022qH6WUrYn/ewQxHyqdAFYYBPqsLks7LCtm
	 Yf6UpVivP0BF3/iCs1F90y5++phzOuAuZHH4cvpPu9PkE9RWytlEH5/XAMtdDy1EBfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nJ9GdjRF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878E3606A31E;
	Wed, 28 Oct 2026 19:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nJ9GdjRF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D82441F01825;
	Wed, 28 Oct 2026 19:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216702;
	bh=04WfB+kvISMn7P3H4UK++thEp8ntnS2muAHASZjq2mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nJ9GdjRFVICHPG8WBNoH40xAnVcR2UgNIEDV2eQsXFMS7bhSkr8hdIosqMtInYzO1
	 i8WE825i4/RP4/aR0qvYN890J3DOJHo9EN0AQrKpVB5wDF3ASXUGL0RCaivrKBCJI/
	 l2+n0iPLO30zoD4lOlKpQKQ0DOFDaCF24wU3fOLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8baf9a79a3ffc6271cb6@syzkaller.appspotmail.com,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1606/1887] nilfs2: fix BUG in nilfs_copy_dirty_pages() on dirty state mismatch
Date: Wed, 28 Oct 2026 18:01:42 +0100
Message-ID: <20261028170536.014601699@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

[ Upstream commit 66f4ad3ce158902e5f98afea93189972ed8750c2 ]

Syzbot reported a kernel BUG triggered within nilfs_copy_dirty_pages(),
which copies dirty DAT file folios/pages to its shadow page cache.  The
BUG occurs when a retrieved dirty folio/page unexpectedly loses its
'dirty' status.

This issue arises because, since the commit referenced below, the 'dirty'
flag of a folio/page can be cleared asynchronously after the filesystem
detects metadata corruption and transitions to read-only mode.

Resolve the issue by returning an -EROFS error if the filesystem has
transitioned to read-only mode.  Also change the behavior to issue a
kernel warning only once instead of triggering a kernel BUG when this
unexpected 'dirty' state is detected while the filesystem is not in
read-only mode.

Reported-by: syzbot+8baf9a79a3ffc6271cb6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=8baf9a79a3ffc6271cb6
Fixes: 8c26c4e2694a ("nilfs2: fix issue with flush kernel thread after remount in RO mode because of driver's internal error or metadata corruption")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/page.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index bf090240f6ede..89cd1510bf715 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -241,6 +241,7 @@ static void nilfs_copy_page(struct page *dst, struct page *src, int copy_dirty)
 int nilfs_copy_dirty_pages(struct address_space *dmap,
 			   struct address_space *smap)
 {
+	struct inode *smap_inode = smap->host;
 	struct pagevec pvec;
 	unsigned int i;
 	pgoff_t index = 0;
@@ -255,8 +256,19 @@ int nilfs_copy_dirty_pages(struct address_space *dmap,
 		struct page *page = pvec.pages[i], *dpage;
 
 		lock_page(page);
-		if (unlikely(!PageDirty(page)))
-			NILFS_PAGE_BUG(page, "inconsistent dirty state");
+		if (unlikely(!PageDirty(page))) {
+			if (WARN_ONCE(!sb_rdonly(smap_inode->i_sb),
+					"inconsistent dirty state\n"))
+				goto unlock_src_page;
+
+			/*
+			 * If the filesystem has been forced to read-only
+			 * due to metadata corruption.
+			 */
+			unlock_page(page);
+			err = -EROFS;
+			break;
+		}
 
 		dpage = grab_cache_page(dmap, page->index);
 		if (unlikely(!dpage)) {
@@ -274,6 +286,7 @@ int nilfs_copy_dirty_pages(struct address_space *dmap,
 
 		unlock_page(dpage);
 		put_page(dpage);
+unlock_src_page:
 		unlock_page(page);
 	}
 	pagevec_release(&pvec);
-- 
2.53.0



