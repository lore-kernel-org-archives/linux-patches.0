Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6FB384243;
	Thu, 17 Sep 2026 16:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663866; cv=none; b=CtHGHtdGYuDL5xLfc3bF1e1jjui99yg3+U0LzXZdqcaGnrLs9MJk76EW+3q76K/73gA7BxhZCpZ6hBp8fTZ2ogw6eT2ICOhyNCdcc1wu0iY+rKCU+iCt6WrA095niGEkDqdB2dwF1Al5cZjj3cMdq87FAygiTIlMcaP6birxR0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663866; c=relaxed/simple;
	bh=yGrR32WjTY51hJWzum8w/TN3cT3KM4mMCAI3EIguB2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H8YVIilKR9b7hKv3eh8E0ia2My+jiCY83ikcGizBF3dxTC3XUyjSf/fKAMqsL29+2fWAdm/8UY+3+h0eyMKyqmUAtY61CQM9l4WMHyB92SCxEHduCA6RePbwWZhvf69mJUOvjN2AYaZBYmqvP8M1uUhhGQ3R6FF3uZTF7VTVjxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DH8uxi/W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DH8uxi/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9621F000FF;
	Thu, 17 Sep 2026 16:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789663865;
	bh=l7+dVy42/QEw7qZBtk5KGjOKP22liNzGGdSEcxoR9fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DH8uxi/WPj7k0/54Szph7Nul+ZEV/Uq7a8TPZbIZeoGyXMlH4ERKlZclcAzsKR+1o
	 7m3Zid1Z4GjAfPGgbC5AxFgoZwQxGGSYGz0bP4rSVs5U1JcNL7P4sNFX47zFfFFue8
	 OCTlBSmVYhHLqYQCjYbOSgcf/cSa6uJesEEWRcKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0181/1250] hpfs: handle set_blocksize failures
Date: Thu, 17 Sep 2026 15:59:36 +0100
Message-ID: <20260917151557.015241085@linuxfoundation.org>
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

[ Upstream commit a405996f23e04942aad064ab8d50c55827482872 ]

hpfs uses buffer_heads, which don't handle block size > PAGE_SIZE well.
Without this, mounting will hit the

        BUG_ON(offset >= folio_size(folio));

in folio_set_bh on the first __bread_gfp call.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260511071701.2456211-3-hch@lst.de
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hpfs/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
index 8ab85e7ac91eb..553e6b6b4600b 100644
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -522,7 +522,8 @@ static int hpfs_fill_super(struct super_block *s, struct fs_context *fc)
 	hpfs_lock(s);
 
 	/*sbi->sb_mounting = 1;*/
-	sb_set_blocksize(s, 512);
+	if (!sb_set_blocksize(s, 512))
+		goto bail0;
 	sbi->sb_fs_size = -1;
 	if (!(bootblock = hpfs_map_sector(s, 0, &bh0, 0))) goto bail1;
 	if (!(superblock = hpfs_map_sector(s, 16, &bh1, 1))) goto bail2;
-- 
2.53.0



