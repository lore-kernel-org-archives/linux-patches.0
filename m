Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D5E35207E;
	Tue, 26 Aug 2025 13:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216745; cv=none; b=SWZrDCMwI63oR2a7rcaGPVZqUG00F2DyhlXgVTkzD8O35CqqNnigTytiF3ajLKUXQ3qZAxKg0jz2M/NIq6uFeWetwH3rYuITXnZEVPJbki1+zcy3W7IIX5CH14FAAKANwlyfZdJyff8UABFW7DozjCWIM8Rha4eOLE3XXfi1wUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216745; c=relaxed/simple;
	bh=35g0kmVNhCtnmTD50ewyr74OeeSd8LCqplQNxZho1ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jTm/2jGj3aOqb18+PD4shtXm19ZQcs2HVSbTfLAkpZO5Qe545o/i7/iSEAWB6/KCnBOtY5vMswcm+GadJrtjL/kVsJzGkZ28wpcX9mD8S+beedeWZdV3ezngwz6AOFsGUiHOv2xZ4x8XFKfNX9jPd9am+WccUuIFowU9h1RYSuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xhAfPgvh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xhAfPgvh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A06C4CEF1;
	Tue, 26 Aug 2025 13:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216745;
	bh=35g0kmVNhCtnmTD50ewyr74OeeSd8LCqplQNxZho1ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xhAfPgvhM0TR7ILhguga1XsSVwgKawqHmQ0pby/S9fW28Cy1sOi8DKR1njyyhAVCY
	 5ldFVXMrko1CTZYM+uOESg8T9kxfvrrv7S+1ob4zUwhZwxjgDCGAekLsWq4+5r5X9r
	 EWpAkxBVP+u9RTs2fBy9uY/eVIh33s+7XJzJCvmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 527/644] block: Make REQ_OP_ZONE_FINISH a write operation
Date: Tue, 26 Aug 2025 13:10:18 +0200
Message-ID: <20250826110959.570882329@linuxfoundation.org>
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

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit 3f66ccbaaef3a0c5bd844eab04e3207b4061c546 ]

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
[ More renumbering... ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/blk_types.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -341,13 +341,13 @@ enum req_opf {
 	/* Close a zone */
 	REQ_OP_ZONE_CLOSE	= 11,
 	/* Transition a zone to full */
-	REQ_OP_ZONE_FINISH	= 12,
+	REQ_OP_ZONE_FINISH	= 13,
 	/* write data at the current zone write pointer */
-	REQ_OP_ZONE_APPEND	= 13,
+	REQ_OP_ZONE_APPEND	= 15,
 	/* reset a zone write pointer */
-	REQ_OP_ZONE_RESET	= 15,
+	REQ_OP_ZONE_RESET	= 17,
 	/* reset all the zone present on the device */
-	REQ_OP_ZONE_RESET_ALL	= 17,
+	REQ_OP_ZONE_RESET_ALL	= 19,
 
 	/* Driver private requests */
 	REQ_OP_DRV_IN		= 34,


