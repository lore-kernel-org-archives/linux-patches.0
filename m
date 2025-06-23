Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE9224DCFD;
	Mon, 23 Jun 2025 13:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685761; cv=none; b=eX5WUwzL4LKNEySCzPBGBmTn3BXXndq2H+QsztpCxgMuMB7EX3B8f2moXvvEU6PRPHpnHDKBx+vsewz1CCVj8XHCLJlPX8mGYsSXOFpIHjXnqcltc8l/eiXL/wP/u01X4SLchpsiZYWlCpalF0IVXX4wUVn57F408sJZW2+1qnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685761; c=relaxed/simple;
	bh=1Vpnx8dR+Z6KbyNE/qDJ0Ey/wOy01vB6VGN29redVis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EiljmNeKg1QaHoVBs5ZFS2do9tVrpmdxMqx8Rgai+n6nnybppVczN21ue9kdAT6KTMcfnNYjA4WIwQ5N/TmD/zORBbxSgiQizxTcOus+AXQ+egoav0dzE2nKaxtR5OtgA3h5N+2W+8BxNtVQwenc22ebJmdYHF9kyGdDMYdjoFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cw4mawtA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cw4mawtA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F185C4CEEA;
	Mon, 23 Jun 2025 13:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685761;
	bh=1Vpnx8dR+Z6KbyNE/qDJ0Ey/wOy01vB6VGN29redVis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cw4mawtAR61JkQVW3e9Z7zgAJ0gCebaZ+ud+dv4+/zPuyGux6bp/145WqJddS02E+
	 44yLtGqBPRLtLpYv1nWbB6ZascA9SP+J626wVI7lfyA6DdiJkF7XkZSj0ivcY30+2W
	 7NCTehukdUPfskGpw/0nGQ/4eg9lEYZutzrkTHcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Wentao Liang <vulab@iscas.ac.cn>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 082/411] nilfs2: do not propagate ENOENT error from nilfs_btree_propagate()
Date: Mon, 23 Jun 2025 15:03:46 +0200
Message-ID: <20250623130635.467796076@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit 8e39fbb1edbb4ec9d7c1124f403877fc167fcecd ]

In preparation for writing logs, in nilfs_btree_propagate(), which makes
parent and ancestor node blocks dirty starting from a modified data block
or b-tree node block, if the starting block does not belong to the b-tree,
i.e.  is isolated, nilfs_btree_do_lookup() called within the function
fails with -ENOENT.

In this case, even though -ENOENT is an internal code, it is propagated to
the log writer via nilfs_bmap_propagate() and may be erroneously returned
to system calls such as fsync().

Fix this issue by changing the error code to -EINVAL in this case, and
having the bmap layer detect metadata corruption and convert the error
code appropriately.

Link: https://lkml.kernel.org/r/20250428173808.6452-3-konishi.ryusuke@gmail.com
Fixes: 1f5abe7e7dbc ("nilfs2: replace BUG_ON and BUG calls triggerable from ioctl")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/btree.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 29f967fb7e9b6..b2abab4b28732 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -2096,11 +2096,13 @@ static int nilfs_btree_propagate(struct nilfs_bmap *btree,
 
 	ret = nilfs_btree_do_lookup(btree, path, key, NULL, level + 1, 0);
 	if (ret < 0) {
-		if (unlikely(ret == -ENOENT))
+		if (unlikely(ret == -ENOENT)) {
 			nilfs_crit(btree->b_inode->i_sb,
 				   "writing node/leaf block does not appear in b-tree (ino=%lu) at key=%llu, level=%d",
 				   btree->b_inode->i_ino,
 				   (unsigned long long)key, level);
+			ret = -EINVAL;
+		}
 		goto out;
 	}
 
-- 
2.39.5



