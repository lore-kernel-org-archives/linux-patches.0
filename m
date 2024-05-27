Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F63116078C;
	Mon, 27 May 2024 19:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836442; cv=none; b=lC0jH35PDoZqETkCF5inu5Bn/zOMqyrfbzL5V4LxIeodvPySpwHJuFk3N/bcXbDXeaHaaLfIzZXG56SKGQIptPSp8RJPpYKKsE86mLPwllNj18QztJMMiRANZYdQiRLbE4EUqtjhcj9pbYEh3BkiXJpxrQajuc51rv81ELfIc0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836442; c=relaxed/simple;
	bh=IfRLKi7J2CuTIR2PPHTo08EW+uS/S7RIQybqF/TFTRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ckTME+Ahl8hnypJwbk6qx4txRJTQNZdrugc8woMso6kt6cYxMIqmZ41qK1IX22/R0l6F6DX3ndTCMF8xcc/DZXK2wHEemr5R3VOlMwfRnFNSAHRAfMDmAZF39iQnCyZl5DDE2hGlgSwYaPXzePLaa80sFDW0CLfo9eqcM3tQRkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ftshduQW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ftshduQW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65ED7C2BBFC;
	Mon, 27 May 2024 19:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836441;
	bh=IfRLKi7J2CuTIR2PPHTo08EW+uS/S7RIQybqF/TFTRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ftshduQWME87Ctf+6NxAkooBdkljSpp1bKprbWasp6MBUyTl2mAgSvwaQOxs1U6vh
	 b6IDFFjpINeFD5n3nNKjsRM6vgRo5nKtPYTNaY9wZSrNxg7wn7VnIgzX212R4DAm4N
	 cs4oD0r33KO3irwNfZcvyr4qBc7jVLNE/t7NANZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 056/427] io_uring: use the right type for work_llist empty check
Date: Mon, 27 May 2024 20:51:43 +0200
Message-ID: <20240527185607.067331991@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 22537c9f79417fed70b352d54d01d2586fee9521 ]

io_task_work_pending() uses wq_list_empty() on ctx->work_llist, but it's
not an io_wq_work_list, it's a struct llist_head. They both have
->first as head-of-list, and it turns out the checks are identical. But
be proper and use the right helper.

Fixes: dac6a0eae793 ("io_uring: ensure iopoll runs local task work as well")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 6426ee382276b..03e52094630ac 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -340,7 +340,7 @@ static inline int io_run_task_work(void)
 
 static inline bool io_task_work_pending(struct io_ring_ctx *ctx)
 {
-	return task_work_pending(current) || !wq_list_empty(&ctx->work_llist);
+	return task_work_pending(current) || !llist_empty(&ctx->work_llist);
 }
 
 static inline void io_tw_lock(struct io_ring_ctx *ctx, struct io_tw_state *ts)
-- 
2.43.0



