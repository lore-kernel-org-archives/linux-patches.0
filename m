Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5B04ABBDB;
	Thu, 17 Sep 2026 17:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667630; cv=none; b=u0TdcdbvY31eONM17oLE7yGZ5T3DKLVnZTqXzhXGPLo7X6s9haOWPckySdbzuqzXejprxkmubjyZ/VIwG5jQ73K0pGtjnNR32BxrumEXrA7iD8mzHO7UDPMGmHp/7WA8FVsZ1CLDfIobhj+e6J4tx4Ii/ljU9XVp6lhbgnKX+mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667630; c=relaxed/simple;
	bh=eiD0DrJtYSTQ7+L/X+HikU6qpguBdVE0RFKogULc3fQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cRexwY+KUTQpvBcdgNCKgxxC1cE76R2UaXEXc86rlm4YA8RyZT31Cr3zM1NXqXIMDuDSGhXeX+6SQSgZu3HTL4lsehMtyYf2CdFb1XvYMQ4rBEew1HQ3febf84xie4toV111Ro36lelK2Nk8UfEoYX64XU28cAgN9ALwt/li/nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b2TJN+XT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b2TJN+XT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF5071F000FF;
	Thu, 17 Sep 2026 17:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667628;
	bh=eenH/NEMK62/6dr8UIgMHD1uPJjaOL5nUEoOGJXbJEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b2TJN+XTzozTRh4u8Aqq5cDy83nmX25eR7t4U3Ak2dCpm7G5yVA9vl1jfgrF7eWt/
	 c86ohEO+TQC6JaWkn2TbYsNgqu4K656LpL7p993rYtGhzacMhmV+KrO8zs5tDwvoTu
	 YwFryP0hj3L4W0YzL7LlHvSth1rXltQoLgg82Jvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0129/1102] isofs: handle set_blocksize failures
Date: Thu, 17 Sep 2026 16:01:12 +0100
Message-ID: <20260917151542.753540967@linuxfoundation.org>
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
index 2b1f56fdde249..f49c4ecd89505 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -818,7 +818,8 @@ static int isofs_fill_super(struct super_block *s, struct fs_context *fc)
 	 * entries.  By forcing the blocksize in this way, we ensure
 	 * that we will never be required to do this.
 	 */
-	sb_set_blocksize(s, orig_zonesize);
+	if (!sb_set_blocksize(s, orig_zonesize))
+		goto out_freesbi;
 
 	sbi->s_nls_iocharset = NULL;
 
-- 
2.53.0



