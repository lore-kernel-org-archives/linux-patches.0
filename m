Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4672623182D;
	Tue, 12 Aug 2025 19:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025388; cv=none; b=tV7QUID8uj1mJMMX7QjEbvylSYwPu2uAhaoSHKoaKkD8FxayY3sx9m6lfyMOElpSaBo7mekBv88omONVqUNgmy0133sGH/FpbBlPzszSzSvgEyqgy9DpnSQRAtO6CcafX2upmWRGNAm7xyzo4LLWDnK8VhUvzXVk6Im/WEDxqQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025388; c=relaxed/simple;
	bh=/OKOib9mZZqEmFL1UI4eiIbyw+A6PKpnY+Uny430YtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JxrbZAf9hnwtcs56diIO7KdG8oUKsWrqVuC06guf55FhlmDZcQFS24MTZtvlhTVeNBuMFYySDEGsfGxY90hZ4HJL0e2uS7Uul1dc54udR2OO7hcdhhaw4pAmonei/zFb48FK5MNWdcRsxNM3nzvfv7d79EmZUzNwcbRPc5dIILc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yPa0KREh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yPa0KREh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F36C4CEF0;
	Tue, 12 Aug 2025 19:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025388;
	bh=/OKOib9mZZqEmFL1UI4eiIbyw+A6PKpnY+Uny430YtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yPa0KREhH9Y/le9L+IpIqA6mXWjL3CShphPyP2sjUPdGyOF72WsGx3+we6VksXsmY
	 eHNn3RORL0sKLxMejCbCcb8Eo5EzIFZOQV6Mj9XOu5/+7B6G/h2u0t2dJKOnyNG5d/
	 6RRvT3oDJPo49hNNKLJI5HzPuOIT2IFMIsE0WmEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilay Shroff <nilay@linux.ibm.com>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 026/480] block: sanitize chunk_sectors for atomic write limits
Date: Tue, 12 Aug 2025 19:43:54 +0200
Message-ID: <20250812174358.401848535@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

[ Upstream commit 1de67e8e28fc47d71ee06ffa0185da549b378ffb ]

Currently we just ensure that a non-zero value in chunk_sectors aligns
with any atomic write boundary, as the blk boundary functionality uses
both these values.

However it is also improper to have atomic write unit max > chunk_sectors
(for non-zero chunk_sectors), as this would lead to splitting of atomic
write bios (which is disallowed).

Sanitize atomic write unit max against chunk_sectors to avoid any
potential problems.

Fixes: d00eea91deaf3 ("block: Add extra checks in blk_validate_atomic_write_limits()")
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Link: https://lore.kernel.org/r/20250711105258.3135198-3-john.g.garry@oracle.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-settings.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 4817e7ca03f8..d8c79e5112b4 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -186,6 +186,8 @@ static void blk_atomic_writes_update_limits(struct queue_limits *lim)
 static void blk_validate_atomic_write_limits(struct queue_limits *lim)
 {
 	unsigned int boundary_sectors;
+	unsigned int atomic_write_hw_max_sectors =
+			lim->atomic_write_hw_max >> SECTOR_SHIFT;
 
 	if (!(lim->features & BLK_FEAT_ATOMIC_WRITES))
 		goto unsupported;
@@ -207,6 +209,10 @@ static void blk_validate_atomic_write_limits(struct queue_limits *lim)
 			 lim->atomic_write_hw_max))
 		goto unsupported;
 
+	if (WARN_ON_ONCE(lim->chunk_sectors &&
+			atomic_write_hw_max_sectors > lim->chunk_sectors))
+		goto unsupported;
+
 	boundary_sectors = lim->atomic_write_hw_boundary >> SECTOR_SHIFT;
 
 	if (boundary_sectors) {
-- 
2.39.5



