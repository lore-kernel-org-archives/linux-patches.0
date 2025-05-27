Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D70E86347;
	Tue, 27 May 2025 17:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365878; cv=none; b=nvUyvkhSx/xsUDqXlurflBjVSAM8eQWpL7nhqqbjRL92erz29TIray4Hd6fmL83oKypfIOa+1dP0dCsg4qlvu+41qHoWqcdF2qe+LdOHY+lzQuPX7o26gJe7R9tv00xVuSvHsEMjlxyvr34oKFzg/n3NdCv/hKWUZXxnv6sagJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365878; c=relaxed/simple;
	bh=t2fKQnErLqWtXE06ciBb4ULu6GWh+X90HF6FoV6KajU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sjkliNyq7d72T5BSD3G53+QqELWj69G4Q5Si2CrJzwLcdaej/cnIbdfSVONl9vVaHJqHog3u/J+ZiUZq6mnazcGXXftJ0kc3R5/gsoEFX2UfJJ7pJzknQ287AadShQGnNcbMEE2FudoBnIe2GNtuvZccQ2be6jQNGGzyyqXGgpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p4QUliyU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p4QUliyU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C38DC4CEE9;
	Tue, 27 May 2025 17:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365878;
	bh=t2fKQnErLqWtXE06ciBb4ULu6GWh+X90HF6FoV6KajU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p4QUliyUR+Oy2wbQ15ROYGXweQcxJHpR/xbgeGqIUMXUnR07tT1092J5bmdvQa3Ex
	 mA1V2mZc79GO4z1RIzseNfTIogPZQNfCp0cuN4NtRmaVxla/xX0krNY5YSpnzydRKA
	 jiBIgxZK6X43Iaxhzva5BkIdHWgQHyzlhWIOMPZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3e77fd302e99f5af9394@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 519/626] io_uring/fdinfo: annotate racy sq/cq head/tail reads
Date: Tue, 27 May 2025 18:26:52 +0200
Message-ID: <20250527162506.046933155@linuxfoundation.org>
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
index 6b1247664b355..ecdbe473a49f7 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -83,11 +83,11 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
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



