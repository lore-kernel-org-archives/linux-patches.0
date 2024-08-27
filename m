Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2EF19F485;
	Tue, 27 Aug 2024 15:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772330; cv=none; b=Qpwc02g7kSGFuFfCNb3qI//qTlQBCnfNc8/hwqmPbVJ+8Jyr4eSr8C6wYmg/stcaTw1B/sMhlzJM4vFqh4bQIfRVcxKmd7B/9dmVJVJlYaHwE0Qu5hucPxqITvqKZbPADGrrDMbGdXYgBf/g/6bZTjlQCgBR6WjqkGbqN1M5WO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772330; c=relaxed/simple;
	bh=pMUkovxrgxnOeQw8ddqGHhybtbjRaF4y39MosUIm7lY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S6OS/xZ5/ozqyjliP73DLqcJpaxiNntG8COkXSKKY+fOEQybZRKkHOkCOMwz9SilVdjj79JaonSV9wozeOuX7eYm6Dsd7u9QvhhFpem/f1svvMdeHAujcwrp/WZwJzrf5+WXnqpP1SZuEei/cA/vySOao4IgsfClSygPS7IaCh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ljVIYy7G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ljVIYy7G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DEC1C4DDF5;
	Tue, 27 Aug 2024 15:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772330;
	bh=pMUkovxrgxnOeQw8ddqGHhybtbjRaF4y39MosUIm7lY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ljVIYy7GDj5txBIW1EmCja+BVnXtyWJwf/5wLg0kdq8NXlJ5/naAuHxH88lwn1rnA
	 OpxKRLhQYg5m/QEg+5eAOvBA5J2gSyn8XZtiejcO0foLlb4JjENtkP7zGFY+yQdUHD
	 R29BFbWgj0DWgBXDB51scaproz9UADxl7J++kNtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 183/321] btrfs: handle invalid root reference found in may_destroy_subvol()
Date: Tue, 27 Aug 2024 16:38:11 +0200
Message-ID: <20240827143845.195816710@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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
index 10ded9c2be03b..bd3388e1b532e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4614,7 +4614,14 @@ static noinline int may_destroy_subvol(struct btrfs_root *root)
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



