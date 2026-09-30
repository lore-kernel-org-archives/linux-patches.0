Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE834E06CC;
	Wed, 30 Sep 2026 17:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790714; cv=none; b=nVy08FlLDzsgH/y6/cJZf/rWusS3n9PQ0f9WX6mu29S+hHAyHzvH5yypnNTy3bLJilpPpxt8hUjaHptT32XcacW/e5fUBZN0tuqG+hxfBtsXP/BOMaUhL91ro32ewicIrIF9SCL5cICkCCWOq1fUTcuXXFTJb6JVTfzRKsHrylE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790714; c=relaxed/simple;
	bh=WS1HMC21BfM01c2jyEO/pky2TOtXlRVe/JXZEySQNIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EbmPnWTSW4uypUrEfX94vNkF6TR60Spd4aAog72n27WXpV2RAd8b6p+I5EDPsxAa2QTqb92p4sbNz0RDtHbfdrrlrehmaImg6OyPIymQuu9U/vLi+BqzIZcSDZSNSO8Uj1gMLQmlvxkfJN8f2FmNnw3KgeBGMIceablo/7tw3mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fLJ3iktf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fLJ3iktf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0201C1F000FF;
	Wed, 30 Sep 2026 17:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790713;
	bh=grdlVrFY2FxnUr+a3LGOYatw2J6EOdWiQHyvYnv9XNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fLJ3iktfj4ux5UeARiJee/T1QQZiTvzuK216kZHIeNsTUmT0wYGchi7b44TALwlbC
	 8gO7DZ9iRNYPAebn7ycsxdITegSlHZgcqL/fnPm2MlrONdmUWd76mKBGLbiRVkJ/Gv
	 +9g1KX7ITPoeWDKmDE00Ipxv0X5oTrKcNVl7mmAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 048/752] befs: handle set_blocksize failures
Date: Wed, 30 Sep 2026 17:18:38 +0200
Message-ID: <20260930152359.193504747@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



