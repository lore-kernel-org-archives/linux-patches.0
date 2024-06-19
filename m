Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11431474AD;
	Wed, 19 Jun 2024 13:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803630; cv=none; b=Jipgd6vfyC9QyG8hL+uLbV3+kmmEWmi32/VL/eRN6KlfP/HOsr1QSojUPDaRAfueiNIoEByz5qnmxywD/i6Z03vryoJXVdjzQ37/shod026HsmdSEB+zva2/c7aHIxueyUWq6aqwrJgupJ4y7oNVlbUItqZsmo2DnNobCPW4tyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803630; c=relaxed/simple;
	bh=zwWG6tJKF/JQvu/TxavtbkjH7cY5nDt8JCGIfTyZZSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q+ANqRZ/o+8i9sT8EzWj15UrFzLoMfdVa4XbLxb+sSd60IMHKdawCY8bePqDVDQzX7e9U8Z0tJJac/W4WQMjUjj1NIA2yi0D+GTmlcmn6y/QBDLPShVV0zwLzb2g3RxjP65crh0RZyaKP5rqWoYRN2tWxacturUuQ1w8esdbYso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RHuhsa3f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RHuhsa3f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298AEC2BBFC;
	Wed, 19 Jun 2024 13:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803630;
	bh=zwWG6tJKF/JQvu/TxavtbkjH7cY5nDt8JCGIfTyZZSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RHuhsa3fqwexITOdfSaWyKVGiBBG0TgGg23SSf2tWxDpbQoRWt49D3c5TO4cnXk41
	 6aG6oDhLBCeHkDcuvUJAwBWY6vPfNaYC4rVoisv7G9fCwUx8N6t1HtkXu1jmL8rC8p
	 ysqN+qWRIjfzPJzrQUeeS6m5aiGdu9sMgdw7mytM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 051/217] btrfs: fix wrong block_start calculation for btrfs_drop_extent_map_range()
Date: Wed, 19 Jun 2024 14:54:54 +0200
Message-ID: <20240619125558.633372546@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit fe1c6c7acce10baf9521d6dccc17268d91ee2305 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_map.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 56d7580fdc3c4..3518e638374ea 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -867,7 +867,7 @@ void btrfs_drop_extent_map_range(struct btrfs_inode *inode, u64 start, u64 end,
 					split->block_len = em->block_len;
 					split->orig_start = em->orig_start;
 				} else {
-					const u64 diff = start + len - em->start;
+					const u64 diff = end - em->start;
 
 					split->block_len = split->len;
 					split->block_start += diff;
-- 
2.43.0



