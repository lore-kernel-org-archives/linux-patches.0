Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327453B3C0A;
	Tue, 21 Jul 2026 20:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665996; cv=none; b=FbEMEYs08kzz1wHvB5g5nLLdLgSYvRSR03aCbv3n3EgcpPtJ3JrD/R8O2I2GpO+7G1eoVnUWEsJDvVMJIdSqWBdMFo8w4wUiEZsnn6IoUG0ievE6z/K72lboImMEc9Wbtw+0FtWLM8sy+6CfxEQL51bcay1gRZRQ1o4fC/65IHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665996; c=relaxed/simple;
	bh=ih6yDoQ0Qswg5y43FWfQ3dZDNcUYlOZsM89Ep8NxEwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCPGrymN98JVGyln+vVzxdmMY/Ul6PCRVYFEPi7O3kpAI9bAce18F3jgT+1zh0lq6qv4791FfHe7wKhwAin646egyX4IHWjU3b/+JaNGPhTe7oCRpZjeJDv1rHIFoXwhrFQIaMRxlfOD3/PLdKA9tzcPkYvnGD74dMOqzYp9P5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jXVu39eV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jXVu39eV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990131F000E9;
	Tue, 21 Jul 2026 20:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665995;
	bh=sdVsx5f+zqR782w0yKa/YBCBA2dPylyzNKhmBIZGJzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jXVu39eVv8JXN3kKaZ/QXPt3f6cySlp5U1wLnpMowbc/JBy5ef5gjASSiOU8iPoiK
	 9kA42D/X6ahhLaJxVH6rIE61DxeEdWNn47tucONx7m0AZy/ey18cE/SglXazu2gvpi
	 QgN+I7O5hWfKs6SiZVkLffdGmZCOs8beAugzmhvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0516/1266] watchdog: unregister PM notifier on watchdog unregister
Date: Tue, 21 Jul 2026 17:15:53 +0200
Message-ID: <20260721152453.395867559@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
index 5b55ccae06d4b0..2d0bb5e4c9c283 100644
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



