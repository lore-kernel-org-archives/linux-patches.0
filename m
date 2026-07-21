Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75375415F0C;
	Tue, 21 Jul 2026 17:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656443; cv=none; b=UwSPCewJGCiYO9yf8npNBbx7tL8GdI+KZKBnfvXSrLA3L6G+LndmF37S1cyZMmqoE3QGqIWMRv5E0A7Bq1NCJBeeeU5GHl52vAj/PXyPGpd78T5CxIPnw6YMImk5aEQPur8cFFbVq/uw2DAqOjK877WpWwhPey+TVXE0oLVDTRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656443; c=relaxed/simple;
	bh=tXYOfHHWFicHf2XfeISNfVLNcG/WHenOKLomh2jJuKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p7j8/9OQ50nfXa9HK70MQRvD5XhzbNbYTcP0nZGO6WPnthXGoGx2uutGxG16XG37TWrn9RL3ETreSHvRV0FKUDsf48yZFVnqdaWn85t0Wdh1DDzh+hzsryWhJdHPFLpMmGIaumqbETku1JHItef0J3So0zUnDJbyoUoG31n01pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ojgySNfN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ojgySNfN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C7A1F000E9;
	Tue, 21 Jul 2026 17:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656442;
	bh=sn31J+2mRZl7hQ4PrMunDo49/3Qhea2VCOtIHC8hhdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ojgySNfNnNX7doNI5bM2a1lKOSdsLpR5ZVYF+XI3z4GSThDScX/PWiDjODK0htTsZ
	 b5Udh2+cdN1GVm/W9GzFXmfKgkRrUacvKfBBefheRkVPek7SYyFJG+S+bdWWIx1mpJ
	 GHNfl71CHbpE0CjY5Jig/dJGlBjqHIDO+TZKFK9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0390/1611] watchdog: unregister PM notifier on watchdog unregister
Date: Tue, 21 Jul 2026 17:08:26 +0200
Message-ID: <20260721152523.990286757@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit a298c7302ee9584a7a1ac1e8acbede8d98ab51a4 ]

watchdog_register_device() registers wdd->pm_nb when
WDOG_NO_PING_ON_SUSPEND is set, but watchdog_unregister_device() does not
remove it. This leaves an embedded notifier block on the PM notifier chain
after the watchdog device has been unregistered.

A later suspend/resume notification can then call watchdog_pm_notifier()
with a stale watchdog_device pointer, or at minimum after wdd->wd_data has
been cleared by watchdog_dev_unregister().

Unregister the PM notifier before tearing down the watchdog device.

Fixes: 60bcd91aafd2 ("watchdog: introduce watchdog_dev_suspend/resume")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Link: https://lore.kernel.org/r/20260601192005.1970805-1-dbgh9129@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/watchdog_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/watchdog/watchdog_core.c b/drivers/watchdog/watchdog_core.c
index 6152dba4b52cb0..4c1a090ee49652 100644
--- a/drivers/watchdog/watchdog_core.c
+++ b/drivers/watchdog/watchdog_core.c
@@ -390,6 +390,9 @@ static void __watchdog_unregister_device(struct watchdog_device *wdd)
 	if (test_bit(WDOG_STOP_ON_REBOOT, &wdd->status))
 		unregister_reboot_notifier(&wdd->reboot_nb);
 
+	if (test_bit(WDOG_NO_PING_ON_SUSPEND, &wdd->status))
+		unregister_pm_notifier(&wdd->pm_nb);
+
 	watchdog_dev_unregister(wdd);
 	ida_free(&watchdog_ida, wdd->id);
 }
-- 
2.53.0



