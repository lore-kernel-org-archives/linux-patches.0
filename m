Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82105313E13;
	Tue, 16 Dec 2025 11:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884214; cv=none; b=kbFh6lIKNpaNXx5+P4pZ0GGCHkU1Ffdh5pNR7BfU9NaZ2XJ7aw6t0TPnQBHpnul2qU7c5dqz1gDyvABzMs4MH2P0QqPjgzAnI9FkIvKD4O5Tb5KbE2Vi5vLYCR6dRazBDoatyXz8tVQFCoRcKAQvEKTeMXXTwxliMD59LBWSVz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884214; c=relaxed/simple;
	bh=rsx80Ne10H698HQFt8muXnVvsAZf3TibK9qx1IHVlwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pz8ZYzvyzBnCiQGdLXFYLRLeyNNiuZQfuhIrfN+Cb27RsCcqlFLqdbPMxoTRrIq8OeG2haYcA/+RMlbDw6zHhNC5Vr7O+JyplDspjyMyQEkWJYZpJedmk3Ph6otFs2SZNFloFAtHc4W821JCnSlTkB67HpcJk9eXXJoj+02GWcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x+BU7wQD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x+BU7wQD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F55C4CEF5;
	Tue, 16 Dec 2025 11:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884214;
	bh=rsx80Ne10H698HQFt8muXnVvsAZf3TibK9qx1IHVlwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x+BU7wQDtxiJkLFwFkd4SJJDqTXtBNmSfu7xlnZCMdFVJ2G1HiGE464rXcR8kez7k
	 MLdYRR42M/7svRDD5skqO5kqSsfBmROWouVL24iTdQMbcTi5R6QHlTtA7h2txjDyEd
	 sqEkVfM0g43efQ17lzEXi6hqroudFVi1hJjqSts8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 126/354] ext4: correct the checking of quota files before moving extents
Date: Tue, 16 Dec 2025 12:11:33 +0100
Message-ID: <20251216111325.487735231@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit a2e5a3cea4b18f6e2575acc444a5e8cce1fc8260 ]

The move extent operation should return -EOPNOTSUPP if any of the inodes
is a quota inode, rather than requiring both to be quota inodes.

Fixes: 02749a4c2082 ("ext4: add ext4_is_quota_file()")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Message-ID: <20251013015128.499308-2-yi.zhang@huaweicloud.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/move_extent.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index a4c94eabc78ec..dfd7958899288 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -487,7 +487,7 @@ mext_check_arguments(struct inode *orig_inode,
 		return -ETXTBSY;
 	}
 
-	if (ext4_is_quota_file(orig_inode) && ext4_is_quota_file(donor_inode)) {
+	if (ext4_is_quota_file(orig_inode) || ext4_is_quota_file(donor_inode)) {
 		ext4_debug("ext4 move extent: The argument files should not be quota files [ino:orig %lu, donor %lu]\n",
 			orig_inode->i_ino, donor_inode->i_ino);
 		return -EOPNOTSUPP;
-- 
2.51.0



