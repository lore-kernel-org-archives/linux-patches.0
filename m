Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F66235208F;
	Tue, 26 Aug 2025 14:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218209; cv=none; b=X0lLYV+G+NEe6X0ovWga79utOacTbEYGidv5nz72CJB29elAG1KwFw5hmiXfP+fFmgUkfbxUsanT28WOdHF+V3hOyD1ZwL+cQ4v7tgGzDVE12tzWJ3zW4g5NWOZKyXBiTyudQXyJa2SFAY4bg0nOgnClC1hnVQAthVlNJ0Qgwck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218209; c=relaxed/simple;
	bh=Y9kt6WWTPQ9mrgrTEYBiQLTaxrc9ypqr40M1EO4fwzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=urGXWbVPlc+eFgqZnEzqk8nC8lMu2mVTeCffYi03TDekFcVbYmyg4d5fqAjYzx/j9MsosqXNUr2n8dWAKZ9y8wc1x5dWN7Jm0MG3hcvSaZ3pWPec62kuTU66dCmMrwwLcsz+QLsBnHj/f/tvLM0akGB+DpXxY1egt/b1WciuvVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=agH5DNYw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="agH5DNYw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 924E5C4CEF1;
	Tue, 26 Aug 2025 14:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218208;
	bh=Y9kt6WWTPQ9mrgrTEYBiQLTaxrc9ypqr40M1EO4fwzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=agH5DNYwAyLLzM7OUOaE5mO4nooTTjoEVgaM/iOGdEJWZcczKAZty8gmzqfiyr+3b
	 y+pPhJNCFnajuLCVWCOswuts2pygEE/wVMCNxLdnngqQw4NfKeO9oZXMUHw9XxRl0v
	 hBqIX9k/Se9DOxKbHDO87C/AFgACsHlLU3N8IKSo=
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
Subject: [PATCH 5.10 433/523] block: Make REQ_OP_ZONE_FINISH a write operation
Date: Tue, 26 Aug 2025 13:10:43 +0200
Message-ID: <20250826110935.137056833@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ Extra renames ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/blk_types.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -353,13 +353,13 @@ enum req_opf {
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
 
 	/* SCSI passthrough using struct scsi_request */
 	REQ_OP_SCSI_IN		= 32,


