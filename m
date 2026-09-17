Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240054E0B8F;
	Thu, 17 Sep 2026 16:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663859; cv=none; b=eYPWpCAWAyTzeMOywsQ6zi/kca53mxKhaPLR/yfAiPp/OaAM+OhskjveztIxotzqV3MScjYj7Su5q2nik5E+CuNaGWi2WSGwhFmAaJlsILrKRu0JtFYifqC18tpwYlaS4hPVii+HI6ZOrnD8S+wl4ykI5JK+C98r1X7rL9qcJc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663859; c=relaxed/simple;
	bh=6OSN360t+d4PBp/PXVrwD5xW9At8/x1faBhRl/s7Uu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JIWu/r+ie2oLkH0cy8T/S+JlJiPBDATUG6MwcIo9mH4KiyR1x4yV+QKyDEWzcygKfIjse8EiXpo7yr4HYOiHiCZhnP/0/6trP4nTplHMVJZM7Xugpw2Q9x00SMR7zjUWUPXKKdwltXEZ9KpzuuHcgJZrI3v9AhxUcnb07KhyWTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GDa5dRFD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GDa5dRFD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F511F000FF;
	Thu, 17 Sep 2026 16:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789663857;
	bh=SQdqD5irG5/f6Wdn9PtxYDuT0GmizCigSxszWSzhykk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GDa5dRFDAuDiTDfjnnFsLkZq11QciYKC2Cys37AcHAlcCQ2XIv2CkJ0i3OXUTsIPH
	 9rXYkGRWHZjYDjGq8q3KOatJP8YrdDuJtuKy5ce+2VDxusDsOmXHe0uHOXcQy+fRMO
	 CRbNrMsK4MN+hifwANZewJ/fIoAuLEF4qczcOCIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Anders Larsen <al@alarsen.net>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0179/1250] qnx4: handle set_blocksize failures
Date: Thu, 17 Sep 2026 15:59:34 +0100
Message-ID: <20260917151556.956441148@linuxfoundation.org>
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
index e399e2dd3a124..7a15ad20d98a2 100644
--- a/fs/qnx4/inode.c
+++ b/fs/qnx4/inode.c
@@ -202,7 +202,8 @@ static int qnx4_fill_super(struct super_block *s, struct fs_context *fc)
 		return -ENOMEM;
 	s->s_fs_info = qs;
 
-	sb_set_blocksize(s, QNX4_BLOCK_SIZE);
+	if (!sb_set_blocksize(s, QNX4_BLOCK_SIZE))
+		return -EINVAL;
 
 	s->s_op = &qnx4_sops;
 	s->s_magic = QNX4_SUPER_MAGIC;
-- 
2.53.0



