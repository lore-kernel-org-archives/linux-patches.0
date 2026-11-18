Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033392;
	b=Ws+KdDBHUB+LCa56i0p9Lv4xGCZ3v3oq4rlwmk3qTN6nxXKa42s+/Fu53kCs/I0zuq4O
	 tFPqK5j7CLBLhQ8T5nXfr0W8lp28tSX9UaqXgh4uKczt+QmNX0GXgCHFEChfy9KOA/fj6
	 S2Wmqe7zingOx65JW3MhHExj+PbST5WeCGN1ipb6t0rOuCB3HR01UpjSImeCwzLsKoifv
	 95PC3FL2Iik8JKnPqEFeRKouBmnAaoR2T1g3s2IPLkrELHLV4I+Z08LarjezPk4fcunpn
	 kjaBS1DrnKunRVWWIq1U9hZHK1OkPesfgg84anLrIiCUOmBmBgawDBL3u4cmd4ov2hQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033392;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0IWJxIr99iPYOiEi86SQpgkurJjbvhYrvCpdx3MCrHk=;
	b=0dkySRP25bfS8WPpaBkGkuH/awj+hJt8hqWiA/4OKr/QHkTEaSMlj58zvODL3I7MeOm4
	 uSOjS6MaqhpenZgnpDhZV1ejTxSPM1gm4Cx9+lVi9ocdscKisDL+BG3FyrZA+m3usYYZz
	 BrAYVyEe8StJ/UJV8afjmvm0+mFaSmlaxwnMg3/spqylsz2VAU9NSt23XwkIKOVbC4OZG
	 0TtxSB9VkZhizi/EDE+dSanUtvR7AXjebyrJ5MbLuuiTj/TkZayYYDF2D1HZzde0Df/gL
	 PhTKY5vaZFpU3xaGx7D+X+B/tJusTAy7h5zs0JXp3J5jf/mEKg5d9aWqtehKE4IvG/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZnLOFC03;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF19606A330;
	Wed, 18 Nov 2026 20:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZnLOFC03
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E2471F000C4;
	Wed, 18 Nov 2026 20:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033392;
	bh=0IWJxIr99iPYOiEi86SQpgkurJjbvhYrvCpdx3MCrHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZnLOFC039+9oPRTM88nsL5P3kJPboRzP+96WHYdB2eMP2QzfdDPGbom5bPeq1VhuF
	 lZPZ6j6P4699m6k9jR+e+P7j9/VSiOSsuXra6+2GZumdLnrr4nI7r8zqMQEZ0SjKj9
	 OLRp56tZCtaJfZH0EQdT4hg3hrB5/D5/RYNzzYEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brown <matthew@bargrove.com>,
	Xiubo Li <xiubo.li@clyso.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.12 1753/1756] ceph: fix leaked inode reference on writeback abort at umount
Date: Wed, 18 Nov 2026 16:04:40 +0100
Message-ID: <20261118150119.316016167@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
@@ -1431,6 +1431,16 @@ void ceph_shift_unused_folios_left(struc
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
@@ -1488,6 +1498,7 @@ new_request:
 			    CONGESTION_OFF_THRESH(fsc->mount_options->congestion_kb))
 				fsc->write_congested = false;
 
+			ceph_undo_wrbuffer_claim(inode, page_folio(page));
 			redirty_page_for_writepage(wbc, page);
 			unlock_page(page);
 			put_page(page);


