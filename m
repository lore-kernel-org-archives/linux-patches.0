Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A49A2206B8;
	Mon, 18 Aug 2025 13:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524295; cv=none; b=ZVPyqWvTecOlD4OGi2LntawmBLCiBrqO329a5OWBQs3Gs2CAFbWUo6uwCZJnpBQLDsOEB96XlOrj61c91EQH/t/1IZDntezZR4XJiXW88oS7l9aP7ifIlV7lt4bEMvU1QVP5x7WPu0ZU+xKM13XmAPc6nBDzUm00Urufx/8doN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524295; c=relaxed/simple;
	bh=JmHFhiEEtMDkazwIJBj5D1XlO0Kp+PgjppkCYBaU3kQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W0Td3mGVxhu4i4VoU+O3p0GwzwfU+Qr0mY4u4YnGlneauicp2sL8p57TGl4+AiRSvRCfhKA+0ZjYyZ0imI5l+CLHl1dX8oOGraVAn4Qq7Vj6v8pGtqH+g4+a4bbdRYW3SZgofkle0Ec0o6/7OCDUOysu8WfTl+notivPV8o44rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hc5+iJhh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hc5+iJhh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9D4C4CEEB;
	Mon, 18 Aug 2025 13:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524295;
	bh=JmHFhiEEtMDkazwIJBj5D1XlO0Kp+PgjppkCYBaU3kQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hc5+iJhhaPBxb8VRV8rCxatJdW5/ZjklMNpUsHT+MtCAKBZ11mGGXWHFevFLxPJJh
	 AqtN9hSvedJfcTzF1c/Y+slWk4hEfJAK6CXZBawzHOdxznAuA0GxoW+pyAtEyeS6jE
	 vp5tAqXhArdLbRHagLqhfuV6exjVaeXFiYfsV2M4=
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
Subject: [PATCH 6.15 427/515] block: avoid possible overflow for chunk_sectors check in blk_stack_limits()
Date: Mon, 18 Aug 2025 14:46:53 +0200
Message-ID: <20250818124514.862665638@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 47a31e1c0909..7a76ff3696c4 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -797,7 +797,7 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 	}
 
 	/* chunk_sectors a multiple of the physical block size? */
-	if ((t->chunk_sectors << 9) & (t->physical_block_size - 1)) {
+	if (t->chunk_sectors % (t->physical_block_size >> SECTOR_SHIFT)) {
 		t->chunk_sectors = 0;
 		t->flags |= BLK_FLAG_MISALIGNED;
 		ret = -1;
-- 
2.39.5



