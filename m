Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2464F7CD7;
	Thu, 17 Sep 2026 16:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663970; cv=none; b=GTMsbmu/BBc02Qf0c8vo9TH2HFOV7yfMHLYJJuxOpUOLifFJPu76dRIGunAiLFZ8hzWoGiEGKC9Z9RHXIExtPR9zWpenLpa5e1sMjQ2f4lwTwJjnixSsceeRDwbKCusOKtDQdDP5FrQUxIX03dBej+eRfX4uQfl4cHZP97bt7JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663970; c=relaxed/simple;
	bh=boQFuvHgmIXffV9N3G7xiwbIDZpi6tkwXYz8/+BgszI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lny/05xoDt669hz6wTtBpzlBWqSrcHwNe6UDVAbvOagHcudqKm5r2ZumKy/reoU7A6oRZBEFmviKp84nquIOqUZtRuHY7anLZJINowbH2pDo5oLCf/Smje/IFs7Rhr0gB0STWNioj2CpiXJyIVe/0YnUle3VTdZzRe0wZF4Wxvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ruKVSU3W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ruKVSU3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A755B1F000FF;
	Thu, 17 Sep 2026 16:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789663969;
	bh=lH/FLAZMwNSdoFjum/mkKR39TTasKnP2gnDdhatLZZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ruKVSU3WdzP0CmoIudB8Ewf3jbhYFVw8SK01gSU7OerUfdpVOjPQsj95zaVvFVVoJ
	 y3ERLx+8IH83t5xRQLh3ARogb7T+VT/Ccw3hZ3LyYNbYJKOyrkwP5NxWXIeBSseovH
	 7ZnZuDUFZFicZnf/IffLcP1U4r+4ruSj9bFD49bI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0177/1250] bfs: handle set_blocksize failures
Date: Thu, 17 Sep 2026 15:59:32 +0100
Message-ID: <20260917151556.899822284@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 984b365df0460..35b86dce3a788 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -342,7 +342,8 @@ static int bfs_fill_super(struct super_block *s, struct fs_context *fc)
 	s->s_time_min = 0;
 	s->s_time_max = U32_MAX;
 
-	sb_set_blocksize(s, BFS_BSIZE);
+	if (!sb_set_blocksize(s, BFS_BSIZE))
+		goto out;
 
 	sbh = sb_bread(s, 0);
 	if (!sbh)
-- 
2.53.0



