Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E1B312819;
	Mon, 13 Oct 2025 15:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369313; cv=none; b=F3334OGcMMWOivT+jcNbnf8t1NRDEkp/HlIRrvh349qzr8ReXYLniwn9iOxuKs3mSs67Mf9DKZ154g26BdpMuMumcOYo5bzInA4dJKkOJsK8lru5ndZ+VnthAiiZXqfOECzZG7Trwg8qIBwfDSu++nfVyLQhL/iGMsQ0CBLU/PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369313; c=relaxed/simple;
	bh=ZCgU8y5I1uEFg7r3dLWr5yhA11DGxcZw0i5WpFa7Qx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CjW9vqTkCZr2ur/x0Vto1VaCfGAcpEgxVcE6Bib1pqNMqVbPadUsTuOVv+7eyLQB+/H4d/6PQOWblLhJQ0yGs2vYQU7jTuPnLn0DKZbbzbMpc61PiNt7hZW43ETsLx4QgOaOuBoZ/JHQ9PswehhpFwjADTmBsR1ITbaVyp113Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hhVmI0YW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hhVmI0YW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71FA0C4CEFE;
	Mon, 13 Oct 2025 15:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369312;
	bh=ZCgU8y5I1uEFg7r3dLWr5yhA11DGxcZw0i5WpFa7Qx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hhVmI0YWIMC0Jm7f1C9SsQhCRl6bdtnPZ6OEZOdP0CRFuzLhK6wyfvcoMxt3gCmht
	 DJwvIIMFRz1biuKucTy6nlAO5N3ERyH1WQFgqMYxMtajYj9A5Bfkac6YsxLhCT4IQW
	 7uTXUoTGZM0TV3tObtLm4TrTKFkg7IbSDAMHrCXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 169/563] block: fix stacking of atomic writes when atomics are not supported
Date: Mon, 13 Oct 2025 16:40:30 +0200
Message-ID: <20251013144417.412148404@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit f2d8c5a2f79c28569edf4948b611052253b5e99a ]

Atomic writes support may not always be possible when stacking devices
which support atomic writes. Such as case is a different atomic write
boundary between stacked devices (which is not supported).

In the case that atomic writes cannot supported, the top device queue HW
limits are set to 0.

However, in blk_stack_atomic_writes_limits(), we detect that we are
stacking the first bottom device by checking the top device
atomic_write_hw_max value == 0. This get confused with the case of atomic
writes not supported, above.

Make the distinction between stacking the first bottom device and no
atomics supported by initializing stacked device atomic_write_hw_max =
UINT_MAX and checking that for stacking the first bottom device.

Fixes: d7f36dc446e8 ("block: Support atomic writes limits for stacked devices")
Signed-off-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-settings.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 6760dbf130b24..8fa52914e16b0 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -56,6 +56,7 @@ void blk_set_stacking_limits(struct queue_limits *lim)
 	lim->max_user_wzeroes_unmap_sectors = UINT_MAX;
 	lim->max_hw_zone_append_sectors = UINT_MAX;
 	lim->max_user_discard_sectors = UINT_MAX;
+	lim->atomic_write_hw_max = UINT_MAX;
 }
 EXPORT_SYMBOL(blk_set_stacking_limits);
 
@@ -232,6 +233,10 @@ static void blk_validate_atomic_write_limits(struct queue_limits *lim)
 	if (!(lim->features & BLK_FEAT_ATOMIC_WRITES))
 		goto unsupported;
 
+	/* UINT_MAX indicates stacked limits in initial state */
+	if (lim->atomic_write_hw_max == UINT_MAX)
+		goto unsupported;
+
 	if (!lim->atomic_write_hw_max)
 		goto unsupported;
 
@@ -723,18 +728,14 @@ static void blk_stack_atomic_writes_limits(struct queue_limits *t,
 	if (!blk_atomic_write_start_sect_aligned(start, b))
 		goto unsupported;
 
-	/*
-	 * If atomic_write_hw_max is set, we have already stacked 1x bottom
-	 * device, so check for compliance.
-	 */
-	if (t->atomic_write_hw_max) {
+	/* UINT_MAX indicates no stacking of bottom devices yet */
+	if (t->atomic_write_hw_max == UINT_MAX) {
+		if (!blk_stack_atomic_writes_head(t, b))
+			goto unsupported;
+	} else {
 		if (!blk_stack_atomic_writes_tail(t, b))
 			goto unsupported;
-		return;
 	}
-
-	if (!blk_stack_atomic_writes_head(t, b))
-		goto unsupported;
 	blk_stack_atomic_writes_chunk_sectors(t);
 	return;
 
-- 
2.51.0



