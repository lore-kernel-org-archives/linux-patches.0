Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B4514A08E;
	Thu,  5 Sep 2024 09:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529937; cv=none; b=olvQoX1g0rPIxO0MmxG6EnCCWfUna8W2PNV7R0w397edxcKvm0VvP0Lww3INO0EhvsZNI7cT1bkIbequlSWzwtbtB+jCv14u03WGxKLFL0p8rDZkQjTGYGrCWv5SAvk8kccSRhU20MsTi0JP9zGG3zysoU7iL0pzHkK3qfwIM5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529937; c=relaxed/simple;
	bh=1SmMMTbTYmWM5XwemCXAWf/E9W6XyzfeSEUI1K9Kkjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s1rAr4UVEy3QLbHWo8yJATCPNKaBkC+90kk7xO7T3n8VfrBlF+pyOJFwP7vxXKKZjkuILITayrtbtmO9jk6rbqxkM0+rx6CZqgF5eJU5kgkXFW6JaB+Lv1HJAWWpLysPLnSFEj4FU6GBA5NhqH2Z2++71rOyX54mV1tqF+KPcUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NZGWHe/K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NZGWHe/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68096C4CEC3;
	Thu,  5 Sep 2024 09:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529936;
	bh=1SmMMTbTYmWM5XwemCXAWf/E9W6XyzfeSEUI1K9Kkjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NZGWHe/KOdx839ZZd74ayXd9WMPDj13SzZzsnYKbIVVOoov/LVgSzLikjnH7kRpuZ
	 Jaz/L0yQjJsH6u+IlOX00eWDdaG9pxw7/kkOPD5G1vS/DDdyCazzGNLBRMKgobdnA7
	 9rsSqIbIpf7uEHx+Z9JZJhqAqRi0kwnvT+A9qX38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 162/184] block: remove the blk_flush_integrity call in blk_integrity_unregister
Date: Thu,  5 Sep 2024 11:41:15 +0200
Message-ID: <20240905093738.664881513@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit e8bc14d116aeac8f0f133ec8d249acf4e0658da7 ]

Now that there are no indirect calls for PI processing there is no
way to dereference a NULL pointer here.  Additionally drivers now always
freeze the queue (or in case of stacking drivers use their internal
equivalent) around changing the integrity profile.

This is effectively a revert of commit 3df49967f6f1 ("block: flush the
integrity workqueue in blk_integrity_unregister").

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Link: https://lore.kernel.org/r/20240613084839.1044015-7-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-integrity.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index ccbeb6dfa87a..8dd8a0126274 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -397,8 +397,6 @@ void blk_integrity_unregister(struct gendisk *disk)
 	if (!bi->profile)
 		return;
 
-	/* ensure all bios are off the integrity workqueue */
-	blk_flush_integrity();
 	blk_queue_flag_clear(QUEUE_FLAG_STABLE_WRITES, disk->queue);
 	memset(bi, 0, sizeof(*bi));
 }
-- 
2.43.0



