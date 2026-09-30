Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9F5511E90;
	Wed, 30 Sep 2026 15:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782440; cv=none; b=YH64TCTDi7Jck6NSn//A4pJcO5Wk/Omqtiah8fyosdZfl3zSb0lox1vGlGbg96aj/jkpdHQpt7tDiqAc4syps3OprnXrMU9BO9hOOZI1uS4Gepq7UwUyvqzMpmVkyQMbXDN9qPWHhFIz8neIPirYVvDkTu9ijrtmoOzdnznCL5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782440; c=relaxed/simple;
	bh=yyg+z1wY96UvvXu1YCPHL2teiDV5TOuqDlfiPn4B27k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pIVBrorr89jzGiyQJdquIZWSBN+Kd8XuD0f/g2vAgVCrrT6ldrEB7OJgSzqBDtgbivlr4+25SN2SzI0bEcsVlHtdgM1cHvVUCY6VzE2E+aa4guXc1Cv0y3VWCsk7W8O7ETAhmVtZuYkEYIc5hkVBubUrKDnf42PUnt14ghh+2yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zRaxSdKC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zRaxSdKC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 902961F0089A;
	Wed, 30 Sep 2026 15:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782431;
	bh=iOy8PS3/k2AHZjkYAG3ToTratkVfbhnovXqO5frhHos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zRaxSdKCQgtTxORzs0r+5uNmDvWDc/3yx+souGphxq42p9cVITzqV2DWsHe3wEHo3
	 q2nyhFZYceOBgmoDE5T3+hUDfDdu3y+IBg3aY1xpqIqP6EZM24FKYA86jwoJOQGP8D
	 S+EsZy9xL399LpjCKWRdM4HcYcdLZmWGqaM3+N6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 044/595] minix: handle set_blocksize failures
Date: Wed, 30 Sep 2026 17:18:57 +0200
Message-ID: <20260930152348.678736345@linuxfoundation.org>
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
index 5b2056d00121f..2b4ef99cd6db4 100644
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



