Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD25B1A735
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AcZ1QaSD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D42C433C8;
	Mon,  9 Oct 2023 13:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859439;
	bh=SyMkxAkbWbOnaWYxCkND9Ke9ZfoqowZKqs+lWUzlNoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AcZ1QaSD4adex+QUxIl6s3ZUQkfsj4KLMT3LBbU6R9CUB3SR45z6yKimoorw3qlZ7
	 VZyn7F+u2xoUyZ7mgbGaibjtqYkOHutfC/sdsEALKRESc3kFpfHfvmd94ESw/TbkVw
	 xy9Xp9J0EZurvg0+A7m1M76hbQu5VqLKPtb/vPQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 22/91] ext4: scope ret locally in ext4_try_to_trim_range()
Date: Mon,  9 Oct 2023 15:05:54 +0200
Message-ID: <20231009130112.294067895@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130111.518916887@linuxfoundation.org>
References: <20231009130111.518916887@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 51def652098b3..58a0d2ea314b7 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5190,7 +5190,6 @@ static int ext4_try_to_trim_range(struct super_block *sb,
 {
 	ext4_grpblk_t next, count, free_count;
 	void *bitmap;
-	int ret = 0;
 
 	bitmap = e4b->bd_bitmap;
 	start = (e4b->bd_info->bb_first_free > start) ?
@@ -5205,10 +5204,10 @@ static int ext4_try_to_trim_range(struct super_block *sb,
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



