Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020450;
	b=DMgBoRutzZo3DsgK/HLn05qtj8Y3AiYMIXF96DAyQdhlRgCOOaUBwyTgkY0FGDe37FV7
	 phBbJdJjLqNIhfJeCDlwXbH+4/gkyCy0oXyv3nQAGjaRjELYjPyVlO95ExNGAaVbvneKV
	 o6bBvkBYcbVisdlA0VcALT7p87EyQRbj4k+nL7bszqbu3e34Z6AbQ4fVrOOLrI2cv3IXN
	 awgOUwe/CaV4WkFH01isX4eopKPZzMa6dlrsqLosZk3Sy5cQFq3ldlQCtTdwy5YIplzxm
	 zqlywSbhQHnlX2B0mQleXzXmcDQDU3QRBuVDw9U4GscImJ2E5oGjsHNG2nI82V9TGWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020450;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/lZ37cEd+3P+7DnQ/EhiKUrkSJ1eNJNKx6zL5ThWEgw=;
	b=j6NtvX4YGcrI32cPbvxS3KPVLzu6YvaUk63zY1ykZ9dLTlOWpyU3mNB0aXaF+IXQH+f1
	 GScJ2TYnN5aUy6AYi5MHwRB7lcyNCHDDAD2o2vaJvr4K2vk1hT7v9SDXGG1osOCTh4aN/
	 veU0xl1K1blPn+Vsil+Q5m782XEFMd2IBXhqeaKzQcCZoY/E32WbWG9ux4zC48dwgjabK
	 Tbql3TNWh8Q9dmPlB5zLJ/1WXmbZm5X9XXsD9Cw7Wvegw8Yw71bdgoQM4xbHVC8AMJi+Q
	 LhF5AwVVZR8aD8KGetXLc/mQbbEcJaA5ABPgHCG2H5tXGWrrKDvL6wugG7jbFOAd8vQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jeparzKk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CD6606A31C;
	Wed, 18 Nov 2026 16:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jeparzKk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC29B1F000C4;
	Wed, 18 Nov 2026 16:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020450;
	bh=/lZ37cEd+3P+7DnQ/EhiKUrkSJ1eNJNKx6zL5ThWEgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jeparzKkOhBd0539XBX4pa75LCiO0Hk6Af/keF2xlWIlC1x9dZwoz//Dxb80emVRB
	 1cWijcsuFdU7K8EfEt8h1S7KcRdExAOBYQY1UfRK06ZbX79KOrenlIsN7lSOX9EHej
	 owjpH6tBp5mX81x21zyQAcAcodmLiqLVuyOtrPX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Sun <sunjunchao@bytedance.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1955/2651] block: reject NOWAIT buffered write fallback
Date: Wed, 18 Nov 2026 15:53:15 +0100
Message-ID: <20261118150356.933531719@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Sun <sunjunchao@bytedance.com>

[ Upstream commit a08bf4b9f87898628e70882430b8dd4260730dba ]

blkdev_write_iter() rejects NOWAIT buffered writes, but does not
enforce this restriction when direct I/O falls back to buffered I/O.
Successful fallback waits for writeback, violating NOWAIT semantics.

Reject NOWAIT requests in blkdev_buffered_write() with -EAGAIN.

Fixes: c35fc7a5abae ("block_dev: support RFW_NOWAIT on block device nodes")
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
Link: https://patch.msgid.link/20261015091105.1315605-2-sunjunchao@bytedance.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/fops.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/block/fops.c b/block/fops.c
index 562cc52af5aa2..d2e38951bab81 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -729,6 +729,10 @@ blkdev_direct_write(struct kiocb *iocb, struct iov_iter *from)
 
 static ssize_t blkdev_buffered_write(struct kiocb *iocb, struct iov_iter *from)
 {
+	/* Buffered fallback waits for writeback, which NOWAIT cannot allow. */
+	if (iocb->ki_flags & IOCB_NOWAIT)
+		return -EAGAIN;
+
 	return iomap_file_buffered_write(iocb, from, &blkdev_iomap_ops, NULL,
 			NULL);
 }
-- 
2.53.0



