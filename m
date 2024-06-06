Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D621A0B04;
	Thu,  6 Jun 2024 14:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683161; cv=none; b=JmiIdsrsGD2xxbjOn+DzpgrxM5h0wTapcLTp9FD7gwAU4NI9t8J+4DB1JBNNCpS7Y25AWCc4sCuzqnzLKk2Xi+hPRmPZGvaPoVaG86JCb+rT8r35nrf79cM6sA6+yw3G3vieX5ga8XY7iNOsqj45SuuhESDNDg8M2B2w1CoV7cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683161; c=relaxed/simple;
	bh=J4HJtHV5bbQcAFXoblcyKqutTr7QGyekM2oIAijciOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WlHOqjcv9lbm4Eu9LKG3rkob06hsj2vZbG1y/DBDaxx4W4xdAcB5qvnEe/F3/Y2oqJLsDqrmaheM/gs3fvFzNs9lHKyuqaIomkBu+iEmr7eiGY4A9BB2smEmqoZ/KB3KXqSTQfpZB7l0OS0hu6XyWT7lpXiAiMZ508esxGjMoxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MrtdQVVK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MrtdQVVK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C42C2BD10;
	Thu,  6 Jun 2024 14:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683160;
	bh=J4HJtHV5bbQcAFXoblcyKqutTr7QGyekM2oIAijciOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MrtdQVVKM+5v8Xu7UgCWys2r3jMq3HTRMNGAzt/6FCV/1Wc7p3BQi8e9EKakkzGce
	 EgyMutfsZexZenkpxTTy/iLtUM7AHBqNeAe9txAIDEGy49OcwTNGqSGVeca2dHdtVP
	 HRpScYPEBBVuMbkVQ48hGNFmaflAYVRgTs/vzd+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 105/744] io_uring: use the right type for work_llist empty check
Date: Thu,  6 Jun 2024 15:56:17 +0200
Message-ID: <20240606131735.756411901@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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
index 411c883b37a95..19ac1b2f1ea45 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -304,7 +304,7 @@ static inline int io_run_task_work(void)
 
 static inline bool io_task_work_pending(struct io_ring_ctx *ctx)
 {
-	return task_work_pending(current) || !wq_list_empty(&ctx->work_llist);
+	return task_work_pending(current) || !llist_empty(&ctx->work_llist);
 }
 
 static inline void io_tw_lock(struct io_ring_ctx *ctx, struct io_tw_state *ts)
-- 
2.43.0



