Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5677E84D26;
	Tue, 14 May 2024 10:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683198; cv=none; b=O/6KtdVGWfCW3FpEqPzHwLpRtuZfULjf4qrmK/NOmItTGQ3nmDhNMhvDFhAFK23u7/gE/c/BRpDwG542P94MMoSgkWDqlg4iQeIb+OrQfk1IcOMpaOG+g6hLx/6SOYne2uc124YONDGGuxr8e/ujVyf/4B0EnBdfiE4xxpMb/X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683198; c=relaxed/simple;
	bh=jMnHgkvf7CljUFyuen0bGWPAv0+apFPdOd+0ZZU/3Dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gV4SmjDR85ovMOwfxYQ9lflvn/oh4m+kBRKgVE4n5a5Fq1tL+aDTXH8QRAZNn+JxqiOEgviGdW79CpsxtADpnFqOVxfzCRQ7T222AiPgOtIHxPQMeNJYpXGvCK26ZwBy6yaJ1MfU4VoZ4TB2rrVxKG2tjSQxMkJId4XJIce5hOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rahxkaTC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rahxkaTC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A59EC2BD10;
	Tue, 14 May 2024 10:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683198;
	bh=jMnHgkvf7CljUFyuen0bGWPAv0+apFPdOd+0ZZU/3Dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rahxkaTC8tyFcoKAFUC7hKTmENf5vs6ru12Ws03PEGWfU3UZIgZKxAVq8WMe3V9AS
	 n5+/r0hDmiirukfsr2jaG3bt2W+f41zC+NDeFBGsOqLDTj5nxVd/jivuGZG5aWl5w8
	 QQbdhx08zGplhoEjSZxUCA6u/7bZlJ9Cdq8Q8LzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 141/336] btrfs: make btrfs_clear_delalloc_extent() free delalloc reserve
Date: Tue, 14 May 2024 12:15:45 +0200
Message-ID: <20240514101043.923908710@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index b28bb1c93dcb5..d3c534c1bfb59 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2522,7 +2522,7 @@ void btrfs_clear_delalloc_extent(struct btrfs_inode *inode,
 		 */
 		if (bits & EXTENT_CLEAR_META_RESV &&
 		    root != fs_info->tree_root)
-			btrfs_delalloc_release_metadata(inode, len, false);
+			btrfs_delalloc_release_metadata(inode, len, true);
 
 		/* For sanity tests. */
 		if (btrfs_is_testing(fs_info))
-- 
2.43.0



