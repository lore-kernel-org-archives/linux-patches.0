Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CA559B5E;
	Tue, 23 Jan 2024 00:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970303; cv=none; b=ePalyYPOnhBeEZEAOak0FzuPOjJP35u4gTuDDfer+TwMDUeaavmwjMl0q2cGqSeEOd8Y/KSiQV2GXxIVsCmR+OV1HGelEjbYBB17gAmU1gupvAE8/mZG/4BlgeJ0ZK45FjevEf+riHsJyAlxgyxmPLMcWM03V0OS7k2q9sqy/0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970303; c=relaxed/simple;
	bh=fJc3hrYKJWSCW6l+QvRs2RJpWpsoYOOo+x31fcGCum4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tSbnCxgdz9KI8BXPRIWPPvpkhpgyvhMwmb5C5ekUU5ttwnoAL3G1d4nZ2PiQpAq5aUoNZ3SLhRbIfU6xciWNLvjAuArX2iW7wO1lWVpozH7LCxOuEyw2eux5t1+lh8WQiebVv3YsRK6gucEHAy8WSdixNIB2JJMAjk7W9o3x400=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZDD5S4NS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZDD5S4NS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0328C433C7;
	Tue, 23 Jan 2024 00:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970303;
	bh=fJc3hrYKJWSCW6l+QvRs2RJpWpsoYOOo+x31fcGCum4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZDD5S4NSS0tJIskML9RNYAu/82Gy/KfclUO6t2X/Ei6uSD+MpI+cqou895kpuvvmF
	 anRIZXIqF4SUv5Rx3R9p+or9eGXx4qSmC21pSDA6nr9ZeeOf9iAeKlo7S3SWYNpPrq
	 LA3laX9BNwo61WE2Aa6YLCYXv6ICmkivyHObhAaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 629/641] io_uring: adjust defer tw counting
Date: Mon, 22 Jan 2024 15:58:53 -0800
Message-ID: <20240122235837.947314350@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit dc12d1799ce710fd90abbe0ced71e7e1ae0894fc ]

The UINT_MAX work item counting bias in io_req_local_work_add() in case
of !IOU_F_TWQ_LAZY_WAKE works in a sense that we will not miss a wake up,
however it's still eerie. In particular, if we add a lazy work item
after a non-lazy one, we'll increment it and get nr_tw==0, and
subsequent adds may try to unnecessarily wake up the task, which is
though not so likely to happen in real workloads.

Half the bias, it's still large enough to be larger than any valid
->cq_wait_nr, which is limited by IORING_MAX_CQ_ENTRIES, but further
have a good enough of space before it overflows.

Fixes: 8751d15426a31 ("io_uring: reduce scheduling due to tw")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/108b971e958deaf7048342930c341ba90f75d806.1705438669.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 7f62f5990152..59f5791c90c3 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1346,7 +1346,7 @@ static inline void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 		nr_tw = nr_tw_prev + 1;
 		/* Large enough to fail the nr_wait comparison below */
 		if (!(flags & IOU_F_TWQ_LAZY_WAKE))
-			nr_tw = -1U;
+			nr_tw = INT_MAX;
 
 		req->nr_tw = nr_tw;
 		req->io_task_work.node.next = first;
-- 
2.43.0



