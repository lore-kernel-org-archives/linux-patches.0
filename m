Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE36618026;
	Tue, 14 May 2024 11:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686450; cv=none; b=K4eveaF34ScdK4GGJQc/Lvzhev/FgTmN5wyK6ucgb8c01k9liogmPrTHZjAEd/nCIa1I2p7gBcx0JY7M5jGJVy565GeRsJ+j75CdTSZtBwZ+cBZAIRLdMDVhUNMvi3qBuVltIDKBGxI/BYtm2DczidD9NWd6qbTIeNBxJrNr0iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686450; c=relaxed/simple;
	bh=BG1OYkqKDKLdljQ/OO6Pc/Ad/2iWgptTN4e+YlXCEBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fSzH3V0+BUk2rnFeJHQI3WmQ3WSuJ83s1mQsx0GZsKN3OLkFI6FuweD1UwhBsQ5k1xUfaEtPsxbWgD4WGEZwifHL7ICpSJKd2BMN/6bimyQVqwBoQIaPvM7kNy5iGzfoj7qq0+LnOpLRzP9yR4onRDYWIfAP4xsW3yjvkOHYFss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n9yzl6qq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n9yzl6qq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43999C2BD10;
	Tue, 14 May 2024 11:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686450;
	bh=BG1OYkqKDKLdljQ/OO6Pc/Ad/2iWgptTN4e+YlXCEBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n9yzl6qq/JQuiJo+kXn6YQ95vYhRJKuubvHn7lqs4rqL6p+C4yqebVP3Up8dJnItJ
	 15zN45G1W8MyVTWau5rYlGPjH3fMsCLa/+pF/roeohAxUXskhR+YW4mSkF0ZpJ7GL5
	 zhM45nblub/Nby9Smmr6vLK9opuB1vIvYBnqMXcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 115/236] btrfs: make btrfs_clear_delalloc_extent() free delalloc reserve
Date: Tue, 14 May 2024 12:17:57 +0200
Message-ID: <20240514101024.738987071@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

From: Boris Burkov <boris@bur.io>

[ Upstream commit 3c6f0c5ecc8910d4ffb0dfe85609ebc0c91c8f34 ]

Currently, this call site in btrfs_clear_delalloc_extent() only converts
the reservation. We are marking it not delalloc, so I don't think it
makes sense to keep the rsv around.  This is a path where we are not
sure to join a transaction, so it leads to incorrect free-ing during
umount.

Helps with the pass rate of generic/269 and generic/475.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f7f4bcc094642..10ded9c2be03b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2472,7 +2472,7 @@ void btrfs_clear_delalloc_extent(struct inode *vfs_inode,
 		 */
 		if (bits & EXTENT_CLEAR_META_RESV &&
 		    root != fs_info->tree_root)
-			btrfs_delalloc_release_metadata(inode, len, false);
+			btrfs_delalloc_release_metadata(inode, len, true);
 
 		/* For sanity tests. */
 		if (btrfs_is_testing(fs_info))
-- 
2.43.0



