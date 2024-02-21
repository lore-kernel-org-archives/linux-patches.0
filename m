Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781134C62;
	Wed, 21 Feb 2024 14:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524529; cv=none; b=mK+KbILHM9HT9wKTf3OzEdL3kyYSVh7ZBe+AfHzumSrQKB8m/6gWEZDgu0bgpA2RhF2DO959iwC3DP5N1yf8BKr2fuv5Xq4Yux6P4VHGYAMxqNJwZ5Yy885Yo2zOATk2xJfEQXDHd0yPmOnCPxZ0MAUFQV6WItKFY4cvm+3ybRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524529; c=relaxed/simple;
	bh=/VkEQEpKH1JVQQxbKFgpP/+YElPl3iPu3S/hdBxE4UI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yugfmvb/hMJSqeGD6C3yxhCWfbTHWP14B67sNA2a8IQnJNPY10Imz34qbLtEUPDS9HJV2zNyecLykw7V6Z9pkEIXl1SKl+097p6Tof8RrUBb5fikkyup1PrUYYiKNOZKnKCt/q++GHdux+WcVpW2vreLzI5WA6Aqrec/zzry+Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FAAA3dMA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FAAA3dMA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B5AC433F1;
	Wed, 21 Feb 2024 14:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524529;
	bh=/VkEQEpKH1JVQQxbKFgpP/+YElPl3iPu3S/hdBxE4UI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FAAA3dMAKpWzfrNMR2wiy5dbMywLIHHxRrcZ+IRdO46hXRosMLNZEOIGP4ppJptt3
	 8EKccbtqydh7ymc94hf1ogy/5BAjeO5m+SO1IgaeAVHBMDmsMGQxOQ7PAXs3NfcqJQ
	 4XyQ3jq0NJvt0uMTEljo9Vg2XGOTvTwacgHQbnnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Breno=20Leit=C3=A3o?= <leitao@debian.org>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 272/379] blk-iocost: Fix an UBSAN shift-out-of-bounds warning
Date: Wed, 21 Feb 2024 14:07:31 +0100
Message-ID: <20240221130002.954218784@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7ba7c4e4e4c9..63a8fb456b28 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1296,6 +1296,13 @@ static bool iocg_kick_delay(struct ioc_gq *iocg, struct ioc_now *now)
 
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



