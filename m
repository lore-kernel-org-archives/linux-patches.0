Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D32CE1DF258;
	Tue, 11 Nov 2025 00:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822550; cv=none; b=Hmb7tGAdU8Nk44xo2shQ+EZjg3eMcCYT026PJU8lFY4cW0TKTJXlXjfxPUALRLkVQp3TYShTcydIViGS9OfEeM4t1Gfqj1QAGkfAgjC4DfWxkqS6B62WueNrlIT1vkbF2m10Z+Gdc7xGJTyZL2pS6Fnqmy8or7FxrCM7i0IhXYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822550; c=relaxed/simple;
	bh=RSGnRkWo8EAWrQ23jEej4mIL8dnMKeEB8h0aTheCYpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WRhQdw/U6HrSxvWIa/YBf+9JoVSbQWboFrjMiVtK43duYAPCMa8RWc+Nt01MUBY4oWqBqPWg/YKq3LY8AY8UKOM4e66XiZkr8tAMQmH/QDatrHaYMRmevYSjFhFBeLnAYDE9y4EUJjBsa5G1pjoWZQX9YXJmCnVeTD4I0+GFAQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gbNP605C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gbNP605C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EE77C2BC86;
	Tue, 11 Nov 2025 00:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822550;
	bh=RSGnRkWo8EAWrQ23jEej4mIL8dnMKeEB8h0aTheCYpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gbNP605CChX/7HokYE6ojyx8oN8ziShSzWXUrBFkq9+swACHLoUo0NGFIsgUyhZbv
	 tZQBYHIE9UmoDEvy0Ik8UzIOcwkN8TMdkzdBxu2Ys2/smgtPkHH0pn8xRm2EyR8adI
	 zei0zx+z5Jfkv4aTbMAt1+YB/1m7kM9tqTB6PgfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 135/849] io_uring/zctx: check chained notif contexts
Date: Tue, 11 Nov 2025 09:35:05 +0900
Message-ID: <20251111004539.660666002@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

[ Upstream commit ab3ea6eac5f45669b091309f592c4ea324003053 ]

Send zc only links ubuf_info for requests coming from the same context.
There are some ambiguous syz reports, so let's check the assumption on
notification completion.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/fd527d8638203fe0f1c5ff06ff2e1d8fd68f831b.1755179962.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/notif.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/io_uring/notif.c b/io_uring/notif.c
index ea9c0116cec2d..d8ba1165c9494 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -14,10 +14,15 @@ static const struct ubuf_info_ops io_ubuf_ops;
 static void io_notif_tw_complete(struct io_kiocb *notif, io_tw_token_t tw)
 {
 	struct io_notif_data *nd = io_notif_to_data(notif);
+	struct io_ring_ctx *ctx = notif->ctx;
+
+	lockdep_assert_held(&ctx->uring_lock);
 
 	do {
 		notif = cmd_to_io_kiocb(nd);
 
+		if (WARN_ON_ONCE(ctx != notif->ctx))
+			return;
 		lockdep_assert(refcount_read(&nd->uarg.refcnt) == 0);
 
 		if (unlikely(nd->zc_report) && (nd->zc_copied || !nd->zc_used))
-- 
2.51.0



