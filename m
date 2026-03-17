Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6307A3EBF33;
	Tue, 17 Mar 2026 16:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765660; cv=none; b=ijUGIvJX+mMsRFgF4Go8Grpej2Qcq/AxuK5ABx3E2IBF8xcCS08M3oqeDdLROoWXmHJwksozWvJBRxEMNfmqQO5IlKsNWFZ2oklWren8R9sO2uXu/v5ROTzFDB2BNgLcjIihaHkp0QWAxhW/Kp61onGqdDLCHrqShhikRyHE8Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765660; c=relaxed/simple;
	bh=jLWUMctNBIcl9r1OjUS1mpZ3BbVdxXXd0g6nem7i7oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RMa1JRZugWuMa5qZYVXPxDnZ5cyEk6RIoqVQRooebxR98jkogNWu289Sb2Np87RGNX38cHMmQDMmKJCByjRh/4OZ0juyQG4LPD+1Bfr2CQN7NRWho591GFBm9AQPcRXAYE/aGsrmLrg26ifqL1vP7HPhRXGqGxU5TX902R0fk1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jwtYgN+e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jwtYgN+e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2BC2C4CEF7;
	Tue, 17 Mar 2026 16:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765660;
	bh=jLWUMctNBIcl9r1OjUS1mpZ3BbVdxXXd0g6nem7i7oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jwtYgN+e7FT2GWY5NlJcBImAG/TfLGouBdYyOTUy8bb6abGiMkEyj9wiHA2himc6Y
	 4Ym/fZ8TjGasnprF2oM51hhH5A+9WdXSnvrAhVRXIHeKWbc8jyXkvbHjI/6CqY5k0E
	 nUWKh8EXTzjsULHZIKoXzPLnATwzJ4Eq1eI4FUlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Boris Burkov <boris@bur.io>,
	Sun YangKai <sunk67188@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 030/378] btrfs: hold space_info->lock when clearing periodic reclaim ready
Date: Tue, 17 Mar 2026 17:29:47 +0100
Message-ID: <20260317163008.087759750@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 30aedf596b548..13b2bbe674308 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -2196,8 +2196,11 @@ void btrfs_reclaim_sweep(const struct btrfs_fs_info *fs_info)
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



