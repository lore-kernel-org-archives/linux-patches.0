Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C360BA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:03:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78AF2C4339B;
	Tue,  7 Mar 2023 18:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212204;
	bh=ulycp4yw5PwKVEnBxrQjSQVmLYGzZJrd0p99qCkkJgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GJJ6tEl741hVy5t816BNCNWnQPHnutUnkeBoOscvMqxeo/4M+yECYvGqkRiYJ5wT/
	 nDbOmvN6y99538mvOEG+o6I6cKLtNThniYrVjU1I8zGtTO1Jtr9rSiNGCJLqbZFILp
	 8J+M9WPnYb4e1JrDrucvvYB+eVLmC0PLOCkgM/2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurav Kashyap <skashyap@marvell.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 109/885] block: bio-integrity: Copy flags when bio_integrity_payload is cloned
Date: Tue,  7 Mar 2023 17:50:43 +0100
Message-Id: <20230307170006.616027538@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Martin K. Petersen <martin.petersen@oracle.com>

[ Upstream commit b6a4bdcda430e3ca43bbb9cb1d4d4d34ebe15c40 ]

Make sure to copy the flags when a bio_integrity_payload is cloned.
Otherwise per-I/O properties such as IP checksum flag will not be
passed down to the HBA driver. Since the integrity buffer is owned by
the original bio, the BIP_BLOCK_INTEGRITY flag needs to be masked off
to avoid a double free in the completion path.

Fixes: aae7df50190a ("block: Integrity checksum flag")
Fixes: b1f01388574c ("block: Relocate bio integrity flags")
Reported-by: Saurav Kashyap <skashyap@marvell.com>
Tested-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Link: https://lore.kernel.org/r/20230215171801.21062-1-martin.petersen@oracle.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio-integrity.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 3f5685c00e360..91ffee6fc8cb4 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -418,6 +418,7 @@ int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
 
 	bip->bip_vcnt = bip_src->bip_vcnt;
 	bip->bip_iter = bip_src->bip_iter;
+	bip->bip_flags = bip_src->bip_flags & ~BIP_BLOCK_INTEGRITY;
 
 	return 0;
 }
-- 
2.39.2



