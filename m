Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924FD35CB6B;
	Mon,  9 Feb 2026 14:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647309; cv=none; b=UkjBTmaxOcaGTjH7qYvVtQBxpwaRq+/Q3EQ8qOMguQA6BPhq+RIIdip5tGOhDQvzJyaHbyD/f38UezQdrIP6xmm/6QYfHGYHpjo0JU6IqhEi5J3pqbRj7EggNrentx2UnDcLy4OBhHtuXgtw1Bj/+zanaw4HE1DKNK1WSXn319A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647309; c=relaxed/simple;
	bh=oDMbmy7q/ORlmHCTBHhrQgxHB2/7rL882S9wt6VIryM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KrIT2GluLGA17AjrqUwnWYhWGP8+WNTI+ZOlEt15YmzLU12qSi0oQ1IPKiGIFJ3s98u3FkTrNitYH+MlOTDj7OKX3XtooPTOySuJG2aJBcn2z6+Apqq2EZn6hcTHFHIozP3sxxV0gbXtVuzoocucaZdIGfeH+kB4PJ7SzP8kHH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a/eNKQlc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a/eNKQlc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08985C116C6;
	Mon,  9 Feb 2026 14:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647309;
	bh=oDMbmy7q/ORlmHCTBHhrQgxHB2/7rL882S9wt6VIryM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a/eNKQlcGUW9Tx3j+56qwKkMHtQngBB/n9cxYZSDqsu4QH088pN2g111uaftXRtk2
	 YUrjEwW64sUNkk7RDEdU3D2BALU7t/4BrgMoARsm0oZEDLDHMlxXoKPpjJK7KP6EDA
	 I709YxMJfwcwb6pNSWiN2N3hKdb4VqDZlwjHtdPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 062/175] btrfs: do not free data reservation in fallback from inline due to -ENOSPC
Date: Mon,  9 Feb 2026 15:22:15 +0100
Message-ID: <20260209142322.691287556@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit f8da41de0bff9eb1d774a7253da0c9f637c4470a ]

If we fail to create an inline extent due to -ENOSPC, we will attempt to
go through the normal COW path, reserve an extent, create an ordered
extent, etc. However we were always freeing the reserved qgroup data,
which is wrong since we will use data. Fix this by freeing the reserved
qgroup data in __cow_file_range_inline() only if we are not doing the
fallback (ret is <= 0).

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1af9b05328ce8..e72c69f77ce4b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -670,8 +670,12 @@ static noinline int __cow_file_range_inline(struct btrfs_inode *inode,
 	 * it won't count as data extent, free them directly here.
 	 * And at reserve time, it's always aligned to page size, so
 	 * just free one page here.
+	 *
+	 * If we fallback to non-inline (ret == 1) due to -ENOSPC, then we need
+	 * to keep the data reservation.
 	 */
-	btrfs_qgroup_free_data(inode, NULL, 0, fs_info->sectorsize, NULL);
+	if (ret <= 0)
+		btrfs_qgroup_free_data(inode, NULL, 0, fs_info->sectorsize, NULL);
 	btrfs_free_path(path);
 	btrfs_end_transaction(trans);
 	return ret;
-- 
2.51.0



