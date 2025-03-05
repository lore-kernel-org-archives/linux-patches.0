Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8201113C67E;
	Wed,  5 Mar 2025 18:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198547; cv=none; b=gP2Xrz6ZFHoSR30EJUXtTT838cVRZKL0PhJtHilmYkaOpOoDpM7C/bdgl0QzYtTs0KwXcIuFN2Pi3PYAwinRYcuZeIysM2in2AxcfBvXEAvedzWe/o75yL/WqH3Ak2uccsS7e8yTQSgIc44Aw3b6K8mZ8R8zxA/xTJVxAoLmAys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198547; c=relaxed/simple;
	bh=6Gv3Rels/GjjFGoI2i3Z7/xwU1yf3gYihy9WRyKrt4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jREHEsDPjAb4CJOzZKykOLquajrFHDa2SDvcVjbw+QhyJy5lTnnWEoxKa6gr2+iGddLauamK0qUwILLtAlDnlIaHGSzY0NBMGihtkAtxJo0kKRW7Eue5efJS/NKDFGaFqD2WY8y9GAYqWTs1t0M7p/yJfg9Kv79qyAssul2uQc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nOvT+Zz4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nOvT+Zz4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BDF7C4CED1;
	Wed,  5 Mar 2025 18:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198547;
	bh=6Gv3Rels/GjjFGoI2i3Z7/xwU1yf3gYihy9WRyKrt4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nOvT+Zz4M9oetEOS6gNJqB3uDY+g2VSPPm1kSMQ0/7oYedxWCZxXisLWaiJoFjA8S
	 ZyGw7anBm8DEn2RpF++irJqyAQyIBEnW795lE2de0GMjNinQXdYj522orkGenAZAd6
	 2yl6hdFaWM/75+4p7j5nKS6q9+xS80htSG/xNQ84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu-Che Cheng <giver@chromium.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 066/157] thermal/of: Fix cdev lookup in thermal_of_should_bind()
Date: Wed,  5 Mar 2025 18:48:22 +0100
Message-ID: <20250305174507.957040702@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 423de5b5bc5b267586b449abd1c4fde562aa0cf9 ]

Since thermal_of_should_bind() terminates the loop after processing
the first child found in cooling-maps, it will never match more than
one cdev to a given trip point which is incorrect, as there may be
cooling-maps associating one trip point with multiple cooling devices.

Address this by letting the loop continue until either all
children have been processed or a matching one has been found.

To avoid adding conditionals or goto statements, put the loop in
question into a separate function and make that function return
right away after finding a matching cooling-maps entry.

Fixes: 94c6110b0b13 ("thermal/of: Use the .should_bind() thermal zone callback")
Link: https://lore.kernel.org/linux-pm/20250219-fix-thermal-of-v1-1-de36e7a590c4@chromium.org/
Reported-by: Yu-Che Cheng <giver@chromium.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Yu-Che Cheng <giver@chromium.org>
Tested-by: Yu-Che Cheng <giver@chromium.org>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Tested-by: Lukasz Luba <lukasz.luba@arm.com>
Link: https://patch.msgid.link/2788228.mvXUDI8C0e@rjwysocki.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_of.c | 50 +++++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 21 deletions(-)

diff --git a/drivers/thermal/thermal_of.c b/drivers/thermal/thermal_of.c
index 5ab4ce4daaebd..5401f03d6b6c1 100644
--- a/drivers/thermal/thermal_of.c
+++ b/drivers/thermal/thermal_of.c
@@ -274,6 +274,34 @@ static bool thermal_of_get_cooling_spec(struct device_node *map_np, int index,
 	return true;
 }
 
+static bool thermal_of_cm_lookup(struct device_node *cm_np,
+				 const struct thermal_trip *trip,
+				 struct thermal_cooling_device *cdev,
+				 struct cooling_spec *c)
+{
+	for_each_child_of_node_scoped(cm_np, child) {
+		struct device_node *tr_np;
+		int count, i;
+
+		tr_np = of_parse_phandle(child, "trip", 0);
+		if (tr_np != trip->priv)
+			continue;
+
+		/* The trip has been found, look up the cdev. */
+		count = of_count_phandle_with_args(child, "cooling-device",
+						   "#cooling-cells");
+		if (count <= 0)
+			pr_err("Add a cooling_device property with at least one device\n");
+
+		for (i = 0; i < count; i++) {
+			if (thermal_of_get_cooling_spec(child, i, cdev, c))
+				return true;
+		}
+	}
+
+	return false;
+}
+
 static bool thermal_of_should_bind(struct thermal_zone_device *tz,
 				   const struct thermal_trip *trip,
 				   struct thermal_cooling_device *cdev,
@@ -293,27 +321,7 @@ static bool thermal_of_should_bind(struct thermal_zone_device *tz,
 		goto out;
 
 	/* Look up the trip and the cdev in the cooling maps. */
-	for_each_child_of_node_scoped(cm_np, child) {
-		struct device_node *tr_np;
-		int count, i;
-
-		tr_np = of_parse_phandle(child, "trip", 0);
-		if (tr_np != trip->priv)
-			continue;
-
-		/* The trip has been found, look up the cdev. */
-		count = of_count_phandle_with_args(child, "cooling-device", "#cooling-cells");
-		if (count <= 0)
-			pr_err("Add a cooling_device property with at least one device\n");
-
-		for (i = 0; i < count; i++) {
-			result = thermal_of_get_cooling_spec(child, i, cdev, c);
-			if (result)
-				break;
-		}
-
-		break;
-	}
+	result = thermal_of_cm_lookup(cm_np, trip, cdev, c);
 
 	of_node_put(cm_np);
 out:
-- 
2.39.5



