Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C52FBEA
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:08:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245DEC433D2;
	Mon, 15 May 2023 17:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170510;
	bh=VvbzIsvkIzTwWjqkgzGR2Qaj+fOhxkfUaADbTHS3kV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NvXN/WJBAD+sC6RLk4DFPSWza/qOEpSUDlonco6U+/oQNsQxXp8c8V/c/VqwvRiws
	 J5/TmA7VHyL0plh+E5szJRlbXSpnyCrcE9FE4B54Xw4aBBUglImPRtsi4Z8orn6C+Z
	 7BLLuoJOvO043Vf+TFnPxGH2CXYhpmxdDOFxhUSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 114/239] btrfs: dont free qgroup space unless specified
Date: Mon, 15 May 2023 18:26:17 +0200
Message-Id: <20230515161725.118675461@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Josef Bacik <josef@toxicpanda.com>

commit d246331b78cbef86237f9c22389205bc9b4e1cc1 upstream.

Boris noticed in his simple quotas testing that he was getting a leak
with Sweet Tea's change to subvol create that stopped doing a
transaction commit.  This was just a side effect of that change.

In the delayed inode code we have an optimization that will free extra
reservations if we think we can pack a dir item into an already modified
leaf.  Previously this wouldn't be triggered in the subvolume create
case because we'd commit the transaction, it was still possible but
much harder to trigger.  It could actually be triggered if we did a
mkdir && subvol create with qgroups enabled.

This occurs because in btrfs_insert_delayed_dir_index(), which gets
called when we're adding the dir item, we do the following:

  btrfs_block_rsv_release(fs_info, trans->block_rsv, bytes, NULL);

if we're able to skip reserving space.

The problem here is that trans->block_rsv points at the temporary block
rsv for the subvolume create, which has qgroup reservations in the block
rsv.

This is a problem because btrfs_block_rsv_release() will do the
following:

  if (block_rsv->qgroup_rsv_reserved >= block_rsv->qgroup_rsv_size) {
	  qgroup_to_release = block_rsv->qgroup_rsv_reserved -
		  block_rsv->qgroup_rsv_size;
	  block_rsv->qgroup_rsv_reserved = block_rsv->qgroup_rsv_size;
  }

The temporary block rsv just has ->qgroup_rsv_reserved set,
->qgroup_rsv_size == 0.  The optimization in
btrfs_insert_delayed_dir_index() sets ->qgroup_rsv_reserved = 0.  Then
later on when we call btrfs_subvolume_release_metadata() which has

  btrfs_block_rsv_release(fs_info, rsv, (u64)-1, &qgroup_to_release);
  btrfs_qgroup_convert_reserved_meta(root, qgroup_to_release);

qgroup_to_release is set to 0, and we do not convert the reserved
metadata space.

The problem here is that the block rsv code has been unconditionally
messing with ->qgroup_rsv_reserved, because the main place this is used
is delalloc, and any time we call btrfs_block_rsv_release() we do it
with qgroup_to_release set, and thus do the proper accounting.

The subvolume code is the only other code that uses the qgroup
reservation stuff, but it's intermingled with the above optimization,
and thus was getting its reservation freed out from underneath it and
thus leaking the reserved space.

The solution is to simply not mess with the qgroup reservations if we
don't have qgroup_to_release set.  This works with the existing code as
anything that messes with the delalloc reservations always have
qgroup_to_release set.  This fixes the leak that Boris was observing.

Reviewed-by: Qu Wenruo <wqu@suse.com>
CC: stable@vger.kernel.org # 5.4+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-rsv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/block-rsv.c
+++ b/fs/btrfs/block-rsv.c
@@ -122,7 +122,8 @@ static u64 block_rsv_release_bytes(struc
 	} else {
 		num_bytes = 0;
 	}
-	if (block_rsv->qgroup_rsv_reserved >= block_rsv->qgroup_rsv_size) {
+	if (qgroup_to_release_ret &&
+	    block_rsv->qgroup_rsv_reserved >= block_rsv->qgroup_rsv_size) {
 		qgroup_to_release = block_rsv->qgroup_rsv_reserved -
 				    block_rsv->qgroup_rsv_size;
 		block_rsv->qgroup_rsv_reserved = block_rsv->qgroup_rsv_size;


