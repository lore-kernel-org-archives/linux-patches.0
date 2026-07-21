Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E66F408634;
	Tue, 21 Jul 2026 19:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661989; cv=none; b=nO/hXoo2TgF60ibzLEiFGJGrBG5IjqAUkPoHxL0qWsbw4I1Ef6HZcnd4ke98EfCs3Yn/O2doBqbvSNKyCddJuUBXqZfWbQb95KpxxHMTtzIkMabMxo8olbX664coWtsuC3nYtDMkyPbFmPYocn+6FAwuFUolO7gUnbCzp/ABZ+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661989; c=relaxed/simple;
	bh=Fuf38TQ1l9ryNKDdQTRCQSJF18ADkxnxHngOMXbz2Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VZ59QLCAa3uBdn1MTfgo/Jicn0qyYJfBafBWHkepPbf40iDC+2UASUSAPBUH7kV+Av1nHx2VY6Kyyx+j93+uLj4priX69jNK/3anz36yQ+B0O6NCvmTDkgorjsgzoWOYGd/ZtljMwZzkhk9VE4ZkZSi9B44FJuyU6Ld21zj4qIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m+Py++7R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m+Py++7R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F481F000E9;
	Tue, 21 Jul 2026 19:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661988;
	bh=VJjWNmqpKcO3DV8J+dtqUm3GP9imppp/m59sjkUmYHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m+Py++7ROI6mQ7z4WrcpFUrvFbKTrJ0otIshwy9VVPbohw6HgVlVm5Q0h37iLKC7t
	 xB9uEV09kwCAK/H254HuIPycrC9+RBcH9yZRJNN6W5B1kqfcrbjvf6sxYbNjckDCBI
	 T3DpmovAQgz8fOcqvXzJW7PkO0wQUFVcgr8cRZeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0272/1276] watchdog: unregister PM notifier on watchdog unregister
Date: Tue, 21 Jul 2026 17:11:55 +0200
Message-ID: <20260721152452.166221251@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index aff2c3912ead69..fd7161a5da332b 100644
--- a/drivers/watchdog/watchdog_core.c
+++ b/drivers/watchdog/watchdog_core.c
@@ -382,6 +382,9 @@ static void __watchdog_unregister_device(struct watchdog_device *wdd)
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



