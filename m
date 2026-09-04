Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B927B3F7AA9;
	Fri,  4 Sep 2026 05:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499016; cv=none; b=BRRJ8EakrpFxNydDVzU0pc3XJIHnxfTABydPjGaQz+Z8HVU5EKxne17CVaVApBRYe0TGE9YMSIyQn7smbAsOHHGJpShQZD+6TWzkgCAADCyoTgHSAP+NnDJUF4GOA7k3XzZ2oFfbJu5AZ3CT7DH7m2X3NjKfvdeZTnZPuco5Cnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499016; c=relaxed/simple;
	bh=0Qa2Zj6e/WdqDDk35MTCwnmCQns4B9lmEy5ZjKw00iM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZ9UFk/97EbuRUzb+bh1QsEijlYCndf9ZXRDHRFbhl8o2QvF1SO/2yQJL1S1DNCcdO8DoksBh92Gs/aFNCuOShxqbpayQBc+m1Y50RTJebzP0ahVu3HGWjGIegoXDyFSoYx5hwn/eg4HHYS3JZeWkDTdI+1wyqr+uZbaDAhmJZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JyDAJ+nH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JyDAJ+nH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139D01F00A3D;
	Fri,  4 Sep 2026 05:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499015;
	bh=H7ESWBRcj1om9Ak06vLiMQWZTjWVpbJRSgXP/EX7Z8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JyDAJ+nHJa4aKL2VfU5F/LVA/Qc8n2DK047T0sFVVKx2SbowlKFxUAE+K0fIf+GbV
	 /zzpY/b3D8NkK+PzHL04XdgF6ZqkoXJbDSesKieQ3XdBT6OHGJUqhitrOvk3tT2tFC
	 k8zkCtleKYNm6+7PQ95sJFMhEcHvgklEt+4kkw1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brown <matthew@bargrove.com>,
	Xiubo Li <xiubo.li@clyso.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 7.2 225/713] ceph: fix leaked inode reference on writeback abort at umount
Date: Fri,  4 Sep 2026 06:53:13 +0200
Message-ID: <20260904045808.863122646@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Matthew Brown <matthew@bargrove.com>

commit c25aee9c630fb86f98d79eccb75765067079b972 upstream.

ceph_dirty_folio() takes a wrbuffer claim on each newly dirtied folio: it
bumps i_wrbuffer_ref (taking an ihold() on the 0->1 transition) and
attaches the snap_context to folio->private.  That claim is released only
by ceph_put_wrbuffer_cap_refs(), which for a submitted write runs from
writepages_finish().

In ceph_submit_write(), if ceph_inc_osd_stopping_blocker() fails -- which
happens during umount -- the request is aborted before submission: the
already-collected folios are only redirtied and unlocked, so
writepages_finish() never runs and the claim is leaked.
redirty_page_for_writepage() -> folio_redirty_for_writepage() ->
filemap_dirty_folio() sets PG_dirty directly and does not go through
->dirty_folio, so ceph_dirty_folio() is not re-entered to rebalance it.
Because every subsequent writeback also fails the osd_stopping_blocker,
i_wrbuffer_ref never returns to 0, the ihold() is never dropped, and the
inode cannot be evicted:

  VFS: Busy inodes after unmount of ceph
  kernel BUG at fs/super.c:650!

Release the orphaned claim in the abort path before redirtying, via
ceph_undo_wrbuffer_claim(): detach the snap_context, drop the wrbuffer
reference (letting i_wrbuffer_ref reach 0 and iput() the inode), and drop
the snap_context reference -- i.e. do what writepages_finish() would have
done for these never-submitted folios.

Only the locked_pages entries are undone; folios still in the fbatch were
never dirty-cleared by this call (folio_clear_dirty_for_io() is the
ownership-transfer point, and a successful move NULLs the fbatch slot), so
they hold no claim this call owns.

Cc: stable@vger.kernel.org
Fixes: fd7449d937e7 ("ceph: fix generic/421 test failure")
Signed-off-by: Matthew Brown <matthew@bargrove.com>
Reviewed-by: Xiubo Li <xiubo.li@clyso.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/addr.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1426,6 +1426,16 @@ void ceph_shift_unused_folios_left(struc
 	fbatch->nr = n;
 }
 
+static void ceph_undo_wrbuffer_claim(struct inode *inode, struct folio *folio)
+{
+	struct ceph_snap_context *snapc = folio_detach_private(folio);
+
+	if (!snapc)
+		return;
+	ceph_put_wrbuffer_cap_refs(ceph_inode(inode), 1, snapc);
+	ceph_put_snap_context(snapc);
+}
+
 static
 int ceph_submit_write(struct address_space *mapping,
 			struct writeback_control *wbc,
@@ -1489,6 +1499,7 @@ new_request:
 			if (!page)
 				continue;
 
+			ceph_undo_wrbuffer_claim(inode, page_folio(page));
 			redirty_page_for_writepage(wbc, page);
 			unlock_page(page);
 		}


