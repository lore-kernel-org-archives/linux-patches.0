Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81D21863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:14:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710E7C433EF;
	Wed, 28 Dec 2022 15:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240475;
	bh=6rVLKENdfv0mxhhkx6J8QNlfvoBiuXKXQCv4wAUGhDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=014jgL2vpLtPNzRzzL1NaIegXLSqDxCi2Hn0aLWsrTvHouL5aejIJpTdwYwtJP1Vk
	 cQ1r0r2jaYlLK9gUBtAyylKij5M/Mn6W7/0n9FpnVChEJ4+TVkVTVPd+rHfh0hoGDv
	 PJRC74gbdvuP7tm1lG1Wt7ynCcUEsi4f8ilt5N2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0165/1073] PM: runtime: Do not call __rpm_callback() from rpm_idle()
Date: Wed, 28 Dec 2022 15:29:13 +0100
Message-Id: <20221228144332.497679138@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit bc80c2e438dcbfcf748452ec0f7ad5b79ff3ad88 ]

Calling __rpm_callback() from rpm_idle() after adding device links
support to the former is a clear mistake.

Not only it causes rpm_idle() to carry out unnecessary actions, but it
is also against the assumption regarding the stability of PM-runtime
status across __rpm_callback() invocations, because rpm_suspend() and
rpm_resume() may run in parallel with __rpm_callback() when it is called
by rpm_idle() and the device's PM-runtime status can be updated by any
of them.

Fixes: 21d5c57b3726 ("PM / runtime: Use device links")
Link: https://lore.kernel.org/linux-pm/36aed941-a73e-d937-2721-4f0decd61ce0@quicinc.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/runtime.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index 997be3ac20a7..d36fb07190bf 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -484,7 +484,17 @@ static int rpm_idle(struct device *dev, int rpmflags)
 
 	dev->power.idle_notification = true;
 
-	retval = __rpm_callback(callback, dev);
+	if (dev->power.irq_safe)
+		spin_unlock(&dev->power.lock);
+	else
+		spin_unlock_irq(&dev->power.lock);
+
+	retval = callback(dev);
+
+	if (dev->power.irq_safe)
+		spin_lock(&dev->power.lock);
+	else
+		spin_lock_irq(&dev->power.lock);
 
 	dev->power.idle_notification = false;
 	wake_up_all(&dev->power.wait_queue);
-- 
2.35.1



