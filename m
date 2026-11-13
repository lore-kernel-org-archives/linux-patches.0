Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591521;
	b=qE3qsySnm5XeboBxyN2D+mNQ1+oNgtUZomFI6mgEJ1aDsDFBOkRNVDW5U/pz/BUpofsm
	 E+dKNP+PReSBEX1Hv1EqZ96KLNk5X5ZxEa2hOb91o8ykKCqAdWKmLJ3yQx1gtXgAwMlhc
	 FjeizpK5kF7/tjD7ljkTPdPO16e7m+4jw79Csgr2jGlqXEIM+7dzXUMhSZXl4BOFuK+hz
	 RwqThBNsKbdwExQEg+9+LK3EzKGoGeE2UAShvH+af6ARiapGZA/0HAqBzSlyhGYTdhuVZ
	 9MjHRFHmeQdtPjZ++1ikkXl5H4oBi/y20up8tUIhmlhyh0VfhvFentj5A61D84IJdrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591521;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VQbaJMrf37eSuO9lUGG40uVCfu7j7xhm5XdwQu1F7gI=;
	b=FuZceTF7gAYz8QzyZwp2HO4PmdlkwKtsCfewypmjWm3TyXrmHzi+6wGG9BBfFCFne3Vp
	 Q5O+66ALO7VRr81FsoHbFU/yhRmEqP6Bd7h7Ai//DPD5Q9zLClqTOuKMS3VtoBA4xVWaS
	 Hf63h0grQI8YPybmYzxL9Uaa6pdph2aR9eID+aQGUIyAl0387Lwg32G0NSBbsIlrg/X9P
	 GDMdPGByvecZ18LQv33Y+iw/SsUW+lgI0X/sBXiVHKtvWmniUsuiLzaKRD9p6Po4u1cSf
	 jVL6sDqgxJhG7/EjovdPb3SRggNhif4yWiWSWkuxh24UgFn3svjIfLOh/T/CJGFRXoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=19phIKc4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEAC0606D49D;
	Fri, 13 Nov 2026 17:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=19phIKc4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E0A81F000C4;
	Fri, 13 Nov 2026 17:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591521;
	bh=VQbaJMrf37eSuO9lUGG40uVCfu7j7xhm5XdwQu1F7gI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=19phIKc4PuCxTgubCBRdKGk/YTwQXkXRzHakAAZK/q6Zkt94Dnuuv1M8TBbKwPD1g
	 o8CALHddLNPRRWq9ajscGjoMdTX5y1nEMC5cIYFZJK3oxAj0hWzZi5pUz13qvDBu74
	 OdWTqoXQry+AgxuoVYR7l6IwI/fl4iOvk/RBQ/OQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e8200299b0556976e13c@syzkaller.appspotmail.com,
	Joanne Koong <joannelkoong@gmail.com>,
	Horst Birthelmer <hbirthelmer@ddn.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 580/670] fuse: dont launder folios of a bad inode
Date: Fri, 13 Nov 2026 10:52:24 -0500
Message-ID: <20261113153831.498446655@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joanne Koong <joannelkoong@gmail.com>

[ Upstream commit 01d0f3d294af126f517d92c11e100525537f8be4 ]

fuse_flush() and fuse_writepages() reject writing back dirty data for
any inode that has been marked bad, but fuse_launder_folio() doesn't.

This can cause the following warning in fuse_write_file_get() to
trigger, as reported by syzbot:

WARNING: fs/fuse/file.c:2043 at fuse_write_file_get fs/fuse/file.c:2043 [inline]
WARNING: fs/fuse/file.c:2043 at fuse_iomap_writeback_range+0x7c8/0x18f0 fs/fuse/file.c:2227
Call Trace:
    iomap_writeback_folio+0x1526/0x2490 fs/iomap/buffered-io.c:2022
    fuse_launder_folio+0x17b/0x240 fs/fuse/file.c:2331
    folio_unmap_invalidate+0x4cd/0x830 mm/truncate.c:634
    invalidate_inode_pages2_range+0x629/0xb30 mm/truncate.c:726
    fuse_open+0x5a6/0x770 fs/fuse/file.c:297

This can be hit on a writeback cache mount:
1) a writeable file is open and a buffered write dirties some pages
2) another thread opens the same file read-only. fuse_open() passes the
   bad inode check and sends OPEN to the server.
3) a SETATTR reply with the wrong file type marks the inode bad
4) the writeable file is closed. Flush and release skip writeback
   because the inode is bad. The pages stay dirty but the file gets
   removed from write_files.
5) server replies to the OPEN. The reply has no FOPEN_KEEP_CACHE, so
   fuse_open() calls invalidate_inode_pages2().
6) the invalidation finds the dirty pages and calls
   fuse_launder_folio(), which finds no wriable file and hits the
   WARN_ON in fuse_write_file_get().

Instead of trying to write back dirty data for the bad inode,
fuse_launder_folio() should return -EIO.

Fixes: 5d069dbe8aaf ("fuse: fix bad inode")
Reported-by: syzbot+e8200299b0556976e13c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e8200299b0556976e13c
Cc: stable@vger.kernel.org
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Horst Birthelmer <hbirthelmer@ddn.com>
Tested-by: syzbot+e8200299b0556976e13c@syzkaller.appspotmail.com
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
[ sashal: Replaced wpc.inode with folio->mapping->host because the writeback implementation has no wpc object. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index d242613a1c8a0..97fcc5c136fcc 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2538,6 +2538,10 @@ static int fuse_write_end(struct file *file, struct address_space *mapping,
 static int fuse_launder_folio(struct folio *folio)
 {
 	int err = 0;
+
+	if (fuse_is_bad(folio->mapping->host))
+		return -EIO;
+
 	if (folio_clear_dirty_for_io(folio)) {
 		struct inode *inode = folio->mapping->host;
 
-- 
2.53.0



