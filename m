Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7FDE2FF14D;
	Tue, 12 Aug 2025 18:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024597; cv=none; b=bT/IlR/aPX8DQjO92HR4CYAxLdKfF7llWFixxZEI4Ymcz2CAnpEVUSWB+2U833F9yDuduGciABa05fNLdjZIy43JayiFfnZgdLTDdyhVuULf+42rFlhGeZfoRqoXWeKAqFepTJAo98fiMkXFk5kyeVAaV/PHIIepQpozEGG6FYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024597; c=relaxed/simple;
	bh=8AQWMKF7OZMrHGZgyKVr/keeuhb8puV3cZetNv21wGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pvI2d3OUFw8GyrrK4IXqpraB/XstY7guRV4SB56bL1EZtp/etqEPheruyry/1MunIqahIUtanOxDl95fQwC4z2fAZo/Pzexc/bCcQZnPALRrVxed453A79LaWfUNPMlu5VoPEyiXcFyLen2I5ErbJmFT7fiBvSPM7N1IkM8zi/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oM6RXpOu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oM6RXpOu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C38C4CEF0;
	Tue, 12 Aug 2025 18:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024597;
	bh=8AQWMKF7OZMrHGZgyKVr/keeuhb8puV3cZetNv21wGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oM6RXpOuNcY1i6+HYZ1WERV+I8cqSEjFdTEOYuxUL3Lb9rRWNtyFRFnJnoquu3JJk
	 InVc6FNizWBrsPfKEnlK0XL13dmcg7wy5Agi6KGMOkGulSECuNLJTAgEmOpkiiTIUm
	 5e2DjutdeyH8O4+OjyL2Y/C0YvuCOLUVUcBVIP4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 387/627] ext4: correct the reserved credits for extent conversion
Date: Tue, 12 Aug 2025 19:31:22 +0200
Message-ID: <20250812173434.017708920@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit 95ad8ee45cdbc321c135a2db895d48b374ef0f87 ]

Now, we reserve journal credits for converting extents in only one page
to written state when the I/O operation is complete. This is
insufficient when large folio is enabled.

Fix this by reserving credits for converting up to one extent per block in
the largest 2MB folio, this calculation should only involve extents index
and leaf blocks, so it should not estimate too many credits.

Fixes: 7ac67301e82f ("ext4: enable large folio for regular file")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Link: https://patch.msgid.link/20250707140814.542883-8-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index be9a4cba35fd..91da3ae0bbc6 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2771,12 +2771,12 @@ static int ext4_do_writepages(struct mpage_da_data *mpd)
 	mpd->journalled_more_data = 0;
 
 	if (ext4_should_dioread_nolock(inode)) {
+		int bpf = ext4_journal_blocks_per_folio(inode);
 		/*
 		 * We may need to convert up to one extent per block in
-		 * the page and we may dirty the inode.
+		 * the folio and we may dirty the inode.
 		 */
-		rsv_blocks = 1 + ext4_chunk_trans_blocks(inode,
-						PAGE_SIZE >> inode->i_blkbits);
+		rsv_blocks = 1 + ext4_ext_index_trans_blocks(inode, bpf);
 	}
 
 	if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
-- 
2.39.5



