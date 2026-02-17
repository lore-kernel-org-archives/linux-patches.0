Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE51266581;
	Tue, 17 Feb 2026 20:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361466; cv=none; b=ie0VdGlpaBm3qnbMR2DEQC60oPtjiJcCT08U3+h2TtD6oUfAgp11p6RltOOh8rJ2lt5SPVhyJP7AvG5HtW9yla7LMo0Awms4wbD2lHl5OPHjRoknkAqErXdyisJ9M0jFABg7UaOgUNLQ4jhh4MtiUS1uldHc8f8aeqaOF+P9dp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361466; c=relaxed/simple;
	bh=3VRnEKB1+HccQBADqT5nwXQerc7jF7QvrkOv3yG2Xq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uzwAIwnmfhx4vt4qg2J71G9ithClhoS9K+jmEyk6KAvhRa4wlOeXLofTQUEuXB2SHC87dOm77UGZ+4UD00KTSWqQ2tcib2NzcguJR8kEHJGcJJ4ZR/n5LuuIYRq7Rwgdrqcr2QjSMTgZp8TeQrufUkzL5z/GD6TVww0i/7VsmLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qj5AA60j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qj5AA60j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C213AC4CEF7;
	Tue, 17 Feb 2026 20:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361466;
	bh=3VRnEKB1+HccQBADqT5nwXQerc7jF7QvrkOv3yG2Xq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qj5AA60jM11HG8j4sb97HcwTa0GdAZ/npt0D8mhlE63s9+cO8vd7F1Y/lspsWyXkQ
	 Qf4dojyTe+NjQx2/V9C/vvXgqghAD4mVHXi7thtEQISdEVF830g0c15rwDa5A5/gtJ
	 ujWH2vUNV5mXuyt4D7cGaudDihlqttDVNDe4GYMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=E6=98=AF=E5=8F=82=E5=B7=AE?= <shicenci@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 24/43] io_uring/fdinfo: be a bit nicer when looping a lot of SQEs/CQEs
Date: Tue, 17 Feb 2026 21:32:04 +0100
Message-ID: <20260217200007.393704783@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200006.470920131@linuxfoundation.org>
References: <20260217200006.470920131@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 38cfdd9dd279473a73814df9fd7e6e716951d361 ]

Add cond_resched() in those dump loops, just in case a lot of entries
are being dumped. And detect invalid CQ ring head/tail entries, to avoid
iterating more than what is necessary. Generally not an issue, but can be
if things like KASAN or other debugging metrics are enabled.

Reported-by: 是参差 <shicenci@gmail.com>
Link: https://lore.kernel.org/all/PS1PPF7E1D7501FE5631002D242DD89403FAB9BA@PS1PPF7E1D7501F.apcprd02.prod.outlook.com/
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/fdinfo.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 294c75a8a3bdb..3585ad8308504 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -65,7 +65,7 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 	unsigned int cq_head = READ_ONCE(r->cq.head);
 	unsigned int cq_tail = READ_ONCE(r->cq.tail);
 	unsigned int sq_shift = 0;
-	unsigned int sq_entries;
+	unsigned int cq_entries, sq_entries;
 	int sq_pid = -1, sq_cpu = -1;
 	u64 sq_total_time = 0, sq_work_time = 0;
 	unsigned int i;
@@ -119,9 +119,11 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 			}
 		}
 		seq_printf(m, "\n");
+		cond_resched();
 	}
 	seq_printf(m, "CQEs:\t%u\n", cq_tail - cq_head);
-	while (cq_head < cq_tail) {
+	cq_entries = min(cq_tail - cq_head, ctx->cq_entries);
+	for (i = 0; i < cq_entries; i++) {
 		struct io_uring_cqe *cqe;
 		bool cqe32 = false;
 
@@ -136,8 +138,11 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 					cqe->big_cqe[0], cqe->big_cqe[1]);
 		seq_printf(m, "\n");
 		cq_head++;
-		if (cqe32)
+		if (cqe32) {
 			cq_head++;
+			i++;
+		}
+		cond_resched();
 	}
 
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
-- 
2.51.0



