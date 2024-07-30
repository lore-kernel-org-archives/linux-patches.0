Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D3D166315;
	Tue, 30 Jul 2024 17:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360609; cv=none; b=jk5lTSIoSrWtPZybvxc5fWSRqLWNRPBeiUdrY093oXpqN3XWfjhBpTeJZdTXrZSvWpKV/0up6gH6d5lR75JCIIirwmvEj/pwTqYliaOdohKQqeeUfJri7Oj2v9j8JXL9+tYOHsjxuf65bF+9Hxo+wFBdSXOCi6v2HjJkmoU+0F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360609; c=relaxed/simple;
	bh=oZ/dVQxdOG6KQQiRZYKi1dbfh8SKNhozUxA9rngDeFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YVyUSrxV2lUPEq36MOcVFRsFkubPNhmZIi9VrzGzCT1E3Sq1oDfSXpXOJ+INOo8XYCBv/d04PPr/ZNyfgEoMKlSF0AwGPB0gk+PnEboCIMZLcP0zP6lOUGLdkUeY0CrA0MBDzcB3J5gO7VVso5QStx8iT6HHXb7ZtJC5isrWIVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gh5OjsaT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gh5OjsaT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993C7C4AF13;
	Tue, 30 Jul 2024 17:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360609;
	bh=oZ/dVQxdOG6KQQiRZYKi1dbfh8SKNhozUxA9rngDeFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gh5OjsaTR7H0o3JgSFkS1ruhbLnUyFiyJYqTnUnzth5U27AEEQtu2+hy5c8s/ZBFO
	 MHbOrG0UAgxUXewN4aho/KqLMjZFUCUn8+uQbutYynFvnvi/+7o2rRGnDefO91zc43
	 /ajoKAh0QDDbP+zkdbbJOxWHCKy1u5RT7c8fX+/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daejun Park <daejun7.park@samsung.com>,
	Chao Yu <chao@kernel.org>,
	Daeho Jeong <daehojeong@google.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 751/809] f2fs: fix null reference error when checking end of zone
Date: Tue, 30 Jul 2024 17:50:27 +0200
Message-ID: <20240730151754.620892439@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daejun Park <daejun7.park@samsung.com>

[ Upstream commit c82bc1ab2a8a5e73d9728e80c4c2ed87e8921a38 ]

This patch fixes a potentially null pointer being accessed by
is_end_zone_blkaddr() that checks the last block of a zone
when f2fs is mounted as a single device.

Fixes: e067dc3c6b9c ("f2fs: maintain six open zones for zoned devices")
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Reviewed-by: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index b9b0debc6b3d3..1a6873cf9651f 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -925,6 +925,7 @@ int f2fs_merge_page_bio(struct f2fs_io_info *fio)
 #ifdef CONFIG_BLK_DEV_ZONED
 static bool is_end_zone_blkaddr(struct f2fs_sb_info *sbi, block_t blkaddr)
 {
+	struct block_device *bdev = sbi->sb->s_bdev;
 	int devi = 0;
 
 	if (f2fs_is_multi_device(sbi)) {
@@ -935,8 +936,9 @@ static bool is_end_zone_blkaddr(struct f2fs_sb_info *sbi, block_t blkaddr)
 			return false;
 		}
 		blkaddr -= FDEV(devi).start_blk;
+		bdev = FDEV(devi).bdev;
 	}
-	return bdev_is_zoned(FDEV(devi).bdev) &&
+	return bdev_is_zoned(bdev) &&
 		f2fs_blkz_is_seq(sbi, devi, blkaddr) &&
 		(blkaddr % sbi->blocks_per_blkz == sbi->blocks_per_blkz - 1);
 }
-- 
2.43.0



