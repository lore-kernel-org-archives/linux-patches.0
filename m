Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9416B27FD53;
	Tue, 27 May 2025 17:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366328; cv=none; b=rYgsfyJ73GsYOLbzZcatP/Z3EcYRWSbNpFSOktnZtniUZ9ZFN9+NH9E41rzwtxaKmb5wauVJVYtiW+G4kE7JPkmmZEf9nvFButIx6+j9q/8lmHF0Jq8xbEr4zPlE6P03j7SQv45MvELecHLHdkbkKS8g2/qqtcH1ldbWzoAFkMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366328; c=relaxed/simple;
	bh=3O1Rfbtg2sgLlYPlOumfyARpzDFxy+7wdUHBppmlEr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ke/jo/1joFpStbQF/hyIg7QzrJ7OURwnqUywic4HQBt7ITESVPMaiAMttyEgkWQL4elwACnVwNg35GP6IgnfVQAzd4NRp4LgDJQMhg3f0oi3f17HRXrSeaxX+kd9gwS2QEt9QSfq+iCZI2lD0hRjuic6cSMUhartjzGwXMq1+vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=STXz7g5w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="STXz7g5w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18CEDC4CEE9;
	Tue, 27 May 2025 17:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366328;
	bh=3O1Rfbtg2sgLlYPlOumfyARpzDFxy+7wdUHBppmlEr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=STXz7g5wBLyxqG7emhvGcnQv+izGT46RAne1y31Bti7edMwVS+E0zBQhp1TCGQYzH
	 51PW7Y9ZcQXxDwJR4aRHPkXVs7ysCgZccT+QSZpPd7XKatPoO2LLYOsCekhpznFFUS
	 frU2DzT2LUJNILqnMhwJ7P3D0Utz+Xm6KFRQK+YE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Davidlohr Bueso <dave@stgolabs.net>,
	kdevops@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 033/783] fs/ocfs2: use sleeping version of __find_get_block()
Date: Tue, 27 May 2025 18:17:10 +0200
Message-ID: <20250527162514.473623770@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Davidlohr Bueso <dave@stgolabs.net>

[ Upstream commit a0b5ff07491010789fcb012bc8f9dad9d26f9a8b ]

This is a path that allows for blocking as it does IO. Convert
to the new nonatomic flavor to benefit from potential performance
benefits and adapt in the future vs migration such that semantics
are kept.

Suggested-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Link: https://kdevops.org/ext4/v6.15-rc2.html # [0]
Link: https://lore.kernel.org/all/aAAEvcrmREWa1SKF@bombadil.infradead.org/ # [1]
Link: https://lore.kernel.org/20250418015921.132400-5-dave@stgolabs.net
Tested-by: kdevops@lists.linux.dev
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/journal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index f37831d5f95a1..e5f58ff2175f4 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1271,7 +1271,7 @@ static int ocfs2_force_read_journal(struct inode *inode)
 		}
 
 		for (i = 0; i < p_blocks; i++, p_blkno++) {
-			bh = __find_get_block(osb->sb->s_bdev, p_blkno,
+			bh = __find_get_block_nonatomic(osb->sb->s_bdev, p_blkno,
 					osb->sb->s_blocksize);
 			/* block not cached. */
 			if (!bh)
-- 
2.39.5



