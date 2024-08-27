Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E4A1C6886;
	Tue, 27 Aug 2024 15:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771649; cv=none; b=r3oZOkFHleCitYE+XViW8juQWgxA9AqfFY7NBWhY51j12G1OSSoIH5p8tyMZWQvE9O+cc2z9hbihzmk9MNTGafQa6FcgBQMpTqqMOTHUnlKs34h37pe1mvthp8992aerk+gJtujZqrTL5Lxl2MsFSJStLYRGbu+Mue2Hj7DwNYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771649; c=relaxed/simple;
	bh=xnNZcJQ9Sc3hZvvFIQb37tNMkjSsieqmipTan+Jvcnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qkNr2YArFHlTE4PTm8WUQyL4YOKHFuHBCwFQF6eYWF7KlbhFnL1iZHzzCoUc39AygSyZi7ZSwHxgELwUDvrGyzpzNMSy+GQ8jOn25LLrRzH7azVn2QqhBiIYsmXd1O2ktfTVKgXC07HAVNcp5wben3RHYKDk6K3OyP54l0yLMMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jL01VAT3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jL01VAT3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B5EEC6106B;
	Tue, 27 Aug 2024 15:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771649;
	bh=xnNZcJQ9Sc3hZvvFIQb37tNMkjSsieqmipTan+Jvcnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jL01VAT36b5+VJRvMkoesUVwWJgmS5AHPbMSVvS+tWH62JVFneqpiO2UvFSix0o70
	 YBw7RY20IDE5IL118RvtoktKQryEKs7fz6bFPl7ETOJiaIHjha9mmg2bT3RfDCZuRp
	 w2MjsxhqUnl6RfIGNLvCDUuW54d+LP/gatqA7b8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.10 252/273] thermal: of: Fix OF node leak in thermal_of_trips_init() error path
Date: Tue, 27 Aug 2024 16:39:36 +0200
Message-ID: <20240827143842.991316499@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit afc954fd223ded70b1fa000767e2531db55cce58 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/thermal_of.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/thermal/thermal_of.c
+++ b/drivers/thermal/thermal_of.c
@@ -125,7 +125,7 @@ static int thermal_of_populate_trip(stru
 static struct thermal_trip *thermal_of_trips_init(struct device_node *np, int *ntrips)
 {
 	struct thermal_trip *tt;
-	struct device_node *trips, *trip;
+	struct device_node *trips;
 	int ret, count;
 
 	trips = of_get_child_by_name(np, "trips");
@@ -150,7 +150,7 @@ static struct thermal_trip *thermal_of_t
 	*ntrips = count;
 
 	count = 0;
-	for_each_child_of_node(trips, trip) {
+	for_each_child_of_node_scoped(trips, trip) {
 		ret = thermal_of_populate_trip(trip, &tt[count++]);
 		if (ret)
 			goto out_kfree;


