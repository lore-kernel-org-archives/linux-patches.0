Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4203850B8A9;
	Wed, 30 Sep 2026 16:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784347; cv=none; b=kEeCZJxTaUhqIscFMXC+izK5TlQ9rwCpPGNc3IgvCVLE50VBVMPaJ/YO4I42Ehdx75ldjJGepq0TRMrjr0Ord2IS7BPwYWwZjnNkI3h+jOOrTWlcE0swWpQF2T+yF9b6S2fCdaJr2p2Xu56bLd6QdJkPhRhimoGND69HqpI/i0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784347; c=relaxed/simple;
	bh=K9rsxoq+Nd1l7mzfi8OMceaOzcpYCtlqgKRjPHb3YyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2eWHKgzu+nYitzGDjrNEX/X9H/gwErpuQhvq00s/iZjT+yPzIm6RIcTUYNwj+tegcqYGNc1Zi4Lgn1tjUSQeGEgQneYzBKJJcp45OGvL3NFgUeRpwjEoYHgS/bQ1tzRFbGS1BZdjMNpJkAH7mXQZvvy530mGIp8I3+eJ7F2P+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AvtcO1Tn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AvtcO1Tn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0803A1F00898;
	Wed, 30 Sep 2026 16:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784343;
	bh=nPVhdyU5Wg54z4DzN8U5tkQzd4Po/oGJ1apgfMfQihw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AvtcO1TnRWmcF0f5Ap8E4/0cplfzrFkG2CwijykyTiZy4t/MPG8iySvijiqb9Kd9n
	 Q6n+mXRtm/uK6t4B7VtlSZnkh4tjTzEGZF4DDP++eJxUZDF4/N/LUbm89PjWMJu56Z
	 UmzKudyU422QvzKpgnFA/DjKX8bzaDSWvOb+E2IA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 068/982] bfs: handle set_blocksize failures
Date: Wed, 30 Sep 2026 17:13:24 +0200
Message-ID: <20260930152418.261666251@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 07f7929d07fd8..c2dadba110c49 100644
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



