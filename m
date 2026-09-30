Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD50D509EEF;
	Wed, 30 Sep 2026 16:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784309; cv=none; b=Hv1h6pHlijxXvgRvKtPIM78KnwEQVFWo2XfeVsYndncSJxRe4tnu6rAytbFTxVTJtxKHJwV7YD2z38r7+UvCWg5GedkrEESr+xKTuW8lALQK6GbD0Jjw+T+rUiDES6gNiKg8X2QYwfAnVYS5OdmICYP5KhQ+4FcCxB6Kcw5I1Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784309; c=relaxed/simple;
	bh=NGCR+NARIYNcSem93gKhS0aGMA4Y5+Vl9Q7p/X5EU7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/S/7+kVWAq7/AVlVTyPGN0UIR2nEClAhTkqJw/yR2nKKQziqiwv0jS+ozg271wqfxptoeYtiNoo7qfigYMLHJontAh/NEeGeiaicQsZjE8Bl+rgs7CAQX1CWOG3idmPT0nwK4lcXuuqbD2YxST1YEZb8clqFTse/g/7LSd+LOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qp+Sjthf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qp+Sjthf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 168191F00893;
	Wed, 30 Sep 2026 16:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784306;
	bh=iaZk5pkIgEJ9Q2lHcFcZzeV6nai2o1EpPF9/wOf+3k8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qp+Sjthf3zXEIK/b9JYiJDIH8PRLXjyHQm33hIzZxB6KNhoITQdl3s7z9v6kmJ2Yn
	 gNHU2FfA6In38NYwErTUD1z5e3NdkG5w97/m77soq9wdxFPwbGxZiYMylPHV5F6AtG
	 ajpsV0+DcsTayGp+evf4yiEg07HBH8ZftTFH/8dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 072/982] hpfs: handle set_blocksize failures
Date: Wed, 30 Sep 2026 17:13:28 +0200
Message-ID: <20260930152418.351197877@linuxfoundation.org>
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
index 1cb89595b8756..c66f859ec9a9b 100644
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



