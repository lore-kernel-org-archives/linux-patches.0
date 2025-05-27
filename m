Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76047194A67;
	Tue, 27 May 2025 16:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364428; cv=none; b=Xt41u8bJi03dwq4CraZrs1wnYCI8n4Np7XhRaFZDbLSkpY5Ku9Gk8G+RkeAsv4ly8H1jsMeunvTfUaZy1PWKSTWXBM9kXFQCw9uPN+LpiHjgyvOC1TtnjoqE9gNpBcqwoqZ/MB03y+09sJcKVbkjwGWzQekuBcyw8Qp7RF4RzLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364428; c=relaxed/simple;
	bh=Z2libKXmS3L/5Hl4vaIjET8+vi+G+Ai+0FO+Vcpwurw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J9OJ+OwsJdV5iNoxEZwmyI18OimiJrhRlAoma1pcW9yy7Jfaec6jsee0XT2LmrQglF2P0aRHh4IaHstkDe7buU4Dv/QgOgo0W5Rgxm/7poVvR2uQEZ3VNV7+zMHgZ4kKcCW/F35AU49EsTWgP/KIy3LWnLtBobFff6l94poVy6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ISiT18DM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ISiT18DM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7876C4CEED;
	Tue, 27 May 2025 16:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364428;
	bh=Z2libKXmS3L/5Hl4vaIjET8+vi+G+Ai+0FO+Vcpwurw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ISiT18DMvLk5ygmSqlEz4JDjO87Wz6XRxt+tgZ4IHeY4y0j/fWc3Cs/haN1fX12r9
	 R67Ogw63hOE44xn1h7YXJTzakGifDM47VUdIr4b7ERS7ixwoKqX2is80IRwFDzSvEy
	 GgeLV+dhQV+VLWrVB28h2Yuqum2+U4DXVxvEwOYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 053/626] io_uring/msg: initialise msg request opcode
Date: Tue, 27 May 2025 18:19:06 +0200
Message-ID: <20250527162447.214682048@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 9cc0bbdaba2a66ad90bc6ce45163b7745baffe98 ]

It's risky to have msg request opcode set to garbage, so at least
initialise it to nop. Later we might want to add a user inaccessible
opcode for such cases.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/9afe650fcb348414a4529d89f52eb8969ba06efd.1743190078.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/msg_ring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 7fd9badcfaf81..35b1b585e9cbe 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -94,6 +94,7 @@ static int io_msg_remote_post(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		kmem_cache_free(req_cachep, req);
 		return -EOWNERDEAD;
 	}
+	req->opcode = IORING_OP_NOP;
 	req->cqe.user_data = user_data;
 	io_req_set_res(req, res, cflags);
 	percpu_ref_get(&ctx->refs);
-- 
2.39.5



