Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185192EA732;
	Wed, 30 Sep 2026 18:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794096; cv=none; b=LIVQa3Ct7GbpSVqGXuOX8OJJRTnpPYVWWuok3wMcVQwo/dKVTZTa5lGUH4HGzXishVbUPggL5uj3talU1z34t4dA4AwyMO3jKeza2Q8MvA22++rXj8Ib+tDtBeBLyQjaNUBH1IVXWD41NLFgcx2FgarEryWkSht+ccNBNQV35bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794096; c=relaxed/simple;
	bh=pfJdB7yqpeUrHWQ+y58yDBtwQROgEIAnGWmpp4cXCek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dmA6PSNLXTH04k8kqZHTakNZQYeaHurtMlMYCiALUmVywxho9LhQVYOvJ95mUhGTGts96ElGD1OmUtwqlOaKyuIwECisjzqMyh5+S21rl4s879R1hxaDJYjyOiQIIrTIYDI/QNLPZBdadsuZTq7t64kEGiXeOns/SKeaYGZOlec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RQcffeN9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RQcffeN9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E811F000FF;
	Wed, 30 Sep 2026 18:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794095;
	bh=qakRDibMDVTzQApLQSV0DSJp70OPjauAMn/FUNbmNTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RQcffeN9lO6RS3qftW9NTqi9QvYbIIXxgVCsNQD5IMUP1pazd8PoyczfenosuWhYa
	 X3X+YbmhDCsJZR7BNHghJc9AjKhBW2T/TxJCQpMbOajvr0ZwtByy4YsZw3VA2JauKB
	 AVROQCe5yaPDzh6azYB4BP4vDZzZR1Y6ybU976pU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0089/1193] hpfs: handle set_blocksize failures
Date: Wed, 30 Sep 2026 17:12:53 +0200
Message-ID: <20260930152436.221776104@linuxfoundation.org>
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
index 758a51564124d..55d5fce08e307 100644
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



