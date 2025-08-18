Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849DC27B355;
	Mon, 18 Aug 2025 12:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521531; cv=none; b=eLnq5UgxFZqLvJHQ9ntd8EiA2pI0UH1twPnNSsWq8f6if43UU2g4fPtWcq2yabblOHYzdVehAhsAuYifhe892npyzEeJwR9UJPpGrZeNYRh/+b4UjD1XNENqudJJFjj94NfN/jPtTjkJZXUlEwgswXWupGanzhMDPR+kA5gZay8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521531; c=relaxed/simple;
	bh=F88NuG8S433JEuPHnNReLjND2MqL2YyfFtXuHmSNx6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=udpsvOMF7qTkAS+dRlHO9AGSM1L0ovw1Tz0y7eiILXWM06uiIEM0gcCq0akoEAI03JRLN0C/yrfug8tZMYoDPKvwd1TIQdSW65Vo09BQz02nWwWXiYNexIf9YFXIk8Z8BBoK+1sVavxaSlCdBz5ftKxNur1HrYXH6z7vNdptLLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nW8rCj/+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nW8rCj/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDEA9C4CEEB;
	Mon, 18 Aug 2025 12:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521531;
	bh=F88NuG8S433JEuPHnNReLjND2MqL2YyfFtXuHmSNx6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nW8rCj/+LcaYpDwIU61bummqwAf0mfahNQ5umYuYwICRQTHqrJWbIwbpp+f19iSRK
	 4ycCTl00c4yzKcVBTHe0mbuQ6Fvr8bafZN+4Oy3KZsTJJV1p+WRIgLuXssiQ+gAWXP
	 Y9zK0tK6tftB39l1Y6ccShaIzwSPav4WAFGqhwTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 041/444] block: Make REQ_OP_ZONE_FINISH a write operation
Date: Mon, 18 Aug 2025 14:41:07 +0200
Message-ID: <20250818124450.476876628@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit 3f66ccbaaef3a0c5bd844eab04e3207b4061c546 upstream.

REQ_OP_ZONE_FINISH is defined as "12", which makes
op_is_write(REQ_OP_ZONE_FINISH) return false, despite the fact that a
zone finish operation is an operation that modifies a zone (transition
it to full) and so should be considered as a write operation (albeit
one that does not transfer any data to the device).

Fix this by redefining REQ_OP_ZONE_FINISH to be an odd number (13), and
redefine REQ_OP_ZONE_RESET and REQ_OP_ZONE_RESET_ALL using sequential
odd numbers from that new value.

Fixes: 6c1b1da58f8c ("block: add zone open, close and finish operations")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20250625093327.548866-2-dlemoal@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/blk_types.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -342,11 +342,11 @@ enum req_op {
 	/* Close a zone */
 	REQ_OP_ZONE_CLOSE	= (__force blk_opf_t)11,
 	/* Transition a zone to full */
-	REQ_OP_ZONE_FINISH	= (__force blk_opf_t)12,
+	REQ_OP_ZONE_FINISH	= (__force blk_opf_t)13,
 	/* reset a zone write pointer */
-	REQ_OP_ZONE_RESET	= (__force blk_opf_t)13,
+	REQ_OP_ZONE_RESET	= (__force blk_opf_t)15,
 	/* reset all the zone present on the device */
-	REQ_OP_ZONE_RESET_ALL	= (__force blk_opf_t)15,
+	REQ_OP_ZONE_RESET_ALL	= (__force blk_opf_t)17,
 
 	/* Driver private requests */
 	REQ_OP_DRV_IN		= (__force blk_opf_t)34,


