Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58FCF3F7A9C;
	Wed, 20 May 2026 17:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299546; cv=none; b=QEoNwbmcnH+eUAyJ/kUx95H91ouJlJcdNLL7U7xLFngwNX7yWNf8j1JQa4jywQj9Jp8VZSL26RdgRglXZccBcU4L+NCXK2vXNsTTQEDaMW938ty28MT+F92OeLrP+zKDw1hJNQxpdrCBkZIfO8T859x4tydh7E2NTlZ5VYRD4Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299546; c=relaxed/simple;
	bh=v3g2JfrU+Xa6nOVAxrpmJMBkMj94xxWoU66+Ey+LSEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cWtf/qN/V4raWjwMKCMYkzv8XQBIFW+8XcnXi2sfGEOZoeqrYMQ8Z3qekXZwMQHb9a4lt0XU+TVVXHdUuaDyVy3DJylPxMoUCXqs0LUGCkHu6OswxoqEfNTWRvEuR6vf/RfeQgT4toygGfcinnjUmTLkYPIw0J87aTRekDCRUZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pdqX9mXp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pdqX9mXp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF6A61F000E9;
	Wed, 20 May 2026 17:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299545;
	bh=tIqUePO3uNrD832heCUMOtcXaNL8z+937jMMqSFdxZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pdqX9mXpvnbadNHrH5+/W31B84STBP8fgMQzRaqi8vV9iWgl6SdbdllC0j3svF3Wn
	 8fMC46wReuO0ELblDvqROIQvj6zj2UZvS/dSyV/HdIRTm0ONxDVb86yVeF81BNQ+IF
	 agXYZCyzsfKHZvwdkbgfL8L1Segyw7nDysrOeXzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 814/957] io_uring/napi: cap busy_poll_to 10 msec
Date: Wed, 20 May 2026 18:21:37 +0200
Message-ID: <20260520162152.220684476@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit df8599ee18c0e5fe343ffe0b4c379636b8bb839a ]

Currently there's no cap on the maximum amount of time that napi is
allowed to poll if no events are found, which can lead to kernel
complaints on a task being stuck as there's no conditional rescheduling
done within that loop.

Just cap it to 10 msec in total, that's already way above any kind of
sane value that will reap any benefits, yet low enough that it's
nowhere near being able to trigger preemption complaints.

Fixes: 8d0c12a80cde ("io-uring: add napi busy poll support")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/napi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/napi.c b/io_uring/napi.c
index 4a10de03e4269..8d68366a4b903 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -276,6 +276,8 @@ static int io_napi_register_napi(struct io_ring_ctx *ctx,
 	/* clean the napi list for new settings */
 	io_napi_free(ctx);
 	WRITE_ONCE(ctx->napi_track_mode, napi->op_param);
+	/* cap NAPI at 10 msec of spin time */
+	napi->busy_poll_to = min(10000, napi->busy_poll_to);
 	WRITE_ONCE(ctx->napi_busy_poll_dt, napi->busy_poll_to * NSEC_PER_USEC);
 	WRITE_ONCE(ctx->napi_prefer_busy_poll, !!napi->prefer_busy_poll);
 	return 0;
-- 
2.53.0



