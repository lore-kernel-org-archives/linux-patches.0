Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F1E142624;
	Thu, 11 Apr 2024 10:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832363; cv=none; b=RVXjABXDivS3+FtlV5l/zLwrPGlz9LdoF0bxLLJdd/5eb0ppT+yrXnPFSNuXj/ki1l7nTJJ5hQpc98bBe1MCGbrhHAcxbCjg2jT8AzakPLIMW/1IZUGGhdUDbktLBD6W1tyolMnI6Ra6iUBL7gLfLkIXp0kSwtbtsNlNs3xZnCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832363; c=relaxed/simple;
	bh=fTrHAQfGi0HYSpaR72PZ6kJ6fCS0i46yafK55J3/Ns0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LaI+t/ruUoOGq3cmKWBUr0xnM0CifwnQJFqQmU7wo6Zw/8XWrq2lSMXvZEqzpIzx8YwoZ8mx1Dxk4xw4MjcxTQ0HISCkgWnWzFoVBL04fK+ZKifmBVlgbvf4VEJ+6CqPA+xJ69O9uzhE6YumHPdonCsV3Fk/M4xNmY6sEZ4eXPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vZx7xd+J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vZx7xd+J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2CFAC433C7;
	Thu, 11 Apr 2024 10:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832363;
	bh=fTrHAQfGi0HYSpaR72PZ6kJ6fCS0i46yafK55J3/Ns0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vZx7xd+JIpAn8vHdqJk2KivG/gcr8yOf7H73f7Au9EwuEfSCE/0NoLcJxzA0w4eIX
	 gqwIHZCD9Qj73hCjNFoGQyTryLwc5MfIXvKgMrnII17/ZYSN8Le1fFHtC+5LM+XeES
	 QXD3NW1yxiH28uhkfWvg9EDa5nc9grkFNgUJbj5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 23/83] btrfs: export: handle invalid inode or root reference in btrfs_get_parent()
Date: Thu, 11 Apr 2024 11:56:55 +0200
Message-ID: <20240411095413.376956389@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.com>

[ Upstream commit 26b66d1d366a375745755ca7365f67110bbf6bd5 ]

The get_parent handler looks up a parent of a given dentry, this can be
either a subvolume or a directory. The search is set up with offset -1
but it's never expected to find such item, as it would break allowed
range of inode number or a root id. This means it's a corruption (ext4
also returns this error code).

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/export.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
index fab7eb76e53b2..58b0f04d7123f 100644
--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -161,8 +161,15 @@ struct dentry *btrfs_get_parent(struct dentry *child)
 	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 	if (ret < 0)
 		goto fail;
+	if (ret == 0) {
+		/*
+		 * Key with offset of -1 found, there would have to exist an
+		 * inode with such number or a root with such id.
+		 */
+		ret = -EUCLEAN;
+		goto fail;
+	}
 
-	BUG_ON(ret == 0); /* Key with offset of -1 found */
 	if (path->slots[0] == 0) {
 		ret = -ENOENT;
 		goto fail;
-- 
2.43.0



