Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5935D432BD3;
	Mon, 31 Aug 2026 13:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183211; cv=none; b=KAN9PqN4fuaneoijoAHfbEKjyqKhiQRR5AUYC6JcopRY3MTfZ4wfmXJWZJm+4GFqw9PwINb1S3BFxw5fVinaj3h0D90la+h6q0OS+p9EwiD/58xNAOvHH5JkAhnIixtEsENM7Se3SC4ojukcUTNiwn0scU5ldBGuYAOWOSuPNls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183211; c=relaxed/simple;
	bh=WejE7pdVwkRplvzY/O1xl6p/VQnqauq4PuAzDY2QJcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z2f++4rIknTyA7ByGxmz5hn1qaVIU44kdQrPKgfUT0qxRZPdCqjqZa8vwnu+d8bKil8v4+KM1D5jBiM1110HFt+hynhIkHhR9v3njbf4uvNC3f0yoFR4E4RkbWhJlV1YjyjoXN354hjH709W2Ik+v1C6AOheoQWlty1K6Yq86Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MMCLWJMP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MMCLWJMP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 677E31F00A3F;
	Mon, 31 Aug 2026 13:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183210;
	bh=EFqhZ4df9SB5zhIMj8qIMB2mLM9hgI2Ebq4uBJMnoDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MMCLWJMPr3RowbuttGxzBs/4yv5GC6RXBbTOGgeuT3UFH9usosw7JV67VRloGut0x
	 +/HCJZMlyg46CDKxdoh7sW8kZ0FTrivPQkCkBGjShqhKBK5nGN6h//f/qGZxHxWRVM
	 6ntjAKraUiljP1nlkF8+n9QkFc0iq/wRiLI7x6iOYQflBgxVdw7NyHbV+BTwbXiHlZ
	 /7GpIBCUjQK+dpQtRiQDJmZbFoLeCaHZ4rNSszZo4XlXGkZ6gjxmPXemN1bWq6tctM
	 Y+QNKeIfJmHNK/5Fjz2YB89AbbxDgk8FGtHHOys9DMkvqcmq9bHOF6DA0XD09tvTFn
	 Yc7FUzH4wA3Hg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	luisbg@kernel.org,
	salah.triki@gmail.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] befs: handle set_blocksize failures
Date: Mon, 31 Aug 2026 09:20:38 -0400
Message-ID: <20260831133314.4125787-10-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

The background git searches finished and match the earlier analysis.

On **v6.18.44**, the `befs: handle set_blocksize failures` commit is not
present (no matches on HEAD). BEFS still ignores the return value at
`fs/befs/linuxvfs.c:861`, while a related fix (`173b066f5826e` — check
`sb_min_blocksize` return) is already in the tree. The patch applies
cleanly and belongs in the same crash-fix series as the romfs backport
already in this tree.

**Verdict: YES** — backport recommended.

 fs/befs/linuxvfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index 8f430ff8e4458..cd9921b977a72 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -858,7 +858,8 @@ befs_fill_super(struct super_block *sb, struct fs_context *fc)
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

