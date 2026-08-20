Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633062DB788;
	Thu, 20 Aug 2026 17:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247517; cv=none; b=RbKHOX4XUHx8AM6OJQ8KYuWjY5hVr9YFafpePv2lE68VMQTdNsJgPLYsbTtgghZLvpS0+6y/b+215Rzhfmt+XG5LXF92i/uvqfPusyhej6WOJ42pzRBABGJ5D861KHjj0rASyFMweZ48sv3hLKH1PnVeEdq8BMQiMiYvCikGUos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247517; c=relaxed/simple;
	bh=Q+uQRxfkP+x67ZP6fBj0U2bLLJZ/JOzb+Fu7drkU59M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQvnjYYLJrGalaeDsbj23nW3QnK6eI/1CauxYkZwInNtqppqIGFCw5qzd7df1gP6F7yqqrluveuyRLTECkF9hFlXnjbdB4PB+1LM6WckUR2e/9QsvT5a85uG5vutgHp8+e/7KHSqcbAz3aej1dMiocp214tELUMyAv8AGPW5NGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pMlle0Lk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pMlle0Lk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B54931F000E9;
	Thu, 20 Aug 2026 17:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247516;
	bh=Qsxwf98eQatwxGunUbxJxK3HnHRb9j2h7KyAlZDnU8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pMlle0LkiLT/hJjmMEz8BlXwU2n+QJyJ2Rpa9OqJnsuypBIS+xJETO1M6bovH0UJ3
	 g7c/faz7hMt5lZV5/a4BEd0VVXtOxBSrzt2JeYdSALDOEpcZkXD+vfXlvD7RfHx9WH
	 qWsfWVTyqhowFM+lr8/RuFiMUhbQ+WhAx8L4cSrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 071/166] ceph: Remove ceph_writepage()
Date: Thu, 20 Aug 2026 16:55:30 +0200
Message-ID: <20260820145213.277695839@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

[ Upstream commit 19a288110435408fcf2cb274823f2a17d03caf9b ]

Ceph already has a writepages operation which is preferred over writepage
in all situations except for page migration.  By adding a migrate_folio
operation, there will be no situations in which ->writepage should
be called.  filemap_migrate_folio() is an appropriate operation to use
because the ceph data stored in folio->private does not contain any
reference to the memory address of the folio.

Signed-off-by: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Link: https://lore.kernel.org/r/20250217185119.430193-2-willy@infradead.org
Tested-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: cbf59617cd71 ("ceph: fix writeback_count leak in write_folio_nounlock()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/addr.c |   28 +---------------------------
 1 file changed, 1 insertion(+), 27 deletions(-)

--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -810,32 +810,6 @@ static int writepage_nounlock(struct pag
 	return err;
 }
 
-static int ceph_writepage(struct page *page, struct writeback_control *wbc)
-{
-	int err;
-	struct inode *inode = page->mapping->host;
-	BUG_ON(!inode);
-	ihold(inode);
-
-	if (wbc->sync_mode == WB_SYNC_NONE &&
-	    ceph_inode_to_fs_client(inode)->write_congested) {
-		redirty_page_for_writepage(wbc, page);
-		return AOP_WRITEPAGE_ACTIVATE;
-	}
-
-	wait_on_page_fscache(page);
-
-	err = writepage_nounlock(page, wbc);
-	if (err == -ERESTARTSYS) {
-		/* direct memory reclaimer was killed by SIGKILL. return 0
-		 * to prevent caller from setting mapping/page error */
-		err = 0;
-	}
-	unlock_page(page);
-	iput(inode);
-	return err;
-}
-
 /*
  * async writeback completion handler.
  *
@@ -1586,7 +1560,6 @@ out:
 const struct address_space_operations ceph_aops = {
 	.read_folio = netfs_read_folio,
 	.readahead = netfs_readahead,
-	.writepage = ceph_writepage,
 	.writepages = ceph_writepages_start,
 	.write_begin = ceph_write_begin,
 	.write_end = ceph_write_end,
@@ -1594,6 +1567,7 @@ const struct address_space_operations ce
 	.invalidate_folio = ceph_invalidate_folio,
 	.release_folio = ceph_release_folio,
 	.direct_IO = noop_direct_IO,
+	.migrate_folio = filemap_migrate_folio,
 };
 
 static void ceph_block_sigs(sigset_t *oldset)


