Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2340F3358D5;
	Tue, 16 Dec 2025 12:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887398; cv=none; b=fcEyuWEUMwkGFB/6IRkyCLaL5q/uXQXyn8rNtjHv9U63L3QIv701p1R02BCayn+iTT6ze4WbgnP8FlUQvC4hBkyjSwCX42y8ZEVEg8M9wXkfDCjRQXsfw1275dREeT8BC4KzwuTS5e3AUJtRgLbqKUPLwLloC3FhxkXDqkMnNSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887398; c=relaxed/simple;
	bh=cR+C1ZhrG+OJGWinAW46WrwJM61xnGQNow9McSkAAJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nqpjzNvJD+RK/qw1jtP0mKa6iqKMni2PBORtqoS8/ST0v5VZpOHQj8m2DQLmzyo9J46/iK95cFfeF3UKpyklBnvhK0cQWGI6+a+Vd3Y9Fr8wVSDBLJFn3a6Wa4aDbEOUVEqkVQzuRhuwPf5c3RPp6y82UIB3Ob15pFFtKLYc2V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sFwjEupI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sFwjEupI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73ED6C19423;
	Tue, 16 Dec 2025 12:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887397;
	bh=cR+C1ZhrG+OJGWinAW46WrwJM61xnGQNow9McSkAAJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sFwjEupIO+17P7WiQX08XeiYHDShivVLiJzdKaHgF9rrjzZ+vcenJQe4Sa9ubLNGy
	 S8zrg37YuoCTYX1zgwlcxCeI9Oi5KoZ4W+IHsVjkt/Mq6wj42Mo2u6RxhFdGi4O8Nu
	 2em111oKZhzSQCIXgZr8lrDYb/3lScQUk1tbk5vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 218/614] ext4: correct the checking of quota files before moving extents
Date: Tue, 16 Dec 2025 12:09:45 +0100
Message-ID: <20251216111409.273425175@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 4b091c21908fd..0f4b7c89edd39 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -485,7 +485,7 @@ mext_check_arguments(struct inode *orig_inode,
 		return -ETXTBSY;
 	}
 
-	if (ext4_is_quota_file(orig_inode) && ext4_is_quota_file(donor_inode)) {
+	if (ext4_is_quota_file(orig_inode) || ext4_is_quota_file(donor_inode)) {
 		ext4_debug("ext4 move extent: The argument files should not be quota files [ino:orig %lu, donor %lu]\n",
 			orig_inode->i_ino, donor_inode->i_ino);
 		return -EOPNOTSUPP;
-- 
2.51.0



