Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2554204E;
	Tue, 11 Nov 2025 01:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822982; cv=none; b=O+91zcZjzMKmClRw2GrOXenQ1AP4tLThaHIpFjNtJUUUXuLVVw/fNUTU6d3X7CHUItSUsxt5Iej6fRzFbi4qH1YKRD6ltkuoaZkq3qq9DAB3Vx5UOuELrddajVAv2bgs856BqTQPWjFoVNTIQBT2L7MXx50OMjKGb7h/+PX/J7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822982; c=relaxed/simple;
	bh=jUxTuTfghiC6bVrXwafx0x+aHEkYZmrsfdkxFjU3ajA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vEFp7s6N91eaNQNztLF3IXyM7IVDgz1v2Vea1sqUThRuqYca76lVaOr3LM1VPfUvZaXcu2HuMKFi36uCoCeadIQFLo8Kn8g3WSwLnpCY+4BmfB/3KJQUnYCB1UBLZhjP4fys75z9k12DbhQnodcOYA3bKHP4QQRJBD5Z2PLyDQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ZWbfcOO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ZWbfcOO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72FE5C4CEFB;
	Tue, 11 Nov 2025 01:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822981;
	bh=jUxTuTfghiC6bVrXwafx0x+aHEkYZmrsfdkxFjU3ajA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ZWbfcOOoltHNGtHvjA0j8qyXAPRa5GSJRl6ge7JOWPrldkXb8fazmPPmsLsPVAhh
	 fjiSPbYdiDgZ3HTLTDZNBcD+2g5e7IGftWwg++s7laQ/PQ3XKgB+lBHmh6RsczirOc
	 bizJfXG9YMAt8mHSQoiVyljj8mLDl6hvpno3ouH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 101/565] io_uring/zctx: check chained notif contexts
Date: Tue, 11 Nov 2025 09:39:17 +0900
Message-ID: <20251111004529.228376390@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d4cf5a1328e63..f50964c7dab82 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -14,10 +14,15 @@ static const struct ubuf_info_ops io_ubuf_ops;
 static void io_notif_tw_complete(struct io_kiocb *notif, struct io_tw_state *ts)
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



