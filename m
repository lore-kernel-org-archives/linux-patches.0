Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692371C1ADB;
	Mon, 22 Sep 2025 19:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570460; cv=none; b=Mlk6qc0HMrYKxdcgByOhBa4lfv6CfKD7gnWR04PG/3CUOuhRW5jURijS/hEXGDO/xLTd0q6AXiAJCGeEOZS1vmkEgNr+Fu5hE4u4s6Thphi/myU4U+66PYawyucBGbbtWPzUdTlk9MLjT587bqj+wc5XVeX4EKUxAIoS85Kw6EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570460; c=relaxed/simple;
	bh=seNCmIiVOzs0m2w2s7kmie017ykVIeQB4wR0qts0Czo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+7zDPP6Rh6MpMhP3N6wfV2wsLdOt0cNZJJ/z7QsvpDJFp0I2AKcGEllqpWQS6eWAmQwhnoj0xFohGqryn/PLYeDX1j0ml5S0SJdnhAo4Osc2CUj24t+9aRcALS/SNwTiWOD/ffSjo9lTm2QXoh2SXzqutMTUmRAcRQH3SC9yG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YDABrjz/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YDABrjz/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8955EC4CEF0;
	Mon, 22 Sep 2025 19:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570459;
	bh=seNCmIiVOzs0m2w2s7kmie017ykVIeQB4wR0qts0Czo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YDABrjz/9oxGFFfRTupc6hiPXQcFs8vAlY7zw3wnc7GjOK6g74yLBDfhiEbc80eMC
	 tZHxdQMmYHKjwn1WTDHU1w4Iv+WF74tzZ9/T/vAwGM6UW5bkCLPTjwx6vs82cS5vfu
	 is2jRrLUFy9DOjMpQlqzgc/M8lPaL/KDUpBunnAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 138/149] io_uring: fix incorrect io_kiocb reference in io_link_skb
Date: Mon, 22 Sep 2025 21:30:38 +0200
Message-ID: <20250922192416.347490317@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Xiuwei <yangxiuwei@kylinos.cn>

[ Upstream commit 2c139a47eff8de24e3350dadb4c9d5e3426db826 ]

In io_link_skb function, there is a bug where prev_notif is incorrectly
assigned using 'nd' instead of 'prev_nd'. This causes the context
validation check to compare the current notification with itself instead
of comparing it with the previous notification.

Fix by using the correct prev_nd parameter when obtaining prev_notif.

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Fixes: 6fe4220912d19 ("io_uring/notif: implement notification stacking")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/notif.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/notif.c b/io_uring/notif.c
index 9a6f6e92d7424..ea9c0116cec2d 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -85,7 +85,7 @@ static int io_link_skb(struct sk_buff *skb, struct ubuf_info *uarg)
 		return -EEXIST;
 
 	prev_nd = container_of(prev_uarg, struct io_notif_data, uarg);
-	prev_notif = cmd_to_io_kiocb(nd);
+	prev_notif = cmd_to_io_kiocb(prev_nd);
 
 	/* make sure all noifications can be finished in the same task_work */
 	if (unlikely(notif->ctx != prev_notif->ctx ||
-- 
2.51.0



