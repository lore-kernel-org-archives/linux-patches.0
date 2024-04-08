Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B6A7E111;
	Mon,  8 Apr 2024 13:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583478; cv=none; b=i4Cx1Q1JtNI2lIaqNWY0L0EsBvwFAcy1RGmls09/iuXpDczQlTeYuFJMvuZ1x0OXGBVN4GUBn6AREDOQjJAj7/DKDG3C6lChww8mYD8CZKOcb9nvj5QGBGO0Db4hL/S0dG0Hg0DBOTyAaSexrkmDB9Ubo+ZqlJsaUyXNnW4rtbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583478; c=relaxed/simple;
	bh=bmUR6TOBtMTHOwL/IuXJQEb11F4plyfDaEbWzGnb8C4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hGssZyAZYExLb5rkxQt09aw1Maurm3+W3/nHNbq8m3ORjQ2YCQ6eenYKFL7CpY2KpEDMqpmA9EyniMUSdxo/Y+Yv3QNvIJUsd+5PdpF0qnSdvxLsDgWqliqdAHWWK6WYUcvXzpS3GYp8O6Kq260nqy7E135pX9qmtMRoh3xk3KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LBdIBKfM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LBdIBKfM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2386CC433F1;
	Mon,  8 Apr 2024 13:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583478;
	bh=bmUR6TOBtMTHOwL/IuXJQEb11F4plyfDaEbWzGnb8C4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LBdIBKfM4TKZ2Hs+AZLpoLb8HZi8A2b92KcJ5qMZ8nB6F9feNw7Gikd+KNiPozyib
	 sM9WMhEA46BjIYUVqIfsLxkVSdmMh/n/ZmOV2SVPMXGCLbsuK3IqMOjIKpwlbLZI+q
	 WbE7yjy7cyeIxzDkFyKS9hTa9oMnl+z0XF572Uy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Travkin <nikita@trvn.ru>,
	Lukasz Luba <lukasz.luba@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 183/273] thermal: gov_power_allocator: Allow binding without trip points
Date: Mon,  8 Apr 2024 14:57:38 +0200
Message-ID: <20240408125314.969670696@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

From: Nikita Travkin <nikita@trvn.ru>

[ Upstream commit da781936e7c301e6197eb6513775748e79fb2575 ]

IPA probe function was recently refactored to perform extra error checks
and make sure the thermal zone has trip points necessary for the IPA
operation. With this change, if a thermal zone is probed such that it
has no trip points that IPA can use, IPA will fail and the TZ won't be
created. This is the case if a platform defines a TZ without cooling
devices and only with "hot"/"critical" trip points, often found on some
Qualcomm devices [1].

Documentation across IPA code (notably get_governor_trips() kerneldoc)
suggests that IPA is supposed to handle such TZ even if it won't
actually do anything.

This commit partially reverts the previous change to allow IPA to bind
to such "empty" thermal zones.

Fixes: e83747c2f8e3 ("thermal: gov_power_allocator: Set up trip points earlier")
Link: arch/arm64/boot/dts/qcom/sc7180.dtsi#n4776 # [1]
Signed-off-by: Nikita Travkin <nikita@trvn.ru>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/gov_power_allocator.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/thermal/gov_power_allocator.c b/drivers/thermal/gov_power_allocator.c
index 207a6a3936b54..38581583ad289 100644
--- a/drivers/thermal/gov_power_allocator.c
+++ b/drivers/thermal/gov_power_allocator.c
@@ -679,11 +679,6 @@ static int power_allocator_bind(struct thermal_zone_device *tz)
 		return -ENOMEM;
 
 	get_governor_trips(tz, params);
-	if (!params->trip_max) {
-		dev_warn(&tz->device, "power_allocator: missing trip_max\n");
-		kfree(params);
-		return -EINVAL;
-	}
 
 	ret = check_power_actors(tz, params);
 	if (ret < 0) {
@@ -712,9 +707,10 @@ static int power_allocator_bind(struct thermal_zone_device *tz)
 	if (!tz->tzp->sustainable_power)
 		dev_warn(&tz->device, "power_allocator: sustainable_power will be estimated\n");
 
-	estimate_pid_constants(tz, tz->tzp->sustainable_power,
-			       params->trip_switch_on,
-			       params->trip_max->temperature);
+	if (params->trip_max)
+		estimate_pid_constants(tz, tz->tzp->sustainable_power,
+				       params->trip_switch_on,
+				       params->trip_max->temperature);
 
 	reset_pid_controller(params);
 
-- 
2.43.0



