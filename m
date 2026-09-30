Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0CE30BF70;
	Wed, 30 Sep 2026 16:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784195; cv=none; b=aLke3OUJUa8nsl8Hh9XBW9dPBu7aHq35yP+O9hfgqF+Wer3B59+DtKqIc75tBJIbCtUM6cdN/uk3FIJBs/agSxFvd/rouZ4kcfcL4z4OxhtQLOPhjAC0PnKajtjTJXR40dkN3kvTkqbXvcKRT6UaaNvcNukIUXPB9R5Jkq5QH0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784195; c=relaxed/simple;
	bh=TPEdTGufO5IAKWGOYdwEWRnnaIR4rh0W6rD+g2Gw84k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TY46VA5Tp+B2nuhjcwCBQtb6CTEAqe4mUJFbN9gfGbX4DP3ZUmX3Nc4yAPt4+o3TL34C4DHNCrwi/qbicLChmVRemLRyLVqgurHu2YIylYHF7GGWQcbrV6tEM5VGAl9HddInjt7r93SfErSlfSDVn4BLoOjJwvkaKaYgEk4ZocE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AnYZROBx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AnYZROBx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1331F000FF;
	Wed, 30 Sep 2026 16:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784190;
	bh=DLv8PJWCIV8P+cmMUgBOpON4Z/YBBxl5qGXCaLIWbPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AnYZROBxiRqliQgZy1D2aZcGJQVvKi8fFblCOJ3OlDz2ZCKAz0iZVcx3xqtT2zv4j
	 3jOCOgq/FrqdMw8hU8X7zA1WKTk7jLPJ2WEycePK63TWseC2pfxriSDPfLqdWSV0Tt
	 DXtuUUe38+hq/tJNcjlBW/RUGS7tL7dEJW4yNC7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 066/982] befs: handle set_blocksize failures
Date: Wed, 30 Sep 2026 17:13:22 +0200
Message-ID: <20260930152418.217374079@linuxfoundation.org>
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
index 32749fcee090a..3646d82271474 100644
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



