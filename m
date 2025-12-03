Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9563343D92;
	Wed,  3 Dec 2025 15:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777484; cv=none; b=mTsfnCJyr1fZ4VdRW9Lav7+WIZQyVpbbkJsqW+IOzeeRRoYBJRW0d5aA+6hmyk7TKuFZnnw8Eg+yZqAqpvulxWp3a0PSuYsGOPNnkb5dFl7zmjBwqcdPAU4gkDNLH44C75CEqAS/iLHwzeZPdRFTsAcHkUeu891+kUrcR6F1n/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777484; c=relaxed/simple;
	bh=AgdfgVC5EyTFmkTmvug0pfLvQVygyDc/aJfxx9Q94Tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fTAeeceplAyFdkmw3n2dzJME8pFRYB9jI5wCTXqqo2QoAUG7DCdhAW3pI2azlQE22sUbSeGcln3iSU9qCpIgMu6hbD/sXYPWW8j3zvsGY1brPxcjNNG+w0YAyQfIEgFOjq680nnCJtRvpXuVD6wZ1ot1wMfBQpVTL+BH9VeJxqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gfKUxQdE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gfKUxQdE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11061C116C6;
	Wed,  3 Dec 2025 15:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777484;
	bh=AgdfgVC5EyTFmkTmvug0pfLvQVygyDc/aJfxx9Q94Tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gfKUxQdE4YN4cqlhyOBjkX27XxM5kgk2iu576KMHfL+n/ZCCGafeFtuvhbKLS/HdZ
	 gnO8aR4izAiB/7546zxg3oC+bmHizgbCXxhiLrju/AkoQ0BDCzDWqDlWD7PPo0Zd6C
	 9VkrIallbYPjORpJB1v5TZAxuUHItjzznS8I+8D8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 052/392] block: make REQ_OP_ZONE_OPEN a write operation
Date: Wed,  3 Dec 2025 16:23:22 +0100
Message-ID: <20251203152416.028550531@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit 19de03b312d69a7e9bacb51c806c6e3f4207376c ]

A REQ_OP_OPEN_ZONE request changes the condition of a sequential zone of
a zoned block device to the explicitly open condition
(BLK_ZONE_COND_EXP_OPEN). As such, it should be considered a write
operation.

Change this operation code to be an odd number to reflect this. The
following operation numbers are changed to keep the numbering compact.

No problems were reported without this change as this operation has no
data. However, this unifies the zone operation to reflect that they
modify the device state and also allows strengthening checks in the
block layer, e.g. checking if this operation is not issued against a
read-only device.

Fixes: 6c1b1da58f8c ("block: add zone open, close and finish operations")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ relocated REQ_OP_ZONE_APPEND from 15 to 21 to resolve numbering conflict ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/blk_types.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -337,17 +337,17 @@ enum req_opf {
 	/* write the zero filled sector many times */
 	REQ_OP_WRITE_ZEROES	= 9,
 	/* Open a zone */
-	REQ_OP_ZONE_OPEN	= 10,
+	REQ_OP_ZONE_OPEN	= 11,
 	/* Close a zone */
-	REQ_OP_ZONE_CLOSE	= 11,
+	REQ_OP_ZONE_CLOSE	= 13,
 	/* Transition a zone to full */
-	REQ_OP_ZONE_FINISH	= 13,
-	/* write data at the current zone write pointer */
-	REQ_OP_ZONE_APPEND	= 15,
+	REQ_OP_ZONE_FINISH	= 15,
 	/* reset a zone write pointer */
 	REQ_OP_ZONE_RESET	= 17,
 	/* reset all the zone present on the device */
 	REQ_OP_ZONE_RESET_ALL	= 19,
+	/* write data at the current zone write pointer */
+	REQ_OP_ZONE_APPEND	= 21,
 
 	/* Driver private requests */
 	REQ_OP_DRV_IN		= 34,


