Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774318;
	b=C08d3nHBQaPKq7YRh8cdsfxGJCGTZ/WAGuvoOAskhRCbeKRjzZMDwrgPqzZ7S+bFrxgs
	 9B4iQsuAjkgkvp8mShF/IA1ZvRoiR8Zsd3hHhHlN+TN9KdUkwIIvO0Ju1l63m2sxbFqZX
	 TMBVVGxMnA7wcjYH9whDcEguG39/rfLw/7LTh6SMOdgUtjrSgLtda9cJrkjASzDzG5m4Z
	 TtSHLJQb8aIePKZyDqzMm6GU6MRf4vhNOtsP8SGaq3chBN2ReQpPrMUINc8QpO1KyQxVp
	 GBnSkG9VciM/+oPwrzZU1FpkUry3fsJhvB2QfWM3gg5qqgOdvV6QSbPQUOR9CCiJFWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774318;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H9zltSc3uy9vkH3WtYfCgDR3HZCLo6oPDCS6A63ltac=;
	b=FLw9zy55qPZCzl1UI8j25FzrI9+CsBvERBv522j+6BRM/32+O/owQeRcDo5kK6mj7f3O
	 yLefD1MrZIqlHFeSYghnKm4oTqvr4iHHf+AskMWMHXLaDiNpTDxHYwVd7ReEt0fBJsKCE
	 uEondaPKQd8Yzh5aPjWkZtClmWIjghZptURF9HqSO2i+QInueO7YqLkOO6KvvVqCuPzTs
	 lghXtdGcwDHPIYPgfGrHuxnhghQUxtz9JS4FHpihXgDeruGzER3quj7vK0glTUMg64x9K
	 leEOgN8N6zW2EsF6JaJ0ke6J6ogSL9T8HeaXlxW2uee8HFqyCzOfPUCCiXKXAGZVv3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nzpRTXtb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1418B606A32A;
	Fri, 23 Oct 2026 16:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nzpRTXtb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F5821F01825;
	Fri, 23 Oct 2026 16:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774317;
	bh=H9zltSc3uy9vkH3WtYfCgDR3HZCLo6oPDCS6A63ltac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nzpRTXtbQqzsfvzVWGK4/J2m5dNYmr+hII9ujOhuklkUuUQdRyUFbR/iyi9vJvSEw
	 Jy2vownTg3tCzoMgI+8HONsr39vHj2DsmD+/VS/poeErfnM9oJFwj1YS9FLJofmpWk
	 rY8/3HODMpvmHveQTZvvPN2udzIuQ1m+muuJAr2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 178/193] io_uring/cancel: move __io_uring_cancel() into cancel.c
Date: Fri, 23 Oct 2026 18:37:35 +0200
Message-ID: <20261023163718.427850731@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 01e019b2a30df41c485f602a5246124ea911071b ]

Yet another function that should be in cancel.c, move it over.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: fddcf4c5321b ("io_uring/cancel: don't spin on local work the task can't run")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/cancel.c   |    6 ++++++
 io_uring/io_uring.c |    6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -422,3 +422,9 @@ bool io_match_task_safe(struct io_kiocb
 	}
 	return matched;
 }
+
+void __io_uring_cancel(bool cancel_all)
+{
+	io_uring_unreg_ringfd();
+	io_uring_cancel_generic(cancel_all, NULL);
+}
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3369,12 +3369,6 @@ end_wait:
 	}
 }
 
-void __io_uring_cancel(bool cancel_all)
-{
-	io_uring_unreg_ringfd();
-	io_uring_cancel_generic(cancel_all, NULL);
-}
-
 static struct io_uring_reg_wait *io_get_ext_arg_reg(struct io_ring_ctx *ctx,
 			const struct io_uring_getevents_arg __user *uarg)
 {


