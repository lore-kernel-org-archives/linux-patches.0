Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF18751A73A;
	Wed, 30 Sep 2026 17:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790737; cv=none; b=iYtQcCyLXq1d2udM8dXIynaDdm0gkXD3ZX94ndBr8dFzBbXnIwJ8mYBgHDPzEWJ6QGxM+RDOnDRg05qxGVKGQZ+JudMLlUnr9QvTQb6Wm7GwMWwmD5NFhnRLi1mZEFGfJoLDmIbXQp5xxCkWjFH8yu5uTf9d5HcZiR2N/4Nn5nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790737; c=relaxed/simple;
	bh=/VGzjwgozTD+KkmLnOWsz7BCooqStobi88UtQgRCS20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X4GlVh6K0miLY78IdbBNODJK33Ptxq6cfeQSBwuK8RQtdGxz8GLaUlG6o90egCpY/jzwGpz258Pf6U6wrnPSAI1RaoO4l0tCMRy/fIe6aUh+tUIucGhVWGCtfQbvBA2T5sFFkLU7zJieeT6flkYqlKC5HgZv+O/ypb1C5dKAh3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PBYwITJ3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PBYwITJ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA961F000FF;
	Wed, 30 Sep 2026 17:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790736;
	bh=glE9PtP2janhKSrPpAKaziW5IqJ014Y3JuftUNW/P2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PBYwITJ3m6vuUR75iTOmkQtSk0GuxzCx5OI92hggloCrl3ITngSjNWWI4PMgM/BqQ
	 eV4Gyp9ojHoGZtChcm2PoWD6R2R9v35TXMbOuxvHQdyuVnY81Mk6VzXradgvIdvrkT
	 06JV5ux2+f93e0b4CD0Fyl+mUdnH6Ax+UgE70TWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 056/752] isofs: handle set_blocksize failures
Date: Wed, 30 Sep 2026 17:18:46 +0200
Message-ID: <20260930152359.371443513@linuxfoundation.org>
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
index e799305b1d687..9b530be5dafa2 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -859,7 +859,8 @@ static int isofs_fill_super(struct super_block *s, void *data, int silent)
 	 * entries.  By forcing the blocksize in this way, we ensure
 	 * that we will never be required to do this.
 	 */
-	sb_set_blocksize(s, orig_zonesize);
+	if (!sb_set_blocksize(s, orig_zonesize))
+		goto out_freesbi;
 
 	sbi->s_nls_iocharset = NULL;
 
-- 
2.53.0



