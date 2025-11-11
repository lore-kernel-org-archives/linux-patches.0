Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4884086A;
	Tue, 11 Nov 2025 00:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822343; cv=none; b=oP99woe3Mj87pE78hLPGKeCBOhdmHI0PTSTbJmYWimh9obqVHkE2I6CQgPo75pI//hcYbJDTOSZMrUNfPlM4+dQQjjyMKIP68wnMHZ2YTBjOh+M7/orC1uB8FzKGg2/TOgEp4SFjB6Vgpy24WHIi5UhoHd/0ETf/9ryYB8dXU9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822343; c=relaxed/simple;
	bh=lPut8GiC2dJC0N0ZrDi+EJgpNEvkjWBiLOO9RyHOUxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FN89Kfj/eTWhuruRX2e1y8WpFapCUaLB4yaFUhkfV/n7N/PvkISOYK38r0tITnuLC6rvWcQOYuI/QGxI3t/HIfgOOsmqY2IinBbO8sPec0hBoUe9B7wTY5WVSzGl2ZZMuntSiRV/0oiQyKPBXcxGf28VgKywfcrt9ZGhacPduCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2OiNrGIW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2OiNrGIW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36924C19425;
	Tue, 11 Nov 2025 00:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822343;
	bh=lPut8GiC2dJC0N0ZrDi+EJgpNEvkjWBiLOO9RyHOUxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2OiNrGIW359ixT/QR5/BvRe1ofrEyVt0tQI6Tq66C496bg0zkqrddGdnf1VbJ0xLY
	 OrPFAJp7OM02Y2cEUXheWJgwRzOfeTtdOyDDEtcxM95hXylH+eewAVKhEI4tmNZCsp
	 tp1DL18biqPuZsenWK+B85YvArKpHx50rOeiZZ8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.17 089/849] block: make REQ_OP_ZONE_OPEN a write operation
Date: Tue, 11 Nov 2025 09:34:19 +0900
Message-ID: <20251111004538.567768853@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Damien Le Moal <dlemoal@kernel.org>

commit 19de03b312d69a7e9bacb51c806c6e3f4207376c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/blk_types.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -343,15 +343,15 @@ enum req_op {
 	/* write the zero filled sector many times */
 	REQ_OP_WRITE_ZEROES	= (__force blk_opf_t)9,
 	/* Open a zone */
-	REQ_OP_ZONE_OPEN	= (__force blk_opf_t)10,
+	REQ_OP_ZONE_OPEN	= (__force blk_opf_t)11,
 	/* Close a zone */
-	REQ_OP_ZONE_CLOSE	= (__force blk_opf_t)11,
+	REQ_OP_ZONE_CLOSE	= (__force blk_opf_t)13,
 	/* Transition a zone to full */
-	REQ_OP_ZONE_FINISH	= (__force blk_opf_t)13,
+	REQ_OP_ZONE_FINISH	= (__force blk_opf_t)15,
 	/* reset a zone write pointer */
-	REQ_OP_ZONE_RESET	= (__force blk_opf_t)15,
+	REQ_OP_ZONE_RESET	= (__force blk_opf_t)17,
 	/* reset all the zone present on the device */
-	REQ_OP_ZONE_RESET_ALL	= (__force blk_opf_t)17,
+	REQ_OP_ZONE_RESET_ALL	= (__force blk_opf_t)19,
 
 	/* Driver private requests */
 	REQ_OP_DRV_IN		= (__force blk_opf_t)34,


