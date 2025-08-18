Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABF7322DC9;
	Mon, 18 Aug 2025 14:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526115; cv=none; b=IfP155AzwczcukzUmfHG2uG8snwzeizKjg0vHiUMG4ZKucOBlATS5aWHS9jyNshpH6La9dTmvVpdsoBrDotGUwEwGkdwMQlItysgwlvMpy6kJvZJYD/jF+d09eGvKXgjnoAlkE5E+tMmA1MBqfSs1fVKFByiGBVvTbt+sWVjDfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526115; c=relaxed/simple;
	bh=YtatHZCb0uq0zmCeiOnsmDjB4P9LWuvEovp2onxXqBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+u74h9d7uyCtFA8UaFkrUzkeu6rYh/UuJrYoEeANCafNVCdfODM4fQ46yANqZr7VAHzsWTcF7i3l+94Ja3lxnnd0wHpZydpQPGK2kx1BXW5VZPSRK45Frr9HUNgdRoCHmeq7E2NY94AdJ5j2oxcuL60x19r8oZSLveJ7NL8YJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YZQaNBoF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YZQaNBoF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5167C113D0;
	Mon, 18 Aug 2025 14:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526115;
	bh=YtatHZCb0uq0zmCeiOnsmDjB4P9LWuvEovp2onxXqBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YZQaNBoFxfzxfIJjJBcCMehG9xxvuIznHEF44tvJC69gMJLucn7Eoqyi7U3dfv74h
	 c7tICLn4nydAzLb7oen3A8jvz0hcTEoMHGDfpl6fXFWBXNaqr7GY5PCsvsKe5WnnL2
	 +lrPdRzU4b/RxYFdiyla5CMenV4YjQ+U8QBJ8xB4=
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
Subject: [PATCH 6.16 463/570] block: avoid possible overflow for chunk_sectors check in blk_stack_limits()
Date: Mon, 18 Aug 2025 14:47:30 +0200
Message-ID: <20250818124523.698942630@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 1a82980d52e9..44dabc636a59 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -792,7 +792,7 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 	}
 
 	/* chunk_sectors a multiple of the physical block size? */
-	if ((t->chunk_sectors << 9) & (t->physical_block_size - 1)) {
+	if (t->chunk_sectors % (t->physical_block_size >> SECTOR_SHIFT)) {
 		t->chunk_sectors = 0;
 		t->flags |= BLK_FLAG_MISALIGNED;
 		ret = -1;
-- 
2.39.5



