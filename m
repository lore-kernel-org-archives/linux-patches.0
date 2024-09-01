Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E141EB5B;
	Sun,  1 Sep 2024 17:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210101; cv=none; b=UAI7A/c1dAHiNuJFtNdPA0xcMA8mO32DMu/hZHdsO2L2R5gF5xtU99+vOsrsGEnCAt0EPRQCZwTpPwVaygYQR9SoiRDKnOFcaGw01JkjePKpi5xELgnUqPr3ot3iVA/dj3g2iwO5WQ2yRM0qA2f8q3IBtvNnPiyLX9MyoXY6wLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210101; c=relaxed/simple;
	bh=FFO4hm9qwK46cJi+Ae792x97/1+SYXPfOXNM7nxtyEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IR/lpYfDxtZUr2MuPWlgS7Y96uetlbmdzzmR9ZYgiNUYLxhrXKoeEwswHo9vXJBD+pCJPH6WyGV852CSIrTZZiRE2XB0vjB5QVtTETmB/7D5HY54T7XdhpsEykhwMLXk6CcpCDTdPr8I6MIE9R+N2KS6F2rVS/Ghq0Ticnq0j1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mv9IMCrS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mv9IMCrS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04E12C4CEC3;
	Sun,  1 Sep 2024 17:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210100;
	bh=FFO4hm9qwK46cJi+Ae792x97/1+SYXPfOXNM7nxtyEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mv9IMCrS1mtwtSr8ehvWSVL7J/g6iysW/fpnocS1+vPfjT7VhlvUKTdEplnvqznH5
	 MXruKIMf4D6pzATU7X11/rvPjSfSBI/win/eA2UnkqeO3ijMV1DJE05MWN9fFqsXfK
	 cMpkmS/hEA1B+lK/cAxIAmTzIiKO+cuBeoFgtm8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 088/215] btrfs: handle invalid root reference found in may_destroy_subvol()
Date: Sun,  1 Sep 2024 18:16:40 +0200
Message-ID: <20240901160826.681154499@linuxfoundation.org>
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

From: David Sterba <dsterba@suse.com>

[ Upstream commit 6fbc6f4ac1f4907da4fc674251527e7dc79ffbf6 ]

The may_destroy_subvol() looks up a root by a key, allowing to do an
inexact search when key->offset is -1.  It's never expected to find such
item, as it would break the allowed range of a root id.

Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 07c6ab4ba0d43..66b56ddf3f4cc 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4411,7 +4411,14 @@ static noinline int may_destroy_subvol(struct btrfs_root *root)
 	ret = btrfs_search_slot(NULL, fs_info->tree_root, &key, path, 0, 0);
 	if (ret < 0)
 		goto out;
-	BUG_ON(ret == 0);
+	if (ret == 0) {
+		/*
+		 * Key with offset -1 found, there would have to exist a root
+		 * with such id, but this is out of valid range.
+		 */
+		ret = -EUCLEAN;
+		goto out;
+	}
 
 	ret = 0;
 	if (path->slots[0] > 0) {
-- 
2.43.0



