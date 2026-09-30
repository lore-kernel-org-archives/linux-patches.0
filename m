Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B026451993B;
	Wed, 30 Sep 2026 17:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790720; cv=none; b=U4OPqvnuoE1BMN4w/NBZaCJvrqwEHzsanOmsBxaS8cFyG+gH5BAxxyHFSI0HPdhJ/tkpCsHMv9RouiYX86EnI/bxhLZ4i1gTe89T4cjmgOrcq9ZNewe+X0wIsG2nFaQIPSzy62zRXevb3xZNETr7u8Xm7fSY7ATjCb54kbUhyts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790720; c=relaxed/simple;
	bh=vEssNDJvreoYkmnvBsnMpmkHQJwGdVZD0Pj5RcPEjFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hXQNUPKSIJlnjB/Gccf96v0xMYmKtLDeWWLFuztdcmUdIKY9Zci7x/UBF4ReC7GsDJ1hhHGeDdBm/E4komM5+4p5JECnQQSsUUsZSOLQKRhSsthVgyRc6K3qS6+fRgcCFX5ufcpw5t+md6GeSimgPKDuL05IrCQaycD+5GRn5k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oF5O8iEq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oF5O8iEq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62881F00899;
	Wed, 30 Sep 2026 17:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790719;
	bh=EaCGqQdQO2E0ylJ9Jhx/qHSF8FQrqtlNRRUh5DXLqRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oF5O8iEqZzp1GhsKMAH86OMyrJpwCJUYUDEJ9ocbAqlOFMWTaEQsSH/VPR0Djj2P7
	 YjSXuC+gZAO+XS5YdAHqyZ68cIeOjps6c6ynOeVxzgz7v52wzbpy2JDxO5PSWyksi3
	 NpS0Twz8jMBNQ8X523njRDajUuFJ5TeXOMXcoh18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 050/752] bfs: handle set_blocksize failures
Date: Wed, 30 Sep 2026 17:18:40 +0200
Message-ID: <20260930152359.238822889@linuxfoundation.org>
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

[ Upstream commit 2430e3380936df0b648af720cae624eef035a2d1 ]

bfs uses buffer_heads, which don't handle block size > PAGE_SIZE well.
Without this, mounting will hit the

	BUG_ON(offset >= folio_size(folio));

in folio_set_bh on the first __bread_gfp call.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260511071701.2456211-2-hch@lst.de
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/bfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index fa4e002925852..56f6bca4246f6 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -343,7 +343,8 @@ static int bfs_fill_super(struct super_block *s, void *data, int silent)
 	s->s_time_min = 0;
 	s->s_time_max = U32_MAX;
 
-	sb_set_blocksize(s, BFS_BSIZE);
+	if (!sb_set_blocksize(s, BFS_BSIZE))
+		goto out;
 
 	sbh = sb_bread(s, 0);
 	if (!sbh)
-- 
2.53.0



