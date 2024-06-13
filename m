Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662C528FF;
	Thu, 13 Jun 2024 12:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282097; cv=none; b=oh+Es5cmwT9TEefJvvf8dgeJ904Yk1EMG/mYNa3SBZiTMl4+aR7JZt90fh7Ii7IMpUXMBOBUYk66XH/D+JT0Amm0qR0ObGvDp0T71kR3UApk8aB4Cgo+A6iqOyYEWMr7xvzTC/MKxgKOjFBcXIDFRei9iw1rIfaMiYvuczLR1Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282097; c=relaxed/simple;
	bh=khaerv9JBHKISx/ttUiJr+Qq97+0qt21n7hG8hmUzLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h8sS1lTFWakQO12YKJBFtgCd9EaHU80wa0Y6QeBobXdyXrgrCmQr90g8PwCPAmE+7XE6iQ/DGQH7ClkbMat0JWzGfSN9J0T2x6JJY6P1hBRTbbLp4YDsNWuyLaaX3wQTIsI4Mu+IG5K+opEvoWOIkU+nMR0kUPi91OuPvgGir1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X0i57BgZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X0i57BgZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF434C2BBFC;
	Thu, 13 Jun 2024 12:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282097;
	bh=khaerv9JBHKISx/ttUiJr+Qq97+0qt21n7hG8hmUzLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X0i57BgZB2PPbL3DczxPJpYhGoouphR1CKP+ardb0R0c513J/0cCYOpOB1MJ7YhJ4
	 lwZWGdhJGvnF1qvnsOE37J4sckcH1DwwA3cHV70z9YbQ1j1T6nXuUVu2YolR6YiA+K
	 ZLOPS8I6m0jSxgFIChMkdnAeYpt+uzQ5QAeceht8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 162/402] ext4: simplify calculation of blkoff in ext4_mb_new_blocks_simple
Date: Thu, 13 Jun 2024 13:31:59 +0200
Message-ID: <20240613113308.453011077@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8dba416aa6c1e..c2fcdee223317 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5908,9 +5908,6 @@ static ext4_fsblk_t ext4_mb_new_blocks_simple(handle_t *handle,
 			return 0;
 		}
 
-		ext4_get_group_no_and_offset(sb,
-			max(ext4_group_first_block_no(sb, group), goal),
-			NULL, &blkoff);
 		while (1) {
 			i = mb_find_next_zero_bit(bitmap_bh->b_data, max,
 						blkoff);
@@ -5925,6 +5922,8 @@ static ext4_fsblk_t ext4_mb_new_blocks_simple(handle_t *handle,
 		brelse(bitmap_bh);
 		if (i < max)
 			break;
+
+		blkoff = 0;
 	}
 
 	if (group >= ext4_get_groups_count(sb) || i >= max) {
-- 
2.43.0



