Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14AA55FF04;
	Tue, 13 Feb 2024 17:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845509; cv=none; b=K1n/MZ2CT3TJrnFGPfGXz8dWerDPlX1gLb9hDBnLFZfBmcFsg6LHIXypHd2K2sJZHYz4vqb61cQgf6GHazQwjYxC07m5ga093OTuPyDzIdOPNZyNpa7TiiFZ+dTWZp4MKpIExMewMpwSp5kNyLwS6dmVCWnQogmWul5Y3Do77xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845509; c=relaxed/simple;
	bh=b7MYkj59SL/g697iOtrgBdGJM/lWyuajACeyLL4KPrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BIgFoqRRSGvmW15OEk2gxE/Y/7p4cJPUbsrZRNYBvrUgdAN9oVYzHO5Q4JgXD7pBIQbcp1G3E88h5LlTEOhZjsVKbF9LWHOUAn/4gY1cGBA+fiz6uhttnwooR3OxLqv/+uurL4tl844FIoiFMffUciR3RsiIlqlPyXaPvIUVzYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D1lEizfC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D1lEizfC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85923C433C7;
	Tue, 13 Feb 2024 17:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845508;
	bh=b7MYkj59SL/g697iOtrgBdGJM/lWyuajACeyLL4KPrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D1lEizfCF8yeciX6hxVmmJpuAvgEm1DyUguRnY3HPTvJjHSfKglog2QkVdKOnk2ci
	 uYu2aQdLeszG1BEz8LF0LJC/r9E6d7Jhuldu2dLraZTdxus9DR17/VA5tTvEF7taVl
	 7HQSuLjz72NBdSSPIdDiTe65YuFiSgCCjCeo+n8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Breno=20Leit=C3=A3o?= <leitao@debian.org>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 098/121] blk-iocost: Fix an UBSAN shift-out-of-bounds warning
Date: Tue, 13 Feb 2024 18:21:47 +0100
Message-ID: <20240213171855.856288665@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 2a427b49d02995ea4a6ff93a1432c40fa4d36821 ]

When iocg_kick_delay() is called from a CPU different than the one which set
the delay, @now may be in the past of @iocg->delay_at leading to the
following warning:

  UBSAN: shift-out-of-bounds in block/blk-iocost.c:1359:23
  shift exponent 18446744073709 is too large for 64-bit type 'u64' (aka 'unsigned long long')
  ...
  Call Trace:
   <TASK>
   dump_stack_lvl+0x79/0xc0
   __ubsan_handle_shift_out_of_bounds+0x2ab/0x300
   iocg_kick_delay+0x222/0x230
   ioc_rqos_merge+0x1d7/0x2c0
   __rq_qos_merge+0x2c/0x80
   bio_attempt_back_merge+0x83/0x190
   blk_attempt_plug_merge+0x101/0x150
   blk_mq_submit_bio+0x2b1/0x720
   submit_bio_noacct_nocheck+0x320/0x3e0
   __swap_writepage+0x2ab/0x9d0

The underflow itself doesn't really affect the behavior in any meaningful
way; however, the past timestamp may exaggerate the delay amount calculated
later in the code, which shouldn't be a material problem given the nature of
the delay mechanism.

If @now is in the past, this CPU is racing another CPU which recently set up
the delay and there's nothing this CPU can contribute w.r.t. the delay.
Let's bail early from iocg_kick_delay() in such cases.

Reported-by: Breno Leitão <leitao@debian.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Fixes: 5160a5a53c0c ("blk-iocost: implement delay adjustment hysteresis")
Link: https://lore.kernel.org/r/ZVvc9L_CYk5LO1fT@slm.duckdns.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iocost.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 089fcb9cfce3..7ee8d85c2c68 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1353,6 +1353,13 @@ static bool iocg_kick_delay(struct ioc_gq *iocg, struct ioc_now *now)
 
 	lockdep_assert_held(&iocg->waitq.lock);
 
+	/*
+	 * If the delay is set by another CPU, we may be in the past. No need to
+	 * change anything if so. This avoids decay calculation underflow.
+	 */
+	if (time_before64(now->now, iocg->delay_at))
+		return false;
+
 	/* calculate the current delay in effect - 1/2 every second */
 	tdelta = now->now - iocg->delay_at;
 	if (iocg->delay)
-- 
2.43.0



