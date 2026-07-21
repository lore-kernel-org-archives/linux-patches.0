Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB43415F23;
	Tue, 21 Jul 2026 22:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671628; cv=none; b=i3Z+u1MR8owjoZPBAi7wlMHNJfYaymfSdiE4j8Zt6arManmMoENYx8JN4AA5yx7L+kUSMXf+aUXm7pwACstN/nTWoRVV536jm3u/xBs5UfbV8OMCW0bBR3fzzdNsk/fa0F5fnT26Ms8i3WKDYqM/oK03fkoJOovx4vJyQtI/0es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671628; c=relaxed/simple;
	bh=3iZlaG2ngiQ96IPspxIBniGSwHJ+2E579ONe1Xf6wp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tX8wCC9oA62xFcGdJrgMEtEP3YNZ3ch4oAtupzSGIqGafRaYH3+VP1gO7Jj7vYybJqQtCbWdmWYXIt5wO7jANP9OCBGCsL1bRSCnPFNgnhgv2KUVdeFoOfgJ5mH3xEV/hhpDVUW0fZQFuV6cUPV+LHn+N31ZEumoLPtIZ02Nm90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YGwb2D9k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YGwb2D9k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 217081F000E9;
	Tue, 21 Jul 2026 22:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671627;
	bh=TlRjUwe3G8mE9H+HpavSfek00JiOfleWrVmobLyolyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YGwb2D9kZN0LbeJQE+d++U9bBtG1sI4L3CnSlTyNJs2q1m1mZIUgEvbTQ2aR+7Pga
	 cJGxQx/T4CcOMdno0EdYkbOPJNjuT8VhA2LeY89hrlUEpJ94QNy0YydLrgy1lq9C/0
	 lyYxxkcr/R+5ThquQdJfbOZUe9SonRiqGBATKcoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 319/843] watchdog: unregister PM notifier on watchdog unregister
Date: Tue, 21 Jul 2026 17:19:14 +0200
Message-ID: <20260721152413.195933454@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3fe8a7edc252f3..6486a66384d9cc 100644
--- a/drivers/watchdog/watchdog_core.c
+++ b/drivers/watchdog/watchdog_core.c
@@ -377,6 +377,9 @@ static void __watchdog_unregister_device(struct watchdog_device *wdd)
 	if (test_bit(WDOG_STOP_ON_REBOOT, &wdd->status))
 		unregister_reboot_notifier(&wdd->reboot_nb);
 
+	if (test_bit(WDOG_NO_PING_ON_SUSPEND, &wdd->status))
+		unregister_pm_notifier(&wdd->pm_nb);
+
 	watchdog_dev_unregister(wdd);
 	ida_simple_remove(&watchdog_ida, wdd->id);
 }
-- 
2.53.0



