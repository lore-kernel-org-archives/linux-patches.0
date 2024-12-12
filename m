Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B72239BA7;
	Thu, 12 Dec 2024 16:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022021; cv=none; b=Fq2ta5YCEu5grxLbu+MGWav7Ff1uxKBUuq/SDpWjTZttbowzUZMvbQjUfKD+MsZlJpCSa6qopSJ7m/r7jJ48kLOgDU1DCy83ZXaIza4JsW9u04vcQTktHrSzvtjllK/OzLfPuvJFQBiM8bUHW+xrGjwmyU99k/emXP4eiTG+jkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022021; c=relaxed/simple;
	bh=xCIh2w3k1GIlncFtbuHXyQettovmlh086jhVakoncHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FF5Y7ASwJn5xd2/qI2meKM1reK+62bvcM7ycJbaHr6rq8Rk1uwokwUb4l7GLeoUT8nhUSm0qt/NjU7b7mQqVG7LAlXL1JnWmBBl3G1nYw5OFVRrPYkLc9HPw9UIYti9stkeIKvnDNibltUSyuAl3MkcRfd2SoRxn9X770Akc19o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZtJEWS7s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZtJEWS7s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56CCFC4CECE;
	Thu, 12 Dec 2024 16:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022020;
	bh=xCIh2w3k1GIlncFtbuHXyQettovmlh086jhVakoncHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZtJEWS7smtZXVuNT+HMJJkjrZmRtF5TYxoHfKyhzKfPIa4ZNbhSTGRYTxMMXiUPmf
	 vdvHN5JinYiPOn9iCq3PynWhCIjcmvYd3S4RKtJ9MQuSwFFzv+A3uVaeM/uVOwOsCg
	 hf7srj9jCqZ7ZPKmX0SfmUVokkFQIMAGIj9gDq+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 095/565] thermal: core: Initialize thermal zones before registering them
Date: Thu, 12 Dec 2024 15:54:50 +0100
Message-ID: <20241212144315.241222380@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 662f920f7e390db5d1a6792a2b0ffa59b6c962fc ]

Since user space can start interacting with a new thermal zone as soon
as device_register() called by thermal_zone_device_register_with_trips()
returns, it is better to initialize the thermal zone before calling
device_register() on it.

Fixes: d0df264fbd3c ("thermal/core: Remove pointless thermal_zone_device_reset() function")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/3336146.44csPzL39Z@rjwysocki.net
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index ce748e03e4331..bb3a4b6720362 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1271,6 +1271,7 @@ thermal_zone_device_register(const char *type, int num_trips, int mask,
 		thermal_zone_destroy_device_groups(tz);
 		goto remove_id;
 	}
+	thermal_zone_device_init(tz);
 	result = device_register(&tz->device);
 	if (result)
 		goto release_device;
@@ -1313,7 +1314,6 @@ thermal_zone_device_register(const char *type, int num_trips, int mask,
 
 	INIT_DELAYED_WORK(&tz->poll_queue, thermal_zone_device_check);
 
-	thermal_zone_device_init(tz);
 	/* Update the new thermal zone and mark it as already updated. */
 	if (atomic_cmpxchg(&tz->need_update, 1, 0))
 		thermal_zone_device_update(tz, THERMAL_EVENT_UNSPECIFIED);
-- 
2.43.0



