Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B289F5383E6;
	Wed, 30 Sep 2026 17:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790731; cv=none; b=qdGBT6YXux+MgZeLIpuNK+afUvWwKmPxEi53kdFNOigE2m6JMP13AH06nUixIjzHGqU+Gk6rpUZ/xGeWBjmQPy8Ty6L98JKBrjy1KJ1BN3h5aiRUn1DUV6HaMYY1YJuOF+pSYRZzjF8D7hPjjy7+XUHlKVJrkdH/hGix4kHGNhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790731; c=relaxed/simple;
	bh=nbH2R0FFgQKyvMcC8ORIqeK3ZJ5kJHN4CQYFF6FijDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HtTc09YlqezmgKvYqwpt9WV68Ahqw2X+2I2Bw/XP6tUI5ESz7yuLqs+elQthf2krw72LGXeiHRSa0XoU0XjIArVD7Xk1MKhTElRrRBeqqFRIicxEql8R54T/Mixa+384yWBDkfOWR1Wvkk86TnpeNZwc6PTKnR1TKaGtpLFr2m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tKTLQFB4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tKTLQFB4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B2D21F000FF;
	Wed, 30 Sep 2026 17:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790730;
	bh=O52FevFjQxO1xOhJapp/VG8MpnaUAekzyLy4S6NULAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tKTLQFB4Vfp7lm2z0P3mOG0njFsL8QdCRYqfwJx68C8X2ZZ/i5bKebHU07vvoVHZF
	 VY5Fle7TWp9/N5VghkGCZDP5yKiShgohD0chjZ86JiGCVBRrV9IdFV+mbFLufyhw3A
	 8AKJdRSrKMH8U6xkPVq/au5tGHZVeaX3mnnPnXfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 054/752] hpfs: handle set_blocksize failures
Date: Wed, 30 Sep 2026 17:18:44 +0200
Message-ID: <20260930152359.324495805@linuxfoundation.org>
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
index a7dbfc8920227..a7c1f3ed04599 100644
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -584,7 +584,8 @@ static int hpfs_fill_super(struct super_block *s, void *options, int silent)
 	}
 
 	/*sbi->sb_mounting = 1;*/
-	sb_set_blocksize(s, 512);
+	if (!sb_set_blocksize(s, 512))
+		goto bail0;
 	sbi->sb_fs_size = -1;
 	if (!(bootblock = hpfs_map_sector(s, 0, &bh0, 0))) goto bail1;
 	if (!(superblock = hpfs_map_sector(s, 16, &bh1, 1))) goto bail2;
-- 
2.53.0



