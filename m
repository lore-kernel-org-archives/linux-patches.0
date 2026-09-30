Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B604E432A;
	Wed, 30 Sep 2026 15:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782431; cv=none; b=byn4UDC6k1vC1lJwDizbw22vVSwlezz0MxGT06VzKBNLQHrwZoFSmDQYiQ8dHGK4dkmwBXHT3xn3lAC7GSdC0qDsiWcPQvbs0N73+pHK6m1JwpIxxwoZLQmaUnVwHTalovJkDW0QmuNBQUddWIZT0AGum6xPIdM2wSY5inPbLzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782431; c=relaxed/simple;
	bh=uIFZQTSV1/FfqqYieguHEzBdyLjPkncwqi9t/ZZyBb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T6fdy1BM5/twZzYwE/BeZQTe194qIXxqUqKkr1X66GqOhaoz/HWUz6uE1wc2h7XXr5mVZsJB2ay7pRsz3h5dft9shziNCjy/Ryb3YRI0LX+Gmm/XoqwItuUodImYdOr7y+ZkRWYnLZYGnjOimiwohuOThlHtzjepU5fdCC0MdtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K27F/+RT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K27F/+RT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FFAB1F000FF;
	Wed, 30 Sep 2026 15:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782422;
	bh=46NpU4/szK6/2ltFLfyqUha8dhSmmUWhCt2GJ2lXzA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K27F/+RTy+UJSHdcBnn+ooh8D39w8RlBx4i+viQu0lb9E8BUKxt362DQ6UJpYNH+B
	 iQL5vCXH6rZAGnwmE3zSk3tT9QjB51MzoHQFkyfwqf5CtK3Hc2pJtu35AKy8itw4lu
	 1eyKdbfdkY8l2UO8OStMzLpxgSWPfhqTGvtO0Tm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 041/595] befs: handle set_blocksize failures
Date: Wed, 30 Sep 2026 17:18:54 +0200
Message-ID: <20260930152348.612652222@linuxfoundation.org>
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

[ Upstream commit 7597d42a25332617a3dfe596758d780ec6c028d7 ]

befs uses buffer_heads, which don't handle block size > PAGE_SIZE well.
Without this, mounting we will hit the

        BUG_ON(offset >= folio_size(folio));

in folio_set_bh on the first __bread_gfp call.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260511071701.2456211-6-hch@lst.de
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/befs/linuxvfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index c1ba13d19024e..0d12000e20b9c 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -891,7 +891,8 @@ befs_fill_super(struct super_block *sb, void *data, int silent)
 	 */
 	sb->s_magic = BEFS_SUPER_MAGIC;
 	/* Set real blocksize of fs */
-	sb_set_blocksize(sb, (ulong) befs_sb->block_size);
+	if (!sb_set_blocksize(sb, (ulong) befs_sb->block_size))
+		goto unacquire_priv_sbp;
 	sb->s_op = &befs_sops;
 	sb->s_export_op = &befs_export_operations;
 	sb->s_time_min = 0;
-- 
2.53.0



