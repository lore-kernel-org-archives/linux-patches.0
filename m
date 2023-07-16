Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51CCD8F70
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:56:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE76C433C8;
	Sun, 16 Jul 2023 19:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537400;
	bh=vFd0cMIrKz6Bxae2ko3ABDJzb6RajFhLrGods/v1FY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=owg0TaJ1iavOMreo4+a09dIDnQrSIsb3P6A22eGySPH3D7ZWHGXr9Ya1o+nF2ikHI
	 6EODM7+i6e456uEuS+SDPBRI9SFeEnf++U30x8ko8i4UnuQUaarRwdSHccIaHTUGwk
	 +gzB2aaeYeBlK5q/ubm83SJe70g78e+sNrVNRK7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 055/800] btrfs: fix range_end calculation in extent_write_locked_range
Date: Sun, 16 Jul 2023 21:38:28 +0200
Message-ID: <20230716194950.367873816@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 36614a3beba33a05ad78d4dcb9aa1d00e8a7d01f ]

The range_end field in struct writeback_control is inclusive, just like
the end parameter passed to extent_write_locked_range.  Not doing this
could cause extra writeout, which is harmless but suboptimal.

Fixes: 771ed689d2cd ("Btrfs: Optimize compressed writeback and reads")
CC: stable@vger.kernel.org # 5.9+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 7027f87108ce ("btrfs: don't treat zoned writeback as being from an async helper thread")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 0c9538bb3c852..ac3aae55d55e5 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2468,7 +2468,7 @@ int extent_write_locked_range(struct inode *inode, u64 start, u64 end)
 	struct writeback_control wbc_writepages = {
 		.sync_mode	= WB_SYNC_ALL,
 		.range_start	= start,
-		.range_end	= end + 1,
+		.range_end	= end,
 		.no_cgroup_owner = 1,
 	};
 	struct btrfs_bio_ctrl bio_ctrl = {
-- 
2.39.2



