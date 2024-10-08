Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69F81DE894;
	Tue,  8 Oct 2024 12:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392133; cv=none; b=C/5jFe0YnSsW9h7BS9fSZUPaZEdkRl57qIE0MXUn0sR70FCuCGU6DQwQyVBYhvLcdnG0BAmhQgvr9vd6MMN/uHfTIjzJqTCsvPQZmfPPDuiE5u3DbYjCsIwZ8x/hnSFX/Ac9OD9AJML537RSj1YRD9mYDfVRnfKc7s1SwZY++Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392133; c=relaxed/simple;
	bh=1xWD/pfL34j/ok6iEo/2ySRE7CKTbPqNRPvZO1h157Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UtonIvGk/DyqD6di0CGar3yqrU/0FSF3xdAi8UCWZaI3FytF+e+R+xB8gWVxnWRjVuJGCmm5Bdmm5uWSBuzVksbFoMA4eVhHR7jmtIwpp9TV7qNg/WoSO+629CJXgnCbFIdWARoueRXJ84mnn9TcYg1JnEA3Kgcc0dCDl9XE5hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DjH9EQga; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DjH9EQga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531C3C4CEC7;
	Tue,  8 Oct 2024 12:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392132;
	bh=1xWD/pfL34j/ok6iEo/2ySRE7CKTbPqNRPvZO1h157Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DjH9EQga4BIMEEZNbOGaYUY+SW7Ntc7BN/+mNyVKKeie3d7lXjDQWRe2xH7mf/Lbx
	 7c/C9Q5D9oSCcdOoc+7tg2eTHVgCp5hMEJM4Zj8lKFDZJYuccgfEKE+KAOH95G4UpI
	 /ErnWBpMdwp0HETBWC6OcbDgg0ajp+9161BfHnLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 308/558] ext4: avoid use-after-free in ext4_ext_show_leaf()
Date: Tue,  8 Oct 2024 14:05:38 +0200
Message-ID: <20241008115714.435047699@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 4e2524ba2ca5f54bdbb9e5153bea00421ef653f5 ]

In ext4_find_extent(), path may be freed by error or be reallocated, so
using a previously saved *ppath may have been freed and thus may trigger
use-after-free, as follows:

ext4_split_extent
  path = *ppath;
  ext4_split_extent_at(ppath)
  path = ext4_find_extent(ppath)
  ext4_split_extent_at(ppath)
    // ext4_find_extent fails to free path
    // but zeroout succeeds
  ext4_ext_show_leaf(inode, path)
    eh = path[depth].p_hdr
    // path use-after-free !!!

Similar to ext4_split_extent_at(), we use *ppath directly as an input to
ext4_ext_show_leaf(). Fix a spelling error by the way.

Same problem in ext4_ext_handle_unwritten_extents(). Since 'path' is only
used in ext4_ext_show_leaf(), remove 'path' and use *ppath directly.

This issue is triggered only when EXT_DEBUG is defined and therefore does
not affect functionality.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Tested-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://patch.msgid.link/20240822023545.1994557-5-libaokun@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index e067f2dd0335c..7954430f886d8 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3287,7 +3287,7 @@ static int ext4_split_extent_at(handle_t *handle,
 }
 
 /*
- * ext4_split_extents() splits an extent and mark extent which is covered
+ * ext4_split_extent() splits an extent and mark extent which is covered
  * by @map as split_flags indicates
  *
  * It may result in splitting the extent into multiple extents (up to three)
@@ -3363,7 +3363,7 @@ static int ext4_split_extent(handle_t *handle,
 			goto out;
 	}
 
-	ext4_ext_show_leaf(inode, path);
+	ext4_ext_show_leaf(inode, *ppath);
 out:
 	return err ? err : allocated;
 }
@@ -3828,14 +3828,13 @@ ext4_ext_handle_unwritten_extents(handle_t *handle, struct inode *inode,
 			struct ext4_ext_path **ppath, int flags,
 			unsigned int allocated, ext4_fsblk_t newblock)
 {
-	struct ext4_ext_path __maybe_unused *path = *ppath;
 	int ret = 0;
 	int err = 0;
 
 	ext_debug(inode, "logical block %llu, max_blocks %u, flags 0x%x, allocated %u\n",
 		  (unsigned long long)map->m_lblk, map->m_len, flags,
 		  allocated);
-	ext4_ext_show_leaf(inode, path);
+	ext4_ext_show_leaf(inode, *ppath);
 
 	/*
 	 * When writing into unwritten space, we should not fail to
@@ -3932,7 +3931,7 @@ ext4_ext_handle_unwritten_extents(handle_t *handle, struct inode *inode,
 	if (allocated > map->m_len)
 		allocated = map->m_len;
 	map->m_len = allocated;
-	ext4_ext_show_leaf(inode, path);
+	ext4_ext_show_leaf(inode, *ppath);
 out2:
 	return err ? err : allocated;
 }
-- 
2.43.0



