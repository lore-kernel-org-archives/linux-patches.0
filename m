Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF33046AA89;
	Tue, 21 Jul 2026 15:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649518; cv=none; b=ZRaqpuha0P473DkRfDrTe63/kquqbUH0NhAsanLl/i/4ObgJ3i26hDVX4fqLB/lQaMKIjZjxk2odp1IwImdrcYGc0umnvhSCsBMiAfXPfZXpwk8i5H/Qdby4hcGNsgVArBE9aguseSY2i2M+sscimQBoShzvxNDQhmoYRT+xSUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649518; c=relaxed/simple;
	bh=9jOhz6hFPnomezDtv6CoRuo2feyQt9+wpGtJgpR4Bt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NHUlsfldYyk7LyTE7iWbNvsQy9D7Z/qx/GAeP8QAoOLgk5pnCK9ICmro3btsdW9taaAuGBAL7HUXUmIaeONx9JdXGPqPUUguob5ucTqcpATvkLwEXGG9h/C3R28+otW2J9vYNAJmh69xUd1s0DqRtlgn+OPDJUb0Ba7NKXusuPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MmnqpZQz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MmnqpZQz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E97C1F000E9;
	Tue, 21 Jul 2026 15:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649516;
	bh=S1aLFx+x0If/D0odCnZkWUnWQTNvPGJF9dk+E3Liov0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MmnqpZQz2yzekmP3oADDl+1zWqsSi3czRilXorv88D6cgbvBo/If82rrFKdlTmua0
	 eT8U21GWZRdzfdlG43dIC5w1Z/0NDaP4WIj5tkvyjpPQC/KtOigkL/2Q8vvuTxY1rs
	 9vuQFYffNLP98XSyC8VM6vpSCUoZN0dArjVKxvQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0609/2077] btrfs: zoned: fix deadlock waiting for ticket during data relocation
Date: Tue, 21 Jul 2026 17:04:42 +0200
Message-ID: <20260721152607.171895338@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit 814c3b4ea357297c507158bceb07bcdc5fbe9808 ]

When performing data relocation on a zoned filesystem, BTRFS can deadlock
in handle_reserve_tickets(). The relocation process is waiting on a space
reservation ticket that can never be fulfilled, because the relocation
itself is the operation responsible for freeing up that space.

Fix this by introducing a new flush state,
BTRFS_RESERVE_FLUSH_ZONED_RELOCATION, specifically for data chunk
allocation during zoned relocation. Like
BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE, this state uses
priority_reclaim_data_space() instead of the normal flushing path, which
avoids re-entering the relocation code and breaking the deadlock cycle.

In btrfs_alloc_data_chunk_ondemand(), select this new flush state when the
inode belongs to a data relocation root on a zoned filesystem.

Fixes: e2a7fd22378f ("btrfs: zoned: add zone reclaim flush state for DATA space_info")
Reviewed-by: Boris Burkov <boris@bur.io>
Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/delalloc-space.c |  2 ++
 fs/btrfs/space-info.c     |  2 ++
 fs/btrfs/space-info.h     | 11 +++++++++++
 3 files changed, 15 insertions(+)

diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
index 0970799d0aa443..4293a63834337f 100644
--- a/fs/btrfs/delalloc-space.c
+++ b/fs/btrfs/delalloc-space.c
@@ -134,6 +134,8 @@ int btrfs_alloc_data_chunk_ondemand(const struct btrfs_inode *inode, u64 bytes)
 
 	if (btrfs_is_free_space_inode(inode))
 		flush = BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE;
+	else if (btrfs_is_zoned(fs_info) && btrfs_is_data_reloc_root(root))
+		flush = BTRFS_RESERVE_FLUSH_ZONED_RELOCATION;
 
 	return btrfs_reserve_data_bytes(data_sinfo_for_inode(inode), bytes, flush);
 }
diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index f0436eea15445b..e7a5cf50caa4be 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -1698,6 +1698,7 @@ static int handle_reserve_ticket(struct btrfs_space_info *space_info,
 						ARRAY_SIZE(evict_flush_states));
 		break;
 	case BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE:
+	case BTRFS_RESERVE_FLUSH_ZONED_RELOCATION:
 		priority_reclaim_data_space(space_info, ticket);
 		break;
 	default:
@@ -1961,6 +1962,7 @@ int btrfs_reserve_data_bytes(struct btrfs_space_info *space_info, u64 bytes,
 
 	ASSERT(flush == BTRFS_RESERVE_FLUSH_DATA ||
 	       flush == BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE ||
+	       flush == BTRFS_RESERVE_FLUSH_ZONED_RELOCATION ||
 	       flush == BTRFS_RESERVE_NO_FLUSH, "flush=%d", flush);
 	ASSERT(!current->journal_info || flush != BTRFS_RESERVE_FLUSH_DATA,
 	       "current->journal_info=0x%lx flush=%d",
diff --git a/fs/btrfs/space-info.h b/fs/btrfs/space-info.h
index 24f45072ca4b1d..aa836e8a9d4a6f 100644
--- a/fs/btrfs/space-info.h
+++ b/fs/btrfs/space-info.h
@@ -77,6 +77,17 @@ enum btrfs_reserve_flush_enum {
 	 */
 	BTRFS_RESERVE_FLUSH_ALL_STEAL,
 
+	/*
+	 * This is for relocation on zoned filesystems only. We need to use
+	 * priority flushing for this, because otherwise we can deadlock on
+	 * waiting for a ticket, that cannot be granted, because we cannot do
+	 * any allocations.
+	 *
+	 * Apart from being specific to zoned relocation, it is equal to
+	 * BTRFS_FLUSH_FREE_SPACE_INODE.
+	 */
+	BTRFS_RESERVE_FLUSH_ZONED_RELOCATION,
+
 	/*
 	 * This is for btrfs_use_block_rsv only.  We have exhausted our block
 	 * rsv and our global block rsv.  This can happen for things like
-- 
2.53.0



