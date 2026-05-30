Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E203AD520;
	Sat, 30 May 2026 17:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162239; cv=none; b=B3kiiU+EppfkmyVLkAKvBd/GKMHsuEra0cYx4lCpy7zxSBJfwZcp/u2sLVYMJUKaRwIdyuvxQ5SwW99JnvPMTrdWtof70TEUuA/fka2I9WLvT1OqOVemyDTR8pwsULQSkwRmQZb1vOUxr8wh3KQ88o/M0wcYofKuGrLK+O8W5QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162239; c=relaxed/simple;
	bh=tgieQTDofmrSz/CNprYKBfSlWpnNnKLwCxadUc0R650=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AtQuCYlAk5a6tKrN9Fpd2KVmCcpG4NvMsOuiZswn/+91lSsBJwUiQDVKrwQBdG8m0R8PMW8qg11/IPeVK3NOw4GISN9jCtQf+BlLJHtxUl1txm6vNnpqJnHE2O9qxn2W7PoNQs+7A262ZMZl5G9jKV3txmwuBGsDpo/QK054ToU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QbTUymWe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QbTUymWe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0337E1F00893;
	Sat, 30 May 2026 17:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162235;
	bh=urVYQVKvY7mb0gupV2+BodTC0j9PbKegP8DywxE3FpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QbTUymWeP7rOKbXO8cFdMZs3msQQthgP5z1GO70enOMJNBXciqZL8sBJrFc9dwGQX
	 2zdiXKFsA/EKqK8g7CVT312EkXcPo4FExVCNK0Tw3/lcXyVBABkwq3fk+e6siJENBs
	 klF7mXIV4qKmQnM7EAnBpRfsEGsUw92TFad+wRIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Li Zetao <lizetao1@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Robert Garcia <rob_garcia@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 832/969] io_uring: prevent opcode speculation
Date: Sat, 30 May 2026 18:05:56 +0200
Message-ID: <20260530160323.621294303@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 1e988c3fe1264708f4f92109203ac5b1d65de50b ]

sqe->opcode is used for different tables, make sure we santitise it
against speculations.

Cc: stable@vger.kernel.org
Fixes: d3656344fea03 ("io_uring: add lookup table for various opcode needs")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Reviewed-by: Li Zetao <lizetao1@huawei.com>
Link: https://lore.kernel.org/r/7eddbf31c8ca0a3947f8ed98271acc2b4349c016.1739568408.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Robert Garcia <rob_garcia@163.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index d0d9ff6b87a08..fdb8afdb01353 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2031,6 +2031,8 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		req->opcode = 0;
 		return io_init_fail_req(req, -EINVAL);
 	}
+	opcode = array_index_nospec(opcode, IORING_OP_LAST);
+
 	def = &io_op_defs[opcode];
 	if (unlikely(sqe_flags & ~SQE_COMMON_FLAGS)) {
 		/* enforce forwards compatibility on users */
-- 
2.53.0



