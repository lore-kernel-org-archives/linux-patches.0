Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28681C8FCF;
	Tue, 27 Aug 2024 15:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772506; cv=none; b=axVU2DdXxHJoJwMLUGkWu0b+6pdrdC/32aK5ejRwKAxeRep5P+JCjA7yxd7T7+nZ3KBtFUIb+0BCTipxLa8dUz5M4uRAuksuW/xa4LuqEwCfZdS28OceD8ex6P1t6Ge9QKs8xGfJ7cpNTm9ICLb0YIHbwGhz+CVhHA0DqUf1Izo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772506; c=relaxed/simple;
	bh=iyk59u3P5CMAOycfikz+YliOZu1/Z4wh/IQGdFAKk8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hNrfRogCr0bq4KmXThDGSm0VNB4X0PTDJuWaUoPOMpFqQorwOirnYgS5+evmy3+OsYCMNrMJ5AJ8T8ZkUYGc7iZ1g0mDaq6BwvWG0/oNlfBOIS84E9NEspHZU02SN9VS/RXrpExmJZ2BzklwHOcY3ZRAMS6YaaWiJkpbk+nYnF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iQAgJutc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iQAgJutc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1185CC61047;
	Tue, 27 Aug 2024 15:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772506;
	bh=iyk59u3P5CMAOycfikz+YliOZu1/Z4wh/IQGdFAKk8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iQAgJutcaIhoy4jW3iVFb79MWoAK2t0lueKEolEzl8Tpu0/VHVjHVNwZq64kux/Zk
	 jo4uMEhcN8CBKOtm6OhhqTjjKA+UKcIFXUp/j9J7rJPLIOpO9OIyGLQvWtnHHQUT2g
	 evu8vJFYaBoDHUWs0dQq/85AR8/X9xJ0LvtPg7iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 204/321] ext4: set the type of max_zeroout to unsigned int to avoid overflow
Date: Tue, 27 Aug 2024 16:38:32 +0200
Message-ID: <20240827143845.999573281@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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
index 5cbe5ae5ad4a2..92b540754799c 100644
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



