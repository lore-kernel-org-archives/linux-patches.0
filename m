Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8841012D1FD;
	Tue, 30 Apr 2024 11:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475553; cv=none; b=YzHBT0WajiEmf31flVttfgZtDV+SLsT5GYIK7M09OJtELZINuHYIRpZV0uFSfkqpVWrIkdRBEoYzLg77V4EYVG6r6xVhymz/udYNBZt9NwwgWWz1rdmJEs8Gg5CEFIwiWk9LaW/eweakiNGAef/Ibkvz4Nsb4JYrXrbcTLHqEx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475553; c=relaxed/simple;
	bh=xWd6e2lOp3M54BYZpG39L8icXcQ1Hvs/VCNRSGamfFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qQCTm0j4IxgkxJD9S/egJmdO2dVeXnPU0XyOjxM5Wv3CJGbhb+zw3mDSQiYj2ptsEzT1Ju0V5pYDT6kBRvnNYujdbLzcRzY48wRL/6Nk5wR19JVi4LhoKifiQQYeFuy0L3vgZQOuoen4dY5b9v1EvA6uXiicIoJu8t3ShJTqN3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vpF72JEg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vpF72JEg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B63C2BBFC;
	Tue, 30 Apr 2024 11:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475553;
	bh=xWd6e2lOp3M54BYZpG39L8icXcQ1Hvs/VCNRSGamfFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vpF72JEg+FuQVEWY8YmgfZUqe28k2m11Q+ZQf23ve/Yoihl+yPCdqaqU6hP//1NXr
	 i6ctV2pXadGNnr3bN3hTQVorNBFl4BKcrVbAQMDPwSEmC8cFMbzMYl06y83W72Jchh
	 YhextkKY7/Lr63SdLH+1ggGyaLMCenti/pbtPQJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 132/186] btrfs: fix wrong block_start calculation for btrfs_drop_extent_map_range()
Date: Tue, 30 Apr 2024 12:39:44 +0200
Message-ID: <20240430103101.862880896@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

From: Qu Wenruo <wqu@suse.com>

commit fe1c6c7acce10baf9521d6dccc17268d91ee2305 upstream.

[BUG]
During my extent_map cleanup/refactor, with extra sanity checks,
extent-map-tests::test_case_7() would not pass the checks.

The problem is, after btrfs_drop_extent_map_range(), the resulted
extent_map has a @block_start way too large.
Meanwhile my btrfs_file_extent_item based members are returning a
correct @disk_bytenr/@offset combination.

The extent map layout looks like this:

     0        16K    32K       48K
     | PINNED |      | Regular |

The regular em at [32K, 48K) also has 32K @block_start.

Then drop range [0, 36K), which should shrink the regular one to be
[36K, 48K).
However the @block_start is incorrect, we expect 32K + 4K, but got 52K.

[CAUSE]
Inside btrfs_drop_extent_map_range() function, if we hit an extent_map
that covers the target range but is still beyond it, we need to split
that extent map into half:

	|<-- drop range -->|
		 |<----- existing extent_map --->|

And if the extent map is not compressed, we need to forward
extent_map::block_start by the difference between the end of drop range
and the extent map start.

However in that particular case, the difference is calculated using
(start + len - em->start).

The problem is @start can be modified if the drop range covers any
pinned extent.

This leads to wrong calculation, and would be caught by my later
extent_map sanity checks, which checks the em::block_start against
btrfs_file_extent_item::disk_bytenr + btrfs_file_extent_item::offset.

This is a regression caused by commit c962098ca4af ("btrfs: fix
incorrect splitting in btrfs_drop_extent_map_range"), which removed the
@len update for pinned extents.

[FIX]
Fix it by avoiding using @start completely, and use @end - em->start
instead, which @end is exclusive bytenr number.

And update the test case to verify the @block_start to prevent such
problem from happening.

Thankfully this is not going to lead to any data corruption, as IO path
does not utilize btrfs_drop_extent_map_range() with @skip_pinned set.

So this fix is only here for the sake of consistency/correctness.

CC: stable@vger.kernel.org # 6.5+
Fixes: c962098ca4af ("btrfs: fix incorrect splitting in btrfs_drop_extent_map_range")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_map.c             |    2 +-
 fs/btrfs/tests/extent-map-tests.c |    5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -843,7 +843,7 @@ void btrfs_drop_extent_map_range(struct
 					split->block_len = em->block_len;
 					split->orig_start = em->orig_start;
 				} else {
-					const u64 diff = start + len - em->start;
+					const u64 diff = end - em->start;
 
 					split->block_len = split->len;
 					split->block_start += diff;
--- a/fs/btrfs/tests/extent-map-tests.c
+++ b/fs/btrfs/tests/extent-map-tests.c
@@ -826,6 +826,11 @@ static int test_case_7(void)
 		goto out;
 	}
 
+	if (em->block_start != SZ_32K + SZ_4K) {
+		test_err("em->block_start is %llu, expected 36K", em->block_start);
+		goto out;
+	}
+
 	free_extent_map(em);
 
 	read_lock(&em_tree->lock);


