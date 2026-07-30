Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C97D2E4257;
	Thu, 30 Jul 2026 15:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425673; cv=none; b=CahK5W2ZxkLNKzedIwCSVv8yKFepGsUOVQFOpwDS3peNadPTQjVnlV/6rlE/i6Zywmq9+4/w2b7wTvHjXIdPRG66hk+evo6TfaJUNWvVeZrtXcFxBvT8r13MfcY9S9MgidB3wWa1x3NtfLqEvfhSlEPjccZd1TJ92E63hSkkvHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425673; c=relaxed/simple;
	bh=udlaV8n06xHqy7ywH8aGfUJDLiVIbB0vbr86uobTNOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NSNDiJsXOGtYmUGEk3aDuG2DRTje6FH6lSTGTqy6C7xiO6jAziqhzEGMEd2B5iTVPJp06wwTiJQU2VDoNLPx1rKqANwGDVq86LoILQO1sqx0q6uDzjHBMB3bSKHM9vxQORYy+Ae2TmElxogTTucMO9aOT3YcOCjdlZ0cD+BSZVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RiCFBZzE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RiCFBZzE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98ED51F000E9;
	Thu, 30 Jul 2026 15:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425672;
	bh=0OV9MAGm5L/yxuEZxRJBvOtNnDnCs9gehCaDhVnS1RE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RiCFBZzE0uJ6ruSE2hs75bQIgGxWISp6OLOMH+NGu/gFemWPSovOEZvZJ/QY2uG/g
	 TnKv8ijseLqotXnfgtYcMMAlVMFUgRzNvbTjj8kd2G333jxLV02eZBWShw/n3PkBsv
	 9Vp3yaJ/37/kE0atK53EWlo920ejvtpFo0M7mLG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Filipe Manana <fdmanana@suse.com>,
	Leo Martins <loemra.dev@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 152/602] btrfs: dont propagate EXTENT_FLAG_LOGGING to split extent maps
Date: Thu, 30 Jul 2026 16:09:04 +0200
Message-ID: <20260730141439.171306298@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Martins <loemra.dev@gmail.com>

[ Upstream commit 5eff4d5b17fa1950e80bfd1ba43dc0699e61a644 ]

When btrfs_drop_extent_map_range() splits an extent map, the new split
maps inherit the original map's flags through a local 'flags' variable.
Commit f86f7a75e2fb ("btrfs: use the flags of an extent map to identify
the compression type") changed the EXTENT_FLAG_LOGGING clearing to
operate on em->flags instead of that local 'flags' copy, so a split of
an extent map that is currently being logged wrongly inherits
EXTENT_FLAG_LOGGING.

The flag is then never cleared on the split, and when it is freed while
still on the inode's modified_extents list (for example by the extent
map shrinker) it trips the WARN_ON(!list_empty(&em->list)) in
btrfs_free_extent_map() and leads to a use-after-free.

Clear EXTENT_FLAG_LOGGING from the local 'flags' copy used for the
splits and only clear EXTENT_FLAG_PINNED from em->flags, restoring the
behaviour prior to f86f7a75e2fb.

CC: Jeff Layton <jlayton@kernel.org>
Link: https://lore.kernel.org/all/20260629-btrfs-skip-logging-v1-1-4e3a28c1acaf@kernel.org/
Fixes: f86f7a75e2fb ("btrfs: use the flags of an extent map to identify the compression type")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Leo Martins <loemra.dev@gmail.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_map.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 36af9aa9aab13f..044970109c7b58 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -859,13 +859,13 @@ void btrfs_drop_extent_map_range(struct btrfs_inode *inode, u64 start, u64 end,
 			goto next;
 		}
 
-		flags = em->flags;
 		/*
 		 * In case we split the extent map, we want to preserve the
 		 * EXTENT_FLAG_LOGGING flag on our extent map, but we don't want
 		 * it on the new extent maps.
 		 */
-		em->flags &= ~(EXTENT_FLAG_PINNED | EXTENT_FLAG_LOGGING);
+		flags = em->flags & ~EXTENT_FLAG_LOGGING;
+		em->flags &= ~EXTENT_FLAG_PINNED;
 		modified = !list_empty(&em->list);
 
 		/*
-- 
2.53.0



