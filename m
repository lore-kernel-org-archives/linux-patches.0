Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5D721CA07;
	Mon,  2 Jun 2025 15:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877273; cv=none; b=FewyxpAPJDgJmLU6lcwwVzfQ672hNRivW2YIfCko5ZRUS//Q40qJ+xbow7m8PoErd0rev+S0mRExg2ALn2tY2eUuuMVqsUe7CIDbnSrO0ZK+xYMa5Kabo/kqMJYLTxYBir572ar11zQ+UvyiSCovGGq5KO8E6vED5w4KktannKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877273; c=relaxed/simple;
	bh=nLPQUnU5NmFjkZZtNSxECxusbR2mFFdFfQQqIz65jzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mpg9EUiy355pcwyh4U95uuZ7yILD/YUvCHV3HDUt0jYM0nEYKet+G9dAPlNxV0FjrZWjc5vNWMQGsX1fVfRRoWgKVqErwRDRgdB95hGZzKBlDDA1KaUcxMoqiyf3Y7vt7Wxt5kz1q8RyKkJZ21rBT1SHUQY/e1+JdBiaEotmJBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zcnw5Mjm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zcnw5Mjm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B8DC4CEEB;
	Mon,  2 Jun 2025 15:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877273;
	bh=nLPQUnU5NmFjkZZtNSxECxusbR2mFFdFfQQqIz65jzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zcnw5Mjm9ni7bVL/s395UNOX2qPKZubL3loO8Gkuo1m2i0YRxZqq2LS8wjeZqSZJu
	 dANkoiEDmS4B4fWL71GMF+zTxVUk3s6/ugt0/06b4+TtYTwmd8ocL1Zbf+E2lXPuV9
	 pMZ41AcecV4UMZL6F7/PF4uIsHpi2H7o0fjI/N5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3e77fd302e99f5af9394@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 225/325] io_uring/fdinfo: annotate racy sq/cq head/tail reads
Date: Mon,  2 Jun 2025 15:48:21 +0200
Message-ID: <20250602134328.927759313@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ea2c2ded4e412..4a50531699777 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -79,11 +79,11 @@ static __cold void __io_uring_show_fdinfo(struct io_ring_ctx *ctx,
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



