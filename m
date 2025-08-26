Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2639434166B;
	Tue, 26 Aug 2025 13:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216539; cv=none; b=PkIBus7hxIuNUGJOtGwEKmxZ5ZUJ434C8ocVom3N2P3g83Gjk6kpTiTnHGPtFrM6MjW4Ne7WsvXsttSjj9pP9QqitMicM1Wqleyn8u2L4naY4R2eTR3+EsIV8jk6k27PKGrqp+Hr+23OK9buDQDbLjyUka4qMlYWmb+xDAzgo1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216539; c=relaxed/simple;
	bh=IKLhSrHDBOUuk/00PQFswykzsFEptGL34YMoYeh2efA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IbMurQ/E3Qk7P9Tvp8AgayBZ2OBRayxb6cjgyGT2NiRQtLGCGmltg/E9LsBVTEuWWER4/ZwKDOiuD4OJzghBSoDFgAP4JpHQ9KL/zvd3+jqkDdrKfVOq+wCYVghIQ8Yi2niE/rgvbzRYW1oW5wlVz8ldafv0xX2WvdRyEHiGNxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lzFL3dw0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lzFL3dw0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E90C4CEF1;
	Tue, 26 Aug 2025 13:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216535;
	bh=IKLhSrHDBOUuk/00PQFswykzsFEptGL34YMoYeh2efA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lzFL3dw0GbmJ9viDNU0VJuzlOfmbPiubJdNa5NdJbGUlIHSfX+TjJyeEf0RVHpsZ9
	 4FUwKbsfJj4OBk5mX3Cox+rSny0Z10Av1V+IOCbGycoem1FV3ezRqLSI9fJwk93i4Y
	 nNvK3gkOGmesRiIjWbA9hzL8siK+EtTf33SB0+54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 448/644] btrfs: do not allow relocation of partially dropped subvolumes
Date: Tue, 26 Aug 2025 13:08:59 +0200
Message-ID: <20250826110957.574526244@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Qu Wenruo <wqu@suse.com>

commit 4289b494ac553e74e86fed1c66b2bf9530bc1082 upstream.

[BUG]
There is an internal report that balance triggered transaction abort,
with the following call trace:

  item 85 key (594509824 169 0) itemoff 12599 itemsize 33
          extent refs 1 gen 197740 flags 2
          ref#0: tree block backref root 7
  item 86 key (594558976 169 0) itemoff 12566 itemsize 33
          extent refs 1 gen 197522 flags 2
          ref#0: tree block backref root 7
 ...
 BTRFS error (device loop0): extent item not found for insert, bytenr 594526208 num_bytes 16384 parent 449921024 root_objectid 934 owner 1 offset 0
 BTRFS error (device loop0): failed to run delayed ref for logical 594526208 num_bytes 16384 type 182 action 1 ref_mod 1: -117
 ------------[ cut here ]------------
 BTRFS: Transaction aborted (error -117)
 WARNING: CPU: 1 PID: 6963 at ../fs/btrfs/extent-tree.c:2168 btrfs_run_delayed_refs+0xfa/0x110 [btrfs]

And btrfs check doesn't report anything wrong related to the extent
tree.

[CAUSE]
The cause is a little complex, firstly the extent tree indeed doesn't
have the backref for 594526208.

The extent tree only have the following two backrefs around that bytenr
on-disk:

        item 65 key (594509824 METADATA_ITEM 0) itemoff 13880 itemsize 33
                refs 1 gen 197740 flags TREE_BLOCK
                tree block skinny level 0
                (176 0x7) tree block backref root CSUM_TREE
        item 66 key (594558976 METADATA_ITEM 0) itemoff 13847 itemsize 33
                refs 1 gen 197522 flags TREE_BLOCK
                tree block skinny level 0
                (176 0x7) tree block backref root CSUM_TREE

But the such missing backref item is not an corruption on disk, as the
offending delayed ref belongs to subvolume 934, and that subvolume is
being dropped:

        item 0 key (934 ROOT_ITEM 198229) itemoff 15844 itemsize 439
                generation 198229 root_dirid 256 bytenr 10741039104 byte_limit 0 bytes_used 345571328
                last_snapshot 198229 flags 0x1000000000001(RDONLY) refs 0
                drop_progress key (206324 EXTENT_DATA 2711650304) drop_level 2
                level 2 generation_v2 198229

And that offending tree block 594526208 is inside the dropped range of
that subvolume.  That explains why there is no backref item for that
bytenr and why btrfs check is not reporting anything wrong.

But this also shows another problem, as btrfs will do all the orphan
subvolume cleanup at a read-write mount.

So half-dropped subvolume should not exist after an RW mount, and
balance itself is also exclusive to subvolume cleanup, meaning we
shouldn't hit a subvolume half-dropped during relocation.

The root cause is, there is no orphan item for this subvolume.
In fact there are 5 subvolumes from around 2021 that have the same
problem.

It looks like the original report has some older kernels running, and
caused those zombie subvolumes.

Thankfully upstream commit 8d488a8c7ba2 ("btrfs: fix subvolume/snapshot
deletion not triggered on mount") has long fixed the bug.

[ENHANCEMENT]
For repairing such old fs, btrfs-progs will be enhanced.

Considering how delayed the problem will show up (at run delayed ref
time) and at that time we have to abort transaction already, it is too
late.

Instead here we reject any half-dropped subvolume for reloc tree at the
earliest time, preventing confusion and extra time wasted on debugging
similar bugs.

CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/relocation.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -749,6 +749,25 @@ static struct btrfs_root *create_reloc_r
 	if (root->root_key.objectid == objectid) {
 		u64 commit_root_gen;
 
+		/*
+		 * Relocation will wait for cleaner thread, and any half-dropped
+		 * subvolume will be fully cleaned up at mount time.
+		 * So here we shouldn't hit a subvolume with non-zero drop_progress.
+		 *
+		 * If this isn't the case, error out since it can make us attempt to
+		 * drop references for extents that were already dropped before.
+		 */
+		if (unlikely(btrfs_disk_key_objectid(&root->root_item.drop_progress))) {
+			struct btrfs_key cpu_key;
+
+			btrfs_disk_key_to_cpu(&cpu_key, &root->root_item.drop_progress);
+			btrfs_err(fs_info,
+	"cannot relocate partially dropped subvolume %llu, drop progress key (%llu %u %llu)",
+				  objectid, cpu_key.objectid, cpu_key.type, cpu_key.offset);
+			ret = -EUCLEAN;
+			goto fail;
+		}
+
 		/* called by btrfs_init_reloc_root */
 		ret = btrfs_copy_root(trans, root, root->commit_root, &eb,
 				      BTRFS_TREE_RELOC_OBJECTID);


