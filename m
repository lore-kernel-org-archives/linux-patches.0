Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C743D16E2;
	Wed, 30 Sep 2026 18:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794090; cv=none; b=mxohPRvjNgShrapL6tz1RF9VfoZM8WAK+Wrw2AsflYrUw8Qtb2u4YhHE9cwaOsUyEKYuraCSq1aKcXRFsL0SCznlvUwfotiHzPp5N/H04BUH84cvW8E0z9IJjFALwAiB9GK1rxyzR+Z5CcqA8LtkFxWJReUs2q2VoTduiPOOSlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794090; c=relaxed/simple;
	bh=Y5vOdvLq26TrmYqhH9cjizVhQnelkUvdvrAd59/UZAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pgFo5AQbkuh/ivCLvkX98Ftxa/Dqdwf1L6weGef1ApyrP5tiKK8MomXZPz1WmxXYjQIrNVwDLTiYo6UMU/kpglvOo+qPeXEhpdJX+QM2tI2YiUxvQ9l4W+e7RwpaQmXNmX46clW69fPN5WpQmCcoO8QAFBW0wLhpgA9npQpLEwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mwVtXPdA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mwVtXPdA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2B51F000FF;
	Wed, 30 Sep 2026 18:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794089;
	bh=QlrvnqPZfsBVoGT+RQurbxaVq5kzVItOytZuS21Iy8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mwVtXPdAUzlH7kIZazCxOgvutmNAMNpNbHVN3Wzq96c9WSp0Ygou2rOoglHB0yIV9
	 a9TpTxykHFgHd9EAi3lTjUHCniJz56MziqG/Jk11Y4FoGw64ffKMJ5TYyUh8G7313C
	 XEFqWZRmYMhtl51Kp+s/Lz/H9CYTKGBUpB6llNew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Anders Larsen <al@alarsen.net>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0087/1193] qnx4: handle set_blocksize failures
Date: Wed, 30 Sep 2026 17:12:51 +0200
Message-ID: <20260930152436.179280968@linuxfoundation.org>
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
index a7171f5532a1f..396b6faf166fb 100644
--- a/fs/qnx4/inode.c
+++ b/fs/qnx4/inode.c
@@ -195,7 +195,8 @@ static int qnx4_fill_super(struct super_block *s, void *data, int silent)
 		return -ENOMEM;
 	s->s_fs_info = qs;
 
-	sb_set_blocksize(s, QNX4_BLOCK_SIZE);
+	if (!sb_set_blocksize(s, QNX4_BLOCK_SIZE))
+		return -EINVAL;
 
 	s->s_op = &qnx4_sops;
 	s->s_magic = QNX4_SUPER_MAGIC;
-- 
2.53.0



