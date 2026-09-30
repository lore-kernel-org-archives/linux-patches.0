Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC204511E9F;
	Wed, 30 Sep 2026 15:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782461; cv=none; b=BlbCryx1lTUhnLi5as3JSmcSI0DBfKl2GR2e89L1uttd9PyF1x1LJStOFklG/D6Otu3xGSCigD/PXgBB+mwIlWjK7aIouoFXr7LJcMkz+7cVG3ScDmrEaB2KjULx3hKjU/C9atedeFZEc1R+MStZyxdDwZfZ5XYzAK0Rq+5+U6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782461; c=relaxed/simple;
	bh=R/NDp2UHi53IeVnledDSLp62A9e+XOwDwA/izyMM7vM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfH+AnaawrQxr/CSCfto0CZZy6+LGj1iAguhCgWI0K0oWbJny2i0RCf6nvtE7Kp2YPlUC0DheGyHDWV6wBCfrcpu8UbwKROUmkVOZr3QWvc75LeG1u/HjvgxHT5rY9JT73KOdW+pnYLCE6oKKgFFhQni1zExcdt+YumL1ZKQ9Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dqTxPkZg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dqTxPkZg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E631F00898;
	Wed, 30 Sep 2026 15:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782448;
	bh=62SKQjNHWBGBSI/7ynaQmg7Qhxsx6wk6dno+MexyJHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dqTxPkZg3w43/21lbdC3o1sjplDjAFotjuS3YK2s95pLdZdd/8PMIrtQ9Eu8mTK0j
	 /HTUuSwaR3TwlCNgEa+wS8A7oMNmt2XxRmOlnSdQFlr7c3pfOlMewSX63CENe+IXJy
	 ZrSw6I62+aZZKqkHlFZw5Jr4L+tV9qMC2Ka7QmBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 049/595] isofs: handle set_blocksize failures
Date: Wed, 30 Sep 2026 17:19:02 +0200
Message-ID: <20260930152348.785282472@linuxfoundation.org>
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

[ Upstream commit 25ef4c4d9f0e96fb89c0ae0d7127c3f12a31bc32 ]

isofs uses buffer_heads, which don't handle block size > PAGE_SIZE well.
Without this, mounting we will hit the

        BUG_ON(offset >= folio_size(folio));

in folio_set_bh on the first __bread_gfp call.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260511071701.2456211-8-hch@lst.de
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/isofs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index a5385b91275f8..eb905f8d6c488 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -858,7 +858,8 @@ static int isofs_fill_super(struct super_block *s, void *data, int silent)
 	 * entries.  By forcing the blocksize in this way, we ensure
 	 * that we will never be required to do this.
 	 */
-	sb_set_blocksize(s, orig_zonesize);
+	if (!sb_set_blocksize(s, orig_zonesize))
+		goto out_freesbi;
 
 	sbi->s_nls_iocharset = NULL;
 
-- 
2.53.0



