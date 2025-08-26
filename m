Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807A834F490;
	Tue, 26 Aug 2025 13:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216489; cv=none; b=GzCZnRva4tQOTEnVIksE40gOwlCJYv0mkrU4i6NmfnhMTiI+eyBADC6voy/oezgNH790+2FbXppUJlxJsb2AG/rhMJKra0hCChO4Lni9lSQKH+xVnZyC6XZ60Zp1NCnCFo6jqAYVWU7CvuN5YVtN3PXr1ic2R9/f+dQgKSivJEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216489; c=relaxed/simple;
	bh=31JjWiXApxeT8Ruom2D+Wbc4fyvdxvfP6OSopGp/oCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bDmLUWndQ+s3p3fe/oXHxLud1j7JJAOIcJ0GP/1v4OGbvKYIQYOVvk6VIueR4obxnc7SBJd4xXn3KJzFjMXzkSBHo+AAysElEouyvO8BD+PrCoha88h6isDNISbh+H2aW53IC4GFuQn0APeM1vUYYbmME8SIpVNHEj0ODvODvsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZXRdShpz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZXRdShpz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA766C4CEF1;
	Tue, 26 Aug 2025 13:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216489;
	bh=31JjWiXApxeT8Ruom2D+Wbc4fyvdxvfP6OSopGp/oCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZXRdShpz3YXxP5LjroRfO5JsxCGAjNTNZrdPyYobOpI3c7KEBRPAcjWnFBbaVZ7BV
	 UXuNLWyI1PSiDkh2NByGoWjvKrrb+UEmLKiDUzGX2r3ekV4yMVztjWCprzYp6gsGmS
	 bSxdHSz4vFDyZI2/e7wvfyk7RCJqjpeyDjwjtrWg=
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
Subject: [PATCH 5.15 429/644] block: avoid possible overflow for chunk_sectors check in blk_stack_limits()
Date: Tue, 26 Aug 2025 13:08:40 +0200
Message-ID: <20250826110957.093886551@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1b92e6624951..d501084bab4a 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -596,7 +596,7 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 	}
 
 	/* chunk_sectors a multiple of the physical block size? */
-	if ((t->chunk_sectors << 9) & (t->physical_block_size - 1)) {
+	if (t->chunk_sectors % (t->physical_block_size >> SECTOR_SHIFT)) {
 		t->chunk_sectors = 0;
 		t->misaligned = 1;
 		ret = -1;
-- 
2.39.5



