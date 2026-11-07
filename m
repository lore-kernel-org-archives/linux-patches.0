Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063454;
	b=DDhuadAMDBkBK3Z/iLTQIVJhV+DiYS/fy6f/ta2vv2DSVLyvGvYmi5EqKTc0ptZz9ye0
	 qMiDtyQ8ZKcEdDw0dfzkBGHIlqPsDgn2ofcRpjLGtYcYF9aK8Ku54BIjsAzwV3fGXb8UM
	 Tmr5IhUmLKywRqPM7k7lVzGpaPV/893CMKwrD83Cz6z7/+0CZUgFTPoZapOc+7B6Shm3L
	 fJmv0krSVbjdZRp5UJRaquzYbVj4873b80UJxZjKttOAhUBlHpQFNcdziK+RXLbq9XKA4
	 R9Pgt0hVeemrUshyn9pxALgwitwf9J6D5+k6R7/WZ1fqItVxSVmI8Zth5j4CBsINKhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063454;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eTSFVsNiv8fNqOt5G64S/Y/VNqxdwM+QqcJFbRf6IFo=;
	b=iocJX2AFRIHTnBJ3nvFDkET0mLG5jXBFkUwGSoMGz4XGs2BOT4GPbVLcGvyWc3VFcu03
	 WtJEubsmb/BiNV9QrgBbYwVU3pecL5Z1Ow9A2XpMH9XcBt/NRZrdzqdBm6Gycl7rLBZyE
	 8lpK8e6i0f5ZisJ1wiofGXHKSr56G5mLtUWvqDRMRlynUwQPOmrNddzbixeRhPrS1pH4k
	 ywfwutubCfpoU9Z8x1jY3hrhO3AZOA7U0gigsRXoR+w7exAJtvL29TIQDl9/SVDWYY1Fu
	 9k7u/14kmrlwtsvjaInHS0VJeT9geQdjoWp6/0EthuVuGwfbKfRP2YgmafYddldi/Ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nSWgNbnl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6A160A381E;
	Sat,  7 Nov 2026 14:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nSWgNbnl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6461F008A1;
	Sat,  7 Nov 2026 14:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063453;
	bh=eTSFVsNiv8fNqOt5G64S/Y/VNqxdwM+QqcJFbRf6IFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nSWgNbnloSS551z+cJtF+feAUtp9TWzxRVN0EBIb3gUmWla+oTBcRZdf3ayTY8vCX
	 uhUayqzC7aWGDCplFexymE4NZrlDWBP8xs8tCfKxPdY/vTqDADbnRH+PEpA9TDBo4j
	 sDdjcWn/Vw1SDygUpbiwOyCczoOl8EjKXQrGJSEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e8200299b0556976e13c@syzkaller.appspotmail.com,
	Joanne Koong <joannelkoong@gmail.com>,
	Horst Birthelmer <hbirthelmer@ddn.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 611/869] fuse: dont launder folios of a bad inode
Date: Sat,  7 Nov 2026 08:54:53 -0500
Message-ID: <20261107134913.788882122@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 18a3ef3a96953..22b3f37ec88b8 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2271,6 +2271,9 @@ static int fuse_launder_folio(struct folio *folio)
 		.wb_ctx	= &data,
 	};
 
+	if (fuse_is_bad(wpc.inode))
+		return -EIO;
+
 	if (folio_clear_dirty_for_io(folio)) {
 		err = iomap_writeback_folio(&wpc, folio);
 		err = fuse_iomap_writeback_submit(&wpc, err);
-- 
2.53.0



