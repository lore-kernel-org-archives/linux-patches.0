Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92881D5AD7;
	Wed,  6 Nov 2024 12:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895021; cv=none; b=X5qqRLaGaZRUL38IkWGlIx6FTWw8brkTT38iRCrSRT0Mx1F3UDo+WzvHuOfE161hkuTwYXoZnq6EgmzMgcOPXaFlLRD1U6GqkEEl70NgjOdeMdXIzb3OqGyf9/a1CckgRC23CP/sMxb78DfMTViLTgpGdvoy/mqoW+Ojs5gdQO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895021; c=relaxed/simple;
	bh=BqGcA7IliecmaTaj9tw36B5DBsUKR57b/5eiwz2gGyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pjio3SBxD4wswAXby0EC7CzwAk4jDyPWpShWYZNjpZb5dtW0oNuF9GTdvAT7+VWRRZrzA7Os4Z3dcWKtp8qv1KYaMtMpJ7Qjan1QWs/xhetq3isJqejBU/q7xOKzoKg370prvj7P7NOmBnl6AOMXUuZJ3n5/JMy9FGgZ5tB2hcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D3ZI563I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D3ZI563I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9DF0C4CECD;
	Wed,  6 Nov 2024 12:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895021;
	bh=BqGcA7IliecmaTaj9tw36B5DBsUKR57b/5eiwz2gGyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D3ZI563IWZ6VjQHjmgrvLw340hLFyE9cipBYC3UnHH2WPkoyPxIbORAKhRgu8FiE1
	 AydhWuhV+na9uO5gmIivwoMdfSfFK3nc0fhhQTXFityzJKAzwExue1UguBMn0xcHmj
	 7QF9d1Obq3/6aWiAncfhlN8xBO8+S5E2KAAfm3fA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 078/350] nilfs2: fix potential oob read in nilfs_btree_check_delete()
Date: Wed,  6 Nov 2024 13:00:06 +0100
Message-ID: <20241106120322.821071471@linuxfoundation.org>
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

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

[ Upstream commit f9c96351aa6718b42a9f42eaf7adce0356bdb5e8 ]

The function nilfs_btree_check_delete(), which checks whether degeneration
to direct mapping occurs before deleting a b-tree entry, causes memory
access outside the block buffer when retrieving the maximum key if the
root node has no entries.

This does not usually happen because b-tree mappings with 0 child nodes
are never created by mkfs.nilfs2 or nilfs2 itself.  However, it can happen
if the b-tree root node read from a device is configured that way, so fix
this potential issue by adding a check for that case.

Link: https://lkml.kernel.org/r/20240904081401.16682-4-konishi.ryusuke@gmail.com
Fixes: 17c76b0104e4 ("nilfs2: B-tree based block mapping")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Lizhi Xu <lizhi.xu@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/btree.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 7cfff27b4b4a5..7c9f4d79bdbc5 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -1660,13 +1660,16 @@ static int nilfs_btree_check_delete(struct nilfs_bmap *btree, __u64 key)
 	int nchildren, ret;
 
 	root = nilfs_btree_get_root(btree);
+	nchildren = nilfs_btree_node_get_nchildren(root);
+	if (unlikely(nchildren == 0))
+		return 0;
+
 	switch (nilfs_btree_height(btree)) {
 	case 2:
 		bh = NULL;
 		node = root;
 		break;
 	case 3:
-		nchildren = nilfs_btree_node_get_nchildren(root);
 		if (nchildren > 1)
 			return 0;
 		ptr = nilfs_btree_node_get_ptr(root, nchildren - 1,
@@ -1675,12 +1678,12 @@ static int nilfs_btree_check_delete(struct nilfs_bmap *btree, __u64 key)
 		if (ret < 0)
 			return ret;
 		node = (struct nilfs_btree_node *)bh->b_data;
+		nchildren = nilfs_btree_node_get_nchildren(node);
 		break;
 	default:
 		return 0;
 	}
 
-	nchildren = nilfs_btree_node_get_nchildren(node);
 	maxkey = nilfs_btree_node_get_key(node, nchildren - 1);
 	nextmaxkey = (nchildren > 1) ?
 		nilfs_btree_node_get_key(node, nchildren - 2) : 0;
-- 
2.43.0



