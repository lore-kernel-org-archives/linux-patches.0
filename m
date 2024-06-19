Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52FD312FB31;
	Wed, 19 Jun 2024 13:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802249; cv=none; b=HB9cPp3YMWDog7q8JKKtP8Y3TSOB9UiF8s41LGAhSZQfhVQgKJUvqOUXdSbDszu0IHyoSg8XAUOoYVkhvRKgE3xCujACmUQEYDiQTvDt8cCe609kJJf0hjz5W/bnHXxRB+i1M09DYlCJfcoyS/Zw2Ck+jhsSd84USDWLlUhKJOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802249; c=relaxed/simple;
	bh=FqQgsjM29DSag4lNTiszNfxN8xFv0yx82ihImN6FrN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L5ROqIse2MleOZ3GCS3qE8mqbJNaZ1ZcAVHbpwEMZMAcO8OiQBF2II9kST5jnJtAGgGXuFC1jcIALj+ezlRCfSYDz5jqdXMb9+HX/mMcpU5U5ErxJ+6zgOsdrb/MgyQznKIuxJwHs4VGv4d/S0BwwNZ74+9wvyh2dS8fJAqnaP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i4uCUGTx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i4uCUGTx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D08D4C2BBFC;
	Wed, 19 Jun 2024 13:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802249;
	bh=FqQgsjM29DSag4lNTiszNfxN8xFv0yx82ihImN6FrN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i4uCUGTxlUy7ejUW4zZbBHfVzFIOyuvNtpIe7C3j4iQHsaz8mslcJPK4xxEudv6xL
	 AsMRRXZe+RY5pdeh/bi5cOTwPumZN+op7wtaQnP6PsnAgb6GkSIR1IGRde3+VKeCyR
	 cXqWkGnsS3Vt7bvppDUh3+SW6+d86rsmJXOHGd64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 133/267] io_uring/io-wq: avoid garbage value of match in io_wq_enqueue()
Date: Wed, 19 Jun 2024 14:54:44 +0200
Message-ID: <20240619125611.455873752@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

From: Su Hui <suhui@nfschina.com>

[ Upstream commit 91215f70ea8541e9011c0b48f8b59b9e0ce6953b ]

Clang static checker (scan-build) warning:
o_uring/io-wq.c:line 1051, column 3
The expression is an uninitialized value. The computed value will
also be garbage.

'match.nr_pending' is used in io_acct_cancel_pending_work(), but it is
not fully initialized. Change the order of assignment for 'match' to fix
this problem.

Fixes: 42abc95f05bf ("io-wq: decouple work_list protection from the big wqe->lock")
Signed-off-by: Su Hui <suhui@nfschina.com>
Link: https://lore.kernel.org/r/20240604121242.2661244-1-suhui@nfschina.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io-wq.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 4a07742349048..8a99aabcac2c3 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -929,7 +929,11 @@ void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work)
 {
 	struct io_wq_acct *acct = io_work_get_acct(wq, work);
 	unsigned long work_flags = work->flags;
-	struct io_cb_cancel_data match;
+	struct io_cb_cancel_data match = {
+		.fn		= io_wq_work_match_item,
+		.data		= work,
+		.cancel_all	= false,
+	};
 	bool do_create;
 
 	/*
@@ -967,10 +971,6 @@ void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work)
 		raw_spin_unlock(&wq->lock);
 
 		/* fatal condition, failed to create the first worker */
-		match.fn		= io_wq_work_match_item,
-		match.data		= work,
-		match.cancel_all	= false,
-
 		io_acct_cancel_pending_work(wq, acct, &match);
 	}
 }
-- 
2.43.0



