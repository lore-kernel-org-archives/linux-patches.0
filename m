Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491412940B;
	Mon, 23 Jun 2025 22:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716603; cv=none; b=tNQW/tuSSPFZ0GqKr1BTjyk28jkFwc8/zov8rKY+ANfuARDomzSRdKyivEAKw70wySKzkLxHuZ2SH4uypYmrC/Qd5fH8bmWD1pEQbS4au5DchjddVXHERWQt6eB9imw3KYwkZNHCaQfsAOsLc4JXjIPxK3I4CxzrTDDRS4dS7Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716603; c=relaxed/simple;
	bh=Tnx3LreYGabuf1Gih05XkvV3fJXvoYqJIDEUKadD9Uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KP3UezWirywzQGwDdLq1kuLxrfl8ITqpmVR37NP3T2hwLvGXKfE/bYniN9vLz6heMJWrv6sbIwj/BnRrUYrNYNmKXtcf9olokoX2r8DOg6KDsMmKTimKNHaX+GQzFd62Ivd8ABtSZ0OKADsR6ER1/rLXZbSiCe6+0thkhOSRXXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M+etyPjw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M+etyPjw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17DBC4CEEA;
	Mon, 23 Jun 2025 22:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716603;
	bh=Tnx3LreYGabuf1Gih05XkvV3fJXvoYqJIDEUKadD9Uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M+etyPjwUQWtxH9g9f1ajpzqxBAP+wHDJhYNsy6CM/EUCNyOI8WoJKg2YEZchXA5J
	 R4L4pJH//lezlCe45CSeMaZiqlNVZDEFU1iX4L8AOk/2d7z32syF9n6sW6ZarTNE1P
	 kkPvDPnzwfJU3M4h858U4DJ1mR9HmRMa9YHtkHsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Penglei Jiang <superman.xpt@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 541/592] io_uring: fix potential page leak in io_sqe_buffer_register()
Date: Mon, 23 Jun 2025 15:08:19 +0200
Message-ID: <20250623130713.308619580@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Penglei Jiang <superman.xpt@gmail.com>

[ Upstream commit e1c75831f682eef0f68b35723437146ed86070b1 ]

If allocation of the 'imu' fails, then the existing pages aren't
unpinned in the error path. This is mostly a theoretical issue,
requiring fault injection to hit.

Move unpin_user_pages() to unified error handling to fix the page leak
issue.

Fixes: d8c2237d0aa9 ("io_uring: add io_pin_pages() helper")
Signed-off-by: Penglei Jiang <superman.xpt@gmail.com>
Link: https://lore.kernel.org/r/20250617165644.79165-1-superman.xpt@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/rsrc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 91c5cb2e1f066..794d4ae6f0bc8 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -810,10 +810,8 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 
 	imu->nr_bvecs = nr_pages;
 	ret = io_buffer_account_pin(ctx, pages, nr_pages, imu, last_hpage);
-	if (ret) {
-		unpin_user_pages(pages, nr_pages);
+	if (ret)
 		goto done;
-	}
 
 	size = iov->iov_len;
 	/* store original address for later verification */
@@ -843,6 +841,8 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	if (ret) {
 		if (imu)
 			io_free_imu(ctx, imu);
+		if (pages)
+			unpin_user_pages(pages, nr_pages);
 		io_cache_free(&ctx->node_cache, node);
 		node = ERR_PTR(ret);
 	}
-- 
2.39.5



