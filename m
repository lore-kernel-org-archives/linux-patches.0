Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2285381
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:45:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34318C433C8;
	Mon, 19 Jun 2023 10:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171531;
	bh=Azj76M3UM3k0Gk6JxbjEooQCRC94PFZLxz2jarQxRMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tqCMKs21upPZUCuy06ZauNHzF8hGffPzkyMD6TSVFX4xsQvFQefJAsoVEMSnzjkmw
	 ljDcbtweJY/Wb/X+5CHFEAxIrxbs4fZChXVu7FOGqOQm5RCsxGDygS2OjeNnphjsgw
	 i8JjoFh92zzb/DxzYE1Ttm9EwUQeMuHxLqWPXA4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.1 065/166] dm thin: fix issue_discard to pass GFP_NOIO to __blkdev_issue_discard
Date: Mon, 19 Jun 2023 12:29:02 +0200
Message-ID: <20230619102157.941940350@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mike Snitzer <snitzer@kernel.org>

commit 722d90822321497e2837cfc9000202e256e6b32f upstream.

issue_discard() passes GFP_NOWAIT to __blkdev_issue_discard() despite
its code assuming bio_alloc() always succeeds.

Commit 3dba53a958a75 ("dm thin: use __blkdev_issue_discard for async
discard support") clearly shows where things went bad:

Before commit 3dba53a958a75, dm-thin.c's open-coded
__blkdev_issue_discard_async() properly handled using GFP_NOWAIT.
Unfortunately __blkdev_issue_discard() doesn't and it was missed
during review.

Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-thin.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -398,8 +398,7 @@ static int issue_discard(struct discard_
 	sector_t s = block_to_sectors(tc->pool, data_b);
 	sector_t len = block_to_sectors(tc->pool, data_e - data_b);
 
-	return __blkdev_issue_discard(tc->pool_dev->bdev, s, len, GFP_NOWAIT,
-				      &op->bio);
+	return __blkdev_issue_discard(tc->pool_dev->bdev, s, len, GFP_NOIO, &op->bio);
 }
 
 static void end_discard(struct discard_op *op, int r)


