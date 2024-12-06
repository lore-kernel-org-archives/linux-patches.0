Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB8F149E0E;
	Fri,  6 Dec 2024 14:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496712; cv=none; b=r77l+wGgWF+n7q9ijgdH7FV5dvG0lwHY/RXUwTHC6oaQhRSW9PLXbrA4ls1PwxVdFcjihx53dXrhutMLQBF2keR0grjz39xGiT9qOHn1bG7ssPqaqaY7ASP/LzGPW+qZQqHUYLpexnhrV5yxBI78OAs1uMs43yV89bV6NOatAqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496712; c=relaxed/simple;
	bh=RxIWZKxopvEm9LRXgDvuRW+3F/plREYZ47dBYJcGZzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XaAUNbH5tUmIyctiXRedLozimFrfrabaJ9xBZ6zmGd+zfpKVXJw/1stkeoBJNd/inF6Eo24FJHeKRfyTlC5WTyZydHradIJGGMzMHmSjv9KuyE7znnt7djXWgLpNEggKbRctdsy2PBDE1Fah5P5pwB55/qKDSbCzRX5uVvDJEys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=crnoprZn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="crnoprZn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10042C4CED1;
	Fri,  6 Dec 2024 14:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496712;
	bh=RxIWZKxopvEm9LRXgDvuRW+3F/plREYZ47dBYJcGZzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=crnoprZnzOwL3RUU2/LzQTnnq/gjDT2WnTFpZgvx2MdKa/D6lT+YvMMDBAzd7G/c7
	 UnEZrdd9gLGZCZD//O0kCvXBl5CaJjbZkbFucesRofLmEFyeAXbkDSArymkCf7LLPD
	 2w/zIIymnlPd/KaeE8+peqSL+MUv0msVtGB3kZ9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 083/676] thermal: core: Initialize thermal zones before registering them
Date: Fri,  6 Dec 2024 15:28:22 +0100
Message-ID: <20241206143656.606630820@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d7ac7eef680e1..dad909547179f 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1336,6 +1336,7 @@ thermal_zone_device_register_with_trips(const char *type, struct thermal_trip *t
 		thermal_zone_destroy_device_groups(tz);
 		goto remove_id;
 	}
+	thermal_zone_device_init(tz);
 	result = device_register(&tz->device);
 	if (result)
 		goto release_device;
@@ -1381,7 +1382,6 @@ thermal_zone_device_register_with_trips(const char *type, struct thermal_trip *t
 
 	INIT_DELAYED_WORK(&tz->poll_queue, thermal_zone_device_check);
 
-	thermal_zone_device_init(tz);
 	/* Update the new thermal zone and mark it as already updated. */
 	if (atomic_cmpxchg(&tz->need_update, 1, 0))
 		thermal_zone_device_update(tz, THERMAL_EVENT_UNSPECIFIED);
-- 
2.43.0



