Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D991257855;
	Wed, 30 Sep 2026 15:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782440; cv=none; b=n/pJgy2JnsWgMtB5bSsAs2PRRS1tj+P3BLo/4f9MpZQRrSbh68JxfT4gcK/P6be5jGg8Cv3VWt+8v7G1XK2VA3HZGhdXqgZkoVdc/X+naAEulNGYrVZlFwpQze7pwOB2BtCQK96VbnFPLXP5ZWDJIh6txKg6zV3b78GH01LHn0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782440; c=relaxed/simple;
	bh=SNhFR3YaLbAjBgl8nSqzwf6hXXKnVwKDMWB9+mRVtv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DDRX3l74+TjXYM6r0NLmg/Pnd5JTKKKyBjxlWPYm5ER57NDGyyqxbp9BovoOyWvQDoki8RrV4vp3LbkzuYn33bYjKmSmcV0N8aOpe2Sb/Y0rPpzkgEhPZtzmBmAjZbkPzlgJsRCaR+yV5mmZQ9z+n1HGGQX4K/bVIaFQdZaMfSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kq6IyxRH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kq6IyxRH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C314A1F00898;
	Wed, 30 Sep 2026 15:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782428;
	bh=RcVBjYhlguTTZTb4qzYVukNzMn+t6/jdHPiSdzS3jp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kq6IyxRHWppzcWuk8ZgeH18UxBKWYLqwsgtrnrcUkNoJ4btUVjxAdLTimao0aXcZp
	 cKef/SJtBU7k6UUJd28w5UYGMPhkh0MhoYSUWbTQt8BC6exYwM89szFta4imM6XJEr
	 lREtVjiMsjPA28cY5PlncIjAobt7ZK35Irr/e+Xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 043/595] bfs: handle set_blocksize failures
Date: Wed, 30 Sep 2026 17:18:56 +0200
Message-ID: <20260930152348.655863393@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 2430e3380936df0b648af720cae624eef035a2d1 ]

bfs uses buffer_heads, which don't handle block size > PAGE_SIZE well.
Without this, mounting will hit the

	BUG_ON(offset >= folio_size(folio));

in folio_set_bh on the first __bread_gfp call.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260511071701.2456211-2-hch@lst.de
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/bfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index fa4e002925852..56f6bca4246f6 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -343,7 +343,8 @@ static int bfs_fill_super(struct super_block *s, void *data, int silent)
 	s->s_time_min = 0;
 	s->s_time_max = U32_MAX;
 
-	sb_set_blocksize(s, BFS_BSIZE);
+	if (!sb_set_blocksize(s, BFS_BSIZE))
+		goto out;
 
 	sbh = sb_bread(s, 0);
 	if (!sbh)
-- 
2.53.0



