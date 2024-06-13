Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB37143887;
	Thu, 13 Jun 2024 11:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278891; cv=none; b=Ki+hk9SKduwQXxzCq+KBLb4MhYh69yf0HXEQl7c7yqhVimjAhehJ8U8ssohNCYGUzT/iDvhX9tqs3o1Kxdi6T+QhEcAf9qDfFeLnoW6Ha4W0CSHZvaltkrdjO/9Bf8ZfjWr8g8toZKYfwQKEVx1qAaZnJuR020W6fmciSdscEkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278891; c=relaxed/simple;
	bh=xW7XNGJGMRXhINOAzTvcRARWvUE+8nH5/oHeWebnPP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O5W3Or8n7gll+Ha/iw3R57yFcO5DcluqO30VNL0euvMrBtZuVqrt4m9n9o62HdjKCdIhaefeDiae4c5o+bU4usN3+i/2QVrdOcDAGPneCSykGGM8iFifppQJzxW3OqGJA6vSooRpkVW8KGP8amELjwiiWmPVmj+X6T5zBkK8O1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w6K8PB4j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w6K8PB4j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98932C2BBFC;
	Thu, 13 Jun 2024 11:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278891;
	bh=xW7XNGJGMRXhINOAzTvcRARWvUE+8nH5/oHeWebnPP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w6K8PB4jMLdFMMrJpvivZydNNMhVQFr40af5GclPsnPHgHy4jdbVkD1llGAzlzEj5
	 zOtHnKxNqKbNSZqKJ3zpRkXRPk0V4Bb2YD9BhEsCEt0rtUY9d6+GNLsvHNxzA0r40N
	 l2BeA1EJqatqWCAHizZYkSqlNfAesdzECZXgKRVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sahitya Tummala <stummala@codeaurora.org>,
	Chao Yu <yuchao0@huawei.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 104/213] f2fs: add error prints for debugging mount failure
Date: Thu, 13 Jun 2024 13:32:32 +0200
Message-ID: <20240613113232.016467344@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

From: Sahitya Tummala <stummala@codeaurora.org>

[ Upstream commit 9227d5227b8db354d386f592f159eaa44db1c0b8 ]

Add error prints to get more details on the mount failure.

Signed-off-by: Sahitya Tummala <stummala@codeaurora.org>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 0fa4e57c1db2 ("f2fs: fix to release node block count in error path of f2fs_new_node_page()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 6 +++++-
 fs/f2fs/super.c   | 4 ++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 7596fce92bef1..34090edc8ce25 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -3409,8 +3409,12 @@ static int restore_curseg_summaries(struct f2fs_sb_info *sbi)
 
 	/* sanity check for summary blocks */
 	if (nats_in_cursum(nat_j) > NAT_JOURNAL_ENTRIES ||
-			sits_in_cursum(sit_j) > SIT_JOURNAL_ENTRIES)
+			sits_in_cursum(sit_j) > SIT_JOURNAL_ENTRIES) {
+		f2fs_msg(sbi->sb, KERN_ERR,
+			"invalid journal entries nats %u sits %u\n",
+			nats_in_cursum(nat_j), sits_in_cursum(sit_j));
 		return -EINVAL;
+	}
 
 	return 0;
 }
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 89fc8a4ce1497..b075ba3e62dcd 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -3016,13 +3016,13 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	err = f2fs_build_segment_manager(sbi);
 	if (err) {
 		f2fs_msg(sb, KERN_ERR,
-			"Failed to initialize F2FS segment manager");
+			"Failed to initialize F2FS segment manager (%d)", err);
 		goto free_sm;
 	}
 	err = f2fs_build_node_manager(sbi);
 	if (err) {
 		f2fs_msg(sb, KERN_ERR,
-			"Failed to initialize F2FS node manager");
+			"Failed to initialize F2FS node manager (%d)", err);
 		goto free_nm;
 	}
 
-- 
2.43.0



