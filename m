Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F792371049;
	Wed, 30 Sep 2026 15:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782448; cv=none; b=NukICQt28U5T5TZh0u4m+7Ye83RcQNHGVknwq3vwIdhRhgR2zOUdVvIQ+K/uonQaZOO32IBR95qPvuQheMyFLz9CmQGrPYJ9EBxaRFSSVv0CyMrfTB5YjYv+8iXKZ1jIwrE14MZ89cHs60JCd2wp6b7//XNvbkbE/cV8tz0eorg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782448; c=relaxed/simple;
	bh=ZkL9GkPBxfu7Rr/BplyJwCohrI5gXpmuOYZ+ow5wUQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TcwQr1PeYh7XJgugM2p9L6je10ZWkqWzKQFySu4N4ZxssD4s9XUDO580wDqMo+Mi55or2Mu5/JDHEefo4udjBz1OHfvIDZv2Mgwj8sdq6tPGxfrRsBGjHVgDy6nX8mVTxhNRtXf+Xku+5+Ywd8vrlzMvXcPs8o6/0cko3PBfJlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xlk5BP41; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xlk5BP41"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E74FF1F0089C;
	Wed, 30 Sep 2026 15:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782439;
	bh=ixw/SHYHuAoAsXUSQRqSzUXVjJK6cJpstNsD4MNVmiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xlk5BP419SwdKy78ZnspOaY6Ob19ejJJEB8V12Rup9FqqBwh8M/eK//a8b0aoP7Lj
	 aAFWz/Hnfk5QF/xJser1o90VUrZ2rcODlUDyDskilvCBUEbmD9XZiIe9/g/ehMElgJ
	 qE8Vi60JJBCOOKGVTcp407dKXh/a33YAGtSyyXVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 046/595] jfs: handle set_blocksize failures
Date: Wed, 30 Sep 2026 17:18:59 +0200
Message-ID: <20260930152348.720892712@linuxfoundation.org>
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

[ Upstream commit 05107f5602751fcfd3d108c1f579eb45aabead52 ]

jfs uses buffer_heads, which don't handle block size > PAGE_SIZE well.
Without this, mounting we will hit the

        BUG_ON(offset >= folio_size(folio));

in folio_set_bh on the first __bread_gfp call.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260511071701.2456211-5-hch@lst.de
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index b2dc4d1f9dcc5..3cd344c649ccb 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -529,7 +529,8 @@ static int jfs_fill_super(struct super_block *sb, void *data, int silent)
 	/*
 	 * Initialize blocksize to 4K.
 	 */
-	sb_set_blocksize(sb, PSIZE);
+	if (!sb_set_blocksize(sb, PSIZE))
+		goto out_unload;
 
 	/*
 	 * Set method vectors.
-- 
2.53.0



