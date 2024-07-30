Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52EC29A2;
	Tue, 30 Jul 2024 15:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354901; cv=none; b=c1nsEyvLKUZD7vc4UaCXcwlV6pen7eGvfOpDSSiJ3zbFliU/JbGN1EHDV+qjAXVxh3HxK8U8/c8h58OiiEHoS9j9igE1wTx29BWGs8tVGJ9IjQMfJTGtXQxLE6hy5Il54qSIvWQQ7//xY7ewh0PuAAfO4Zs8XQskgWs0I/yrDko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354901; c=relaxed/simple;
	bh=IPc1aFxvwQOGSSFplTEPei2FKK3k6S2+vKVQRuOfFUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=igkxgRZtM8FR+qowQgruLQbMyuEkoEcxIC0gO6KPpX5RkGfEs6AgM+W5OIwZCBCrzX+/IIXJh4nyHZpgunSDCJQE3W6GpyN4dERU3bOw8if/aSSJbzWXMvVQC/H4n/PeIiXSt6cBQ6Cwtg9ZWk5Pl2/UPalkp1iKedYgB2C9hW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ig5RPeb2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ig5RPeb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291DAC32782;
	Tue, 30 Jul 2024 15:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354901;
	bh=IPc1aFxvwQOGSSFplTEPei2FKK3k6S2+vKVQRuOfFUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ig5RPeb2AShCDpwT9+8CmdiX05DyT7AM9uS8y/TNapUdfL/AxS5p81h1OFN57UxaB
	 E7hu0/5HHXX4i5NsQt3GGNhZMIlWearPiue2kFnithxS6PzkcpGY2hdgCvIWEh0Zlv
	 51rU75BywUG9BJrUe6mDd5LuVgtHBXRliDjZganY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 008/568] ubd: untagle discard vs write zeroes not support handling
Date: Tue, 30 Jul 2024 17:41:55 +0200
Message-ID: <20240730151640.143254305@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 31ade7d4fdcf382beb8cb229a1f5d77e0f239672 ]

Discard and Write Zeroes are different operation and implemented
by different fallocate opcodes for ubd.  If one fails the other one
can work and vice versa.

Split the code to disable the operations in ubd_handler to only
disable the operation that actually failed.

Fixes: 50109b5a03b4 ("um: Add support for DISCARD in the UBD Driver")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Acked-By: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Link: https://lore.kernel.org/r/20240531074837.1648501-3-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/ubd_kern.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 73354782f5871..ef7b4b911a455 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -458,10 +458,11 @@ static int bulk_req_safe_read(
 
 static void ubd_end_request(struct io_thread_req *io_req)
 {
-	if (io_req->error == BLK_STS_NOTSUPP &&
-	    req_op(io_req->req) == REQ_OP_DISCARD) {
-		blk_queue_max_discard_sectors(io_req->req->q, 0);
-		blk_queue_max_write_zeroes_sectors(io_req->req->q, 0);
+	if (io_req->error == BLK_STS_NOTSUPP) {
+		if (req_op(io_req->req) == REQ_OP_DISCARD)
+			blk_queue_max_discard_sectors(io_req->req->q, 0);
+		else if (req_op(io_req->req) == REQ_OP_WRITE_ZEROES)
+			blk_queue_max_write_zeroes_sectors(io_req->req->q, 0);
 	}
 	blk_mq_end_request(io_req->req, io_req->error);
 	kfree(io_req);
-- 
2.43.0



