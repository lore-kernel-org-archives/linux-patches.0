Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65F84F30C3;
	Wed, 30 Sep 2026 15:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782445; cv=none; b=sTFTJ0NfFNQqvzGjMC4FCLE0wUHnLPAuaJJ5ifVxm3pXk9P56E10g0dGu7XBtype5cezBCqd8O4muzuaYSLf6Kq5u/o/QggnCkuZLD2kpWJu7LxPAeiE+ezg78NGglZRCy/fQ9L5fSFDob3En7QxciTggDtG3mJKg0ao1yQu/9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782445; c=relaxed/simple;
	bh=WIhv1A0QhvF3xs05QBIBAm6Rh/pFTc83/u5+mvuIz7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQI/z6Mu1KPRyVmoF62JHqyNgwTIO+aSthgmk7GgaChK0Wq5NCM+JkmMkwyU+OrXn69gyc/+z2N6CbUY/MlIi4D8G+KmXhoLmN30Vuv9djK2A771wwOf8m+VGbqBjxprfugSvW5u9oBPNkQBAAWaVh3txU4xdeOmoi6wcZucmXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DbXr0gK3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DbXr0gK3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC941F00899;
	Wed, 30 Sep 2026 15:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782436;
	bh=D9qBHnvpdAOTpQ1VKV8cLd6czdkkpkVZBZuML/8pfao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DbXr0gK3hsk/Ns+aU/Cpv0Rnqz8ho8/IbocI5uihQoaG/l5H+V+eYIhC7kl10Tu0w
	 a5s5VC8cxKEPhC3nvrkfiyMziUe/9JUF7cdCkU/hB3AwtuMxot7tPoodDjHfH9k4UN
	 8LeRlLfCMnSOUFSKsdxbV//l/bCZupyA3YuCME9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Anders Larsen <al@alarsen.net>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 045/595] qnx4: handle set_blocksize failures
Date: Wed, 30 Sep 2026 17:18:58 +0200
Message-ID: <20260930152348.699236606@linuxfoundation.org>
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

[ Upstream commit c7d911ea1cc9a63b07e52f5e75b263be0615b289 ]

qnx4 uses buffer_heads, which don't handle block size > PAGE_SIZE well.
Without this, mounting will hit the

        BUG_ON(offset >= folio_size(folio));

in folio_set_bh on the first __bread_gfp call.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260511071701.2456211-4-hch@lst.de
Acked-by: Anders Larsen <al@alarsen.net>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/qnx4/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/qnx4/inode.c b/fs/qnx4/inode.c
index 3fb7fc819b4fc..73eeb22d0f505 100644
--- a/fs/qnx4/inode.c
+++ b/fs/qnx4/inode.c
@@ -195,7 +195,8 @@ static int qnx4_fill_super(struct super_block *s, void *data, int silent)
 		return -ENOMEM;
 	s->s_fs_info = qs;
 
-	sb_set_blocksize(s, QNX4_BLOCK_SIZE);
+	if (!sb_set_blocksize(s, QNX4_BLOCK_SIZE))
+		return -EINVAL;
 
 	s->s_op = &qnx4_sops;
 	s->s_magic = QNX4_SUPER_MAGIC;
-- 
2.53.0



