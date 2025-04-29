Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EAFA1A5BBB;
	Tue, 29 Apr 2025 18:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950062; cv=none; b=IPtLOgh/1OH6GuqOpCTD3hlblMXnK0Zp375GhRRjamrqR9V0oWrOMxFVup69gkW9hLU06/BOuGEJzpPDZ3NaVaImRv3HPH3CaPIsbQcnjIZZgFO21qV4jHu4+wv9TLzNhwIFDqc6shHEY4B03K797UEOFjd1gPfurjk65djtx7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950062; c=relaxed/simple;
	bh=nO3L2PydrM0enigGStsefidPSefGt6MY0Fwk4limnck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r7rAFQNuZvRJjNoalTwGnEKDG2IRyTcVXuiXkeIIlrDQQCifAgZKLUny60KFHTrdqUUQOaNrGqQ4Wi9YLQYII7RN/jCALGnBmcVDIgpO9TNRC2pD/ZSPFauKwgO87DjLNxB3kZBCCc+As4AsyCjnSUEAs1Perxxj68+D1NFvGhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qLD9cuGM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qLD9cuGM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DEF5C4CEE3;
	Tue, 29 Apr 2025 18:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950062;
	bh=nO3L2PydrM0enigGStsefidPSefGt6MY0Fwk4limnck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qLD9cuGMDd4y9Ep6wpJgY5Hja5//ufE+xvqhSwMI2UHvskEsHtPGzuWWdsXtz23zK
	 2sqalOiiA4ZuF7o0oZUgH2m0rdeG0mip+T1LTnDBY/obaelEvX0gRj2OsMUaIqbqhf
	 UZzgyV//beNTtITEd7uW+8js1Ae/LjxrpIwWZttU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunlong Xing <yunlong.xing@unisoc.com>,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 144/167] loop: aio inherit the ioprio of original request
Date: Tue, 29 Apr 2025 18:44:12 +0200
Message-ID: <20250429161057.555341330@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1c356bda9dfa8..e3e5d533a7eca 100644
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



