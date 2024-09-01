Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5325217C;
	Sun,  1 Sep 2024 17:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210097; cv=none; b=ZO1BCpEg3mccE3SiYJ2L5uz51FOmeJRBt6w9cg7STH4MPfFpRc+cLPM24VTh9ABj0b4EczPRFDILqAKWc6QOq6LzhJm42wZR8HMlRG0UBoeIs/O5BLPxON6ZbJxmQDRHLsuFEJDNdzLg/s8pXo7sRRbq/s7g62Fd0NSMT4o2Gyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210097; c=relaxed/simple;
	bh=bSW1xK5b1/lpYuk++yCkozOgN7ex7MhfZzDb/Yx19j4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=myJDEQzMDptVKb3LIv0rmte7vBbOTRa5/D/txZJZN4I9V1WPhKOcu3gw6hYUjLcrKIsqcC0HBk+L9bcgwOhqBhi5n/iMS4p5oxxlbT8jDwcf//ocHmpN4s0FK4rHiZXooGQKsrsO/XSvGJOJQ2jnIWUcNX/9MaF6ZRE2DE8DGno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c7P1ELsS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c7P1ELsS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B530DC4CEC8;
	Sun,  1 Sep 2024 17:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210097;
	bh=bSW1xK5b1/lpYuk++yCkozOgN7ex7MhfZzDb/Yx19j4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c7P1ELsSgiTNcq7kvH8bxcwUb3qsrDsalnr/rwmjKhSy19C5dZRA9YPJyX+UO2lOQ
	 ttAl3xHC97+v0FnnapmFJlxyYDLreQJhBv+5frt65D9muHkm4U5Qmz2+B0Ny8iANtM
	 TUtXVTHsLZGAOORraExGtn2UcHkV9hfFD2qLrDQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 087/215] btrfs: change BUG_ON to assertion when checking for delayed_node root
Date: Sun,  1 Sep 2024 18:16:39 +0200
Message-ID: <20240901160826.643568049@linuxfoundation.org>
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

[ Upstream commit be73f4448b607e6b7ce41cd8ef2214fdf6e7986f ]

The pointer to root is initialized in btrfs_init_delayed_node(), no need
to check for it again. Change the BUG_ON to assertion.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/delayed-inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 8d8b455992362..fa4a5053ca89a 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -901,7 +901,7 @@ static void btrfs_release_delayed_inode(struct btrfs_delayed_node *delayed_node)
 
 	if (delayed_node &&
 	    test_bit(BTRFS_DELAYED_NODE_INODE_DIRTY, &delayed_node->flags)) {
-		BUG_ON(!delayed_node->root);
+		ASSERT(delayed_node->root);
 		clear_bit(BTRFS_DELAYED_NODE_INODE_DIRTY, &delayed_node->flags);
 		delayed_node->count--;
 
-- 
2.43.0



