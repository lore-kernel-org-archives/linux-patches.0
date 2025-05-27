Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CC52566;
	Tue, 27 May 2025 17:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368298; cv=none; b=dTWaOiEqQSMc20bJvlPRP35919w10hIb9GeKhpToM97AHEPlzs2c54YrWWB6Z7YNErOYHQ13snu23qL5t5oIYEy111ETgUCktpJt8Zl0HVmf8etTfz3EjfrNrBPL63vRCSoBD5yt3UQL1wVy+/NiDD0gPBFftTu1nfLpJYqh6ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368298; c=relaxed/simple;
	bh=GWXRmmR9KbAUD+wTEppBaUf4WMXCLAZwiWl5D7M4+04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I9/8/b3UasszEdSIGWHkImaG/eUrjn4CxSabA7w3+2SQEkuIAuPzOOihglelG6TWx5igbo2WN5f6aNDvb3kRSsaeqktCpQGrsIuNcmgnNHreh6oElJCHjGma+es2FfuSZb0fWP8sCzcT2F4UnM73KLCH4Pk9ePjZwVEAVnnqfIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Meb3OzmZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Meb3OzmZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A3EC4CEE9;
	Tue, 27 May 2025 17:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368297;
	bh=GWXRmmR9KbAUD+wTEppBaUf4WMXCLAZwiWl5D7M4+04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Meb3OzmZZR7b0kG7t5ml1IF7oFS1swu9byEH0RJCWc0BLAJyOICyLHv4OmGeL+Myy
	 LB1tDb9DCbD3R40bbXRyjv4RFbxKO3+RwhYJypAm/+m8oCU6WkuTRkhlMdlNnRfTNa
	 tGu1INnYlYNn/8uDniK+LPUnh7YPsjpRd+Vn4L6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3e77fd302e99f5af9394@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 662/783] io_uring/fdinfo: annotate racy sq/cq head/tail reads
Date: Tue, 27 May 2025 18:27:39 +0200
Message-ID: <20250527162540.083601487@linuxfoundation.org>
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
index 336aec7ea8c29..e0d6a59a89fa1 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -117,11 +117,11 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
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



