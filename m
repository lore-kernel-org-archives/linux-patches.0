Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B2B312806;
	Wed, 25 Feb 2026 06:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002770; cv=none; b=tH7WAOcaQLDl6V2A9vRLNuCYxMte3DjnE84l/XAwKWp8cUIjJpx1rOTdw89I/vlRp5a8wXh/VXoPWCkng6Z8rSOmnW23je8SwDoaFJlQU/Bl2rQXeCRJt6Fb9U1YJz1W9DfcQD+0x8hkgoEbDScU42cITC1v8M4d3aHDeH21UJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002770; c=relaxed/simple;
	bh=Yz/1R67NkL4pQvnVVGyy87b2obeMgCUVrWxfbcaIoKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QfLA1sQU40dd38UkIxVw5DwlqAMBdi2RldWeP8aQoc7W5K7pcP6t8MfDH+ByhkaKcpAzBZL6q1pee7B7ZUosZ527wDvUemqJLcxBjEFLPeD/g6Gm/tVmQlXvKcC6th1x6AnkG8RMDb8VQNJZrbUhw6gChzFd3KrQoPDoLuVkZVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VLkrhNUs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VLkrhNUs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 381ABC116D0;
	Wed, 25 Feb 2026 06:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002770;
	bh=Yz/1R67NkL4pQvnVVGyy87b2obeMgCUVrWxfbcaIoKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VLkrhNUsaz0lbqGduNDp0gymlxHrKzdZI8n+yaf/WUZj9wRIkcq+IBOCqvvLcdfIg
	 Sn5y62a4Gju79Vapqmf7EQ1sfrBGi8uwBN6eONfauZqmafmzFH8yCZXgvMvRXJYYLv
	 5ScjhUEl9RMDPRQV7X9jYq6a3vCxn40N2DrrCRV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Lyakas <alex.lyakas@zadara.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 605/641] btrfs: use the correct type to initialize block reserve for delayed refs
Date: Tue, 24 Feb 2026 17:25:31 -0800
Message-ID: <20260225012403.173720501@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 2155d0c0a761a56ce7ede83a26eb23ea0f935260 ]

When initializing the delayed refs block reserve for a transaction handle
we are passing a type of BTRFS_BLOCK_RSV_DELOPS, which is meant for
delayed items and not for delayed refs. The correct type for delayed refs
is BTRFS_BLOCK_RSV_DELREFS.

On release of any excess space reserved in a local delayed refs reserve,
we also should transfer that excess space to the global block reserve
(it it's full, we return to the space info for general availability).

By initializing a transaction's local delayed refs block reserve with a
type of BTRFS_BLOCK_RSV_DELOPS, we were also causing any excess space
released from the delayed block reserve (fs_info->delayed_block_rsv, used
for delayed inodes and items) to be transferred to the global block
reserve instead of the global delayed refs block reserve. This was an
unintentional change in commit 28270e25c69a ("btrfs: always reserve space
for delayed refs when starting transaction"), but it's not particularly
serious as things tend to cancel out each other most of the time and it's
relatively rare to be anywhere near exhaustion of the global reserve.

Fix this by initializing a transaction's local delayed refs reserve with
a type of BTRFS_BLOCK_RSV_DELREFS and making btrfs_block_rsv_release()
attempt to transfer unused space from such a reserve into the global block
reserve, just as we did before that commit for when the block reserve is
a delayed refs rsv.

Reported-by: Alex Lyakas <alex.lyakas@zadara.com>
Link: https://lore.kernel.org/linux-btrfs/CAOcd+r0FHG5LWzTSu=LknwSoqxfw+C00gFAW7fuX71+Z5AfEew@mail.gmail.com/
Fixes: 28270e25c69a ("btrfs: always reserve space for delayed refs when starting transaction")
Reviewed-by: Alex Lyakas <alex.lyakas@zadara.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-rsv.c   | 7 ++++---
 fs/btrfs/transaction.c | 2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/block-rsv.c b/fs/btrfs/block-rsv.c
index 75cd35570a287..fc378d2038a2d 100644
--- a/fs/btrfs/block-rsv.c
+++ b/fs/btrfs/block-rsv.c
@@ -278,10 +278,11 @@ u64 btrfs_block_rsv_release(struct btrfs_fs_info *fs_info,
 	struct btrfs_block_rsv *target = NULL;
 
 	/*
-	 * If we are a delayed block reserve then push to the global rsv,
-	 * otherwise dump into the global delayed reserve if it is not full.
+	 * If we are a delayed refs block reserve then push to the global
+	 * reserve, otherwise dump into the global delayed refs reserve if it is
+	 * not full.
 	 */
-	if (block_rsv->type == BTRFS_BLOCK_RSV_DELOPS)
+	if (block_rsv->type == BTRFS_BLOCK_RSV_DELREFS)
 		target = global_rsv;
 	else if (block_rsv != global_rsv && !btrfs_block_rsv_full(delayed_rsv))
 		target = delayed_rsv;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index b537bba767806..089712b15d603 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -726,7 +726,7 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
 
 	h->type = type;
 	INIT_LIST_HEAD(&h->new_bgs);
-	btrfs_init_metadata_block_rsv(fs_info, &h->delayed_rsv, BTRFS_BLOCK_RSV_DELOPS);
+	btrfs_init_metadata_block_rsv(fs_info, &h->delayed_rsv, BTRFS_BLOCK_RSV_DELREFS);
 
 	smp_mb();
 	if (cur_trans->state >= TRANS_STATE_COMMIT_START &&
-- 
2.51.0



