Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB8235A3B7
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300920; cv=none; b=dvF+P/5bji/GUemZ63QDgh20eNkQXwCS2eo02U1ExMcjDLSTTxxcLypprgGtYWwxBxQrWoBY0A7Sw8dquSnLT1xWOFDddOKT85134AwsphIaPUUEIwUF75MqOGlNhqFG1wCUY0rmdX9gKDtpIEzdn0Q2cnYHOi0M3mhD4ssJx0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300920; c=relaxed/simple;
	bh=jYGMSl7GrHFClHthZd7ZEUTk7vbj8A7hXlDhnywIKxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LyKBVGRQAivoZ+V7v/FpxzEsHxUkKJrJD47bKGsS4Rhql7tEY3zG9oh/9LevzUk6K946AjWaRZAPudXkBRpr+6jD6MvCqa7Pib19X7i3i+eT4S+4OFfzByuAyeMJyjJRrMa5k78HYcRUoNM4TGnxeEdAxNNsBsOEb7sr1c2cXpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n85wkwF1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n85wkwF1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD87C19425;
	Sat, 28 Feb 2026 17:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300920;
	bh=jYGMSl7GrHFClHthZd7ZEUTk7vbj8A7hXlDhnywIKxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n85wkwF1kAypyviSGI7x2Zyn5xTPegYrdDzE1wWgXWdZzIa9XBWyAU1UboYQbpdjx
	 5RrISjbNeCA5y4VzYhq75W1SbC2/Z6cP2/nGbur5PGwshKfJJdPWP57ro9G3g4St+t
	 Ur9SzRCeTLWHPAzZUrZYGodDS+6TH+ZjZtHkAZ8GO107og2TRy0qC2Jjurn5Yd2QNN
	 BwtSzoZmmTUdOpofog7qlWfLXCtdZnxHidvx7eBZgWdFNmS1R67n+pfieoRzmXTYE4
	 I2hV7A6zNZeaaz39HdyspP3u2ykjQD7t4OanM1QhXR2g307wolg9U6KPiI5DuPkpg3
	 Yolz2RN0xyniQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: jinbaohong <jinbaohong@synology.com>,
	Qu Wenruo <wqu@suse.com>,
	Robbie Ko <robbieko@synology.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 037/752] btrfs: handle user interrupt properly in btrfs_trim_fs()
Date: Sat, 28 Feb 2026 12:35:48 -0500
Message-ID: <20260228174750.1542406-37-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: jinbaohong <jinbaohong@synology.com>

[ Upstream commit bfb670b9183b0e4ba660aff2e396ec1cc01d0761 ]

When a fatal signal is pending or the process is freezing,
btrfs_trim_block_group() and btrfs_trim_free_extents() return -ERESTARTSYS.
Currently this is treated as a regular error: the loops continue to the
next iteration and count it as a block group or device failure.

Instead, break out of the loops immediately and return -ERESTARTSYS to
userspace without counting it as a failure. Also skip the device loop
entirely if the block group loop was interrupted.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Robbie Ko <robbieko@synology.com>
Signed-off-by: jinbaohong <jinbaohong@synology.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-tree.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 01337e3f2879c..a48ba97bb3694 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6568,6 +6568,10 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
 						     range->minlen);
 
 			trimmed += group_trimmed;
+			if (ret == -ERESTARTSYS || ret == -EINTR) {
+				btrfs_put_block_group(cache);
+				break;
+			}
 			if (ret) {
 				bg_failed++;
 				bg_ret = ret;
@@ -6581,6 +6585,9 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
 			"failed to trim %llu block group(s), last error %d",
 			bg_failed, bg_ret);
 
+	if (ret == -ERESTARTSYS || ret == -EINTR)
+		return ret;
+
 	mutex_lock(&fs_devices->device_list_mutex);
 	list_for_each_entry(device, &fs_devices->devices, dev_list) {
 		if (test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state))
@@ -6589,6 +6596,8 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
 		ret = btrfs_trim_free_extents(device, &group_trimmed);
 
 		trimmed += group_trimmed;
+		if (ret == -ERESTARTSYS || ret == -EINTR)
+			break;
 		if (ret) {
 			dev_failed++;
 			dev_ret = ret;
@@ -6602,6 +6611,8 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
 			"failed to trim %llu device(s), last error %d",
 			dev_failed, dev_ret);
 	range->len = trimmed;
+	if (ret == -ERESTARTSYS || ret == -EINTR)
+		return ret;
 	if (bg_ret)
 		return bg_ret;
 	return dev_ret;
-- 
2.51.0

