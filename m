Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF92D3F54A5;
	Tue, 17 Mar 2026 17:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767169; cv=none; b=X1eUPGseOmgyxe1KsOuzJ6TgtsXamOELrzng1mCXUudxHH0xnH3ERUMw+XXNIPPk3TiZp8TFVukUf4SEV7C55HXxqaebgVhu1GXwy9zhK3cmsNSAVdik49K8L+bf9moikABsJvo25gEXNK+lroLDR2U6buyT6LGzVWvWdUwXMZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767169; c=relaxed/simple;
	bh=v6tsxp/5ORbd2UGaa7+NA+72Oac702V5pAztdj+QreY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l/xaBOMDC/RXBFjDF11pVI+Yu30i8aYsUkcVD4jHS7k/e9Cljld05w9KFIJYGnCv+c7P91e6LKt2fCFAQP2KYPcXLsOO8O2YPreCCYb5xOlXNovPFzZbIAP8Yyzw3fnFQ2HlZqEv0eOlHfhKIj7G3n3P1NuXU/OAx1y+UQByhwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dWdvssyb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dWdvssyb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D44C4CEF7;
	Tue, 17 Mar 2026 17:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767169;
	bh=v6tsxp/5ORbd2UGaa7+NA+72Oac702V5pAztdj+QreY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dWdvssybA1KNJs1jjsgiudY3af28bdokWDPobJ4FVPqkKil67HGrgXLmwimU0HPvr
	 h4nPknxfF+DumfTXe4K8l+h/01Ssx8DIPGHJm0o9bRRr4543ziBW1t5EtFHIeQ6hLk
	 QW+HQoIl3tO55ghi3pnMX8LhwsteJoeSRnPrzMvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Boris Burkov <boris@bur.io>,
	Sun YangKai <sunk67188@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 029/333] btrfs: hold space_info->lock when clearing periodic reclaim ready
Date: Tue, 17 Mar 2026 17:30:58 +0100
Message-ID: <20260317163000.442527705@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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
index 6b64691034de4..194f590201658 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -2171,8 +2171,11 @@ void btrfs_reclaim_sweep(const struct btrfs_fs_info *fs_info)
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



