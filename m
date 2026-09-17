Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C093B4EBB;
	Thu, 17 Sep 2026 17:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667534; cv=none; b=YExsSvVwIoZOmgCs21h/+tfUj7BeNBZHFpDdpfBGMt/yu925LL4YmY8Bvapfcami0CtEZxZr9cRPVcPbu1eLMWpROsT6Sdg8/OLsDn47XECzfP8AgNeR38Y79IItaiU1jWW2F1xge9LMISJRTmZsIm+VOVm0jESfbxjcULFCkeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667534; c=relaxed/simple;
	bh=UHApF6doigSAaAB7whwptEg101r1fSnRMIRoGE8jecI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n/BkOLkkN5EITN2dsWeL5fqt07VcnMreWOaiSAnG7pX27wxyEByeS4c9CLoyLhMav/6xQk0ZhqN06U4/w7cQJJzfupVlkdCPtHz69wQalM+EIbIndMFgzBoqtMGrcxNt3pIVFcrBJpZlZPTG8Jz/eEOWFBdR0cHgD9tWFbLxcIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kXcSHW1o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kXcSHW1o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E6A1F000FF;
	Thu, 17 Sep 2026 17:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667533;
	bh=4b14e2LzbweJF0am1N0DTi4Ijh3UAryW8iF59UNqcPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kXcSHW1oY5VhcLxy0fFliZrAJthTddfHplMkxJXt9VfAPCj3OdnP9ZZ5WepRdNKBR
	 iVHMKNOa6j/4CuqDM1h60ho+1IZ/RmUKwTBnCUysa3Eo8BhEJXVj8KFdY0gSjryCPD
	 uL9vksEWvVe2HPmDzQzBdZjpgM7o4eJ70NH0PdkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0124/1102] minix: handle set_blocksize failures
Date: Thu, 17 Sep 2026 16:01:07 +0100
Message-ID: <20260917151542.625369357@linuxfoundation.org>
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
index b38eec2760699..7084f41cefbcd 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -272,7 +272,8 @@ static int minix_fill_super(struct super_block *s, struct fs_context *fc)
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



