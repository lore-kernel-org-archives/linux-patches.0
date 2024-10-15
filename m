Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1351E6339;
	Tue, 15 Oct 2024 11:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993565; cv=none; b=tkyYw1ue21+dQSpivv/znw+l9lYQFnshUMFMD3c4+k6mDSUTQsX+DCMjvcf+iF2Yomjd2lcJPOJKiZY2+oH6pJO2j1R5M5e0czbpeA2NtdYHOqpEAtq1vV8LUvsa+jnvKeB4+zNk0bPWnNuhcHyhaj+oN+JPR4hJvyzATAviRu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993565; c=relaxed/simple;
	bh=XgIXAhYNLAv95zv1X1cq4vYzlLsp7lpgrgLQOcm7hBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aDCNazkoW3Gf89EyUD+yACM5E+vL5YqQVCmITA8VznoR8RgX0Pbxlt8/7gu9eGy3DtP0XJW4+/MvdxDCjZrP+j74PaKcAUwGwhglSGRaoZMVFj+BlUpdt1lVJEydjCTxEJyJlBsX0pkc17XBtY1Ejl7+kGlS6Vix6bxtUO+Dj4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xpe367cR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xpe367cR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509BDC4CEC6;
	Tue, 15 Oct 2024 11:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993564;
	bh=XgIXAhYNLAv95zv1X1cq4vYzlLsp7lpgrgLQOcm7hBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xpe367cRK0zi7aqrevMxLx49N20HWeMOPnpxBk11J2SskcIPG5pb68jNoj+IoaM1z
	 i5GWwu7Oi4IX8SgdE5prrBW7ZImPX5pcaDY83/YCfLRYQ1nzu51pV9YG2coO/o0meT
	 /JMfp9VauFQdZE2vwdexvyztQjH81Biikk296Nfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Konstantin Ovsepian <ovs@ovs.to>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 418/691] blk_iocost: fix more out of bound shifts
Date: Tue, 15 Oct 2024 13:26:06 +0200
Message-ID: <20241015112456.933602744@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Ovsepian <ovs@ovs.to>

[ Upstream commit 9bce8005ec0dcb23a58300e8522fe4a31da606fa ]

Recently running UBSAN caught few out of bound shifts in the
ioc_forgive_debts() function:

UBSAN: shift-out-of-bounds in block/blk-iocost.c:2142:38
shift exponent 80 is too large for 64-bit type 'u64' (aka 'unsigned long
long')
...
UBSAN: shift-out-of-bounds in block/blk-iocost.c:2144:30
shift exponent 80 is too large for 64-bit type 'u64' (aka 'unsigned long
long')
...
Call Trace:
<IRQ>
dump_stack_lvl+0xca/0x130
__ubsan_handle_shift_out_of_bounds+0x22c/0x280
? __lock_acquire+0x6441/0x7c10
ioc_timer_fn+0x6cec/0x7750
? blk_iocost_init+0x720/0x720
? call_timer_fn+0x5d/0x470
call_timer_fn+0xfa/0x470
? blk_iocost_init+0x720/0x720
__run_timer_base+0x519/0x700
...

Actual impact of this issue was not identified but I propose to fix the
undefined behaviour.
The proposed fix to prevent those out of bound shifts consist of
precalculating exponent before using it the shift operations by taking
min value from the actual exponent and maximum possible number of bits.

Reported-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Konstantin Ovsepian <ovs@ovs.to>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20240822154137.2627818-1-ovs@ovs.to
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iocost.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index bfdb7b0cf49de..9654d1c2c20f8 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2068,7 +2068,7 @@ static void ioc_forgive_debts(struct ioc *ioc, u64 usage_us_sum, int nr_debtors,
 			      struct ioc_now *now)
 {
 	struct ioc_gq *iocg;
-	u64 dur, usage_pct, nr_cycles;
+	u64 dur, usage_pct, nr_cycles, nr_cycles_shift;
 
 	/* if no debtor, reset the cycle */
 	if (!nr_debtors) {
@@ -2130,10 +2130,12 @@ static void ioc_forgive_debts(struct ioc *ioc, u64 usage_us_sum, int nr_debtors,
 		old_debt = iocg->abs_vdebt;
 		old_delay = iocg->delay;
 
+		nr_cycles_shift = min_t(u64, nr_cycles, BITS_PER_LONG - 1);
 		if (iocg->abs_vdebt)
-			iocg->abs_vdebt = iocg->abs_vdebt >> nr_cycles ?: 1;
+			iocg->abs_vdebt = iocg->abs_vdebt >> nr_cycles_shift ?: 1;
+
 		if (iocg->delay)
-			iocg->delay = iocg->delay >> nr_cycles ?: 1;
+			iocg->delay = iocg->delay >> nr_cycles_shift ?: 1;
 
 		iocg_kick_waitq(iocg, true, now);
 
-- 
2.43.0



