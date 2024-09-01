Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C083186611;
	Sun,  1 Sep 2024 16:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209191; cv=none; b=bjdOjrAMZuy5BiY0eyiunhkQ+saV0lErc5wUK7CuQ8putGsSwtDptcGn4MKyi+lYvA3ZptzhzCH1cw9WAcs7eR69RfQCRgc2TKsr+Fsfdx+NRILS9skgjfz4whw3Ga2iMd3QePGyXQP7bxWFIQm30w51UeaT4bpTCmkAGJAf7jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209191; c=relaxed/simple;
	bh=DhLCpcZbUCcEzdq0TFpi9ioDLhVV1JseRrEtVHpOS9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u35xFQclPP5eY7dm2nYZbbJNX+WOKTGkLUezQErzBSY1NJPUaO6hb8O/R41r1y4s8oVTyKIXIymr2maYtg+UNYIpYigI3pQI0Y3KvvU+dyl2p8RY2z7Co0HIjD61UXOX1pPLV0ZkLMEylucpmt069QxdiQtKymn6CICv3OFLhOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=euFcleQt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="euFcleQt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E808AC4CEC3;
	Sun,  1 Sep 2024 16:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209190;
	bh=DhLCpcZbUCcEzdq0TFpi9ioDLhVV1JseRrEtVHpOS9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=euFcleQt99I0PO11oYwTbqCU4VmLlhmwymXQMyPQTy9y+xlVvXetqqJOujlOy8aex
	 a83aUus2KM/S3tsohF1Z6SvK5s6u1aPlsHaciK3bKeyrCkXE4Hc3AUPwnjO7/m0VBK
	 QVh3iIQ+5ZFSRttXsHJ/F1wJChKX12KrUa5qFF8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 29/71] thermal: of: Fix OF node leak in thermal_of_trips_init() error path
Date: Sun,  1 Sep 2024 18:17:34 +0200
Message-ID: <20240901160802.989936037@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
References: <20240901160801.879647959@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 202dce0d2e309..62099ffcd9721 100644
--- a/drivers/thermal/thermal_of.c
+++ b/drivers/thermal/thermal_of.c
@@ -235,7 +235,7 @@ static int thermal_of_populate_trip(struct device_node *np,
 static struct thermal_trip *thermal_of_trips_init(struct device_node *np, int *ntrips)
 {
 	struct thermal_trip *tt;
-	struct device_node *trips, *trip;
+	struct device_node *trips;
 	int ret, count;
 
 	trips = of_get_child_by_name(np, "trips");
@@ -260,7 +260,7 @@ static struct thermal_trip *thermal_of_trips_init(struct device_node *np, int *n
 	*ntrips = count;
 
 	count = 0;
-	for_each_child_of_node(trips, trip) {
+	for_each_child_of_node_scoped(trips, trip) {
 		ret = thermal_of_populate_trip(trip, &tt[count++]);
 		if (ret)
 			goto out_kfree;
-- 
2.43.0



