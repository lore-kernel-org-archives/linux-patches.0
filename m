Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BAE374C4;
	Tue,  8 Apr 2025 11:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110828; cv=none; b=mI0hzFO3og0v09VpXtUF+Ax8hp4IIB4PMVAMAzKt1jnmWeHI/8ULRlqc0IHPwFdlJ5TwylwOQrfOJJT79gHRS6ia1hsJksrI41TfPJ490xag8iDGgWnFcesTeoh85NwPaK6U4zPAEuB93g4XbH6fyGjXhLSUgnf0M1eTe5uXvic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110828; c=relaxed/simple;
	bh=H9YBT/R2I+qrQq9/mTQDr5mO6VKOqNRqGDjSdu2JL2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IismqQC+b77yv839LvLXg9QQM543rP3eU6tiaTq6SERhZZFEKE4D+sIsuf0FUDLsW3vcS/PeOTvnixQrgPrxOVsiaXK+PFlW58vjLJ0WyfsP4mE4S2Tu/8sOIOibeIlnsJ1Zp0evZKNZ1OmKylgi6CbTkORz8A8HVxgpnrfTTAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hzg5RwrM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hzg5RwrM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8D0C4CEE5;
	Tue,  8 Apr 2025 11:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110828;
	bh=H9YBT/R2I+qrQq9/mTQDr5mO6VKOqNRqGDjSdu2JL2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hzg5RwrMF5KQ0zTTedfP6NySmNH+cmAmIBaUp62hNZVjV9lyDBMg7izvFhiCpFEuY
	 iVPc3JrdgeJjmdjiLg7dtVabsDEoMIP++AvzNcdFQSIJPnKEV/vQEJ7YYewbwwzbyX
	 hkvzihVz9fzZlL77RCxg1kx6N72O4CPVddwLBMos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Kolacinski <karol.kolacinski@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.14 207/731] ice: ensure periodic output start time is in the future
Date: Tue,  8 Apr 2025 12:41:44 +0200
Message-ID: <20250408104919.095539592@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

From: Karol Kolacinski <karol.kolacinski@intel.com>

[ Upstream commit 53ce7166cbffd2b8f3bd821fd3918be665afd4c6 ]

On E800 series hardware, if the start time for a periodic output signal is
programmed into GLTSYN_TGT_H and GLTSYN_TGT_L registers, the hardware logic
locks up and the periodic output signal never starts. Any future attempt to
reprogram the clock function is futile as the hardware will not reset until
a power on.

The ice_ptp_cfg_perout function has logic to prevent this, as it checks if
the requested start time is in the past. If so, a new start time is
calculated by rounding up.

Since commit d755a7e129a5 ("ice: Cache perout/extts requests and check
flags"), the rounding is done to the nearest multiple of the clock period,
rather than to a full second. This is more accurate, since it ensures the
signal matches the user request precisely.

Unfortunately, there is a race condition with this rounding logic. If the
current time is close to the multiple of the period, we could calculate a
target time that is extremely soon. It takes time for the software to
program the registers, during which time this requested start time could
become a start time in the past. If that happens, the periodic output
signal will lock up.

For large enough periods, or for the logic prior to the mentioned commit,
this is unlikely. However, with the new logic rounding to the period and
with a small enough period, this becomes inevitable.

For example, attempting to enable a 10MHz signal requires a period of 100
nanoseconds. This means in the *best* case, we have 99 nanoseconds to
program the clock output. This is essentially impossible, and thus such a
small period practically guarantees that the clock output function will
lock up.

To fix this, add some slop to the clock time used to check if the start
time is in the past. Because it is not critical that output signals start
immediately, but it *is* critical that we do not brick the function, 0.5
seconds is selected. This does mean that any requested output will be
delayed by at least 0.5 seconds.

This slop is applied before rounding, so that we always round up to the
nearest multiple of the period that is at least 0.5 seconds in the future,
ensuring a minimum of 0.5 seconds to program the clock output registers.

Finally, to ensure that the hardware registers programming the clock output
complete in a timely manner, add a write flush to the end of
ice_ptp_write_perout. This ensures we don't risk any issue with PCIe
transaction batching.

Strictly speaking, this fixes a race condition all the way back at the
initial implementation of periodic output programming, as it is
theoretically possible to trigger this bug even on the old logic when
always rounding to a full second. However, the window is narrow, and the
code has been refactored heavily since then, making a direct backport not
apply cleanly.

Fixes: d755a7e129a5 ("ice: Cache perout/extts requests and check flags")
Signed-off-by: Karol Kolacinski <karol.kolacinski@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index e26320ce52ca1..a99e0fbd0b8b5 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1783,6 +1783,7 @@ static int ice_ptp_write_perout(struct ice_hw *hw, unsigned int chan,
 				  8 + chan + (tmr_idx * 4));
 
 	wr32(hw, GLGEN_GPIO_CTL(gpio_pin), val);
+	ice_flush(hw);
 
 	return 0;
 }
@@ -1843,9 +1844,10 @@ static int ice_ptp_cfg_perout(struct ice_pf *pf, struct ptp_perout_request *rq,
 		div64_u64_rem(start, period, &phase);
 
 	/* If we have only phase or start time is in the past, start the timer
-	 * at the next multiple of period, maintaining phase.
+	 * at the next multiple of period, maintaining phase at least 0.5 second
+	 * from now, so we have time to write it to HW.
 	 */
-	clk = ice_ptp_read_src_clk_reg(pf, NULL);
+	clk = ice_ptp_read_src_clk_reg(pf, NULL) + NSEC_PER_MSEC * 500;
 	if (rq->flags & PTP_PEROUT_PHASE || start <= clk - prop_delay_ns)
 		start = div64_u64(clk + period - 1, period) * period + phase;
 
-- 
2.39.5



