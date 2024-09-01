Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576C817C;
	Sun,  1 Sep 2024 17:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210260; cv=none; b=jff6AcgHsKuniK1VTxn+jk4xjLZlaXjRmuQqctl8QWkdVO0nPkA1NIpIepEim/yVztJtOoV8o6c/gNmNiW2A9pUH1PBtPrf1D/4+c4OhmWFT+p/1EJsHVwllTNynjDqfaQwvrbpbyZNc+z1afkL0Ciq78jdbrUkzrrCo2+tHoYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210260; c=relaxed/simple;
	bh=1TqgCSefdqEeGfPo8FlhsuOFvctdGGFkKStQNepgDnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z/73gYbyJTuGCDEosK83iXqSIs1h+N7pzxMi15GcJVGlrDGPGv8D/mnd5qYs+q/9nHKsq/KpvSGuv54i/I0Koy4WPwQZf87a4AgvUIeOX0d6Cb+fZuhyBQrcktac2EeUPqng2jHXwAWqpCLA13K+ReqlO4dtDJiQYHcsHjwybKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oha/vfQz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oha/vfQz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC57C4CEC3;
	Sun,  1 Sep 2024 17:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210260;
	bh=1TqgCSefdqEeGfPo8FlhsuOFvctdGGFkKStQNepgDnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oha/vfQzRXy9unK76y+55SxWd+hzNrLdt/UXNALtly2+gAHaPe4JX+ncM5RYd6inY
	 EjgxLNeiOOPy5MOIzKfx16XuRURofTaWT/iiZGO8c324Vlq3B9Fbhew05xtr7p6A6O
	 R4LEU41M3TEFNeJr1dTShKHPrJK9tAT3qA9VX9WA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 105/215] ext4: set the type of max_zeroout to unsigned int to avoid overflow
Date: Sun,  1 Sep 2024 18:16:57 +0200
Message-ID: <20240901160827.315686230@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 261341a932d9244cbcd372a3659428c8723e5a49 ]

The max_zeroout is of type int and the s_extent_max_zeroout_kb is of
type uint, and the s_extent_max_zeroout_kb can be freely modified via
the sysfs interface. When the block size is 1024, max_zeroout may
overflow, so declare it as unsigned int to avoid overflow.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20240319113325.3110393-9-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 6c41bf322315c..a3869e9c71b91 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3404,9 +3404,10 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 	struct ext4_extent *ex, *abut_ex;
 	ext4_lblk_t ee_block, eof_block;
 	unsigned int ee_len, depth, map_len = map->m_len;
-	int allocated = 0, max_zeroout = 0;
 	int err = 0;
 	int split_flag = EXT4_EXT_DATA_VALID2;
+	int allocated = 0;
+	unsigned int max_zeroout = 0;
 
 	ext_debug(inode, "logical block %llu, max_blocks %u\n",
 		  (unsigned long long)map->m_lblk, map_len);
-- 
2.43.0



