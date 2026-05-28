Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA19019A288;
	Thu, 28 May 2026 20:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999927; cv=none; b=bn71b//N0rLd5mx+LJxC2msuLatl9tO2LgWKy8XShfSK19lAahmy59fkIM+is4VVFjGEHma/gFbr+Ldo1+LyK9eUSUwUCYBe0hX2Qh/e3qPgYUCBNbQWqQlOcsuwV8qL8/Als80D3I8o/FWQZcUiIdTXwZqWGlkz3JHu4dPZ3Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999927; c=relaxed/simple;
	bh=VvzhUzs9CBahCvfThonfTW5mh2MxGktGIv+aZaXOUW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gj6/8u7b5Kqclbuaqk7DBjOh4/Fm8lbV2r49iYa0od0r1fDEvhR4Kh54kX8folo+737205+PKbD2LMv36vScizWfXhI9x+vkWEYWWMWM/14dGUAHZwP0292Nxqnb8bTlJEIu6A1WVCp3yG8tzSRBYU5boMkLPhVr8FsZEBWyjUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0UbLTt+s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0UbLTt+s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423201F000E9;
	Thu, 28 May 2026 20:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999925;
	bh=OJlYAQfonkh7X4p8SsDWEdTrGuDZKpyrJwPQArxwiTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0UbLTt+sReO05qnoszaGBU2dvE9XlLJJW0o+cye3h2fp4HaAotNvysrAfMeDkW34R
	 UNSEOCbdRgdymTUzoJS6Q0zOX9NnlA7ZPpSSM+eXLbkGG2HGbyUvkDVuCilHNlda13
	 LnbXEqEx20w7lHzPIgKqqV1YJyW2/nVMTNaQAOfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Matthew Wilcox <willy@infradead.org>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 241/377] netfs: Fix read-gaps to remove netfs_folio from filled folio
Date: Thu, 28 May 2026 21:47:59 +0200
Message-ID: <20260528194645.364013894@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit a41168aef634356a9b87ec44349e3c82835700a5 ]

Fix netfs_read_gaps() to remove the netfs_folio record from the folio
record before marking the folio uptodate if it successfully fills the gaps
around the dirty data in a streaming write folio (dirty, but not uptodate).

Found with:

    fsx -q -N 1000000 -p 10000 -o 128000 -l 600000 \
        /xfstest.test/junk --replay-ops=junk.fsxops

using the following as junk.fsxops:

    truncate 0x0 0x138b1 0x8b15d *
    write 0x507ee 0x10df7 0x927c0
    write 0x19993 0x10e04 0x927c0 *
    mapwrite 0x66214 0x1a253 0x927c0
    copy_range 0xb704 0x89b9 0x24429 0x79380
    write 0x2402b 0x144a2 0x90660 *
    mapwrite 0x204d5 0x140a0 0x927c0 *
    copy_range 0x1f72c 0x137d0 0x7a906 0x927c0 *
    read 0 0x9157c 0x9157c

on cifs with the default cache option.

It shows folio 0x24 misbehaving if the FMODE_READ check is commented out in
netfs_perform_write():

                if (//(file->f_mode & FMODE_READ) ||
                    netfs_is_cache_enabled(ctx)) {

and no fscache.  This was initially found with the generic/522 xfstest.

Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260512123404.719402-16-dhowells@redhat.com
Fixes: ee4cdf7ba857 ("netfs: Speed up buffered reading")
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/buffered_read.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index e6157122da3a4..3531c19eea97a 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -394,6 +394,7 @@ static int netfs_read_gaps(struct file *file, struct folio *folio)
 {
 	struct netfs_io_request *rreq;
 	struct address_space *mapping = folio->mapping;
+	struct netfs_group *group = netfs_folio_group(folio);
 	struct netfs_folio *finfo = netfs_folio_info(folio);
 	struct netfs_inode *ctx = netfs_inode(mapping->host);
 	struct folio *sink = NULL;
@@ -460,6 +461,12 @@ static int netfs_read_gaps(struct file *file, struct folio *folio)
 
 	ret = netfs_wait_for_read(rreq);
 	if (ret >= 0) {
+		if (group)
+			folio_change_private(folio, group);
+		else
+			folio_detach_private(folio);
+		kfree(finfo);
+		trace_netfs_folio(folio, netfs_folio_trace_filled_gaps);
 		flush_dcache_folio(folio);
 		folio_mark_uptodate(folio);
 	}
@@ -495,10 +502,8 @@ int netfs_read_folio(struct file *file, struct folio *folio)
 	struct netfs_inode *ctx = netfs_inode(mapping->host);
 	int ret;
 
-	if (folio_test_dirty(folio)) {
-		trace_netfs_folio(folio, netfs_folio_trace_read_gaps);
+	if (folio_test_dirty(folio))
 		return netfs_read_gaps(file, folio);
-	}
 
 	_enter("%lx", folio->index);
 
-- 
2.53.0



