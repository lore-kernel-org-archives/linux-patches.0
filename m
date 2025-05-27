Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257E01E89C;
	Tue, 27 May 2025 17:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366489; cv=none; b=Vv4Ol80lR9jm1dQ9BKVwkT6HkWIDojfDQp7vctkptokhqifizxiErOWEqKTHobPqiV19QjiPnf51E7pcX7zsPhN2qKP84+vSlArGgbQ75IKaz5NQ8FJqIwHnXWkAVaLHgVTaIBkS96HuTxtyg4ejwt68jEQUXfF/50yirQrdkkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366489; c=relaxed/simple;
	bh=Jr+W3PRvtDr6nfIPjLO1l+N6YiC/o6npk3OBXldZIV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sSka034HIl7MCpK4mgnNhacIlfcL1ZxZXaIxbsxZ0rygDoLbjnuqvU5b0CBtbInSstkzXrLHyedeb8rvSIdYD1NwxjUf4Qytj9L5SzLqc3yhzNIXLEkI2L3eg2XJzcEHb3U5gJs+p+Yn9cqhsY+nihhOt7hfYokHugj4bSefwnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DPUl6kkL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DPUl6kkL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96D3C4CEE9;
	Tue, 27 May 2025 17:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366489;
	bh=Jr+W3PRvtDr6nfIPjLO1l+N6YiC/o6npk3OBXldZIV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DPUl6kkLCokohc5tsSvmDOhDDQR/i+Qse0x5Soi+LmJBW8a5VSMhIx70fCLR3T94c
	 QF3bkmDB1JpPzPWIAILZUWEMesXErM+x4Ry/v2Vmi8JpC8f2zygArrrLp9myDJ02ZH
	 jwVe9z/xqH0QQaHgb9StgmrUZfMBNy3jtor+qQh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 054/783] io_uring/msg: initialise msg request opcode
Date: Tue, 27 May 2025 18:17:31 +0200
Message-ID: <20250527162515.327589588@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 7e6f68e911f10..f844ab24cda42 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -93,6 +93,7 @@ static int io_msg_remote_post(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		kmem_cache_free(req_cachep, req);
 		return -EOWNERDEAD;
 	}
+	req->opcode = IORING_OP_NOP;
 	req->cqe.user_data = user_data;
 	io_req_set_res(req, res, cflags);
 	percpu_ref_get(&ctx->refs);
-- 
2.39.5



