Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D0751B196;
	Wed, 30 Sep 2026 17:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790723; cv=none; b=tPV5+fMGECxl0NS66af1plIs38WlT9UZ7j/OOs1I6kU0SVb2E6EJVnAboJUZXScXJdpzNojU9TOQtm+vOVrK4BijnOMi8JTOi9H1uc92nIIh0qMNYlX80PU1eLzr0OSe6aB2WfTpLpAV7vYyyxVXPgGPCZfJo80wHyN03jt2vQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790723; c=relaxed/simple;
	bh=MpgJF2NxyqVPpAPuE4r+faWcnyBrlhWbP0uqWflB9V4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O2U/aKY93sqWYFUwmWYTaUZExjrQHuCOYe4iHCxrwTbpkLDtT6eU7Y1PbdATxyhviVLl5NJgqVXFvD73PoFSCKoTkSQi9ZamaOJ3ZzgU4gyYBtOfxDnNUAD2ptfru8eMgF7B17pAn2423yKjLoQfvTmZO/7dCTGJxKm4jOub7uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2VgCx6Z7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2VgCx6Z7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 921111F0089B;
	Wed, 30 Sep 2026 17:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790722;
	bh=u9EZAlUTFfk9SceWe+W8wEPLOWAyshKN1dFg46bh0U0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2VgCx6Z78Xf76EwNu97Tll6QFm2AZWJC43Ev2kn90zq41gV44iOvCB9PwhPR1vjrW
	 ZH8ZESGXX3seN8hxmyi3WytnvU1JTb2h4oW0iSl5sUQmjUbDoMfzU9VRMToIq67ddr
	 tBxfJubVwfbLACfu+IJ4JmmZUy8NNwAmR4jGvETo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 051/752] minix: handle set_blocksize failures
Date: Wed, 30 Sep 2026 17:18:41 +0200
Message-ID: <20260930152359.260368840@linuxfoundation.org>
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

[ Upstream commit 38a03dc2bc71e7e0746cdb9ef5e9947f72470c67 ]

minix uses buffer_heads, which don't handle block size > PAGE_SIZE well.
Without this, mounting we will hit the

        BUG_ON(offset >= folio_size(folio));

in folio_set_bh on the first __bread_gfp call.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260511071701.2456211-9-hch@lst.de
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/minix/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index 95705305d358a..2f08925f969aa 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -270,7 +270,8 @@ static int minix_fill_super(struct super_block *s, void *data, int silent)
 		sbi->s_namelen = 60;
 		sbi->s_version = MINIX_V3;
 		sbi->s_mount_state = MINIX_VALID_FS;
-		sb_set_blocksize(s, m3s->s_blocksize);
+		if (!sb_set_blocksize(s, m3s->s_blocksize))
+			goto out;
 		s->s_max_links = MINIX2_LINK_MAX;
 	} else
 		goto out_no_fs;
-- 
2.53.0



