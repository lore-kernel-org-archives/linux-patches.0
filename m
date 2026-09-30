Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA0C3B3BE1;
	Wed, 30 Sep 2026 18:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794087; cv=none; b=NODXzVzGuzJ1iC2aHXGNOBsoEIgVmZpst6lsFB8jRKytxEcnnb/Oi7DuOmtuCshljJZFfnRT22y6Rv3JXPGS5graiWejhcEMcZuUXbPPD4YKevLo0F9Pp6hYu7jIq8TSWc7cpQkX6v+A/uliD/kMgZ/gvOuhzIuKwuOr4SjkgBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794087; c=relaxed/simple;
	bh=BX0fSTEVvARc4cDGEmY9b5R2cQBUdgO/rA4jyMjjsns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kHaKdbimJd4w2yjC9gDe69whv1AHQ1mdMyNgL/1JO7w64ONkKPXM0MnQgVlkBojIaFn9dNB9oYFrGBi0UTa/CVJzL8J7DP6L007TK+nDdDMDq/Vnax+E78HuyAswB6FbpJYa91d0leyPVKp89N26xtNOQe+KwyGbL8OoCpfymgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PZbBczbQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PZbBczbQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E619D1F000FF;
	Wed, 30 Sep 2026 18:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794086;
	bh=YEKEHE54Ial/FprYge/zqxiL7Sz/Ou3Kwt0LdA3d2LE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PZbBczbQJ7dNz+I/fZ0nwntfz/fpUGKKft8vwZYO8j2F00BXIwGeUYVK9Q1cJ62TA
	 mVpR/z7EZYwEVLICtMnIUT78XisMIjYUVNKdYmQ3rmAW0VLRiIfK1ZZBgW+rgNaxu1
	 IeSup2gePrtlRV4kLZFoP2eBWdPbyoj89NLebXdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0086/1193] minix: handle set_blocksize failures
Date: Wed, 30 Sep 2026 17:12:50 +0200
Message-ID: <20260930152436.158779675@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 38a03dc2bc71e7e0746cdb9ef5e9947f72470c67 ]

minix uses buffer_heads, which don't handle block size > PAGE_SIZE well.
Without this, mounting we will hit the

        BUG_ON(offset >= folio_size(folio));

in folio_set_bh on the first __bread_gfp call.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260511071701.2456211-9-hch@lst.de
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/minix/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index 820c7753bd105..7672f7f555607 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -270,7 +270,8 @@ static int minix_fill_super(struct super_block *s, void *data, int silent)
 		sbi->s_namelen = 60;
 		sbi->s_version = MINIX_V3;
 		sbi->s_mount_state = MINIX_VALID_FS;
-		sb_set_blocksize(s, m3s->s_blocksize);
+		if (!sb_set_blocksize(s, m3s->s_blocksize))
+			goto out;
 		s->s_max_links = MINIX2_LINK_MAX;
 	} else
 		goto out_no_fs;
-- 
2.53.0



