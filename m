Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD8A196DAB;
	Thu,  6 Jun 2024 14:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683378; cv=none; b=RO+NSMHiWcwLg4sFTP607GUlkpEE3ffBuzHUHZGcYhUK0nZNYjkYMxfwmxtQYZi4vdiXguPjYuINYxKJRX1TOmmWr6+gx2T1lqdRNQjh9NWNBVFbwd4D1pZe6dhF9ELsS2s0ZBLIsdzE+TZqvZ1/+2A6oDjIC8HgZGigyJcaGqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683378; c=relaxed/simple;
	bh=c1Lu6vbQ6hnX+Mx/M1uj7jd+WATvAUqSOteOz69J6wU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LwX4k3ttHAASRY6wLIOBYUt6Tm3Rbun14OA4EKl7xgas4h/kcAEodu4129XZxXtZMnvzM0uCeYjWY8ruyMeLlw86Kt0NrZ5s0dF5DJfP60YNIDv7SVAsS6fb119pk/RwMBE+3r56EHoiimChY2Hwte3Sj6rRAevprtpHb8zHMW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QcnK0+pv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QcnK0+pv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E0B5C2BD10;
	Thu,  6 Jun 2024 14:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683378;
	bh=c1Lu6vbQ6hnX+Mx/M1uj7jd+WATvAUqSOteOz69J6wU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QcnK0+pvlKyfudRIlOZwldH87JSLyEpX/j5a683iFXzLhlqBrrv0hgLz/AYDrIR97
	 q5TfN1s/viSwRkidhN51qazTgSm6jQTxsfDo6EXwg1kLBaA2PRCcyymcIVVuThHQdb
	 ppX5xS7R8IcFx9cb9jElo9kwPEliDP9hcQeq8Xk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 261/473] ext4: simplify calculation of blkoff in ext4_mb_new_blocks_simple
Date: Thu,  6 Jun 2024 16:03:10 +0200
Message-ID: <20240606131708.588884151@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit 253cacb0de89235673ad5889d61f275a73dbee79 ]

We try to allocate a block from goal in ext4_mb_new_blocks_simple. We
only need get blkoff in first group with goal and set blkoff to 0 for
the rest groups.

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Link: https://lore.kernel.org/r/20230303172120.3800725-21-shikemeng@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 3f4830abd236 ("ext4: fix potential unnitialized variable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index a843f964332c2..eaa5db60865a4 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5896,9 +5896,6 @@ static ext4_fsblk_t ext4_mb_new_blocks_simple(handle_t *handle,
 			return 0;
 		}
 
-		ext4_get_group_no_and_offset(sb,
-			max(ext4_group_first_block_no(sb, group), goal),
-			NULL, &blkoff);
 		while (1) {
 			i = mb_find_next_zero_bit(bitmap_bh->b_data, max,
 						blkoff);
@@ -5913,6 +5910,8 @@ static ext4_fsblk_t ext4_mb_new_blocks_simple(handle_t *handle,
 		brelse(bitmap_bh);
 		if (i < max)
 			break;
+
+		blkoff = 0;
 	}
 
 	if (group >= ext4_get_groups_count(sb) || i >= max) {
-- 
2.43.0



