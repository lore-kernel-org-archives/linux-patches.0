Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A152155A4E;
	Tue, 29 Apr 2025 18:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950718; cv=none; b=Xh0eNx2mzhgDh0Jiws3i3poh2pYL5/ibWFoEmN1yutl/9L7S3w8oTvi4Z13VY1I63uKcJby5D/uAaB29IiumbjbTNEZhhP+KcpIFk+IDewip9S9DORR5elfuFEpwRQ+XrxcOAdQyI0iHwSjycz4cChP53lyg1uBJid4Aa0/YiuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950718; c=relaxed/simple;
	bh=jQ0w0N8jvj+nshmZWw2Wyj2eEVtqSkW2iWrIdtPYOY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kpOL11k+pxcQI+zM1pxzWFji7r2f3K2SZi1EUdAiYDQb1gnY3oPCXzUJkrlbqqZZjlzPv7CxfTGIUEu5tyfuQ7wmq+nQsqyLA4j0IyubK5RsjL4l2AuMN/vvb5UiHMBk6tso92HEvxmq4NImwLC9wTM0+9/HemX2rY9w1S81DU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0zq5uNqT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0zq5uNqT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D537AC4CEE3;
	Tue, 29 Apr 2025 18:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950718;
	bh=jQ0w0N8jvj+nshmZWw2Wyj2eEVtqSkW2iWrIdtPYOY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0zq5uNqTiIeXTKd0ikaqOGtKZLlLGyk6gCQEvCsOcHU9i1ZRMkNk8Q6PHGXHipHiW
	 j0tkLPdbk9lUlPPRY/pXaym+PZ1COjtnV5KQoAHv094zs6RnNSkI8DBgxe++Ueth4m
	 B2fDq2IYbmPgPL/P0XhiV3px49cFXoRIzFHYEXLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunlong Xing <yunlong.xing@unisoc.com>,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 182/204] loop: aio inherit the ioprio of original request
Date: Tue, 29 Apr 2025 18:44:30 +0200
Message-ID: <20250429161106.838821747@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunlong Xing <yunlong.xing@unisoc.com>

[ Upstream commit 1fdb8188c3d505452b40cdb365b1bb32be533a8e ]

Set cmd->iocb.ki_ioprio to the ioprio of loop device's request.
The purpose is to inherit the original request ioprio in the aio
flow.

Signed-off-by: Yunlong Xing <yunlong.xing@unisoc.com>
Signed-off-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20250414030159.501180-1-yunlong.xing@unisoc.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 8a6c1146df00f..455e2a2b149f4 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -441,7 +441,7 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
 	cmd->iocb.ki_filp = file;
 	cmd->iocb.ki_complete = lo_rw_aio_complete;
 	cmd->iocb.ki_flags = IOCB_DIRECT;
-	cmd->iocb.ki_ioprio = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_NONE, 0);
+	cmd->iocb.ki_ioprio = req_get_ioprio(rq);
 
 	if (rw == ITER_SOURCE)
 		ret = call_write_iter(file, &cmd->iocb, &iter);
-- 
2.39.5



