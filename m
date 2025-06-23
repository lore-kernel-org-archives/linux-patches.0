Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E17347DD;
	Mon, 23 Jun 2025 13:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686132; cv=none; b=dPZWRMu+vwJRBAXIVUSx79Bz1HSExrJHE/PppCjeN+rfasfmv3Q3bAaOoDKlzJJhKWYCDPW055sBgWybp9gfagiFeEkmBcPmVpHYVSeuhlcI6o7IKE5wwUhfYMoEc63EYN4ldEx0og+rhr3vxl66zLQQYC3xe8l90NyjB+IspBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686132; c=relaxed/simple;
	bh=II8ytU23JHN9MABiHzk4HsA01Z/rOG2b7qrMT/JV3Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TvyK4dvhINOnZZEWd3Txn9g4Iba9GiIaEDxkguOe0RED/z3BSPXXsznGf8E6+n5GJhZoBCxDz+K6wXzgIEDx+OvHfSov/G6Byhsnv/k3kyfeC5EKYfaC2o76mnWFAmeQcjYiHrWAV1FCLrzJNbj735saY52Ujn0sWaAbQlcjQ6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HJ6hvTGz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HJ6hvTGz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB428C4CEF1;
	Mon, 23 Jun 2025 13:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686132;
	bh=II8ytU23JHN9MABiHzk4HsA01Z/rOG2b7qrMT/JV3Rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HJ6hvTGz7pq+d8tI2x5+PfcNwZFINBV1SYPRG82TUbVCoS6zysWlEU6NJgmC6kEPo
	 D/Ps5nSp5+wmFJxnFeHMqZVxPMqezrudvaV/TJegUFtiCQ2I2avHN5VEvmusPzqnIH
	 oqjSjT/spyQ5OZVLhs7fYBa5T11vJP3uldYD7GOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrick Daly <quic_pdaly@quicinc.com>,
	Charan Teja Kalla <quic_charante@quicinc.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 139/222] PM: runtime: fix denying of auto suspend in pm_suspend_timer_fn()
Date: Mon, 23 Jun 2025 15:07:54 +0200
Message-ID: <20250623130616.272714709@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index d301a6de762df..7fa231076ad5f 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -982,7 +982,7 @@ static enum hrtimer_restart  pm_suspend_timer_fn(struct hrtimer *timer)
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



