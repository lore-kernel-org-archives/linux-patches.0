Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7DFAD5A;
	Tue, 27 May 2025 16:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364369; cv=none; b=uV6XVOKxZbPKFeWgjzw9hN7MuFe+NBE+h5ZSi5hspOYmA2+z7RUfPLXELUqdWQvBSC/63mTg0hn5qtXj/lhD5mGv3/3aW0yhvKhwTJoVXg2gvAkbvTZiHILGI12VGZKmatRK/qa6TBU+5t6F3fl/0TpMqv58DAY4hHYNQLPtZYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364369; c=relaxed/simple;
	bh=bKTsUSTIGv5jDHEoA7FJmYfjRCVGKq1vVxYZGV0hbhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aja06fxnlYbxlgoWJT5WUjGUbC0FZu08udNphL6gGF2pojoAq3uuQU211oJsbURVgTIZZ3s7GJK0gn/uh30SNKRvMWXV4w+DlVGUQeIK5eKGcQgyl5PQf9oP+GA0/eCA8NXWHFOplVX4OCO0iwRNuZio11D/Ve7wvhjcJOmaTrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CUjX6mqr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CUjX6mqr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A22C4CEE9;
	Tue, 27 May 2025 16:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364369;
	bh=bKTsUSTIGv5jDHEoA7FJmYfjRCVGKq1vVxYZGV0hbhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CUjX6mqrT4peqSCyDb6S5rvNEB+1Qkw3pQ39Alm0vCfrbeE0CruN+5MpTfyv84tLz
	 2UJhAWlMeuCvdJNdRk91GHoP4F1A/exe2hAagwcQlo5ZAEBqd5dOQdbOeVxiUAAX+b
	 9OmTH9Aufa3lJRyehYTJnRD5lgsqcAKnCg0QC3l0=
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
Subject: [PATCH 6.12 034/626] fs/ocfs2: use sleeping version of __find_get_block()
Date: Tue, 27 May 2025 18:18:47 +0200
Message-ID: <20250527162446.454937657@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2ebee1dced1b2..c2a73bfb16aa4 100644
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



