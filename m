Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B4812DDA1;
	Mon, 13 Oct 2025 14:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367540; cv=none; b=jSCMvoPxiDz/zqqGOiNiyUTZ0XcUCuuLQMmqsaNplRfWaLO2ql/UjV84HYOykDa0E7B++Em/9yHTKpykRoOUIgb/zWJvvhrH6vaA7snyLSaTnfOS9NlBkdpMaLuRC7RdSz/yLmlcwrAAA0OsfCPoas/bB7ZGSgknP0jyT3YZGUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367540; c=relaxed/simple;
	bh=MJpMdQ+pUptFmgSUUp8XBLXCMbBR+pfBEGhN9jVfSjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQ1W0o3E9jSPp55vYJxLYwjk33+A47pgbP3ciZS+0Z2Oa/lxiiV5X2zFyOVvqyvyEhWijYZrBP3Q00RZUWcZ3jEMOEEtZT3WKZ/NS8k0ul1sNS9bmfums9l8McXLdjalGKB7LMkWzWtZXEbD/QWIGCaguer4eP0gTZh6AsHH5iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WsMx/euA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WsMx/euA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3343CC4CEE7;
	Mon, 13 Oct 2025 14:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367540;
	bh=MJpMdQ+pUptFmgSUUp8XBLXCMbBR+pfBEGhN9jVfSjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WsMx/euAc7p/f0fOPxQ0fZ1cVTaJ7oUfMlyh04jwCdPuvpor9zAfSdikZURoY7TVe
	 rzeDNwyoRIUBKdMS3FxHTwKCVeiRxYSWO4WhOLEy5bAHEmfj7ZlOTevkl5A6Uc1xmV
	 y50ElcseZ6m5cn9s/IIxUaGS3umroUa0Yjk6COPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/196] PM: sleep: core: Clear power.must_resume in noirq suspend error path
Date: Mon, 13 Oct 2025 16:43:41 +0200
Message-ID: <20251013144316.287265718@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit be82483d1b60baf6747884bd74cb7de484deaf76 ]

If system suspend is aborted in the "noirq" phase (for instance, due to
an error returned by one of the device callbacks), power.is_noirq_suspended
will not be set for some devices and device_resume_noirq() will return
early for them.  Consequently, noirq resume callbacks will not run for
them at all because the noirq suspend callbacks have not run for them
yet.

If any of them has power.must_resume set and late suspend has been
skipped for it (due to power.smart_suspend), early resume should be
skipped for it either, or its state may become inconsistent (for
instance, if the early resume assumes that it will always follow
noirq resume).

Make that happen by clearing power.must_resume in device_resume_noirq()
for devices with power.is_noirq_suspended clear that have been left in
suspend by device_suspend_late(), which will subsequently cause
device_resume_early() to leave the device in suspend and avoid
changing its state.

Fixes: 0d4b54c6fee8 ("PM / core: Add LEAVE_SUSPENDED driver flag")
Link: https://lore.kernel.org/linux-pm/5d692b81-6f58-4e86-9cb0-ede69a09d799@rowland.harvard.edu/
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://patch.msgid.link/3381776.aeNJFYEL58@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/main.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index baa31194cf20d..ef5157fc8dcc5 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -600,8 +600,20 @@ static void __device_resume_noirq(struct device *dev, pm_message_t state, bool a
 	if (dev->power.syscore || dev->power.direct_complete)
 		goto Out;
 
-	if (!dev->power.is_noirq_suspended)
+	if (!dev->power.is_noirq_suspended) {
+		/*
+		 * This means that system suspend has been aborted in the noirq
+		 * phase before invoking the noirq suspend callback for the
+		 * device, so if device_suspend_late() has left it in suspend,
+		 * device_resume_early() should leave it in suspend either in
+		 * case the early resume of it depends on the noirq resume that
+		 * has not run.
+		 */
+		if (dev_pm_skip_suspend(dev))
+			dev->power.must_resume = false;
+
 		goto Out;
+	}
 
 	if (!dpm_wait_for_superior(dev, async))
 		goto Out;
-- 
2.51.0



