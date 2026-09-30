Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4277C3CAE8F;
	Wed, 30 Sep 2026 18:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794073; cv=none; b=WHSwWv4usGAd7aeEv6sLm8tj2RypN4aIiGPph8YSKkx50OeBeVTaKBf+gyB7bASfrY97V6+fquvvYDaBfpr1HIxuHqU9bDSfSYoWG82qdk70Efz5sUvbNCwxUt4EXm/HAwbcjTQMEiI5ZyvGw4m3oueJtDBHTnU0YEV++n+9kVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794073; c=relaxed/simple;
	bh=BWJuIexAtT3CJF5T6EanNJNWRtZtK/4NqBl264HLXRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=enuTx8SYOUqgZTgoMuipW9HxQgo21wPR6wfhHfVnT9a9re3V2KcTZqs8b4gcUNI9CxyMmi3g7c3fYZ57OLn1oe6CcUXTLNSNu7tY4V6LCpHH/SNL/fCBCikmznMg6Wue4Q5b7WdsmgNH/a3B8mz/CwOxEDWO3TTrNTr5Gtzb+9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o+DQC+qn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o+DQC+qn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA251F000FF;
	Wed, 30 Sep 2026 18:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794072;
	bh=YT5jPes/MXz4gfpumBUoMSsdB1OFfZ/I/DMCL2dVuh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o+DQC+qn+mPDDcJCIzAGOOHkpKrLJ/ggpeVhtFLFRkmGN+QiJK5fzrEoHXxij7+an
	 D717yJFivWugG8as8B9WwmUr8OYyRdYg2VgsfGKlsWvRyxrKh+mEP+BySEaWBf2Gyq
	 LALks2zc8rWbMpN4cr3EVLCN3IJ4rPba3dukZRSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0082/1193] befs: handle set_blocksize failures
Date: Wed, 30 Sep 2026 17:12:46 +0200
Message-ID: <20260930152436.073163043@linuxfoundation.org>
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
index 9a16a51fbb88d..ec0d42b32094e 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -890,7 +890,8 @@ befs_fill_super(struct super_block *sb, void *data, int silent)
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



