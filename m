Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489E013C695;
	Tue, 14 May 2024 10:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683186; cv=none; b=NqagCH4i7+rCPhWYwraZGUJcK7FHdXaZcqYTtSw70/w37KnqS5WJRQpKh7OLi+TwlD1aFIcjk/iUeC2NjpeWckd+JpLJEcO11ngAfp/3TYf5ejw6RMHdQjrlJPcIOSKPmda2nFigJcf/nShCKkLMMLjfaN2eVK6Ypnoj0Xqffgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683186; c=relaxed/simple;
	bh=NeByYpr7ubwCs84Y5OXp2NeYhmn6S6chcPUb7Bu4rOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQjYRkTpjQC95qXia6G9+M4RUksq50uWzbvhDalwQXVFUWcpTdKWDRnNLAEBddk3BO93ukID4cHU2XSJLMi2ma10v7rweRvOZRcTXymKVVySSZne3vmda+9S/1aqSpCTVCaBF1l65DxEFv6taUl2uHwVh4RZAGust4pCXEyNrik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hwb4TKFe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hwb4TKFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A776AC2BD10;
	Tue, 14 May 2024 10:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683186;
	bh=NeByYpr7ubwCs84Y5OXp2NeYhmn6S6chcPUb7Bu4rOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hwb4TKFe+OwvFFmffk5Aj06zE+//3Egx9ZWWCUdHsAy2QrxKNbydEkT0jfLKxkD7l
	 R6uHWh07YpztG/TJQbigw2510EKf2pdu/2u8bwgasoxxFRqhqarsn+QdsMbXnu5ACZ
	 IN8c+yzFcC9l9VyQM7Vgxo/T13hxaskxNX3eSIa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rik van Riel <riel@surriel.com>,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 149/336] blk-iocost: avoid out of bounds shift
Date: Tue, 14 May 2024 12:15:53 +0200
Message-ID: <20240514101044.227785073@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 04d44f0bcbc85..b1c4c874d4201 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1347,7 +1347,7 @@ static bool iocg_kick_delay(struct ioc_gq *iocg, struct ioc_now *now)
 {
 	struct ioc *ioc = iocg->ioc;
 	struct blkcg_gq *blkg = iocg_to_blkg(iocg);
-	u64 tdelta, delay, new_delay;
+	u64 tdelta, delay, new_delay, shift;
 	s64 vover, vover_pct;
 	u32 hwa;
 
@@ -1362,8 +1362,9 @@ static bool iocg_kick_delay(struct ioc_gq *iocg, struct ioc_now *now)
 
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



