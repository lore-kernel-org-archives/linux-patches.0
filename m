Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4712F24;
	Mon, 23 Jun 2025 13:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684914; cv=none; b=joP6MK88rSXUmxK3q0ShuUR8UVaZ5421w+lpklrVryf8ZWABEgyDTydcQHpA/14nOAtnkoEqABe/cXnfEvbgUkiyp/VYh/sm2/byUSQoszgMSOZaWMrHaDp15k1WLuCWFjD7aMamwiLtkxikH1pBqW3Jo9x3gbI+lfUY4KKFru0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684914; c=relaxed/simple;
	bh=tlSAndm4DrvHrJ4NwDJFM2r2NG4x3e5YHCruBodyskk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aBN/7+YMyUIT1qbS3zqtt0vF5kyXCt4pzb914yOCYGksg9O8JZEC6C5fk0jW7iHKTK9qe/DB6cr5z/W/sXWGynVV5AbhSVpJXj+9egF4mULMtpkMHvLcuAvkUIajVox6Xr28Bu/dyQXwk4t14SZ711dzlZTYSVuhcJ5ijMPkRoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YmeWe4aa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YmeWe4aa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F64C4CEEA;
	Mon, 23 Jun 2025 13:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684914;
	bh=tlSAndm4DrvHrJ4NwDJFM2r2NG4x3e5YHCruBodyskk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YmeWe4aa3dKh2W5IdKbQKMhZYWhYxZkAijogPIUwO7PpZ8ad88ebyxwA26ue2jrmm
	 LNxOxTW3EWoxIBQpa3VEZArWZCR3EZzRPRLeuOekXQ9qkelbHQXRpBzz8Mry212WJk
	 YMtohtsVzOaCk9zojGbSPFdZse+r4eYa/hF8Oivs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Wentao Liang <vulab@iscas.ac.cn>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 046/222] nilfs2: do not propagate ENOENT error from nilfs_btree_propagate()
Date: Mon, 23 Jun 2025 15:06:21 +0200
Message-ID: <20250623130613.334950905@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 7c9f4d79bdbc5..4a5e8495fa674 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -2097,11 +2097,13 @@ static int nilfs_btree_propagate(struct nilfs_bmap *btree,
 
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



