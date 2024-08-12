Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3518E183CD4;
	Mon, 12 Aug 2024 16:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480165; cv=none; b=tZbVUpo6JuxPtLGhX/fwBZEkWUBrK7h64fJ7ihoWPBidfmv5LKwf0CT8nLNgif+56j78ftZu5kk3S1Yoy4XB9M8VCdRct7+LRHM9DJ783l0J47pOgOcb2WSt0Wev3idudNBQTAFhiAVcnKUBLqJC3vZScepqrs3AVDnri1fRU1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480165; c=relaxed/simple;
	bh=bOYgFfkimAnkg0l5WVY1mV7OiY7arZCSEmnDGcvspmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eFrJVyPwUxxVqyWtKtoVHsF+s8XXuwxxX8lR3lBjvK5MbQWSiGomsvkLIlrejsNj94o32WouD7Ec8XzBeK4+RbmxhvPRCgKxOS3ztbv36u1NXvRPxHvLxwnvKGnB5FAsBZNnKwK8+bvSvcNeFSZL3MiLmb/DwR/5o+r+mWqHbrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NsUhSR1v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NsUhSR1v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADCE1C32782;
	Mon, 12 Aug 2024 16:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480165;
	bh=bOYgFfkimAnkg0l5WVY1mV7OiY7arZCSEmnDGcvspmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NsUhSR1vRMs+nDnRqvzjbGDmueOfULWCW9lm1qd+9VaLmcBjENmUKDg8YJJ15Gly6
	 vpfw58TKsCFkwUOegv7btEaTUnxo21FPkBqT6AVZk1VF+OrUdo7hlX6ofzbIvpPgj/
	 FnQGgYx+FxZ0z5Ar0L30bNPHnBw0WjXaM/aON0W0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 113/263] jbd2: avoid memleak in jbd2_journal_write_metadata_buffer
Date: Mon, 12 Aug 2024 18:01:54 +0200
Message-ID: <20240812160150.870746780@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index ae5b544ed0cc0..c8d9d85e0e871 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -399,6 +399,7 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
 		tmp = jbd2_alloc(bh_in->b_size, GFP_NOFS);
 		if (!tmp) {
 			brelse(new_bh);
+			free_buffer_head(new_bh);
 			return -ENOMEM;
 		}
 		spin_lock(&jh_in->b_state_lock);
-- 
2.43.0



