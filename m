Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A236BB5B;
	Tue, 12 Aug 2025 18:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023392; cv=none; b=odZyaiVXAo5uLmKZlwpQGIp7O+MQrUxQR6B7sHrcggoVzsS+M8gRaSBMi9daeSTAmf7H7SoyA971fXDDrHmm+E59rTSRCJXeBO7P+UcKrOwDZjHI0H95BLXTw2j0U+8CIvg3XOxkflF487dedLykA6GixazFaPkTK06mS8ihXa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023392; c=relaxed/simple;
	bh=ly/6PH/maR4jPs6pT4G8dVvYQFoGIC7M3Dti6QsGVRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bhqFGwx9wmcZ5SnCzzPPcb+JFzXc+qmj7Znon21BfazlPNeIPhBe6goyegNyqLxP1Gb8st0XCnxPb1+/uI/Hn9VLS/PwOGZ8ewwBIPUciagcQIMKEBE0fAxeNuxmE9xB+tYKtcx2bfCyrnd1DaR/5Sf6wtgnf99vxyX7Lcc43Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cl7st0Wr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cl7st0Wr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 072B7C4CEF0;
	Tue, 12 Aug 2025 18:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023392;
	bh=ly/6PH/maR4jPs6pT4G8dVvYQFoGIC7M3Dti6QsGVRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cl7st0WrcUTW3+fDNoIlFk3sLdrYTzLM8T//ljGE7I52GkwxddTEGoQTJGER0BowX
	 WTckGuQFxe7KX+b6x9+NMIZ6Q+lpjIjExthla0reegCbPOsGLaOAZBBFKyaqVR82tg
	 Su4LLbkWR2IGtg20VVWjALvYCGec2pi+2c0sOkHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilay Shroff <nilay@linux.ibm.com>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 023/627] block: sanitize chunk_sectors for atomic write limits
Date: Tue, 12 Aug 2025 19:25:18 +0200
Message-ID: <20250812173420.200703183@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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
index a000daafbfb4..3425ae1b1f01 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -181,6 +181,8 @@ static void blk_atomic_writes_update_limits(struct queue_limits *lim)
 static void blk_validate_atomic_write_limits(struct queue_limits *lim)
 {
 	unsigned int boundary_sectors;
+	unsigned int atomic_write_hw_max_sectors =
+			lim->atomic_write_hw_max >> SECTOR_SHIFT;
 
 	if (!(lim->features & BLK_FEAT_ATOMIC_WRITES))
 		goto unsupported;
@@ -202,6 +204,10 @@ static void blk_validate_atomic_write_limits(struct queue_limits *lim)
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



