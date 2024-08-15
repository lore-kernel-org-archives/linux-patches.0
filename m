Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5281714D0;
	Thu, 15 Aug 2024 13:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729018; cv=none; b=JNvH6f3a4sXTp9sPGx7NHYgkVal+NYJYHFEok4lGW8qyhk9Dfn81esBAEA2+QgxgdqMhViL1JW9+m0Ly092WqtBhYhyCiiIutGCh+wWT2OGDkjV3BpZE+dQ77z5anbqZG+177eH+iL4vKmTPZf34uHXpN5LvYl42jvEu+9q9AjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729018; c=relaxed/simple;
	bh=UomFiaLEvhT4WR884sK3cSCOU+I1zMw9PWbWLG9jdWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ppw2Ufk5FlY/LBIyDZ75cDbHTMZ/KBpEMiezIhE2hLiox7BDDYPoPP9sPF/ve/53/g3L9SFq2TJks03SV95MU4HmqIyBxb3esWK9rM9vG8xlSOK+pFPJnM+QV95qanwum3r7Lox1Er6GVr7sauv3QuLIhXFqPzLaPKUY3wh+AiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z5HCMeSp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z5HCMeSp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD90C32786;
	Thu, 15 Aug 2024 13:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729018;
	bh=UomFiaLEvhT4WR884sK3cSCOU+I1zMw9PWbWLG9jdWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z5HCMeSp5JPEZrxPWBuppxhlTA+VSNBpA5JpFu8Cn/bUhSdFoQF8nvqWH5h4CVEbP
	 YPMaSCsaggUpHqNVbl9d1DEjd9yZjZBaKsW1nCBbsQmJsLteiYaTUZoxpvJKfPf140
	 L+AcLwN6i/EGqk4sXCp+G8IjbvRzgUkh1pAUbPS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 143/196] jbd2: avoid memleak in jbd2_journal_write_metadata_buffer
Date: Thu, 15 Aug 2024 15:24:20 +0200
Message-ID: <20240815131857.543844995@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit cc102aa24638b90e04364d64e4f58a1fa91a1976 ]

The new_bh is from alloc_buffer_head, we should call free_buffer_head to
free it in error case.

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20240514112438.1269037-2-shikemeng@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/journal.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 629928b19e487..08cff80f8c297 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -430,6 +430,7 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
 		tmp = jbd2_alloc(bh_in->b_size, GFP_NOFS);
 		if (!tmp) {
 			brelse(new_bh);
+			free_buffer_head(new_bh);
 			return -ENOMEM;
 		}
 		jbd_lock_bh_state(bh_in);
-- 
2.43.0



