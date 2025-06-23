Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F6419049B;
	Mon, 23 Jun 2025 21:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715653; cv=none; b=OcqFRKLqDIZmiD5Wq7yPbDWfqKFQUTve9Bbb5SlVr+GtqCK7X+cvZfQgB92Z0JtHsdY+KEa/jn+U8SwDE4vm1M+N9yNXmPAYD0UP75B1t27rNa1PCRxQ0aDQKVmJA3dcvomDkwyATielt6vdBC1YxvxSWbU1rVpouszNdHDdeeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715653; c=relaxed/simple;
	bh=VpV/B24rbf1Xjm7T7fcTbIDWN00VhhYeNZ4qwWoh8xU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zdx64/a5Qlk0lTDOAhumZdG8p+ndN9n8zvsIW5KxQQ+2xeQVy18OwZmJ/cK/EK27uzjPisNW94HZ+yUZb1Y10nx9yXzNKFA7lBuJtJwBT2Iux6POmz55aQN8crzFH92A+CpktHer+gGHvuyH70mNepKofzSkRkB78trcDRSLexU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sVRlF/aS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sVRlF/aS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D98AFC4CEEA;
	Mon, 23 Jun 2025 21:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715653;
	bh=VpV/B24rbf1Xjm7T7fcTbIDWN00VhhYeNZ4qwWoh8xU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sVRlF/aSoxSL6q+jTjw1J8UJoDJ9ih32IQT/MNuCOIY+3EXRLX5PJAARtwIJ6bDv+
	 JwKoTo5zgL8xvzOwAkLL72ED+9WXRqRcBN3mhONuYSvBSKY8vZ3NL+v5gJYr9pHWUO
	 TcXfmGjKYlpPMm7XOZK9p5DPHlAUfr+1lENbu4DU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrick Daly <quic_pdaly@quicinc.com>,
	Charan Teja Kalla <quic_charante@quicinc.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 270/411] PM: runtime: fix denying of auto suspend in pm_suspend_timer_fn()
Date: Mon, 23 Jun 2025 15:06:54 +0200
Message-ID: <20250623130640.451742024@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charan Teja Kalla <quic_charante@quicinc.com>

[ Upstream commit 40d3b40dce375d6f1c1dbf08d79eed3aed6c691d ]

pm_runtime_put_autosuspend() schedules a hrtimer to expire
at "dev->power.timer_expires". If the hrtimer's callback,
pm_suspend_timer_fn(), observes that the current time equals
"dev->power.timer_expires", it unexpectedly bails out instead of
proceeding with runtime suspend.

pm_suspend_timer_fn():

 if (expires > 0 && expires < ktime_get_mono_fast_ns()) {
 	dev->power.timer_expires = 0;
 	rpm_suspend(..)
 }

Additionally, as ->timer_expires is not cleared, all the future auto
suspend requests will not schedule hrtimer to perform auto suspend.

rpm_suspend():

 if ((rpmflags & RPM_AUTO) &&...) {
 	if (!(dev->power.timer_expires && ...) { <-- this will fail.
 		hrtimer_start_range_ns(&dev->power.suspend_timer,...);
 	}
 }

Fix this by as well checking if current time reaches the set expiration.

Co-developed-by: Patrick Daly <quic_pdaly@quicinc.com>
Signed-off-by: Patrick Daly <quic_pdaly@quicinc.com>
Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
Link: https://patch.msgid.link/20250515064125.1211561-1-quic_charante@quicinc.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/runtime.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index edee7f1af1cec..35e1a090ef901 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -996,7 +996,7 @@ static enum hrtimer_restart  pm_suspend_timer_fn(struct hrtimer *timer)
 	 * If 'expires' is after the current time, we've been called
 	 * too early.
 	 */
-	if (expires > 0 && expires < ktime_get_mono_fast_ns()) {
+	if (expires > 0 && expires <= ktime_get_mono_fast_ns()) {
 		dev->power.timer_expires = 0;
 		rpm_suspend(dev, dev->power.timer_autosuspends ?
 		    (RPM_ASYNC | RPM_AUTO) : RPM_ASYNC);
-- 
2.39.5



