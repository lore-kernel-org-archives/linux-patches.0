Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8D632FA3D;
	Fri,  9 Jan 2026 11:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959650; cv=none; b=RGzrabPDxuZhIyZGP5Dq/uqOdslYP2FCBqIE7AnESyn7MELj8YS7+PxoKZY2fzYe/h6UB6nJFbQS45DQIm+aOVDyQ7cEooxgaGeD89I88mlCap2CzO7Rqyi9gwDVuXZMU5dzSguiwJ9d2+tlGCXxMNfAdBcOKTfilI50lUPp810=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959650; c=relaxed/simple;
	bh=bKgZIG7FnC/DBQBefokquTxCBqnMofwgvFrkTDe40pM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QjhX6i2Htj6qCYekPdnIYnkEexb+B8RLcALi4IuvQBPO7bj7cvx4dwjStuVpwtMS25q5HBAfGemst17mrl0CIa1yQTGmICVDxxEMmqj5Md1WNEWBGp1SjgE3Y8p3bfvdwGYF+e1psNIyg9uyrKn5a2AUStMDGZZ9ddhse6gV8o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R8q050+V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R8q050+V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88C5CC4CEF1;
	Fri,  9 Jan 2026 11:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959649;
	bh=bKgZIG7FnC/DBQBefokquTxCBqnMofwgvFrkTDe40pM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R8q050+VV+zJYhNSWmgkpmHTP5mVD5RvNstyLCUyw4bWYv202QhKc9GLX5J+wpTjF
	 Hf9iwWp8ihA8nLxHts4FZy5druPFcCCn0SdShLtLwgZ5MUH/GV5HxHnBk6yz7Xvr9V
	 eUBkd7ByHggB3ddh6QfzLANTd/gaqCzjW2mn9GT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 126/737] ext4: correct the checking of quota files before moving extents
Date: Fri,  9 Jan 2026 12:34:25 +0100
Message-ID: <20260109112138.742758190@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c566161127cd7..a3b0acca02ca5 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -486,7 +486,7 @@ mext_check_arguments(struct inode *orig_inode,
 		return -ETXTBSY;
 	}
 
-	if (ext4_is_quota_file(orig_inode) && ext4_is_quota_file(donor_inode)) {
+	if (ext4_is_quota_file(orig_inode) || ext4_is_quota_file(donor_inode)) {
 		ext4_debug("ext4 move extent: The argument files should not be quota files [ino:orig %lu, donor %lu]\n",
 			orig_inode->i_ino, donor_inode->i_ino);
 		return -EOPNOTSUPP;
-- 
2.51.0



