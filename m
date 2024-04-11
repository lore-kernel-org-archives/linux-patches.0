Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED4363A2;
	Thu, 11 Apr 2024 10:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831856; cv=none; b=dweBLQct0rau2/oGJCWqlrT9d93Wzk2Qai1FytclZlALy0MlCg+uj/HB0gsk1OebjYW+hCsPCYZcghd/Ypk/KkxpEzlxDTq4TUTdD1BzhsoxI71pzjGRETvUEuH/VoL8G4zHTDllcZzXSvJWuTiLjDhsg5kfGozvofNJFWZcONs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831856; c=relaxed/simple;
	bh=J8O06kkziEBTZNofZQesUJyRGfRB02VvF5OMksBCGdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YqThjjs9yIWaEb6U0ldUXBY+kM1YEgDS4OI+LMpiRVhmu3ImQ3WujjHlIyGx5+mueM0FdZUXkdvT3e480R1hgV8SIgd9sUHB06KVT7blmPcU5TmyFRxDBtmi+znbnoNhORewpYEx3/uGO8DlG/ZTA4LkOu+QNpri4BMzIlo5qKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GhoMEYRV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GhoMEYRV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B31C433F1;
	Thu, 11 Apr 2024 10:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831856;
	bh=J8O06kkziEBTZNofZQesUJyRGfRB02VvF5OMksBCGdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GhoMEYRVJfGPLbaMNnh03e4PH6YYR+3qZ2jx9DiceeWSgw3t/I6c8qH8cdR4T7/MT
	 W2hS04aZNCxBJ287KQzGb4rTzFIi59MR5kyYvRDw5yX75mYRCS/1K3TvdTWb5FQHHD
	 K6hRWNjYMY8cT67glq+bo3NIkMLQnTnrGrGXCcwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+cfed5b56649bddf80d6e@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 101/294] nilfs2: fix failure to detect DAT corruption in btree and direct mappings
Date: Thu, 11 Apr 2024 11:54:24 +0200
Message-ID: <20240411095438.712987725@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

[ Upstream commit f2f26b4a84a0ef41791bd2d70861c8eac748f4ba ]

Patch series "nilfs2: fix kernel bug at submit_bh_wbc()".

This resolves a kernel BUG reported by syzbot.  Since there are two
flaws involved, I've made each one a separate patch.

The first patch alone resolves the syzbot-reported bug, but I think
both fixes should be sent to stable, so I've tagged them as such.

This patch (of 2):

Syzbot has reported a kernel bug in submit_bh_wbc() when writing file data
to a nilfs2 file system whose metadata is corrupted.

There are two flaws involved in this issue.

The first flaw is that when nilfs_get_block() locates a data block using
btree or direct mapping, if the disk address translation routine
nilfs_dat_translate() fails with internal code -ENOENT due to DAT metadata
corruption, it can be passed back to nilfs_get_block().  This causes
nilfs_get_block() to misidentify an existing block as non-existent,
causing both data block lookup and insertion to fail inconsistently.

The second flaw is that nilfs_get_block() returns a successful status in
this inconsistent state.  This causes the caller __block_write_begin_int()
or others to request a read even though the buffer is not mapped,
resulting in a BUG_ON check for the BH_Mapped flag in submit_bh_wbc()
failing.

This fixes the first issue by changing the return value to code -EINVAL
when a conversion using DAT fails with code -ENOENT, avoiding the
conflicting condition that leads to the kernel bug described above.  Here,
code -EINVAL indicates that metadata corruption was detected during the
block lookup, which will be properly handled as a file system error and
converted to -EIO when passing through the nilfs2 bmap layer.

Link: https://lkml.kernel.org/r/20240313105827.5296-1-konishi.ryusuke@gmail.com
Link: https://lkml.kernel.org/r/20240313105827.5296-2-konishi.ryusuke@gmail.com
Fixes: c3a7abf06ce7 ("nilfs2: support contiguous lookup of blocks")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+cfed5b56649bddf80d6e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=cfed5b56649bddf80d6e
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/btree.c  | 9 +++++++--
 fs/nilfs2/direct.c | 9 +++++++--
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 65cd599cb2ab6..4905b7cd7bf33 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -724,7 +724,7 @@ static int nilfs_btree_lookup_contig(const struct nilfs_bmap *btree,
 		dat = nilfs_bmap_get_dat(btree);
 		ret = nilfs_dat_translate(dat, ptr, &blocknr);
 		if (ret < 0)
-			goto out;
+			goto dat_error;
 		ptr = blocknr;
 	}
 	cnt = 1;
@@ -743,7 +743,7 @@ static int nilfs_btree_lookup_contig(const struct nilfs_bmap *btree,
 			if (dat) {
 				ret = nilfs_dat_translate(dat, ptr2, &blocknr);
 				if (ret < 0)
-					goto out;
+					goto dat_error;
 				ptr2 = blocknr;
 			}
 			if (ptr2 != ptr + cnt || ++cnt == maxblocks)
@@ -782,6 +782,11 @@ static int nilfs_btree_lookup_contig(const struct nilfs_bmap *btree,
  out:
 	nilfs_btree_free_path(path);
 	return ret;
+
+ dat_error:
+	if (ret == -ENOENT)
+		ret = -EINVAL;  /* Notify bmap layer of metadata corruption */
+	goto out;
 }
 
 static void nilfs_btree_promote_key(struct nilfs_bmap *btree,
diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
index f353101955e3b..7faf8c285d6c9 100644
--- a/fs/nilfs2/direct.c
+++ b/fs/nilfs2/direct.c
@@ -66,7 +66,7 @@ static int nilfs_direct_lookup_contig(const struct nilfs_bmap *direct,
 		dat = nilfs_bmap_get_dat(direct);
 		ret = nilfs_dat_translate(dat, ptr, &blocknr);
 		if (ret < 0)
-			return ret;
+			goto dat_error;
 		ptr = blocknr;
 	}
 
@@ -79,7 +79,7 @@ static int nilfs_direct_lookup_contig(const struct nilfs_bmap *direct,
 		if (dat) {
 			ret = nilfs_dat_translate(dat, ptr2, &blocknr);
 			if (ret < 0)
-				return ret;
+				goto dat_error;
 			ptr2 = blocknr;
 		}
 		if (ptr2 != ptr + cnt)
@@ -87,6 +87,11 @@ static int nilfs_direct_lookup_contig(const struct nilfs_bmap *direct,
 	}
 	*ptrp = ptr;
 	return cnt;
+
+ dat_error:
+	if (ret == -ENOENT)
+		ret = -EINVAL;  /* Notify bmap layer of metadata corruption */
+	return ret;
 }
 
 static __u64
-- 
2.43.0



