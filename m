Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92BC418026;
	Tue, 14 May 2024 11:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686479; cv=none; b=JyHnqc7ePREgnWDG1Glvm04VQem6+RvhHBACL9TBPiQEyQ4Et0Edy+sFu0HJAQO0avoX5dIz/lo4hwV53Qvs7pCiYA+v3+K9JMJJxz6DH4QkXRavK6XWnrAmydOWcsThXT58RyynEltsAEZ1bINmNmvQQmV0lH0FqK2R117akf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686479; c=relaxed/simple;
	bh=rhl6hwYIfjiyo/lLEF6dgUbrYlIx+Ol+2/i1fCPfcG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kx/275KA/WY8ePwR7iYqwkxnIQtrc+V1Dyxtqwulg7KwSIYZirF8AebpY0HRmUNNjW+NOhRHq5u7yBN5MlXjTSrrolPEzsPbiXLQoiUqXI05ioJZ7a38DwDJsT/yTK5LnWGMjHb5XUkFtv+QlKFSr/rpdrT1z/JZ7YqXOtgWtIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z95po9z2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z95po9z2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B889C2BD10;
	Tue, 14 May 2024 11:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686479;
	bh=rhl6hwYIfjiyo/lLEF6dgUbrYlIx+Ol+2/i1fCPfcG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z95po9z227fLHTZMRQ02hBgUah8KV+ed7cule8O7/Eg7Qrxr4jUr9oR/5EGhyk5UV
	 LVhy8Z075cYYO4FCHcwop6kUVrNswK4yXxb7IcI0E/8/7r2wB/ZBkF4RkucFhTPVrZ
	 nGTgJinu3DP2S3GZCYop8yXIeb5cOJATIOYX/EoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rik van Riel <riel@surriel.com>,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 121/236] blk-iocost: avoid out of bounds shift
Date: Tue, 14 May 2024 12:18:03 +0200
Message-ID: <20240514101024.964174979@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Rik van Riel <riel@surriel.com>

[ Upstream commit beaa51b36012fad5a4d3c18b88a617aea7a9b96d ]

UBSAN catches undefined behavior in blk-iocost, where sometimes
iocg->delay is shifted right by a number that is too large,
resulting in undefined behavior on some architectures.

[  186.556576] ------------[ cut here ]------------
UBSAN: shift-out-of-bounds in block/blk-iocost.c:1366:23
shift exponent 64 is too large for 64-bit type 'u64' (aka 'unsigned long long')
CPU: 16 PID: 0 Comm: swapper/16 Tainted: G S          E    N 6.9.0-0_fbk700_debug_rc2_kbuilder_0_gc85af715cac0 #1
Hardware name: Quanta Twin Lakes MP/Twin Lakes Passive MP, BIOS F09_3A23 12/08/2020
Call Trace:
 <IRQ>
 dump_stack_lvl+0x8f/0xe0
 __ubsan_handle_shift_out_of_bounds+0x22c/0x280
 iocg_kick_delay+0x30b/0x310
 ioc_timer_fn+0x2fb/0x1f80
 __run_timer_base+0x1b6/0x250
...

Avoid that undefined behavior by simply taking the
"delay = 0" branch if the shift is too large.

I am not sure what the symptoms of an undefined value
delay will be, but I suspect it could be more than a
little annoying to debug.

Signed-off-by: Rik van Riel <riel@surriel.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Jens Axboe <axboe@kernel.dk>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20240404123253.0f58010f@imladris.surriel.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iocost.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index e6557024e3da8..64b594d660b79 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1331,7 +1331,7 @@ static bool iocg_kick_delay(struct ioc_gq *iocg, struct ioc_now *now)
 {
 	struct ioc *ioc = iocg->ioc;
 	struct blkcg_gq *blkg = iocg_to_blkg(iocg);
-	u64 tdelta, delay, new_delay;
+	u64 tdelta, delay, new_delay, shift;
 	s64 vover, vover_pct;
 	u32 hwa;
 
@@ -1346,8 +1346,9 @@ static bool iocg_kick_delay(struct ioc_gq *iocg, struct ioc_now *now)
 
 	/* calculate the current delay in effect - 1/2 every second */
 	tdelta = now->now - iocg->delay_at;
-	if (iocg->delay)
-		delay = iocg->delay >> div64_u64(tdelta, USEC_PER_SEC);
+	shift = div64_u64(tdelta, USEC_PER_SEC);
+	if (iocg->delay && shift < BITS_PER_LONG)
+		delay = iocg->delay >> shift;
 	else
 		delay = 0;
 
-- 
2.43.0



