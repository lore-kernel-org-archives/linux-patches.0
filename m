Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B831D0F48;
	Wed,  2 Oct 2024 14:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880553; cv=none; b=UhXekp/xHZpUmR5TXROIWJpR5ZNlT23NnDxtrSgu0NjazdUZv0ijNP9eFAyqlHWvSW3s1Lf8v5P6ZCU6wlcMdjE65SM36XG2fH/BoT5qYrBJD33k5LLQUOVq9NaDIPUSY7hEzzDoqp0w3TLYlpEcLTFusZrVWOnPgRbuE4xmyn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880553; c=relaxed/simple;
	bh=Bq73EZ733SOKR3FCetcel3RyaaUNbBHj9L6IE/Ey5Mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OcDZUl84uUf5UkiqMr2J51TlOy9oivGbV+ouWeEI1JwxHy/RMks0UVqAqzRFCgx8fQwCwhzX8DqfvgTLlUv251dKOT1iPFSYC+Q8ORkBcKwxOXufuSnsheqTuIGTeFJyZLnA2iwEtDVauuuUAeOI99DVgbbpMvPL9SLDuQaguz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PQw2aN15; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PQw2aN15"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A665C4CEC2;
	Wed,  2 Oct 2024 14:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880553;
	bh=Bq73EZ733SOKR3FCetcel3RyaaUNbBHj9L6IE/Ey5Mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PQw2aN15Yp8fhEPSdzbcS8gLtIAApLJSImOfcxW/U8TVz6d7SciEUCxytbuacLE9c
	 Tf8RKr5tjHWgBfjUcHm85Hax5EObycn3txOt/FgYLAv5Olfw9Hb6qek8MUPpjgv5nD
	 sS9nWJHg6dm02oRimDcJvDTuN7//QwEEAM5GIyCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 497/538] btrfs: reorder btrfs_inode to fill gaps
Date: Wed,  2 Oct 2024 15:02:16 +0200
Message-ID: <20241002125812.058043706@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: David Sterba <dsterba@suse.com>

[ Upstream commit 398fb9131f31bd25aa187613c9942f4232e952b7 ]

Previous commit created a hole in struct btrfs_inode, we can move
outstanding_extents there. This reduces size by 8 bytes from 1120 to
1112 on a release config.

Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 7ee85f5515e8 ("btrfs: fix race setting file private on concurrent lseek using same fd")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/btrfs_inode.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index bda1fdbba666a..b75c7f5934780 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -102,6 +102,14 @@ struct btrfs_inode {
 	/* held while logging the inode in tree-log.c */
 	struct mutex log_mutex;
 
+	/*
+	 * Counters to keep track of the number of extent item's we may use due
+	 * to delalloc and such.  outstanding_extents is the number of extent
+	 * items we think we'll end up using, and reserved_extents is the number
+	 * of extent items we've reserved metadata for.
+	 */
+	unsigned outstanding_extents;
+
 	/* used to order data wrt metadata */
 	struct btrfs_ordered_inode_tree ordered_tree;
 
@@ -223,14 +231,6 @@ struct btrfs_inode {
 	/* Read-only compatibility flags, upper half of inode_item::flags */
 	u32 ro_flags;
 
-	/*
-	 * Counters to keep track of the number of extent item's we may use due
-	 * to delalloc and such.  outstanding_extents is the number of extent
-	 * items we think we'll end up using, and reserved_extents is the number
-	 * of extent items we've reserved metadata for.
-	 */
-	unsigned outstanding_extents;
-
 	struct btrfs_block_rsv block_rsv;
 
 	/*
-- 
2.43.0



