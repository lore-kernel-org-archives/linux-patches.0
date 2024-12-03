Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85351F8AD2;
	Tue,  3 Dec 2024 15:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240338; cv=none; b=bWaLpv8sPajJUUSzr18bxn+9SbJP0NwU0bFSQ+LYJF0kpZmnXY4iT7+So1M9xyFlfoKAoqmfMi2/fpcHpH5+UwsKXlqg5Qj1G2OmoAvS8PKtT/t3PVsHVJLv9aD+OufStmT9CYSGaQnJ+YaPDX0GlhCRbb+OkWMXTIPTnb3JI/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240338; c=relaxed/simple;
	bh=9hj1VzRRmlWz9Pq/Qh1TxkKb8SE9lhuG7/Y502QWIo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OBZj7Q1SK4rdGqWAjunHVYewVnAvVoxsFt3uEYiKcEY3q/IBfo5TYHXtvVFEYD9Dud+JIZGUuSE8HRk+Xi1lj8JNxPRV1y3NwDA6viOhxCKtD4w1ThmeUl9pKiWMmrwrmK+3RvdH0BO5veOaIn5D15qHGkFp7sGvfqqf8n1N1bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Itm9BsqB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Itm9BsqB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E44C4CECF;
	Tue,  3 Dec 2024 15:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240338;
	bh=9hj1VzRRmlWz9Pq/Qh1TxkKb8SE9lhuG7/Y502QWIo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Itm9BsqBV29PvwJ7XiPLXv99ArfCiCSv+ncDimHArkbpgDKmqEcmEZEdB2pz6xEJY
	 KH+J2r8+45ouE0PK26VJCmPLhQ0E3QNrboJRl3GR1KXYh0jWjuaj3EDyiE/nXQl5F2
	 GCXaOYMN4tfWN2MyDbEOhO30CrxJs+ZfvrftYI9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 074/826] thermal: testing: Use DEFINE_FREE() and __free() to simplify code
Date: Tue,  3 Dec 2024 15:36:41 +0100
Message-ID: <20241203144746.358012017@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 1c426fd09ca85fb77f120f7933e39eb9df99a39a ]

Use DEFINE_FREE() to define a __free function for dropping thermal
zone template reference counters and use it along with __free() to
simplify code in some places.

No intentional functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/4628747.LvFx2qVVIh@rjwysocki.net
[ rjw: Add variable initialization to address compiler warning ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 0104dcdaad3a ("thermal: testing: Initialize some variables annoteded with _free()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/testing/zone.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/thermal/testing/zone.c b/drivers/thermal/testing/zone.c
index c6d8c66f40f98..452c3fa2b2bc5 100644
--- a/drivers/thermal/testing/zone.c
+++ b/drivers/thermal/testing/zone.c
@@ -310,6 +310,9 @@ static void tt_put_tt_zone(struct tt_thermal_zone *tt_zone)
 	tt_zone->refcount--;
 }
 
+DEFINE_FREE(put_tt_zone, struct tt_thermal_zone *,
+	    if (!IS_ERR_OR_NULL(_T)) tt_put_tt_zone(_T))
+
 static void tt_zone_add_trip_work_fn(struct work_struct *work)
 {
 	struct tt_work *tt_work = tt_work_of_work(work);
@@ -332,9 +335,9 @@ static void tt_zone_add_trip_work_fn(struct work_struct *work)
 
 int tt_zone_add_trip(const char *arg)
 {
+	struct tt_thermal_zone *tt_zone __free(put_tt_zone) = NULL;
 	struct tt_work *tt_work __free(kfree);
 	struct tt_trip *tt_trip __free(kfree);
-	struct tt_thermal_zone *tt_zone;
 	int id;
 
 	tt_work = kzalloc(sizeof(*tt_work), GFP_KERNEL);
@@ -350,10 +353,8 @@ int tt_zone_add_trip(const char *arg)
 		return PTR_ERR(tt_zone);
 
 	id = ida_alloc(&tt_zone->ida, GFP_KERNEL);
-	if (id < 0) {
-		tt_put_tt_zone(tt_zone);
+	if (id < 0)
 		return id;
-	}
 
 	tt_trip->trip.type = THERMAL_TRIP_ACTIVE;
 	tt_trip->trip.temperature = THERMAL_TEMP_INVALID;
@@ -366,7 +367,7 @@ int tt_zone_add_trip(const char *arg)
 	tt_zone->num_trips++;
 
 	INIT_WORK(&tt_work->work, tt_zone_add_trip_work_fn);
-	tt_work->tt_zone = tt_zone;
+	tt_work->tt_zone = no_free_ptr(tt_zone);
 	tt_work->tt_trip = no_free_ptr(tt_trip);
 	schedule_work(&(no_free_ptr(tt_work)->work));
 
@@ -425,23 +426,18 @@ static int tt_zone_register_tz(struct tt_thermal_zone *tt_zone)
 
 int tt_zone_reg(const char *arg)
 {
-	struct tt_thermal_zone *tt_zone;
-	int ret;
+	struct tt_thermal_zone *tt_zone __free(put_tt_zone);
 
 	tt_zone = tt_get_tt_zone(arg);
 	if (IS_ERR(tt_zone))
 		return PTR_ERR(tt_zone);
 
-	ret = tt_zone_register_tz(tt_zone);
-
-	tt_put_tt_zone(tt_zone);
-
-	return ret;
+	return tt_zone_register_tz(tt_zone);
 }
 
 int tt_zone_unreg(const char *arg)
 {
-	struct tt_thermal_zone *tt_zone;
+	struct tt_thermal_zone *tt_zone __free(put_tt_zone);
 
 	tt_zone = tt_get_tt_zone(arg);
 	if (IS_ERR(tt_zone))
@@ -449,8 +445,6 @@ int tt_zone_unreg(const char *arg)
 
 	tt_zone_unregister_tz(tt_zone);
 
-	tt_put_tt_zone(tt_zone);
-
 	return 0;
 }
 
-- 
2.43.0



