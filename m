Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734331875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:07:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9FA4C433D2;
	Wed, 28 Dec 2022 16:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243635;
	bh=Im+3gM728uRYqBPQJw1yPeuW1QFVizrZxO8ndmQXP5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TEY7tzbrNhXZrQbxrLFJLZVrIvx5Ew57e5qJGUNLczne6AOr0ZMYAep/FjU2zccZ4
	 qwjNtXf0citGh8SUKUKx89bOy0xLoZ0CuCLbPEQBwhZItYpvViZZFpw0LZgaB0lYpK
	 xl/D4zBV3kNSIWXxcUVECJzYXSkuAweYoLfdEH/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Jihong <yangjihong1@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0525/1146] blktrace: Fix output non-blktrace event when blk_classic option enabled
Date: Wed, 28 Dec 2022 15:34:24 +0100
Message-Id: <20221228144344.436264476@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Jihong <yangjihong1@huawei.com>

[ Upstream commit f596da3efaf4130ff61cd029558845808df9bf99 ]

When the blk_classic option is enabled, non-blktrace events must be
filtered out. Otherwise, events of other types are output in the blktrace
classic format, which is unexpected.

The problem can be triggered in the following ways:

  # echo 1 > /sys/kernel/debug/tracing/options/blk_classic
  # echo 1 > /sys/kernel/debug/tracing/events/enable
  # echo blk > /sys/kernel/debug/tracing/current_tracer
  # cat /sys/kernel/debug/tracing/trace_pipe

Fixes: c71a89615411 ("blktrace: add ftrace plugin")
Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
Link: https://lore.kernel.org/r/20221122040410.85113-1-yangjihong1@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/blktrace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index a995ea1ef849..a66cff5a1857 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1548,7 +1548,8 @@ blk_trace_event_print_binary(struct trace_iterator *iter, int flags,
 
 static enum print_line_t blk_tracer_print_line(struct trace_iterator *iter)
 {
-	if (!(blk_tracer_flags.val & TRACE_BLK_OPT_CLASSIC))
+	if ((iter->ent->type != TRACE_BLK) ||
+	    !(blk_tracer_flags.val & TRACE_BLK_OPT_CLASSIC))
 		return TRACE_TYPE_UNHANDLED;
 
 	return print_one_line(iter, true);
-- 
2.35.1



