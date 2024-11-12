Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60599221FBF;
	Tue, 12 Nov 2024 10:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407843; cv=none; b=CYfX8u8C7GzLPNe5MKYKikMaXP0ZuGeYSKRJyXPMAmZvzpe24rChCAkSSYvPPmYBLX6LahWwZ+wx9yCLDzRpPSn2SHeHA2MJsSPcIKZz8c5jSypEde8SpvQayHlzsyKYrplAmy3rpo7nobcNUcCYg9sQSLJJsbc7Sup0cUw9iDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407843; c=relaxed/simple;
	bh=/xFYdUEoeugV8BbS9cmdsOvTvIfl49P36gaN2al2V58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G4AxSTXlBNXwdjPtIRSIvqCE28YodxKDqNkMXMdYVA9vG1X5RUbLmYhorDdq6TYUpcQgBK/HoExCSPTOjRslCa6WnSCOjJYMxbEDKiP+iQ/JSCSRv3iDyrIxFxQigtH+UN8Ock4DlfwgrRIU2Fk7mqVLFTgt0O7SJzKC2Tr/rsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jFrqf+gE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jFrqf+gE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02E5C4CECD;
	Tue, 12 Nov 2024 10:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407843;
	bh=/xFYdUEoeugV8BbS9cmdsOvTvIfl49P36gaN2al2V58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jFrqf+gEBIMcAcDlZH59D31p2U6AwYc4KbKb8LOIbKuYTfGy7eKRN1COkav9Z9RDc
	 FgB4d6KazdQL2CaA2ruuNkraV2y/de0QEUDh7+NPCQOyJxBpzbMUmT4DU7xKqO7Mz7
	 OBqc1mMeiNSskPiqCZW6AS1iC+wkxr/MBvZhz58s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <uwu@icenowy.me>,
	Chen-Yu Tsai <wenst@chromium.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 058/119] thermal/of: support thermal zones w/o trips subnode
Date: Tue, 12 Nov 2024 11:21:06 +0100
Message-ID: <20241112101850.934208764@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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
index d8dfcd49695d3..4e5f86c214561 100644
--- a/drivers/thermal/thermal_of.c
+++ b/drivers/thermal/thermal_of.c
@@ -126,18 +126,15 @@ static struct thermal_trip *thermal_of_trips_init(struct device_node *np, int *n
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
@@ -160,7 +157,6 @@ static struct thermal_trip *thermal_of_trips_init(struct device_node *np, int *n
 
 out_kfree:
 	kfree(tt);
-	*ntrips = 0;
 out_of_node_put:
 	of_node_put(trips);
 
@@ -498,11 +494,14 @@ static struct thermal_zone_device *thermal_of_zone_register(struct device_node *
 
 	trips = thermal_of_trips_init(np, &ntrips);
 	if (IS_ERR(trips)) {
-		pr_err("Failed to find trip points for %pOFn id=%d\n", sensor, id);
+		pr_err("Failed to parse trip points for %pOFn id=%d\n", sensor, id);
 		ret = PTR_ERR(trips);
 		goto out_kfree_of_ops;
 	}
 
+	if (!trips)
+		pr_info("No trip points found for %pOFn id=%d\n", sensor, id);
+
 	ret = thermal_of_monitor_init(np, &delay, &pdelay);
 	if (ret) {
 		pr_err("Failed to initialize monitoring delays from %pOFn\n", np);
-- 
2.43.0



