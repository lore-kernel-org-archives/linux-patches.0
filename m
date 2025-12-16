Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B946736A032;
	Tue, 16 Dec 2025 12:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887410; cv=none; b=axOskbs6vGFPNEQloPFbtg/o39ThDXbutoVO8sp3mg+RLAfQhl5BoGQbQXjMrCNl0uDWpzpy9p2R+pvgrE833k/EAfv22YNj0iVghXGdXe3Cef8EaIHKiF3hau19zxANlOICAdKfMM2dyrC4bT9JhFOKppYix4pS6PTduTLQW0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887410; c=relaxed/simple;
	bh=xknIK75LFhSshsmJoSKP+5oT5sTmBlHExy6KsTeYPMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uhoTmEQzHb3NfLUwbyuumrekZpRf2exGbndSX2xLfT7WNL6Z/m2nCkosE72SKdaeqcNSXvC2VsULs9Mw7RL1FJ9XZIxqrzBPb8br1onuxQpXM1Inr6LsbhvFqLtv0boR6Tp7V4BZAjdRBLq98tE1fJMuAFTFQKvR2SeDtFCXjcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kFCGouWa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kFCGouWa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00FD3C4CEF1;
	Tue, 16 Dec 2025 12:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887410;
	bh=xknIK75LFhSshsmJoSKP+5oT5sTmBlHExy6KsTeYPMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kFCGouWa/te56lCf6bYp7Pqhutny4HUAhXqmd3k0udrsMDtOYDkVdfeWyqLIVh11o
	 is5rGtiyIx5GfpD8OzBmyOzi4lPTXBtI/cYy1Ey0iAyNyf3A09r1QXEDsMkbH+twCa
	 yNTv1f34uqgoVL8N6TT8kdmBmkV4I/fCH2/Hq+bY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 222/614] io_uring: use WRITE_ONCE for user shared memory
Date: Tue, 16 Dec 2025 12:09:49 +0100
Message-ID: <20251216111409.417049379@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 02339b74ba8d4..765abec2571f0 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3623,10 +3623,6 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 
 	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
 		ctx->sq_array = (u32 *)((char *)rings + sq_array_offset);
-	rings->sq_ring_mask = p->sq_entries - 1;
-	rings->cq_ring_mask = p->cq_entries - 1;
-	rings->sq_ring_entries = p->sq_entries;
-	rings->cq_ring_entries = p->cq_entries;
 
 	if (p->flags & IORING_SETUP_SQE128)
 		size = array_size(2 * sizeof(struct io_uring_sqe), p->sq_entries);
@@ -3649,6 +3645,12 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
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



