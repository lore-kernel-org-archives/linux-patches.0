Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F69F3F8F4;
	Mon,  1 Apr 2024 16:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989887; cv=none; b=IfLi3hWg7j4AKBDu8xrECVoCjVh6SnCPfVV/GwcX1fqkJhmKPJJUV5FszHmU7Biu1gziJ7K+7jXJDfiN/dxGFlKjUbD6O/BQmBvSMIvrLRdT2LThaWKqdAfCKOYFTSXfBaA8jdN+IsE8OXyKq9OoUgwygUzaTdepFYAR0OBYLak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989887; c=relaxed/simple;
	bh=p2Sfy1lI26AY5SfS46L3a22k6rc9LKF6f/OyP0BrEws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uDV9+pDDpm+BglE30XUm+8XUBA0tT7sPR1SbJ6DuMRRgD/3p4Ik1L5zQayLellXcst56GpeZQklVgIPi7Ai2Vr1CTVJpeX7FLFNE/PwFSuzvBmGYc2Pw54DEQLCq79Zvmxl9G+O2TbJVjciORspM7M2JTqfOxtdN5jE6i5q7iGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2KVxCq1F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2KVxCq1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84979C433C7;
	Mon,  1 Apr 2024 16:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989887;
	bh=p2Sfy1lI26AY5SfS46L3a22k6rc9LKF6f/OyP0BrEws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2KVxCq1FA1pXdt/GRzgyWPtCoAehlg41ukGPLCatRA4ZjWRJCmQPrzpB79fOlF1yt
	 tXXoOBMEY/f7WDzLT+7ipelDXFPf9rQgqCCrJFK5NJn3D6qk0ZZhyYQzE+2CzlSuSU
	 KLwqfAtd3L/7ecNoh1SEv/dp979caK73okzcWIfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+cfed5b56649bddf80d6e@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 154/396] nilfs2: fix failure to detect DAT corruption in btree and direct mappings
Date: Mon,  1 Apr 2024 17:43:23 +0200
Message-ID: <20240401152552.537041342@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 13592e82eaf68..65659fa0372e6 100644
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
index 4c85914f2abc3..893ab36824cc2 100644
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



