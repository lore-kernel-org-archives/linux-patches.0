Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D9D2356DA;
	Mon,  2 Jun 2025 14:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873990; cv=none; b=FTPBIiUkeHZvhEdbAiYz9dDummJ1nRRRe+V03ScskP1Jm2h/pgNi5Eo37UFxsGQYXaSkuTfmmIG+AhineTV4FeMnCBPxM4yh6ki7GDJc3sV45UqMeeaij98HT1+LL1X/nnNXM09/Fa999UNUZus/gjdqLQu4E3udIfdQQa5cExw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873990; c=relaxed/simple;
	bh=bV5PjrCHP/4xCPJfUop2vi57b/mJMmnUpdx3Mse+idM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kvMk+l0OrZu6SkS63SXtqmpeovPbR5VgyJmDV6RluKsSBkN7Dm8BWlSHGLvLz/m6YsTJH+rlyoJzi35+7KpIr/uCkTk6P1BqNCecsU3mmPnuKDX6Z7xW1DLYFXYrN2Bi9iEZhBJtANKk6Z/hCqkA7U51e3tNno+lB/sRXHDjC+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tBb+YITz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tBb+YITz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C812AC4CEF2;
	Mon,  2 Jun 2025 14:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873990;
	bh=bV5PjrCHP/4xCPJfUop2vi57b/mJMmnUpdx3Mse+idM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tBb+YITzUOCgrJo/k+yc0aNmSZBmWscdGpedVgH/jUGDLhsq22aZihXlyl6vtM5Be
	 K3+D5nJvwYw/FHrx+xkQ7xTvLknV1pjIfnIE56YGnPcVy3H/PJ6b/m1/Hqum/BjloG
	 PCv/vaVKsqKb57N427N2xo/9mlotBn8zjqjMXHDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3e77fd302e99f5af9394@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 321/444] io_uring/fdinfo: annotate racy sq/cq head/tail reads
Date: Mon,  2 Jun 2025 15:46:25 +0200
Message-ID: <20250602134353.969511091@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit f024d3a8ded0d8d2129ae123d7a5305c29ca44ce ]

syzbot complains about the cached sq head read, and it's totally right.
But we don't need to care, it's just reading fdinfo, and reading the
CQ or SQ tail/head entries are known racy in that they are just a view
into that very instant and may of course be outdated by the time they
are reported.

Annotate both the SQ head and CQ tail read with data_race() to avoid
this syzbot complaint.

Link: https://lore.kernel.org/io-uring/6811f6dc.050a0220.39e3a1.0d0e.GAE@google.com/
Reported-by: syzbot+3e77fd302e99f5af9394@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/fdinfo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 976e9500f6518..a26cf840e623d 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -81,11 +81,11 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
 	seq_printf(m, "SqMask:\t0x%x\n", sq_mask);
 	seq_printf(m, "SqHead:\t%u\n", sq_head);
 	seq_printf(m, "SqTail:\t%u\n", sq_tail);
-	seq_printf(m, "CachedSqHead:\t%u\n", ctx->cached_sq_head);
+	seq_printf(m, "CachedSqHead:\t%u\n", data_race(ctx->cached_sq_head));
 	seq_printf(m, "CqMask:\t0x%x\n", cq_mask);
 	seq_printf(m, "CqHead:\t%u\n", cq_head);
 	seq_printf(m, "CqTail:\t%u\n", cq_tail);
-	seq_printf(m, "CachedCqTail:\t%u\n", ctx->cached_cq_tail);
+	seq_printf(m, "CachedCqTail:\t%u\n", data_race(ctx->cached_cq_tail));
 	seq_printf(m, "SQEs:\t%u\n", sq_tail - sq_head);
 	sq_entries = min(sq_tail - sq_head, ctx->sq_entries);
 	for (i = 0; i < sq_entries; i++) {
-- 
2.39.5



