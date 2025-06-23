Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C897D70838;
	Mon, 23 Jun 2025 21:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713076; cv=none; b=RMcmXJurob/iCwHhDMYroi7gCooHwIwTUJI9T0ZLpHEp4UbzIrP4CD00FXh5zDbYezKMYg2Vk5Tjxqn2LwF/DfcVyX9Uaa8EQkqVsKH08UAV6DPEoXd+KfXEVbJrClyC08MjR+HFDcVWTY5W+Yd1C/O3l8M/LIjl2LHHT+b2UoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713076; c=relaxed/simple;
	bh=L8YBMyxjGo8VVGneLNSZXkpalbBYNCcYITPcRzqQ7Qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qNlTCmvp2nmCC9FshNjVZhMGRlDMFoCReepVGHtAGmsUc20nEV5Ld+VhfAvC4dmmaFRAtsNV6qgiHeYCEc5tBVNKJjI0P0usFdKn5AaJFa7BIWNd66viQre6XY+mnAqJ3DhZQLq+8bkqkEl8UgpNTRvzwQQ1E8yq6aUCZN9CZ/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gUeXi3k6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gUeXi3k6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD3BC4CEEA;
	Mon, 23 Jun 2025 21:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713076;
	bh=L8YBMyxjGo8VVGneLNSZXkpalbBYNCcYITPcRzqQ7Qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gUeXi3k63t3tMUMmDjfX2pmmlgBK1CxEA/mPmkmHHH3Uf4MMwdwx6gGjZS1uxwk2P
	 sma4KRvp87lkgjT8jE7c1MwUro4YOwva2fSLbzgbmrZmj8XujaZeNTD5IAgaiZm0uP
	 d3DPstQXpqnf2zFyTgj8ptMfr0zhew5m2rWRH2PE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Chris Bainbridge <chris.bainbridge@gmail.com>
Subject: [PATCH 5.15 123/411] PM: sleep: Fix power.is_suspended cleanup for direct-complete devices
Date: Mon, 23 Jun 2025 15:04:27 +0200
Message-ID: <20250623130636.653112180@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit d46c4c839c20a599a0eb8d73708ce401f9c7d06d ]

Commit 03f1444016b7 ("PM: sleep: Fix handling devices with direct_complete
set on errors") caused power.is_suspended to be set for devices with
power.direct_complete set, but it forgot to ensure the clearing of that
flag for them in device_resume(), so power.is_suspended is still set for
them during the next system suspend-resume cycle.

If that cycle is aborted in dpm_suspend(), the subsequent invocation of
dpm_resume() will trigger a device_resume() call for every device and
because power.is_suspended is set for the devices in question, they will
not be skipped by device_resume() as expected which causes scary error
messages to be logged (as appropriate).

To address this issue, move the clearing of power.is_suspended in
device_resume() immediately after the power.is_suspended check so it
will be always cleared for all devices processed by that function.

Fixes: 03f1444016b7 ("PM: sleep: Fix handling devices with direct_complete set on errors")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4280
Reported-and-tested-by: Chris Bainbridge <chris.bainbridge@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/4990586.GXAFRqVoOG@rjwysocki.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index d77ab224b861a..c784de10b494e 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -900,6 +900,8 @@ static void __device_resume(struct device *dev, pm_message_t state, bool async)
 	if (!dev->power.is_suspended)
 		goto Complete;
 
+	dev->power.is_suspended = false;
+
 	if (dev->power.direct_complete) {
 		/* Match the pm_runtime_disable() in __device_suspend(). */
 		pm_runtime_enable(dev);
@@ -955,7 +957,6 @@ static void __device_resume(struct device *dev, pm_message_t state, bool async)
 
  End:
 	error = dpm_run_callback(callback, dev, state, info);
-	dev->power.is_suspended = false;
 
 	device_unlock(dev);
 	dpm_watchdog_clear(&wd);
-- 
2.39.5



