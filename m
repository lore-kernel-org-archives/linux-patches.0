Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B1E412276;
	Sat, 12 Sep 2026 11:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212130; cv=none; b=SOITLC8y7H2lXHR7o4w2jdHhhq03sKbszFeXQPIEf1AOg4mI/F/wA4oqOftypMD7MJKCLbRoRTgqU43DmutD5CPrY+vzl5y7XtjLcmHe3YqkbSWixgYH3tMD4wEKdxas/87Q+gVCfaZ7u/rmJtU702x4lYqmuM0jmVNx3dg1e0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212130; c=relaxed/simple;
	bh=FKHWJSOqYjHrx7ys+obctplGfeMqSyh3sbCq/pSxZgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CVE2Hcz4ODTvGFy0doVnYeDbezNWAWp/hdH4NgeXtCB1HuFGy4+vAYvni2Xg8tY4pHuI2ai8on2t+PEDuimuRC+ycoyn7Un23Xbhvjv9o93vKhm/uleY9k4yuczjkvAH5DomR/zuRg7hZhQSocrYwEFTxUanC8ZDurYuM65wrFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=guC+Aio4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="guC+Aio4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7731F000FF;
	Sat, 12 Sep 2026 11:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212128;
	bh=fQ2ZRVTjKuFUa7ssUvYbVR7KKp4AzwU4fiZqvNfqncQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=guC+Aio4no/rGTPeZiVyrQcAdngIdpzZ9NKkdDJ3KeuLJ/6yIJztjyafREwWNr6Gq
	 X3HWdbnYyU5U8LMBv9akd0IncuPzpc9pC9qiIioOibPUssnXhUM+tutU2bJmQVk3ju
	 hl5rDLXs/8yzKuMnXbJqgWWlmBO3y246VH7vY7GI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1371/1518] ptp: netc: fix period truncation and potential divide-by-zero in PEROUT
Date: Sat, 12 Sep 2026 08:59:00 +0200
Message-ID: <20260912065654.558317336@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit 777dbc9914b2f003f1d44af80c7a4a395c5961b2 ]

The max_period bound in net_timer_enable_perout() was computed as:

  max_period = (u64)NETC_TMR_DEFAULT_FIPER + integral_period;

which exceeds U32_MAX when integral_period > 0 (e.g. 0x100000002 for
the default 333333333 Hz clock). A period_ns that passes this check but
exceeds U32_MAX is then silently truncated when stored into the u32
struct netc_pp::period field.

A truncated value of zero can reach netc_timer_set_perout_alarm(), where
the local u32 period variable would also be 0, causing a divide-by-zero
in roundup_u64(delta, period) whenever the stime < min_time branch is
taken (which always happens for a start time of {0, 0}).

Additionally, netc_timer_enable_periodic_pulse() and
netc_timer_enable_fiper() both compute:

  fiper = pp->period - integral_period;

A zero pp->period results in an unsigned wraparound to 0xFFFFFFFD,
mis-programming the FIPER hardware register.

Fix all three issues by capping max_period at NETC_TMR_DEFAULT_FIPER
(0xFFFFFFFF). This ensures that any period_ns passing the range check
fits in a u32 without truncation, so the stored value is always valid
and non-zero. The accepted range is reduced by integral_period ns
(typically only a few nanoseconds), which is negligible in practice.

Fixes: 671e266835b8 ("ptp: netc: add periodic pulse output support")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260821032449.1235065-1-wei.fang@oss.nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_netc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/ptp/ptp_netc.c b/drivers/ptp/ptp_netc.c
index 59db08e189e6e..19ca99d80e95b 100644
--- a/drivers/ptp/ptp_netc.c
+++ b/drivers/ptp/ptp_netc.c
@@ -440,7 +440,7 @@ static int net_timer_enable_perout(struct netc_timer *priv,
 	}
 
 	if (on) {
-		u64 period_ns, gclk_period, max_period, min_period;
+		u64 period_ns, gclk_period, min_period;
 		struct timespec64 period, stime;
 		u32 integral_period;
 		int alarm_id;
@@ -450,12 +450,12 @@ static int net_timer_enable_perout(struct netc_timer *priv,
 		period_ns = timespec64_to_ns(&period);
 
 		integral_period = netc_timer_get_integral_period(priv);
-		max_period = (u64)NETC_TMR_DEFAULT_FIPER + integral_period;
 		gclk_period = netc_timer_get_gclk_period(priv);
 		min_period = gclk_period * 4 + integral_period;
-		if (period_ns > max_period || period_ns < min_period) {
-			dev_err(dev, "The period range is %llu ~ %llu\n",
-				min_period, max_period);
+		if (period_ns > NETC_TMR_DEFAULT_FIPER ||
+		    period_ns < min_period) {
+			dev_err(dev, "The period range is %llu ~ %lu\n",
+				min_period, NETC_TMR_DEFAULT_FIPER);
 			err = -EINVAL;
 			goto unlock_spinlock;
 		}
-- 
2.53.0



