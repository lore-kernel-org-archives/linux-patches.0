Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E32188921;
	Tue, 10 Sep 2024 10:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963424; cv=none; b=ktII+5I449aJPQwFQUQDCUwlXyTPLP4z8Qdfq4d3KNb8rOTYCUXPGkn84hl/r/v7R7dpNPpB1wQqFJB2yx4Ebi/vaK4MEr79RfsrycZ4rkZgweVAKkODKffzXzwJC+8jsxk1h6GWhH7R+KNJ8k7coYoqc80qnATCPRo0WdYzVoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963424; c=relaxed/simple;
	bh=iyn23iNusDqzFlQT6bVs+lbXBbbzfWfV8T9VnGUmPJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XCFS7FrNth662hVecFZp9JnUFWY43XBFznmB4vz8UwNduJnRzS8vT631ajpfJ+sAPjJYSQUlhYchZXyvvzH0U+Ol6mgioy1Z3mpIjoJMFutdlculvWv5NddBumnvhxCvQ5rNuH2n6RqoZzez/ic6Pn9qTode5i9qWYWFLYJpyj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L6pMlyCA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L6pMlyCA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3F8C4CEC3;
	Tue, 10 Sep 2024 10:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963423;
	bh=iyn23iNusDqzFlQT6bVs+lbXBbbzfWfV8T9VnGUmPJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L6pMlyCAn39fTOe3Wd4zvns/70act4FU+BFK1JkJX7GlJJrEYVkAZoFtZgYi0rL+s
	 BT6trsvzZMNucKsp/31XGNy6ERn174XCEnNOxcRySt8CT27AMsJdFYv3hjP9gcGrph
	 9R+1k4WhdHFx3m3Y7sBcHSMcdndxmYNnHqA1dsA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 052/214] block: remove the blk_flush_integrity call in blk_integrity_unregister
Date: Tue, 10 Sep 2024 11:31:14 +0200
Message-ID: <20240910092600.895944529@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 16d5d5338392..85edf6614b97 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -431,8 +431,6 @@ void blk_integrity_unregister(struct gendisk *disk)
 	if (!bi->profile)
 		return;
 
-	/* ensure all bios are off the integrity workqueue */
-	blk_flush_integrity();
 	blk_queue_flag_clear(QUEUE_FLAG_STABLE_WRITES, disk->queue);
 	memset(bi, 0, sizeof(*bi));
 }
-- 
2.43.0



