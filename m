Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539917F7C5;
	Mon,  8 Apr 2024 13:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581973; cv=none; b=qMOWd0s87pkVNpWX+ilAY+oL4d1DkzDcaiJapAQ29bq9BGUZfDGX8SA/7eRAvpzDczg8rXHtaylwRIDDGi2APYdRL3KQHOwThZlqphHgq+c41FcLUEexM++mP95mL5d1oFc2svDP4Yq2k99dh5BRW0MeOCns2GKGvaTlnkFignA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581973; c=relaxed/simple;
	bh=+mVABhxtqWzLUUT9XX8E4If4exztTIGe/ZydfFJbw40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqYn+QY5xX+Tel/FCoxuzqYo6uY8ozeGrSH8df3ol8EVI/tYe5TCiTWgJF9f5+mjSgJeWpgWZ0Q5bWtWw5kGg8AkJv3C+G0J65cfx3VYSyzvL4F1tMvds0OZKLjA0nLI8IEWdigR4WnY+eRCu6iGT4aRfP1wyO+J+uGOgjoUp9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gwi1AHvm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gwi1AHvm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B912C433C7;
	Mon,  8 Apr 2024 13:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581972;
	bh=+mVABhxtqWzLUUT9XX8E4If4exztTIGe/ZydfFJbw40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gwi1AHvmzERRj0gfVNFMGsejXUJlJeGWHsSkQpRfsjPSm9qahd3O5vWok2OsflIvw
	 vLsv1ccgHGrdL+PqpYQO2xEL2/s+muQ9XX/I36A63L9r9HwSyeygwSpNfJbUdzoo6v
	 Ftqi5J0cnEuZpa25C7nsLUhQbG85nnZeuFvigWlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+cfed5b56649bddf80d6e@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 101/690] nilfs2: fix failure to detect DAT corruption in btree and direct mappings
Date: Mon,  8 Apr 2024 14:49:27 +0200
Message-ID: <20240408125403.146612422@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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
index def9121a466ef..385ec71fcdef2 100644
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
@@ -781,6 +781,11 @@ static int nilfs_btree_lookup_contig(const struct nilfs_bmap *btree,
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



