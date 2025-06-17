Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0872EE5E7;
	Tue, 17 Jun 2025 16:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177620; cv=none; b=u0HvobxESOhhKOeVB0r4jiQSDuzZwK6TMxhKa5I5McMqZc5ADzuev8tSIDdDmUnf2vFJo/eqZf60posJHzZUP7J4hyVklFHfhHf6WWhLx+T5TLQJQT/PDI5+VH/EHlKmNhs1X9TUbaKanTCkfayOSbMpGEGiQ6AIW4hupZwSKIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177620; c=relaxed/simple;
	bh=GVUnNDNhJ96B2YEM6QJxyWV0a0o8T4+sDiWXVTPYFi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C/QdlLlIKtNZHza8Ar5meJVAQQnopBgCXgMWPCJeJzCHwl4/2S+gc0Z1I6Qp3DtT06eqme9EKZ+f2JkO28WRjOxmHutsDlSdtULXebA7lglb6alJNjJjgtyw7ekWKOfYaXDEeWuWQ9EcxHSB3DHnLJncPEwg7I8jQrdRfgo694A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ukFFzwip; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ukFFzwip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC40CC4CEE3;
	Tue, 17 Jun 2025 16:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177620;
	bh=GVUnNDNhJ96B2YEM6QJxyWV0a0o8T4+sDiWXVTPYFi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ukFFzwipkWlNzRR5LTvfKaiZmmrsL134WQ2wFQUM40RA2O7/dvf6nmOb0n0nnqEWw
	 hO6W7B4Z+q5Vh0NhdZWN0IIT9RW0VDc5Ru3NactrSzZanyMv7Gf9iN4e3q6QdKcLt3
	 0+Bm7IWAnVbB9rTdQ7AtBn7rNbp6LZzm2D39Y/R4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Chris Bainbridge <chris.bainbridge@gmail.com>
Subject: [PATCH 6.12 372/512] PM: sleep: Fix power.is_suspended cleanup for direct-complete devices
Date: Tue, 17 Jun 2025 17:25:38 +0200
Message-ID: <20250617152434.669777516@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1abe61f11525d..faf4cdec23f04 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -916,6 +916,8 @@ static void device_resume(struct device *dev, pm_message_t state, bool async)
 	if (!dev->power.is_suspended)
 		goto Complete;
 
+	dev->power.is_suspended = false;
+
 	if (dev->power.direct_complete) {
 		/* Match the pm_runtime_disable() in __device_suspend(). */
 		pm_runtime_enable(dev);
@@ -971,7 +973,6 @@ static void device_resume(struct device *dev, pm_message_t state, bool async)
 
  End:
 	error = dpm_run_callback(callback, dev, state, info);
-	dev->power.is_suspended = false;
 
 	device_unlock(dev);
 	dpm_watchdog_clear(&wd);
-- 
2.39.5



