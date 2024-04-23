Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E829A143895;
	Tue, 23 Apr 2024 21:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908778; cv=none; b=PkV5hos5h2l5LFob7zoI7OEwGJmhYlc9Kkgr6TyNgUBdfOxDi5nFp7ggBtD5RMYEXk9jExU7nEx1dOy5j3ECCtgT4F6cquUGBkJAhS2UhxBo9/4V1qvkb4xhyPjfmB0eNzXMJoaN+2GCUSkyY8XsXX6Oi/3Zx6dQDeAtEhekDnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908778; c=relaxed/simple;
	bh=p79EzAmFA8VT2brkKgODJotqRWiFbvthXMnVg6CdI0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lFnK9fFgdUmiR1WfaPNRGqINuwTx+aVvdSE0zfhPVj3HZznD1mLqe/kOeG+lW/lQlUrTx8ovHmQFGdg7GnVY/3TCsSZeY4q4jbZRb5P4aoxocUqs8EsL7ZudEF0/unE/XGa3YOBlCpWimIqMtttS5V0VxTRaokCRYGAvtyVC/E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qzC3FU7y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qzC3FU7y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36D8C116B1;
	Tue, 23 Apr 2024 21:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908777;
	bh=p79EzAmFA8VT2brkKgODJotqRWiFbvthXMnVg6CdI0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qzC3FU7yDOiGQwWR1fU1eBnjS/B8zdPZGF2EIX8spPcadpT1zFsZLiuV8EieOHNwD
	 ZaPi6Q94G1F61REqV/fY4bvbzGXiMzEWQXqEYjcAVr9h3V1dFCoWj+rvuTv7pk02IE
	 A3HLSTAmIvaS5htdaVEuUoOtPm5yqbKxSot/8kqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 04/71] btrfs: record delayed inode root in transaction
Date: Tue, 23 Apr 2024 14:39:17 -0700
Message-ID: <20240423213844.279293591@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213844.122920086@linuxfoundation.org>
References: <20240423213844.122920086@linuxfoundation.org>
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

From: Boris Burkov <boris@bur.io>

[ Upstream commit 71537e35c324ea6fbd68377a4f26bb93a831ae35 ]

When running delayed inode updates, we do not record the inode's root in
the transaction, but we do allocate PREALLOC and thus converted PERTRANS
space for it. To be sure we free that PERTRANS meta rsv, we must ensure
that we record the root in the transaction.

Fixes: 4f5427ccce5d ("btrfs: delayed-inode: Use new qgroup meta rsv for delayed inode and item")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/delayed-inode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 5a98c5da12250..8d8b455992362 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1046,6 +1046,9 @@ __btrfs_commit_inode_delayed_items(struct btrfs_trans_handle *trans,
 	if (ret)
 		return ret;
 
+	ret = btrfs_record_root_in_trans(trans, node->root);
+	if (ret)
+		return ret;
 	ret = btrfs_update_delayed_inode(trans, node->root, path, node);
 	return ret;
 }
-- 
2.43.0



