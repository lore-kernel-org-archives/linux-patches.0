Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61247145353;
	Thu, 11 Apr 2024 10:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830980; cv=none; b=k+g3UVCFGj0k9Hq2SK1XvUZmqsOL14gJALsRhQwY1bx/S5ay7w6YWLZkQVeOSr1VW5x5ikRMtyCIsYe4UxyOXm9bHRfkoEPYlg5I1x4vl369VQj6KHvAqJ/3PvLlxUIK+/zgvaBlWbU3PEABISzKUONQyJuKC6dH8gmCobbaWSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830980; c=relaxed/simple;
	bh=MNZN/a8gLjd04aEFkWN9zml/9quXTTwSM7hRnFuArV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gAwDyh7LZlJCSl5O+Ldcfy7Cn6FZjZEr5PhWj/+GD8hWPgRe4QIvVT9lQv3cUUPojpbagCmbqAp5BVQ2dDyr6AUIqvwqNPpYvyOEAp/ZjuPctLyp2ULL12RnTY414CK8H0Sr0pMQN8x9gUFPgR28iC7kDawyOmIyhzRkUt05Bcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JJbnVsYu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JJbnVsYu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB748C433C7;
	Thu, 11 Apr 2024 10:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830980;
	bh=MNZN/a8gLjd04aEFkWN9zml/9quXTTwSM7hRnFuArV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JJbnVsYum3/oExXja9e18HSYcKW1y/iAyNTfY19yzUSVIcVzX7C0sL63LF0ljFoZ1
	 AcvmDacW5YanBkjBHXKnDSYTYGV5gzN7XIHvTQjc7errXeuQEvl49cy/pcKlcKdxwS
	 rF7lRUJ7YC3SL0loE442BC9A+K4sUFVIBEWiGUTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 182/215] btrfs: export: handle invalid inode or root reference in btrfs_get_parent()
Date: Thu, 11 Apr 2024 11:56:31 +0200
Message-ID: <20240411095430.339346612@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 6e4727304b7b4..08d1d456e2f0f 100644
--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -182,8 +182,15 @@ struct dentry *btrfs_get_parent(struct dentry *child)
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



