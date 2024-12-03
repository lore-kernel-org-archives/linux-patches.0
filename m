Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E69C1F666B;
	Tue,  3 Dec 2024 14:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237894; cv=none; b=ChOeFeTzEf7syQmE7M6EfEj80fWk8mGWjfV9K5f3IRxJ2sz+SViEb5mS2BlX+aHK+2mvdR/Oak/QDhzIgV7ux34mKQUwft6Bfn9eqhrmqNJgV4Vz8mV5H4GQJTPDdfoQqu3wkMmBarRL4z4rfRFT59CqSOSmWp0kqlDYdkKsjyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237894; c=relaxed/simple;
	bh=E3v6c/Kp9frBe+Zzcu16Jug+RqY0ygy2pZagO8mtT9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JQex58Q1+BBTtn9CeCqLskdnApWLLcyczfmkfoqFTdzRYNvNW8kHz8zLV5KTaH4FrwYja1r/Z1t8fd0WJg3fR7Zv6Z0JEJGUtwBirIQ+4t5ZbISAsbvlUFa2vS1zJCBQST6ey1oXT9+gzPTBWp6GfzZzX/h1Eupct1XyP40geAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xd0368x/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xd0368x/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECDE0C4CECF;
	Tue,  3 Dec 2024 14:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237894;
	bh=E3v6c/Kp9frBe+Zzcu16Jug+RqY0ygy2pZagO8mtT9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xd0368x/MaTqj3oIDA+Ee8iGZJy4hlRzAfHVBHfc7IxP35ImtWRPt5A5BHV1FCYec
	 X6dMDqcy2ELrx/WeKn7zyXA+B/mfPqQKVt18lZA0ryI1g2mfJ7XpM7Fk3ODjAjQpra
	 1QrkdYogDBuT50D7G6ohtUykvWYWeQo6WZ5GMjmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 098/817] thermal: core: Initialize thermal zones before registering them
Date: Tue,  3 Dec 2024 15:34:30 +0100
Message-ID: <20241203143959.531116184@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 795be67ca878b..2f9128cf55e92 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1498,6 +1498,7 @@ thermal_zone_device_register_with_trips(const char *type,
 		thermal_zone_destroy_device_groups(tz);
 		goto remove_id;
 	}
+	thermal_zone_device_init(tz);
 	result = device_register(&tz->device);
 	if (result)
 		goto release_device;
@@ -1543,7 +1544,6 @@ thermal_zone_device_register_with_trips(const char *type,
 
 	mutex_unlock(&thermal_list_lock);
 
-	thermal_zone_device_init(tz);
 	/* Update the new thermal zone and mark it as already updated. */
 	if (atomic_cmpxchg(&tz->need_update, 1, 0))
 		thermal_zone_device_update(tz, THERMAL_EVENT_UNSPECIFIED);
-- 
2.43.0



