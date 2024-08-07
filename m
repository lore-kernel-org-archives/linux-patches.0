Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37BD78C92;
	Wed,  7 Aug 2024 15:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043218; cv=none; b=lVIPu1yFStfAYIhgr203OM+Io9XgAMsC9lbiFMOhyd0csQUOU9z+7Pqgur8X1b+diqvvZmoATHspyY5izALzPu1aNwa5EoZMh4n+P+48+v+jCrIL2SRIET+ke3VcVthY0kQv089B36RliZMeMlKARaYG4guqgioZETm8htIdNEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043218; c=relaxed/simple;
	bh=rjky8C4GM6KDXiLn6/leNevRCDmP8o3cenFLcyDhcgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pEQBnncPzmr6xiVm3s0eACmcecBBWM0HrNyuZV/I6CchiiPiSEfQItmUVeYi+kb54EhxjsbmKWsqjrpEDxepzXIDK4124/tiTZENKi7rwudsO6iz/nURdMruqv5J+amvyLMu+VniJZfnwN8tAd4EMMIy+uswwvtG3ZwjOkfddG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FZSqqICt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FZSqqICt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ACECC32781;
	Wed,  7 Aug 2024 15:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043218;
	bh=rjky8C4GM6KDXiLn6/leNevRCDmP8o3cenFLcyDhcgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FZSqqICtsoxPt6YBK4PTQJsoDY2uNhzzfXCq6on8xBXTKu/Wz9hLdMB3qDlmco1Fw
	 xESNXsju6GL+UkTnUHzL+4keF+nWaM+I7xqpUGqcLPNH/wXuL26WjEBu9sR6JTOPg5
	 Vm+37O3uK1LRlGKiiaWYuHKQX3kFUO3TSWpFi0Jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 011/121] thermal: bcm2835: Convert to platform remove callback returning void
Date: Wed,  7 Aug 2024 16:59:03 +0200
Message-ID: <20240807150019.742020612@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit f29ecd3748a28d0b52512afc81b3c13fd4a00c9b ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart
from emitting a warning) and this typically results in resource leaks.

To improve here there is a quest to make the remove callback return
void. In the first step of this quest all drivers are converted to
.remove_new(), which already returns void. Eventually after all drivers
are converted, .remove_new() will be renamed to .remove().

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: e90c369cc2ff ("thermal/drivers/broadcom: Fix race between removal and clock disable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/broadcom/bcm2835_thermal.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/thermal/broadcom/bcm2835_thermal.c b/drivers/thermal/broadcom/bcm2835_thermal.c
index 3acc9288b3105..5c1cebe075801 100644
--- a/drivers/thermal/broadcom/bcm2835_thermal.c
+++ b/drivers/thermal/broadcom/bcm2835_thermal.c
@@ -282,19 +282,17 @@ static int bcm2835_thermal_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int bcm2835_thermal_remove(struct platform_device *pdev)
+static void bcm2835_thermal_remove(struct platform_device *pdev)
 {
 	struct bcm2835_thermal_data *data = platform_get_drvdata(pdev);
 
 	debugfs_remove_recursive(data->debugfsdir);
 	clk_disable_unprepare(data->clk);
-
-	return 0;
 }
 
 static struct platform_driver bcm2835_thermal_driver = {
 	.probe = bcm2835_thermal_probe,
-	.remove = bcm2835_thermal_remove,
+	.remove_new = bcm2835_thermal_remove,
 	.driver = {
 		.name = "bcm2835_thermal",
 		.of_match_table = bcm2835_thermal_of_match_table,
-- 
2.43.0



