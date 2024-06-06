Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7199319924D;
	Thu,  6 Jun 2024 14:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683201; cv=none; b=mZZx173YVDP/qFYHpgnY9aPyH+ZO35SGdSEHKFr4/cUOIvYnN8iNcatqhLmxBwrBLhjYKm4Lh2KaKwdF2y2KiLo+Rt8mFhwA4dE6JMdhLDP9uFz7UGhcNZPieilwioeHufNenKCnHeY9ghLurlvk9V70MTSfp1GKyA6iL4j0B0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683201; c=relaxed/simple;
	bh=eBv/S98k1PZRBjtl+N/CCSfW3ZG2ni716wjdu5IsGqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j29DxkWyGwAGNW4rLh99t2Q0FShalrTKYuuZ/TlWHqyqRBQm33egd5A6IPY4yMsbpzwQXBv2LgCqYP/o4YN8oz65X7n2cfGjwsUTGBscqoj+KQJVqtxemy8VKkwgX19YR5iUYgYkVfti5BxdHjGGYhKCAU+fCQDVTFqcMRl4skU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k0MX3crq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k0MX3crq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0A4C2BD10;
	Thu,  6 Jun 2024 14:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683201;
	bh=eBv/S98k1PZRBjtl+N/CCSfW3ZG2ni716wjdu5IsGqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k0MX3crq/InYUBiYEuP452IMyQiykXomRMxlRL0djgcaB/+eIzu2GYXRtBSrkQTXp
	 +5jQ9IEldIm14HwSYLXxMgmeSraB/I5ZAKlk8STTLVO9ZrK0qSIhRww1DckBtdsxKL
	 tGPxQYYWiRUA2lKZatm8h/Gff8hKJBfK1iwCC4XM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 079/473] io_uring: use the right type for work_llist empty check
Date: Thu,  6 Jun 2024 16:00:08 +0200
Message-ID: <20240606131702.525941056@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9e74f7968e059..0cafdefce02dc 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -275,7 +275,7 @@ static inline int io_run_task_work(void)
 
 static inline bool io_task_work_pending(struct io_ring_ctx *ctx)
 {
-	return task_work_pending(current) || !wq_list_empty(&ctx->work_llist);
+	return task_work_pending(current) || !llist_empty(&ctx->work_llist);
 }
 
 static inline int io_run_task_work_ctx(struct io_ring_ctx *ctx)
-- 
2.43.0



