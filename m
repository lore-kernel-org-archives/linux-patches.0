Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74DE4D4892;
	Thu, 17 Sep 2026 17:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667523; cv=none; b=tJnBbnYkwNOoTrs+ua3I+Z7DYmIJrrobJcuDeHZjlLBuz5uOajZUDnqRCV93qaA2XKkAbFZVq9gBflN/Semxe+owk0fElnTHH/PSaG/HKYH1o/7FfZ2lQZ5lAo5VxwgzXvJf1mVmUahLuH0BtTh5r9FY/fm0luCuvOdpY3gzsP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667523; c=relaxed/simple;
	bh=Uv7Vo0umeEyD/Vij3hq9n2MiYvLkZKVhiwRQ4tMy9vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DYTN7Mnfqy1AeNb0/LJkoWZzrcfwrN1CXZ5Ab6Z3r1bDLHfOYQgW3oQ5mhcOoQO1kWzaXytFd6xCHjRMRaSer4QPdLkBPk2RGGxWOcA6d7lW+SM3ETulfIEjnU99swXP8fbh17jSJoOJLHPHJ/JqAN7fOiXBNF7mcFVlJ/9gQW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SBzugxQ2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SBzugxQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34EF51F000FF;
	Thu, 17 Sep 2026 17:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667521;
	bh=e9HqomDjXJ191LhWpb0jb1BNOn6LkbwkCui+nKCHkr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SBzugxQ2R4eT2+rDD+GmUsh5oqb+6xBaM5gCboDI7n6ZfXo3y9PAmoA4KS4wvEpw4
	 wikYpfIRR6XMx2iY+aIMndWqeKLPv/n2+Ew+bVdzOh1/MPcGFfNjLUANzDMKeXssbG
	 pyE72wOy8qQ2zW6EgeBRf1ERRhlvjn3LmMtClBPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0120/1102] befs: handle set_blocksize failures
Date: Thu, 17 Sep 2026 16:01:03 +0100
Message-ID: <20260917151542.522112089@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f92f108840f50..8059a720be06a 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -885,7 +885,8 @@ befs_fill_super(struct super_block *sb, void *data, int silent)
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



