Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9DD15FCF2;
	Mon, 27 May 2024 19:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836511; cv=none; b=JzcnPq0bzcezMvN/5o3IdRAG5LEearPc39aSYplACZ5Vz7dihAghcrxGChbb0ykQZvFaorb4qNatpk0AaVQODSXYKEWhdvESOsxB2kKgwB//V96DiFyC96BOS0MFAirNvSx1KMryOHGxVjN5EYz9kLZxJ0MGnkG7mhtPOLeBlTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836511; c=relaxed/simple;
	bh=xV7p5AO1VFiv8hWcRNQyfBc+K5ZGqcRkt6+qc2K+7P8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RVFjLQ7DGl7aFl/9dx9u/vRRTXIpTJEh/V7QkcA4EkY9iEX7CtavJAr6On5lx4Gh+B0iPGt+KnWi8qqQtPEH7cp5aK+P+QqHvJAvFErHdI5HeNRnoyKcU1TvMXYhTjE3pkUumHiYD2GHuC9B5FZB4u0KVlwCH6bmNWHWMZzZp+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JbhnXiTU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JbhnXiTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B27C2BBFC;
	Mon, 27 May 2024 19:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836510;
	bh=xV7p5AO1VFiv8hWcRNQyfBc+K5ZGqcRkt6+qc2K+7P8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JbhnXiTUn+YIlQq+8i3pPiOgN8Cwu1QqBlUhxgxA5qhyNN43kqYDvY7ZEmWxRLlRH
	 hm7GKlLd7WJ90UtBrUjRZESElcRw/JOQGGXh3IY3xFiTOMFpFSKitLhY7dXPbHJgfd
	 PL7Ku3t+wHUQdIjF+R44iLt+yc4XSz+/LgI6WBvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 081/427] io_uring/net: fix sendzc lazy wake polling
Date: Mon, 27 May 2024 20:52:08 +0200
Message-ID: <20240527185609.289497264@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit ef42b85a5609cd822ca0a68dd2bef2b12b5d1ca3 ]

SEND[MSG]_ZC produces multiple CQEs via notifications, LAZY_WAKE doesn't
handle it and so disable LAZY_WAKE for sendzc polling. It should be
fine, sends are not likely to be polled in the first place.

Fixes: 6ce4a93dbb5b ("io_uring/poll: use IOU_F_TWQ_LAZY_WAKE for wakeups")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/5b360fb352d91e3aec751d75c87dfb4753a084ee.1714488419.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/net.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/net.c b/io_uring/net.c
index 4afb475d41974..3896e6220d0bf 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1041,6 +1041,7 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	struct io_kiocb *notif;
 
 	zc->done_io = 0;
+	req->flags |= REQ_F_POLL_NO_LAZY;
 
 	if (unlikely(READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3)))
 		return -EINVAL;
-- 
2.43.0



