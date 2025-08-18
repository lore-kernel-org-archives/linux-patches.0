Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBB38BEC;
	Mon, 18 Aug 2025 13:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522684; cv=none; b=tgCJVhpRsmHq8Aw9j/A96XVsthsWJOJXiVkzZe9ssUopqIa3lV6D5CXr520e9X6aUDnEsjGzzx/m4HaTmszcEg90a4XMK+0hGCXIquboHTS23wXkZfpDmRQBggDLl+mAHBgaDFGl8/gQN5S2k5128qB+rruoUYzXsssWmmM5hPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522684; c=relaxed/simple;
	bh=hjKgG4zTjdrGvMtusdgHBW2IiXgFuvTvHmwNfvSSCj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EErBvdvWBy+jlR4sjurKe5lf4zxglPb1ofmtfyyvhE4Ldb3ypqMnJghxQ5jSleL8Lih+pMHIjtejF/vy//1KXLSzcUKo0mZQ0yMwalpsKPf8PHjNptMZ5MqDALHQnf6o7HKiGRv8akTVLW+CSF5+LfqtXz/Cp1pysxQ3KJ9XXAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ejAA4n0b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ejAA4n0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ACE5C4CEEB;
	Mon, 18 Aug 2025 13:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522683;
	bh=hjKgG4zTjdrGvMtusdgHBW2IiXgFuvTvHmwNfvSSCj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ejAA4n0bMLZgXCjKWAQ9tDitF116Y248MSqYOpS2l7MD2yzwhCDyc4Uq4fvIxsWbv
	 yrYo7446/ir8Hjw9npYfSneP8QXPYQqwG6AWGPiCbR2tGXLAd/grGy+GNvEBr/8aL8
	 XtVdMtM1nPZw3Nb+BlU8nnpFoW0DS5wFIY2oFQCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 362/444] block: avoid possible overflow for chunk_sectors check in blk_stack_limits()
Date: Mon, 18 Aug 2025 14:46:28 +0200
Message-ID: <20250818124502.480504999@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit 448dfecc7ff807822ecd47a5c052acedca7d09e8 ]

In blk_stack_limits(), we check that the t->chunk_sectors value is a
multiple of the t->physical_block_size value.

However, by finding the chunk_sectors value in bytes, we may overflow
the unsigned int which holds chunk_sectors, so change the check to be
based on sectors.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20250729091448.1691334-2-john.g.garry@oracle.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-settings.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 22ce7fa4fe20..9ae3eee4b5ae 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -623,7 +623,7 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 	}
 
 	/* chunk_sectors a multiple of the physical block size? */
-	if ((t->chunk_sectors << 9) & (t->physical_block_size - 1)) {
+	if (t->chunk_sectors % (t->physical_block_size >> SECTOR_SHIFT)) {
 		t->chunk_sectors = 0;
 		t->flags |= BLK_FLAG_MISALIGNED;
 		ret = -1;
-- 
2.39.5



