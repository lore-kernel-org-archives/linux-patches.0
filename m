Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4C615FCFB;
	Mon, 27 May 2024 19:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838609; cv=none; b=Xtl0KkprSb//1efYOThJCbAB7H8HOfKptQPch5ve8dQzYZ4ffKILpVlvvEXALTN5Mvt68Uq2Z9xMUAC82RXq5Z1eow38ZXsip1Hb1y5wb1YLLi56mBISEFLmcC26r35OTYZe7yjt192wh/20IGoAwRPQIr+ME2IvsxyFCrYqjco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838609; c=relaxed/simple;
	bh=E9VUsxix/oQURjXKWy03AnyOd3CqjIF3s/rPvP0gmEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dEkG8iWZJA0hIUnqUH1Y/9P+1+AwajrCB8d6VwLOMvktnkD5WGt8msEmAjIq92Sz0Zsvs1UY9UGENfRUMYiZfMrrVu1aiTT9Erpr4W/UgvRlH8G3blP4p651tjkieE5itlbmYqvlyojUD8VpagGLXOf3qy1ld8j9KpeRp4mxHNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EwoAyZMm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EwoAyZMm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C14C2BBFC;
	Mon, 27 May 2024 19:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838609;
	bh=E9VUsxix/oQURjXKWy03AnyOd3CqjIF3s/rPvP0gmEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EwoAyZMm+267Ilh67URNMZEFp3EmAu5Com1QTy+oi5ipMeQFj92nQN9xGORFCY02e
	 RpLZckHer47Ze0jwdc0aqKLlDMJ3CM4WowMLgaE0LB3BDDIu1PF4sf1O1gfmBZe9Gt
	 3MYdNDdz9IPUWF5vL9PiGt09UvzFKoU/q1p3XxeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 459/493] ext4: remove the redundant folio_wait_stable()
Date: Mon, 27 May 2024 20:57:41 +0200
Message-ID: <20240527185645.218450726@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit df0b5afc62f3368d657a8fe4a8d393ac481474c2 ]

__filemap_get_folio() with FGP_WRITEBEGIN parameter has already wait
for stable folio, so remove the redundant folio_wait_stable() in
ext4_da_write_begin(), it was left over from the commit cc883236b792
("ext4: drop unnecessary journal handle in delalloc write") that
removed the retry getting page logic.

Fixes: cc883236b792 ("ext4: drop unnecessary journal handle in delalloc write")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20240419023005.2719050-1-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2ccf3b5e3a7c4..31604907af50e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2887,9 +2887,6 @@ static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
 	if (IS_ERR(folio))
 		return PTR_ERR(folio);
 
-	/* In case writeback began while the folio was unlocked */
-	folio_wait_stable(folio);
-
 #ifdef CONFIG_FS_ENCRYPTION
 	ret = ext4_block_write_begin(folio, pos, len, ext4_da_get_block_prep);
 #else
-- 
2.43.0



