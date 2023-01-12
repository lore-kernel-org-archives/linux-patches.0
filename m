Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C25C749D
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:11:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D2B2C433F1;
	Thu, 12 Jan 2023 14:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532689;
	bh=UBc0hF8DfhKPOqTyNXOkq1eqV2N4WgScwG+SqkW3ByA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uwBvZM6mXyaKu/2YsmbdewuAWGhAtN5fH3ZzaXmTue9JG5ZGdGRgRMYYynA1u+aVz
	 asytSlh3PxtKx4Hiw31CmtXt1bkNweqtn7auaGvl94/5RDnljoInKRDIfTzvZAWQC0
	 sALLVdfSnHUy0819Udt2wE/pvYXZ768sxct1dPVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Jihong <yangjihong1@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 245/783] blktrace: Fix output non-blktrace event when blk_classic option enabled
Date: Thu, 12 Jan 2023 14:49:21 +0100
Message-Id: <20230112135535.754010613@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index 15a376f85e09..ab912cc60760 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1592,7 +1592,8 @@ blk_trace_event_print_binary(struct trace_iterator *iter, int flags,
 
 static enum print_line_t blk_tracer_print_line(struct trace_iterator *iter)
 {
-	if (!(blk_tracer_flags.val & TRACE_BLK_OPT_CLASSIC))
+	if ((iter->ent->type != TRACE_BLK) ||
+	    !(blk_tracer_flags.val & TRACE_BLK_OPT_CLASSIC))
 		return TRACE_TYPE_UNHANDLED;
 
 	return print_one_line(iter, true);
-- 
2.35.1



