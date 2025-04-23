Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EA527FD74;
	Wed, 23 Apr 2025 14:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419731; cv=none; b=I+pG8rstBsSJxZibzoCtSYl8Fqzxn2xfbCDLSJjBXVKWtPdTpu1jR3SVlziaiKNc+0UfZwLylNTfndB2IIVUOXIVdcwRZv7R5skkCghN2r7VfwxSCBYEMY+bQgrrW7W0bGs+RoZvJB+ThnjBZlgWT9oxOBJIibO4sVrHN5HB+Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419731; c=relaxed/simple;
	bh=zJk3zfFZFgHgYox3hXEG/TrBg5n+G4UALaGecsMOL5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NmgdKTrEgf3zyGp1bbQ9Cj/3qgA1CVlfaLQxiOjyaG0Rq2pt70Jc8u2ylkvp85EguW2HL4Ivxe9TiL2iEWZkpha90b5zMEiXSoZQNHEAzgjC8aPEOMDsvVJfoNHo+iMmYAIvA5LRnoIFciik6Tx087LOGxKe/8Fu1w17qKW0Fv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FUeD9gG/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FUeD9gG/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32FC0C4CEE2;
	Wed, 23 Apr 2025 14:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419731;
	bh=zJk3zfFZFgHgYox3hXEG/TrBg5n+G4UALaGecsMOL5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FUeD9gG/inIOhufYKNPue+TOW1Xe2uM2Yh5vwIkprsxeRe/tQ5T6xvrRsqWyO1WxY
	 7i/oTlvC9X9UTYhWe2HExRYlnbZ5WwEfvqYsJt1C9HQf9GmQWRObVrFofUlCcqDijj
	 gdVNNWdiHur2AT74uPZbh7VR6DOHQ4BTpTHihw0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunlong Xing <yunlong.xing@unisoc.com>,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 052/223] loop: aio inherit the ioprio of original request
Date: Wed, 23 Apr 2025 16:42:04 +0200
Message-ID: <20250423142619.251816915@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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
Stable-dep-of: f2fed441c69b ("loop: stop using vfs_iter_{read,write} for buffered I/O")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 86cc3b19faae8..7e17d533227d2 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -462,7 +462,7 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
 	cmd->iocb.ki_filp = file;
 	cmd->iocb.ki_complete = lo_rw_aio_complete;
 	cmd->iocb.ki_flags = IOCB_DIRECT;
-	cmd->iocb.ki_ioprio = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_NONE, 0);
+	cmd->iocb.ki_ioprio = req_get_ioprio(rq);
 
 	if (rw == ITER_SOURCE)
 		ret = file->f_op->write_iter(&cmd->iocb, &iter);
-- 
2.39.5



