Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2951934DB7B;
	Tue, 16 Dec 2025 11:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885593; cv=none; b=cAG7MKxrvyn2sOCGKGNvm51oa7HY7obRk17RurlVHuEknlr8KNVteWhs7Ocy68gt/4kAhfPUCDzIwK4THdf1EKH7MjzB+HpZOKZhgPZGXe2E/4WPSYTfB0SpnqwxfMl+8RSsHDQs3+ZGiR7EYlM0RBgYZGrwWWF1vhxzyufIrUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885593; c=relaxed/simple;
	bh=shfgDRtUhqX395Ebk31f9MXzG5gbzmupXoVRwWuTPOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CtzdS4RrlGxOV6W59YyE2GLAfORnbJDdxC/iQMaEEtB4JF1UtgpfSmOh2n5cGO8b0+aG3AS3PBJftUcrn1ACYbu5SfB/76tsUUNXngIiaEnrkNHH+Cv5C+gCX8hwbUwbPcuh02GFpDH6fdcFO84XSOW/rCFIbsOOnsSklYuE+g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RUx5hjDL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RUx5hjDL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CD21C4CEF1;
	Tue, 16 Dec 2025 11:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885593;
	bh=shfgDRtUhqX395Ebk31f9MXzG5gbzmupXoVRwWuTPOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RUx5hjDL6HO82IaGZJ7TkiqhVhNnQ2nzysnUGUmG4X6N3HG7Tr1oWPalBZpC0Ob52
	 Y69iUdXquVFfmTDeAlSEDc9De6myvzYZYW7FNuyTlygH5kszRHMHodtPQ+iA52zOjF
	 wbgMw0dc4KljGEQvJI0ZOiLrOB28HZ5P8vCdsujU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 186/507] io_uring: use WRITE_ONCE for user shared memory
Date: Tue, 16 Dec 2025 12:10:27 +0100
Message-ID: <20251216111352.252249804@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 93e197e524b14d185d011813b72773a1a49d932d ]

IORING_SETUP_NO_MMAP rings remain user accessible even before the ctx
setup is finalised, so use WRITE_ONCE consistently when initialising
rings.

Fixes: 03d89a2de25bb ("io_uring: support for user allocated memory for rings/sqes")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 93665cebe9bdd..44afe57cbd653 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3570,10 +3570,6 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 
 	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
 		ctx->sq_array = (u32 *)((char *)rings + sq_array_offset);
-	rings->sq_ring_mask = p->sq_entries - 1;
-	rings->cq_ring_mask = p->cq_entries - 1;
-	rings->sq_ring_entries = p->sq_entries;
-	rings->cq_ring_entries = p->cq_entries;
 
 	if (p->flags & IORING_SETUP_SQE128)
 		size = array_size(2 * sizeof(struct io_uring_sqe), p->sq_entries);
@@ -3596,6 +3592,12 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 		return ret;
 	}
 	ctx->sq_sqes = io_region_get_ptr(&ctx->sq_region);
+
+	memset(rings, 0, sizeof(*rings));
+	WRITE_ONCE(rings->sq_ring_mask, ctx->sq_entries - 1);
+	WRITE_ONCE(rings->cq_ring_mask, ctx->cq_entries - 1);
+	WRITE_ONCE(rings->sq_ring_entries, ctx->sq_entries);
+	WRITE_ONCE(rings->cq_ring_entries, ctx->cq_entries);
 	return 0;
 }
 
-- 
2.51.0



