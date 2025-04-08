Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403E82686AA;
	Tue,  8 Apr 2025 11:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110663; cv=none; b=L6vgfal4qoaWSEcINkql2b7z2qG8/oQajM+DaNXnEnsLekgT0X/3Fxo0bsX+yewwM6Oid1UaQijQ4rVkQ7K4AE38Rqk0Tnua5aBfjoYG/jlJhYWKLzEClShzBjBm1+g4fjRaRndn/HnMwCrRAmHexqEq3Q/VuWlv3Z3hQRGbXE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110663; c=relaxed/simple;
	bh=LGvFc35JLHbJoqSlVNcfNKnBLIXgydT16l1s6jr5zK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bx6MTrGelYdisHUbNlf2lMFCjHWm2GwP7GRi01ao3bd/KF/ezBWf16oobWhMIXJkwFCDDARWqaJKykl9Rhe6eLGCoYwFM07Ax0hDBdYv7vsb2urgQEbNBXaj5oel5kdd7Ga+wWF9zQcFZAWVXywn7WCebhPgKaix680fhriw7tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uTg6sYbY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uTg6sYbY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C110BC4CEE5;
	Tue,  8 Apr 2025 11:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110663;
	bh=LGvFc35JLHbJoqSlVNcfNKnBLIXgydT16l1s6jr5zK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uTg6sYbYUItpHiAxykBmCcO8ufjlZwAtfdsiSUIQiSRwp27tGm42zRfV8k5AUybvn
	 og8nhPtXwth5dU/zFRiG4+yu8lAS5XRkxPrpAkw/1tJc1W/ku5Gv2kIO0VsRVgk47t
	 /pFxpzp78Fg7EESFj6lV6XwXpVKQav4oTTP8EUFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	M Nikhil <nikh1092@linux.ibm.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 147/731] block: ensure correct integrity capability propagation in stacked devices
Date: Tue,  8 Apr 2025 12:40:44 +0200
Message-ID: <20250408104917.694431975@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anuj Gupta <anuj20.g@samsung.com>

[ Upstream commit 677e332e4885a17def5efa4788b6e725a737b63c ]

queue_limits_stack_integrity() incorrectly sets
BLK_INTEGRITY_DEVICE_CAPABLE for a DM device even when none of its
underlying devices support integrity. This happens because the flag is
inherited unconditionally. Ensure that integrity capabilities are
correctly propagated only when the underlying devices actually support
integrity.

Reported-by: M Nikhil <nikh1092@linux.ibm.com>
Link: https://lore.kernel.org/linux-block/f6130475-3ccd-45d2-abde-3ccceada0f0a@linux.ibm.com/
Fixes: c6e56cf6b2e7 ("block: move integrity information into queue_limits")
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20250305063033.1813-2-anuj20.g@samsung.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-settings.c | 50 +++++++++++++++++++-------------------------
 1 file changed, 21 insertions(+), 29 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index b9c6f0ec1c499..0b0641fa33c02 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -867,36 +867,28 @@ bool queue_limits_stack_integrity(struct queue_limits *t,
 	if (!IS_ENABLED(CONFIG_BLK_DEV_INTEGRITY))
 		return true;
 
-	if (!ti->tuple_size) {
-		/* inherit the settings from the first underlying device */
-		if (!(ti->flags & BLK_INTEGRITY_STACKED)) {
-			ti->flags = BLK_INTEGRITY_DEVICE_CAPABLE |
-				(bi->flags & BLK_INTEGRITY_REF_TAG);
-			ti->csum_type = bi->csum_type;
-			ti->tuple_size = bi->tuple_size;
-			ti->pi_offset = bi->pi_offset;
-			ti->interval_exp = bi->interval_exp;
-			ti->tag_size = bi->tag_size;
-			goto done;
-		}
-		if (!bi->tuple_size)
-			goto done;
+	if (ti->flags & BLK_INTEGRITY_STACKED) {
+		if (ti->tuple_size != bi->tuple_size)
+			goto incompatible;
+		if (ti->interval_exp != bi->interval_exp)
+			goto incompatible;
+		if (ti->tag_size != bi->tag_size)
+			goto incompatible;
+		if (ti->csum_type != bi->csum_type)
+			goto incompatible;
+		if ((ti->flags & BLK_INTEGRITY_REF_TAG) !=
+		    (bi->flags & BLK_INTEGRITY_REF_TAG))
+			goto incompatible;
+	} else {
+		ti->flags = BLK_INTEGRITY_STACKED;
+		ti->flags |= (bi->flags & BLK_INTEGRITY_DEVICE_CAPABLE) |
+			     (bi->flags & BLK_INTEGRITY_REF_TAG);
+		ti->csum_type = bi->csum_type;
+		ti->tuple_size = bi->tuple_size;
+		ti->pi_offset = bi->pi_offset;
+		ti->interval_exp = bi->interval_exp;
+		ti->tag_size = bi->tag_size;
 	}
-
-	if (ti->tuple_size != bi->tuple_size)
-		goto incompatible;
-	if (ti->interval_exp != bi->interval_exp)
-		goto incompatible;
-	if (ti->tag_size != bi->tag_size)
-		goto incompatible;
-	if (ti->csum_type != bi->csum_type)
-		goto incompatible;
-	if ((ti->flags & BLK_INTEGRITY_REF_TAG) !=
-	    (bi->flags & BLK_INTEGRITY_REF_TAG))
-		goto incompatible;
-
-done:
-	ti->flags |= BLK_INTEGRITY_STACKED;
 	return true;
 
 incompatible:
-- 
2.39.5



