Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1914D4897;
	Thu, 17 Sep 2026 17:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667532; cv=none; b=TE0apR14c4rkIU/WpXVr84zrVj8pfpG+AizdYqQfDaGmAA43OSJJwP3+4gsCHPr7vAKxAx+j9yhe6hh5oeQNHgLAS7/PFrGe//cUqUpN++M6MDeH/smPICJlK7rpe3ZQl0MzgZ7BzQ63iEHuFaIliOMUB4VFvSjMcl5x/NVAbeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667532; c=relaxed/simple;
	bh=vbEVSP5fKu27NyYU80frE50fTqtr2id15STG9rlkL/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PE2Mu6NCB/9fn1wyHvqK2e05+dmmfv6FG1iefahaAoRtfq+h1Wx8+FQzAXC0l/CV3n6AR9NVUSKgl4i0ANRNNsg0tnng1wVdXRZghpkQYSjRGkN3T/Ok4VgLelgKk4wTtVLvtVf+KuhENzKTEVlXQhWoCyVjZdKMZhBOi0U6OFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gh4mHe0m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gh4mHe0m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF661F000FF;
	Thu, 17 Sep 2026 17:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667530;
	bh=75bIlkjsy/VSy6CYNAvTu9Ysk/RgOPM/0UhWfM64tiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gh4mHe0mkldU+KSRTjtb0AT/WoJYNRA0aSLpfPpzVJAJF1mgSS0P0MfqO5vfam0AZ
	 ewXaQ9v/AOdPdgcNHMdIeWHnXmyWdeO2pE5l06bgzlKIjVDasKSlbt1QtpQkNOEtSk
	 sVk6GPj32xjzqAEc6JFm+4rmHnfEln9Er1WEoH9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0123/1102] bfs: handle set_blocksize failures
Date: Thu, 17 Sep 2026 16:01:06 +0100
Message-ID: <20260917151542.599752132@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ecf7f74779c6a..c1e941250f441 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -340,7 +340,8 @@ static int bfs_fill_super(struct super_block *s, void *data, int silent)
 	s->s_time_min = 0;
 	s->s_time_max = U32_MAX;
 
-	sb_set_blocksize(s, BFS_BSIZE);
+	if (!sb_set_blocksize(s, BFS_BSIZE))
+		goto out;
 
 	sbh = sb_bread(s, 0);
 	if (!sbh)
-- 
2.53.0



