Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714C618E025;
	Tue, 17 Jun 2025 16:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178942; cv=none; b=j8sFE6PcatBCekCNYYVQEkKblYxU40ym0Uzm9EL1lRfi+z+AdKMgSnbX++EPrGVzQNEU56FIwQpG5K7qq/G3JFhILOq7xZwB9LN2GcFSk6hN2H5g8lhdvt1IQOa7VkBWclejUtJhBFGzpd/8UjAl8uncE3tmYjkIGQ9tLRrAKQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178942; c=relaxed/simple;
	bh=HrLpb2j7oaFd8ZVkP20vQKVh7AmTy4ClZ2GGrKX3xhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MRAI2uDEaIeIcoViyZIo+ecLO1KttySM1E2d86HYXIXLrjLNjkRkMmRzw5y0Mcun2yZMxbtKiPxcaahrJX9RLqlmwSh9J3TZ/vgfhhxwkmi8mTE6t3z79GxFR5mlwloJkFW40tsfkaWDK4C+F0JAOmyXXJx08YcvLxaJyZ/Hoh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NwW3+OGV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NwW3+OGV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81384C4CEE3;
	Tue, 17 Jun 2025 16:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178942;
	bh=HrLpb2j7oaFd8ZVkP20vQKVh7AmTy4ClZ2GGrKX3xhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NwW3+OGVkLcyYeOYK/8vWhxe2jxdLclFErDphF/EgcuyOX7O+yAf+u3gMGrI9azXd
	 zVwGYkc04UWIj1V7DtBM5P733wHSTm5U0+1XpIReqmy9QO8yqp885Q0VJ8OXckGvHE
	 SOtKu4ydpLs4MpfqtN3ASmjODVIIK3ii1EC9fywY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Chris Bainbridge <chris.bainbridge@gmail.com>
Subject: [PATCH 6.15 599/780] PM: sleep: Fix power.is_suspended cleanup for direct-complete devices
Date: Tue, 17 Jun 2025 17:25:07 +0200
Message-ID: <20250617152515.878545867@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index c8b0a9e29ed84..1926454c7a7e8 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -941,6 +941,8 @@ static void device_resume(struct device *dev, pm_message_t state, bool async)
 	if (!dev->power.is_suspended)
 		goto Complete;
 
+	dev->power.is_suspended = false;
+
 	if (dev->power.direct_complete) {
 		/*
 		 * Allow new children to be added under the device after this
@@ -1003,7 +1005,6 @@ static void device_resume(struct device *dev, pm_message_t state, bool async)
 
  End:
 	error = dpm_run_callback(callback, dev, state, info);
-	dev->power.is_suspended = false;
 
 	device_unlock(dev);
 	dpm_watchdog_clear(&wd);
-- 
2.39.5



