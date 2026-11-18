Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026894;
	b=xZIgwv5KxMqvNcRKokgy00UOIiKi7EVDsxpJIOYNNUD3epL5D58JN+fIkDTmaL9GimJ2
	 Rn3zsrTkd02NBGBqDhgsT2CaSoqEitsENX1C1Uebjpu9ebuAuhZqxbbzpKFBkHO5AFU5J
	 fjmfTAiqDklvlggymarLEewHbhiyHGRZVj2b3UDuG8ju9GzA6YXGMtSBNa63ASGU6lwVg
	 tpXS3tQxkPYBwWIKUEfBxV0oWw2ZRzHjzzSbIN9SnjNe/VlhbPrnzc4Gx2GC+/3WUmaMm
	 ZwKCofkrqQQvioqsIWV0yYdkNhYrE/Zp8YO7UaFvM2rfYRTJkR3qfDKFbXDqgO3XUQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026894;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RxgqkUwO4YAYoLrnFjAFyNuvFfglHoYdkbLrbAyRPu0=;
	b=MxSWLUAzYGz9eiM3DPsl6nVU3dZPsCHqWwV9pJqBMDzbYy/SIoCkFi7kRt/ucHFqvg2T
	 ndrS4fE9T3kkNPONOyil4NoUo0qLyUGaQxoJkbj8ZMxFELsWTuXt994WMl9ShaWNIKaWn
	 dmrTqiEJqB/4PsNAhQBLNz2v79Nc0VoPZbLZFoYkhD/+QGVVuR5yBUXu+k3TdOw/PSxGB
	 abDk+tQ5YXjMYwRBauSLwgHUm+XS4JvWboTqy+GN1EIUq6+zDEbGR5UKRDl1KQ1Bt6bGi
	 QZqubQiCVDCys5rXzPYVWZnjsNeDjfjexYHYtJdGb3eFwyHVwi51atz+QMAtsfFhl9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J+BPplZQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53412606A320;
	Wed, 18 Nov 2026 18:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J+BPplZQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CEA11F000C4;
	Wed, 18 Nov 2026 18:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026893;
	bh=RxgqkUwO4YAYoLrnFjAFyNuvFfglHoYdkbLrbAyRPu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J+BPplZQx7kabIC8gd5fEQ39b3BZ5+SJcIzT1KnHGc0ca8a2LEz9gkuQfTHMP4Vta
	 EhvgwdRj4BcdPLZ89ueVglPzXEWFjii8GHrrOTF6yiSJB/w+7qbs+oGOQ8aBeDTBq7
	 IiYUbm25StgnWKYQaxtRJP+YqF6GYyYMJ4ApEjMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Sun <sunjunchao@bytedance.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1595/2151] block: reject NOWAIT buffered write fallback
Date: Wed, 18 Nov 2026 15:55:30 +0100
Message-ID: <20261118150219.983532804@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 17cdecf39398c..c7cd9f89c352c 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -757,6 +757,10 @@ blkdev_direct_write(struct kiocb *iocb, struct iov_iter *from)
 
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



