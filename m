Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736FA4DEC1D;
	Thu, 17 Sep 2026 17:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667542; cv=none; b=fzHrke8huqEqj493it3asK4QumgNd8z08Z6iLCGF+uGKjPZ2ymKlP0fnEtZKzz1UAlS9y/NcQiaGEjXxpFCDngRsRlqmAfWdOcmFEyAFJUZBTYFLWmlZIqZeG3X3dQdt9Nc+LKiQ6WSHRj8YNsYye6+l6bnuX6EnagwkoxrQJNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667542; c=relaxed/simple;
	bh=ibWtNttQj74b6ppGh3Ssi+Tv+V0E6x5FhvIgfqM3rtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RfOPm573RO2HKp2FnfF76yE+7hIZA3ziP2aWRh8r4AZxSpHDlZawDLYzO3/04glkdHjjNuix4d2XtmPNGkZH9z+g9ROhe7/6vkDXXOuPH1Bk3zNsywnnCbPTpIXOf0PSyPxUeEy2zBi5zXx5h+Bpc8soCFtqYMHty19rbQTQpLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wiCehGXK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wiCehGXK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF1A1F000FF;
	Thu, 17 Sep 2026 17:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667539;
	bh=JuPo1XNBePF/ZWka51Wd7JtPQM8f+2BN/MlD3ZtJXms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wiCehGXKaWtqH0D+qwAg2JfI3VgO1oa7KxW9K6FGE9po80zbOvjxDmwDD3PTBg+GE
	 A5vbF7q1+JLbLtZKhiobCHpnxsL3sELb8EB8iCXdJouP4FEr2YmtNUUcPRzcMU/3WY
	 Jjm2lsbyT8QDu0SuZInWChDJx3fgLnd0UNveUJU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Anders Larsen <al@alarsen.net>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0125/1102] qnx4: handle set_blocksize failures
Date: Thu, 17 Sep 2026 16:01:08 +0100
Message-ID: <20260917151542.650606645@linuxfoundation.org>
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



