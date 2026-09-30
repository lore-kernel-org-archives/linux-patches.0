Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52EF4F93A8;
	Wed, 30 Sep 2026 16:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784219; cv=none; b=I0cxc8OlQUThv1ubFqjukX6M6cpRvE7gEk0uDcsK3GUmHj6eywCnwKV+YdKR51ClZ5R7c7f8cQdn4myYxy+im/+Ad7NuoEQfl2C6jXNg1MnmmP1QR5ZiUV/htd5eK2oDh4IFbHMdcZtyUeXiO0UUJdMXHNPVSB3aPXZnYNFZ15I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784219; c=relaxed/simple;
	bh=BnryMM4oIlFleksVPpFGpCGlIS2B1QCPm52DbkWaQ3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGVV3ZgVaBfCgdc0/64GgKg9my5+57nHgGi6bZIQdOyNGeJgnFMyIbqTtgj5hPt6nFYggSkcaPx40vs6KDZPUUNVHRpntcIhDhIdhmSo9O46aVzF6d2MmlEukPX0jXkIjuyOQxn1iysBhgi/pjVRME3gUc0edWrCPP0P7WM3Bz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cizpPt0J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cizpPt0J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A581F000FF;
	Wed, 30 Sep 2026 16:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784213;
	bh=6zMzsl6v6Qeg/0qPiMT+zYATyET+3V861c/bz0bG2vM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cizpPt0J8j9Ujvkc3DED0R7c+ZiVNcLjQVCC9j7NyrdIN46Q5LvUUKrQOBFHdHFFN
	 J6K2F0el+Dn6bP9XTzOrjPjQWXQRQs9YN0rHHSphshQOZdDLt9h6nWo1vU72nlMoPa
	 8ZK8QciITH+2o/EgY9y06c9ksZbGd7/4B5hp/a4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 069/982] minix: handle set_blocksize failures
Date: Wed, 30 Sep 2026 17:13:25 +0200
Message-ID: <20260930152418.284152703@linuxfoundation.org>
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
index fbbc4ef1b7a2e..99ba8a1bf9394 100644
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



