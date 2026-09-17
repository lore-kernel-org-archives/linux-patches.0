Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD174F7CA8;
	Thu, 17 Sep 2026 16:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663961; cv=none; b=PxI947q0iDrAEQt/lDE2SyrUCYGlQoh+O+R+a7/WIuA63VYuh876qm07EK5gT4rph8yf1F/+QdxYWk16j0wlNQAWTOO1cceg1o97T8ivljIt3f4vfo/FpuURKdZMEaGafJ5a1MQVj1lLChBTH144XdABc5YxIgcSsgdEe5/CEp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663961; c=relaxed/simple;
	bh=wXBQzE7wmbZHWBNENY6i4Ot86miFcZXn9ConU66+kQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJFwYq+2BNQxGPNR49U53r28Ycxt6R4jHYBw6VPj1U3IXFbKOt0/L3tWA7iw3D4st7ZrGlDDkzH3KDztPS/T+SDB6Aeou8xxsDDfm1CFgTcn2gvOKVIFpUEDeKpb+KvjG0gFRPWcAow2Gn6u+uCXWtGIk2CXkDTKV2wSgRoOYog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z4wYpjsM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z4wYpjsM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A67C21F000FF;
	Thu, 17 Sep 2026 16:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789663960;
	bh=Ez9iOjdkR0LLFXxC+Th0mZRGqaziAIXvMlhFon6/m9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z4wYpjsMPdwKSBZmIg8+bbx6tZBrAXdNB/UC6Y/6/02GxY0vARU4eW54R7GMygURA
	 Y/lTR6ZzsVs6v0VzP7s6OwESvbaLms0fdfsFLyqUKrEoumMXYblcjmxBnhCiUlpX6d
	 DrrUzxTZY70JkvSR7NtUZ7mY95toTE0RMcbYnNUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0174/1250] befs: handle set_blocksize failures
Date: Thu, 17 Sep 2026 15:59:29 +0100
Message-ID: <20260917151556.815608151@linuxfoundation.org>
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



