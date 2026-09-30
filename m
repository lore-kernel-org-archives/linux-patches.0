Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2753D3498;
	Wed, 30 Sep 2026 18:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794085; cv=none; b=HtK/BPhuriDsl+Qr7xMTyLpjnlN39cRYAjm3edTWen1kcWxdetfNQAUFItrLG08pM7KR5UE4T6KEXL0VGxI1Lg/0nUMEaAmXMKM2qStJwX/MLBgYzsS+2s1dp4yyRUwGcK/GBHCXCS908R5xKQPOqN/tVirMWZ1xA5ui9FxMVV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794085; c=relaxed/simple;
	bh=QOe3dSp4NNIC5dA2dEzJYfRR4sPnSVedYs9A1R/ksJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LPJO0ZTlFPpZFOoqyf0BRG4+77mF2EoYRfe5peejE4G0fZeoL6mF1+XYRaIWJUWCiwsPIvJVdawUQDwIfd1MfovawBwT3Gny2beiA66lAW34vc5Txl8mQS2kBICRquAmd/6LvfuCe0ySqc7weIZ9T5KwW6cOwl9VzTIfFjXJMmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xpd9rGPj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xpd9rGPj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB491F000FF;
	Wed, 30 Sep 2026 18:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794083;
	bh=BXJcrA3jMRbstgO7ORKH6bDglnDmigxoLfm9GZ5CphI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xpd9rGPjrLeeOW9e4rOvsnhNVU5xcnUAPs9Q+3ekHJ8sM0DuXWQCoYOdLVFxhvG1C
	 QWRUpEleMetyCydP8sRw9So3bS0gtKXDSZ7D/zuXG+5n6CyL2Umv/qEzCLVspBnwbB
	 wNoNJiJfK5KDxJ1I4ar0fRbY6j2AUd971iP5/ViE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0085/1193] bfs: handle set_blocksize failures
Date: Wed, 30 Sep 2026 17:12:49 +0200
Message-ID: <20260930152436.137245682@linuxfoundation.org>
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
index 42805e3dbdaec..cb61d9f1b3843 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -342,7 +342,8 @@ static int bfs_fill_super(struct super_block *s, void *data, int silent)
 	s->s_time_min = 0;
 	s->s_time_max = U32_MAX;
 
-	sb_set_blocksize(s, BFS_BSIZE);
+	if (!sb_set_blocksize(s, BFS_BSIZE))
+		goto out;
 
 	sbh = sb_bread(s, 0);
 	if (!sbh)
-- 
2.53.0



