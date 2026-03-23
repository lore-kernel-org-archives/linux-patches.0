Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1E6199FAB;
	Mon, 23 Mar 2026 14:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275250; cv=none; b=m99G8JTIyAv+FLiiTTTiWh4GVoT2VPkFrCQNR/ii/R0apzQUbO4ZJdH4H8xO+Yty8QcV1ghGSBiV72UGzZwcWBo6Dz98jhL6qC4+NAaH4WQIpoEKDQ5wKvHOH5X0bnAPCB6R6VpTfhV6M3Y2knHOB5Vn+B0bcbUksy6S/KQyCcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275250; c=relaxed/simple;
	bh=I8Gy9BvLqVFL8v+jImBLEHV6V0hEdZJn76nKFuRbcjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F2oQ4GywSCUkrYVCfXOcSb/IUue+DLWj9rFs9JJ2rIvn/zHTnBpjC+A+q4UnsULAO7b7OPxcu03lcvlgDygG8nksFJFEgKULskm0f+CbRdfVLSwLuR/Vh4sRmtQg1ffrzyeyvtUJa8ScvjKgpNBynwnW7+Bmi2BG13WPMDdpwEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=soq/gTmK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="soq/gTmK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE04C4CEF7;
	Mon, 23 Mar 2026 14:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275250;
	bh=I8Gy9BvLqVFL8v+jImBLEHV6V0hEdZJn76nKFuRbcjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=soq/gTmKNzy54BS1LMV6fHMu0uexNE+3iD1Be8Jp7UO07jbcZSyTpFjAfeaCHj/3z
	 UWE4ixRL3FExT/cxxBNHZFSagmv1X+uma5Ssgo639KuRhAPmHjg5GVtOtlfHtJvvA4
	 Pw8IukjDzvzd2FmmItXq41zo7iDTp09llAcSU+VA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Boris Burkov <boris@bur.io>,
	Sun YangKai <sunk67188@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 028/460] btrfs: hold space_info->lock when clearing periodic reclaim ready
Date: Mon, 23 Mar 2026 14:40:24 +0100
Message-ID: <20260323134527.386944397@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Sun YangKai <sunk67188@gmail.com>

[ Upstream commit b8883b61f2fc50dcf22938cbed40fec05020552f ]

btrfs_set_periodic_reclaim_ready() requires space_info->lock to be held,
as enforced by lockdep_assert_held(). However, btrfs_reclaim_sweep() was
calling it after do_reclaim_sweep() returns, at which point
space_info->lock is no longer held.

Fix this by explicitly acquiring space_info->lock before clearing the
periodic reclaim ready flag in btrfs_reclaim_sweep().

Reported-by: Chris Mason <clm@meta.com>
Link: https://lore.kernel.org/linux-btrfs/20260208182556.891815-1-clm@meta.com/
Fixes: 19eff93dc738 ("btrfs: fix periodic reclaim condition")
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Sun YangKai <sunk67188@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/space-info.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index af19f7a3e74a4..ada19b3288611 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -2128,8 +2128,11 @@ void btrfs_reclaim_sweep(const struct btrfs_fs_info *fs_info)
 		if (!btrfs_should_periodic_reclaim(space_info))
 			continue;
 		for (raid = 0; raid < BTRFS_NR_RAID_TYPES; raid++) {
-			if (do_reclaim_sweep(space_info, raid))
+			if (do_reclaim_sweep(space_info, raid)) {
+				spin_lock(&space_info->lock);
 				btrfs_set_periodic_reclaim_ready(space_info, false);
+				spin_unlock(&space_info->lock);
+			}
 		}
 	}
 }
-- 
2.51.0



