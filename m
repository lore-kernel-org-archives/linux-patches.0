Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D0A18035
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0q1JJ+9L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 043F6C433C9;
	Mon,  9 Oct 2023 13:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858106;
	bh=txLNGn1BjSxuzd5LOL2C4TyQhzlpxPX0+xHTREhC/fU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0q1JJ+9LBfPUDalepcuYMepQbM8+Izy0HQybGruVugAPIFsbFdsKvl07hkBmNdkla
	 PuZcmhunEHClR/l6cW/xnvRtUNHq4bVPe0tneX7hwFSRu0FWGNsCfmaigUL/aniE1w
	 VyCQyoAs1vlOxZUsQHy9QL8q374nMbz8xY70QwME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 007/131] ext4: scope ret locally in ext4_try_to_trim_range()
Date: Mon,  9 Oct 2023 15:00:47 +0200
Message-ID: <20231009130116.553818958@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130116.329529591@linuxfoundation.org>
References: <20231009130116.329529591@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>

[ Upstream commit afcc4e32f606dbfb47aa7309172c89174b86e74c ]

As commit 6920b3913235 ("ext4: add new helper interface
ext4_try_to_trim_range()") moves some code into the separate function
ext4_try_to_trim_range(), the use of the variable ret within that
function is more limited and can be adjusted as well.

Scope the use of the variable ret locally and drop dead assignments.

No functional change.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Link: https://lore.kernel.org/r/20210820120853.23134-1-lukas.bulwahn@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 45e4ab320c9b ("ext4: move setting of trimmed bit into ext4_try_to_trim_range()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 5a7fe5aa0fc38..e1b487acb843b 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5200,7 +5200,6 @@ static int ext4_try_to_trim_range(struct super_block *sb,
 {
 	ext4_grpblk_t next, count, free_count;
 	void *bitmap;
-	int ret = 0;
 
 	bitmap = e4b->bd_bitmap;
 	start = (e4b->bd_info->bb_first_free > start) ?
@@ -5215,10 +5214,10 @@ static int ext4_try_to_trim_range(struct super_block *sb,
 		next = mb_find_next_bit(bitmap, max + 1, start);
 
 		if ((next - start) >= minblocks) {
-			ret = ext4_trim_extent(sb, start, next - start, e4b);
+			int ret = ext4_trim_extent(sb, start, next - start, e4b);
+
 			if (ret && ret != -EOPNOTSUPP)
 				break;
-			ret = 0;
 			count += next - start;
 		}
 		free_count += next - start;
-- 
2.40.1



