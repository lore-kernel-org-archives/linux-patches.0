Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368673CC303;
	Tue, 16 Jun 2026 18:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636056; cv=none; b=CDt1fDTC8PE9ke5+p6uhUA/iVUGO71hkqqQ0nwulFi76OsytMuVErmk3utMpz/FuTf7Kr7O71Ousb/DoxsQQOE9VjPw6+JvzTeXVWIsLrXhAk4XspxDpr/wICwvqYebIENs4l7y1ff3PfCpa6qbl2h5mg3f6XfvzncObFknF+4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636056; c=relaxed/simple;
	bh=GRWylYvlFUZkv0ub7mYLaUfCvvrmniunbvVXumjKssI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MOHuiMiTk48xnyJ3OZKXVWZWHBwEyFDeCtYv/vVB5F6WIa2LLrwkEevbvD4MYrqe7AbPYEMQDfqOMysdm1GmXFPD2kXRhuzuQ53PenD8VZTTLL8qYcOdh7CeeUPVMK2Vu3kG4PHwsqi5PHZANGrOYpeip3Y4QcQiN7ZWro7DmAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rmoZdcXF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rmoZdcXF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B9D1F000E9;
	Tue, 16 Jun 2026 18:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636055;
	bh=A4vCo12Q0BJF9BNQiKFz4fA9Y2fjF274nA3aYDlfWKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rmoZdcXFywZD/0DtprRyOkyjU1oPGnlYzHdQGpU1h+7fVuAK8DlwllWgZmvWi9tBT
	 WySEkrXmNlvQracVvuAAHy5d5LKD6FLGlqs0O6ThiW5yJ4gZGx5mIAE0Pw0YVilCiV
	 sQ+cezzqCFgZAktRG75MPnP59+/i7nXpOSD2y66g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Li Zetao <lizetao1@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Alexey Panov <apanov@astralinux.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 159/342] io_uring: prevent opcode speculation
Date: Tue, 16 Jun 2026 20:27:35 +0530
Message-ID: <20260616145055.575398048@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit 1e988c3fe1264708f4f92109203ac5b1d65de50b upstream.

sqe->opcode is used for different tables, make sure we santitise it
against speculations.

Cc: stable@vger.kernel.org
Fixes: d3656344fea03 ("io_uring: add lookup table for various opcode needs")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Reviewed-by: Li Zetao <lizetao1@huawei.com>
Link: https://lore.kernel.org/r/7eddbf31c8ca0a3947f8ed98271acc2b4349c016.1739568408.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ Alexey: Sanitize req->opcode directly because io_init_req() in
  linux-5.10.y has no local opcode variable and subsequent lookups use it. ]
Signed-off-by: Alexey Panov <apanov@astralinux.ru>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 2ca09e2dbd3d4a..51262d48a4a11b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -7193,6 +7193,8 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		return -EINVAL;
 	if (unlikely(req->opcode >= IORING_OP_LAST))
 		return -EINVAL;
+	req->opcode = array_index_nospec(req->opcode, IORING_OP_LAST);
+
 	if (!io_check_restriction(ctx, req, sqe_flags))
 		return -EACCES;
 
-- 
2.53.0



