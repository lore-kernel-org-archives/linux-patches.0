Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC0C325706;
	Thu, 12 Mar 2026 20:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346716; cv=none; b=ANg7nRzX1qvAUJl0JWv1GMR/7j4hOyp5TEoEHpTrhogpQTA8TmlzsXsMS0+2VqfkLwn/EjmhnY/NCGz1iCCtJ39l4/CupVBFGifRi9Bx6gworYRsTRnXJPGY1cTIdXdIXHqFZ7I56NddpHb4nXZhCYDPSeCdGYK5EWzgBXWEU1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346716; c=relaxed/simple;
	bh=dgyfZ9XEgLuXZU9td4AbGCiwFy6CsJ3bwvWXtnAhlM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbEAywEeCYD36cFF3WNQVP6K4lpKlu5t2f2X0f0Q/ed4PeOKE1aMsN8nq0ysamGJZelUeKAIxvC5uXeYmYr4j7wC1vxCByyfFqEdnmfoBmwb6e9ZumM1uqkbtJLel0gP5y/BF0aFh1s/ublhEAfL8LairTtKaCjhY6+4m8KkZeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RIMvH3wz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RIMvH3wz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7659DC2BC87;
	Thu, 12 Mar 2026 20:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346715;
	bh=dgyfZ9XEgLuXZU9td4AbGCiwFy6CsJ3bwvWXtnAhlM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RIMvH3wz+5qiE05PcSzJab6+v9vSVdOljIjdYX5LQxtvE7pGkc7MpoXFYaf7kNSqv
	 mMXdsfWnFCY+Hi5GORw8OF1R4ujdsbOV4A2P768Q8/NwlaGZsWumueIGJLoekgpOVK
	 MQaSBdXcXwVb/SBccnde3pgEhvx4q9U1hi6R20mI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 106/265] btrfs: zoned: fixup last alloc pointer after extent removal for DUP
Date: Thu, 12 Mar 2026 21:08:13 +0100
Message-ID: <20260312201022.061826031@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

From: Naohiro Aota <naohiro.aota@wdc.com>

[ Upstream commit e2d848649e64de39fc1b9c64002629b4daa1105d ]

When a block group is composed of a sequential write zone and a
conventional zone, we recover the (pseudo) write pointer of the
conventional zone using the end of the last allocated position.

However, if the last extent in a block group is removed, the last extent
position will be smaller than the other real write pointer position.
Then, that will cause an error due to mismatch of the write pointers.

We can fixup this case by moving the alloc_offset to the corresponding
write pointer position.

Fixes: c0d90a79e8e6 ("btrfs: zoned: fix alloc_offset calculation for partly conventional block groups")
CC: stable@vger.kernel.org # 6.16+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/zoned.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 5deddb89c6197..bf41d9b641f58 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1411,6 +1411,20 @@ static int btrfs_load_block_group_dup(struct btrfs_block_group *bg,
 		return -EIO;
 	}
 
+	/*
+	 * When the last extent is removed, last_alloc can be smaller than the other write
+	 * pointer. In that case, last_alloc should be moved to the corresponding write
+	 * pointer position.
+	 */
+	for (int i = 0; i < map->num_stripes; i++) {
+		if (zone_info[i].alloc_offset == WP_CONVENTIONAL)
+			continue;
+		if (last_alloc <= zone_info[i].alloc_offset) {
+			last_alloc = zone_info[i].alloc_offset;
+			break;
+		}
+	}
+
 	if (zone_info[0].alloc_offset == WP_CONVENTIONAL)
 		zone_info[0].alloc_offset = last_alloc;
 
-- 
2.51.0



