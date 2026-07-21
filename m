Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882022641CA;
	Tue, 21 Jul 2026 21:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669035; cv=none; b=gRoHtEQZtvjb/uh1jBvpZvJx4T9moa8Mrl0O5VO8rVoB/jQltHcrbJ0WmgO3nT1QTGTeLIB7bumzfAYeO/cFSQvp/JWBq+QHYYqFwuKuZxHBuj/hnNtpOWA+JtHynY2FZy2cviMiYCxEMRkMN1YyZsaZqH58THEM+I6zVCI+4Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669035; c=relaxed/simple;
	bh=/DsuCcHN/DLVULhtdyyYpeeFDSulbFGvkRXpDurB2a4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZiLeiEFySju5IZuSSnT9Snb8L6mzGbM6QL+L7FXafASgBP5RezC6F/Og1QqVGrxF5aK+KS2tnYdLA6S0qwS43J1fc5R0y4/W11xi2wm5XQ9dqSL97qqk59X5YhF/MsENSv0U+yIevY37t8qOa4a8hSWb1Jekak5ygKlV6DjTRi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hjn+mKmc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hjn+mKmc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDC5C1F000E9;
	Tue, 21 Jul 2026 21:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669034;
	bh=x//tN601g4Z1EqqMbR86Woihhu4l9Zy2mhCzxaUjwRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hjn+mKmcrJBCBKAhxUSNO6UwdZ4VNxfc6C1E67pifenTWofuilz+pQT1ossGgfV7c
	 aNkec+MxDKEPsxea6+mRXfnreQ0LnfO9fwrnOQzdaMOTrNk2VwhAt33RoqvN+16t7S
	 5lgMBdFi8SOp0mEaMLXmt74m9fnuZXD8qVAjB8dA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0402/1067] watchdog: unregister PM notifier on watchdog unregister
Date: Tue, 21 Jul 2026 17:16:43 +0200
Message-ID: <20260721152433.628183898@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c777a612d932dd..6c2599e040b84a 100644
--- a/drivers/watchdog/watchdog_core.c
+++ b/drivers/watchdog/watchdog_core.c
@@ -381,6 +381,9 @@ static void __watchdog_unregister_device(struct watchdog_device *wdd)
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



