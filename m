Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0506E1DF996;
	Wed,  6 Nov 2024 12:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895541; cv=none; b=lE5n8FqPHdBBnuL3iN7WZEnp059a9A81GDWKG8j++KZLuAUD5T5DZAb7NbNwIfmdZdGVqr4YQPtR99Ia29Kp+zMc/JSSqoWyXLZb/WrO9VeH32E6bla3WK/tbPEMHVnVsCYi41ZArRKQ7f+fBtQYHHfykLdfM1A4UyLdWdtcKrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895541; c=relaxed/simple;
	bh=9BLyk2x10dZKN26xwVcXaeribsBNqenBtzqqcjqqmBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BXbpUMDiGKMmEUFtLWABmsk3CnO9COapTo7/N2Sn/C6O4JpmkY9EW9hiid7H7DL1W+Ra4SqQ1M6jMeXChc6tIijxfThr5BLZ90TKjy34wWVIIYc9wM2nKXjVUyJu8V+n5xBDw6zL8LA4LbDSgteV1ouBNDEUuNdTW3TUCKtlWdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A47OaFw0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A47OaFw0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789EEC4CED4;
	Wed,  6 Nov 2024 12:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895540;
	bh=9BLyk2x10dZKN26xwVcXaeribsBNqenBtzqqcjqqmBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A47OaFw0y8zIrPOqOZKS9WdenNLcghmFwHsDmr4EvfVa73+Zoxz1BoMQKsbDAvPxX
	 eAJFYSx6j4HBT3uIgDtzCn+qNkwUtREDcTWcz+oo0423mQO9D6QoMQeBrjQfQ18I18
	 oTfqgD51clhvcwL7wsBeAMylbWQkDLhi9urOn9e4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 216/350] ext4: update orig_path in ext4_find_extent()
Date: Wed,  6 Nov 2024 13:02:24 +0100
Message-ID: <20241106120326.334480510@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 5b4b2dcace35f618fe361a87bae6f0d13af31bc1 ]

In ext4_find_extent(), if the path is not big enough, we free it and set
*orig_path to NULL. But after reallocating and successfully initializing
the path, we don't update *orig_path, in which case the caller gets a
valid path but a NULL ppath, and this may cause a NULL pointer dereference
or a path memory leak. For example:

ext4_split_extent
  path = *ppath = 2000
  ext4_find_extent
    if (depth > path[0].p_maxdepth)
      kfree(path = 2000);
      *orig_path = path = NULL;
      path = kcalloc() = 3000
  ext4_split_extent_at(*ppath = NULL)
    path = *ppath;
    ex = path[depth].p_ext;
    // NULL pointer dereference!

==================================================================
BUG: kernel NULL pointer dereference, address: 0000000000000010
CPU: 6 UID: 0 PID: 576 Comm: fsstress Not tainted 6.11.0-rc2-dirty #847
RIP: 0010:ext4_split_extent_at+0x6d/0x560
Call Trace:
 <TASK>
 ext4_split_extent.isra.0+0xcb/0x1b0
 ext4_ext_convert_to_initialized+0x168/0x6c0
 ext4_ext_handle_unwritten_extents+0x325/0x4d0
 ext4_ext_map_blocks+0x520/0xdb0
 ext4_map_blocks+0x2b0/0x690
 ext4_iomap_begin+0x20e/0x2c0
[...]
==================================================================

Therefore, *orig_path is updated when the extent lookup succeeds, so that
the caller can safely use path or *ppath.

Fixes: 10809df84a4d ("ext4: teach ext4_ext_find_extent() to realloc path if necessary")
Cc: stable@kernel.org
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20240822023545.1994557-6-libaokun@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents.c     | 3 ++-
 fs/ext4/move_extent.c | 1 -
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index c538d09542391..63380c2910077 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -956,6 +956,8 @@ ext4_find_extent(struct inode *inode, ext4_lblk_t block,
 
 	ext4_ext_show_path(inode, path);
 
+	if (orig_path)
+		*orig_path = path;
 	return path;
 
 err:
@@ -3311,7 +3313,6 @@ static int ext4_split_extent_at(handle_t *handle,
 	}
 	depth = ext_depth(inode);
 	ex = path[depth].p_ext;
-	*ppath = path;
 
 	if (EXT4_EXT_MAY_ZEROOUT & split_flag) {
 		if (split_flag & (EXT4_EXT_DATA_VALID1|EXT4_EXT_DATA_VALID2)) {
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 2c368d67a33ac..1581b48af1fed 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -37,7 +37,6 @@ get_ext_path(struct inode *inode, ext4_lblk_t lblock,
 		*ppath = NULL;
 		return -ENODATA;
 	}
-	*ppath = path;
 	return 0;
 }
 
-- 
2.43.0



