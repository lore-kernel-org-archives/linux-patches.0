Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B28E522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:19:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B04C433C8;
	Sun,  9 Jul 2023 11:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901565;
	bh=wIDjWhyOgdYnH1+qBDyWt/fNT/CuYZ+3Y6INCqz6IMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SCO0Zuf5xhTV8NKWQEv3bu2C319CB4x9Q1aTQ4J/qccXjJm5EXYoSAKJd+dP6hKP/
	 rNzC2sWnJMPKqeQ60o304WUT4HuiYKRsbazovLqgR40C0hax02ROrdXxzOLcPPHZkd
	 DuesZ5mkzNmgAKjq0yr2RK3nO14lWZDDrhQsZZA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 037/431] btrfs: fix file_offset for REQ_BTRFS_ONE_ORDERED bios that get split
Date: Sun,  9 Jul 2023 13:09:45 +0200
Message-ID: <20230709111451.966395548@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
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

[ Upstream commit c731cd0b6d255e4855a7cac9f276864032ab2387 ]

If a bio gets split, it needs to have a proper file_offset for checksum
validation and repair to work properly.

Based on feedback from Josef, commit 852eee62d31a ("btrfs: allow
btrfs_submit_bio to split bios") skipped this adjustment for ONE_ORDERED
bios.  But if we actually ever need to split a ONE_ORDERED read bio, this
will lead to a wrong file offset in the repair code.  Right now the only
user of the file_offset is logging of an error message so this is mostly
harmless, but the wrong offset might be more problematic for additional
users in the future.

Fixes: 852eee62d31a ("btrfs: allow btrfs_submit_bio to split bios")
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/bio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 67e5156f940d3..4bb2c6f4ad0e7 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -79,8 +79,7 @@ static struct btrfs_bio *btrfs_split_bio(struct btrfs_fs_info *fs_info,
 	btrfs_bio_init(bbio, orig_bbio->inode, NULL, orig_bbio);
 
 	bbio->file_offset = orig_bbio->file_offset;
-	if (!(orig_bbio->bio.bi_opf & REQ_BTRFS_ONE_ORDERED))
-		orig_bbio->file_offset += map_length;
+	orig_bbio->file_offset += map_length;
 
 	atomic_inc(&orig_bbio->pending_ios);
 	return bbio;
-- 
2.39.2



