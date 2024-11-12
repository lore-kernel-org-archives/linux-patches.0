Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0484212F00;
	Tue, 12 Nov 2024 10:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408138; cv=none; b=MOY2Zn7CTG2c5hrnXiSngfwtxSldbbSgLAZOJP+i0TjsJ9E0VlALjd3X0oOq1wdlGbGYWPbgxdHVemhPJxwdFoV7AsGYFLJupqEujjpDG3zHLPRUoZTZ9HYnS9C8pQsvT2zrepbxQGJw06Cses3yqE6KwFzCqXczLS0Ibj9Gx0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408138; c=relaxed/simple;
	bh=LCtpqBdZLhct2mL7dLczLsD88r0dPv7sry1V72LbFw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hj+BkRNaUaoH+GhzLmy+lJao4nFz0U6grN6CEugtijH+NA/VmpJ5VS3wEm5Pwq1VwZUZxRvR+vgstasG7BLkjQ4r6J09r5oglsHz+CGq0qz9xoWxfu+QsvDKZC/2IglsXQG7xR9ZrXBiodwkhBrICmB0dJkPuEDA/pCAKBFRFMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nMyHx7Wb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nMyHx7Wb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F56C4CECD;
	Tue, 12 Nov 2024 10:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408137;
	bh=LCtpqBdZLhct2mL7dLczLsD88r0dPv7sry1V72LbFw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nMyHx7WbxebE0TjJEmuE/5wdwjxydcS2hMUWeuKkGDuvOZm91QDBjzrw+Zgm390/K
	 2plSRXUcuje8L9oROUTTjSyB6MKdeqA3Uw5iSalYRYLIILzkmahM9EpDcA5hMveoOa
	 xIScD5IkXHSK6x4I146qqPhDi3l7JDGgc/mwgp6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <uwu@icenowy.me>,
	Chen-Yu Tsai <wenst@chromium.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 072/184] thermal/of: support thermal zones w/o trips subnode
Date: Tue, 12 Nov 2024 11:20:30 +0100
Message-ID: <20241112101903.627556396@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

From: Icenowy Zheng <uwu@icenowy.me>

[ Upstream commit 725f31f300e300a9d94976bd8f1db6e746f95f63 ]

Although the current device tree binding of thermal zones require the
trips subnode, the binding in kernel v5.15 does not require it, and many
device trees shipped with the kernel, for example,
allwinner/sun50i-a64.dtsi and mediatek/mt8183-kukui.dtsi in ARM64, still
comply to the old binding and contain no trips subnode.

Allow the code to successfully register thermal zones w/o trips subnode
for DT binding compatibility now.

Furtherly, the inconsistency between DTs and bindings should be resolved
by either adding empty trips subnode or dropping the trips subnode
requirement.

Fixes: d0c75fa2c17f ("thermal/of: Initialize trip points separately")
Signed-off-by: Icenowy Zheng <uwu@icenowy.me>
[wenst@chromium.org: Reworked logic and kernel log messages]
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Rafael J. Wysocki <rafael@kernel.org>
Link: https://lore.kernel.org/r/20241018073139.1268995-1-wenst@chromium.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_of.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/thermal/thermal_of.c b/drivers/thermal/thermal_of.c
index 1f252692815a1..0cbdc35d45007 100644
--- a/drivers/thermal/thermal_of.c
+++ b/drivers/thermal/thermal_of.c
@@ -128,18 +128,15 @@ static struct thermal_trip *thermal_of_trips_init(struct device_node *np, int *n
 	struct device_node *trips;
 	int ret, count;
 
+	*ntrips = 0;
+	
 	trips = of_get_child_by_name(np, "trips");
-	if (!trips) {
-		pr_err("Failed to find 'trips' node\n");
-		return ERR_PTR(-EINVAL);
-	}
+	if (!trips)
+		return NULL;
 
 	count = of_get_child_count(trips);
-	if (!count) {
-		pr_err("No trip point defined\n");
-		ret = -EINVAL;
-		goto out_of_node_put;
-	}
+	if (!count)
+		return NULL;
 
 	tt = kzalloc(sizeof(*tt) * count, GFP_KERNEL);
 	if (!tt) {
@@ -162,7 +159,6 @@ static struct thermal_trip *thermal_of_trips_init(struct device_node *np, int *n
 
 out_kfree:
 	kfree(tt);
-	*ntrips = 0;
 out_of_node_put:
 	of_node_put(trips);
 
@@ -491,11 +487,14 @@ static struct thermal_zone_device *thermal_of_zone_register(struct device_node *
 
 	trips = thermal_of_trips_init(np, &ntrips);
 	if (IS_ERR(trips)) {
-		pr_err("Failed to find trip points for %pOFn id=%d\n", sensor, id);
+		pr_err("Failed to parse trip points for %pOFn id=%d\n", sensor, id);
 		ret = PTR_ERR(trips);
 		goto out_of_node_put;
 	}
 
+	if (!trips)
+		pr_info("No trip points found for %pOFn id=%d\n", sensor, id);
+
 	ret = thermal_of_monitor_init(np, &delay, &pdelay);
 	if (ret) {
 		pr_err("Failed to initialize monitoring delays from %pOFn\n", np);
-- 
2.43.0



