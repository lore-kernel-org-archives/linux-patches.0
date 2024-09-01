Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CC633987;
	Sun,  1 Sep 2024 16:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208014; cv=none; b=YxlgUgxl/5JWonc+lLIFquP0PqjmDwOX7bRSPL8rBTobVn9bm/w3cNEAGm6Afd3J8o2cy4veTKAsXlduRWRq+ZtGSm+UdIWQ4UQ0xtuTKJpzzWPRyQuugUYgsJr0bBjYrLBEIl3Wn4tC37sT3OahX1CUyawbfglYC6aOblUHayU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208014; c=relaxed/simple;
	bh=ggAOvFXRdg9mBIzIRPFDVXL401cz5ncV7jPIbjEVVp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0P/XLVUA5HsOlHyv6Qx5BvtTGmMP11GLtuoUSyoq2xlywiMbWNB/KG9kNJ6dJw47jXbucCB/IjFOVdfwekaHiG9ds8Urfe2Sg72ahaXiVfbi7d0RDt+rte5Lhwim6ak9xIyjtjBN8Gtb5xT6bDmi8OjjrVPKBcm1viScDdyq2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wmJHl5f0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wmJHl5f0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00129C4CEC3;
	Sun,  1 Sep 2024 16:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208014;
	bh=ggAOvFXRdg9mBIzIRPFDVXL401cz5ncV7jPIbjEVVp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wmJHl5f0P7sJHpMzfEZ2AvuvaoGxnZ1DloIYeZbv7E01ICBJ1IzGiOsxyB91o7mzf
	 CpKT+zqIHER/vBRYyevBub3REEas01BDQjeYGB0lWHtLz+McPJ6d1XyDinczJgce/x
	 ueako/nyQY8J7bqKPRrOIoOUEyb1M/uOwOmAUgI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 30/93] thermal: of: Fix OF node leak in thermal_of_trips_init() error path
Date: Sun,  1 Sep 2024 18:16:17 +0200
Message-ID: <20240901160808.494274932@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit afc954fd223ded70b1fa000767e2531db55cce58 ]

Terminating for_each_child_of_node() loop requires dropping OF node
reference, so bailing out after thermal_of_populate_trip() error misses
this.  Solve the OF node reference leak with scoped
for_each_child_of_node_scoped().

Fixes: d0c75fa2c17f ("thermal/of: Initialize trip points separately")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://patch.msgid.link/20240814195823.437597-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_of.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/thermal_of.c b/drivers/thermal/thermal_of.c
index d5174f11b91c2..e7d25e70fb93e 100644
--- a/drivers/thermal/thermal_of.c
+++ b/drivers/thermal/thermal_of.c
@@ -123,7 +123,7 @@ static int thermal_of_populate_trip(struct device_node *np,
 static struct thermal_trip *thermal_of_trips_init(struct device_node *np, int *ntrips)
 {
 	struct thermal_trip *tt;
-	struct device_node *trips, *trip;
+	struct device_node *trips;
 	int ret, count;
 
 	trips = of_get_child_by_name(np, "trips");
@@ -148,7 +148,7 @@ static struct thermal_trip *thermal_of_trips_init(struct device_node *np, int *n
 	*ntrips = count;
 
 	count = 0;
-	for_each_child_of_node(trips, trip) {
+	for_each_child_of_node_scoped(trips, trip) {
 		ret = thermal_of_populate_trip(trip, &tt[count++]);
 		if (ret)
 			goto out_kfree;
-- 
2.43.0



