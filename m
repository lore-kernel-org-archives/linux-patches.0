Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817AC471250;
	Tue, 21 Jul 2026 18:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657969; cv=none; b=R72yGUSCypp7Q3CJ6UuMEqLRgWs6rskc2qSDMSLQV+4zFUh0qWsTgFVoLpw3KAlPIZuvRdpvSGIKngr2QBPFjYn4gAC+21kKJkeqQwmVZE143PZvOcyaBGN30950yN+nuALTOGUXBUUQIOWEkZm9RFk6rOnUPIdoj8dJ/pVG9C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657969; c=relaxed/simple;
	bh=F+2mmHYk/Kjaz4TYj2H7TCyBiXoNhfkbHvILKJcQ+Y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tkHSvIaiPIR3Tx5O3DeC/2qR1nnUXCsUDIcELqKHMSceojnQDzC5OS0bS43wSI6zX1AhvLD2p5l0i9BvGieF9q/xUX8CqGSgZnoSbbAj65Mwp8KS8lDxUBEHQ0MNHMfCJXWMo/mAlr21p6tWj1o4pPhG8EjV5x6IFbDGNSVkh9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QhrkZ0co; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QhrkZ0co"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E82EE1F000E9;
	Tue, 21 Jul 2026 18:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657968;
	bh=Ckqi038KB7kmiTKvoAmsMqagjBfJSJtgROqjmR/K8Mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QhrkZ0coHfASQskZCc3IQsoX8smZj3LOkEZh3B2yKk2+Da6na81wNEQD3D+juv1BI
	 fSgkj5xDqoAgUBEHZZjmz4Z0oQOh1lqB7rIJiDdwT9lcCj16iaQHDg/5Q/nQ0buE3U
	 /X8a1ke6Tm27wo9tRZihZU3XF6J+LscB2Y8km840=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0965/1611] hwmon: (pmbus) Fix passing events to regulator core
Date: Tue, 21 Jul 2026 17:18:01 +0200
Message-ID: <20260721152537.102864109@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 9ef7dacd44216bf5ea05c8aef49eba4d145f4047 ]

Sashiko reports:

Commit 754bd2b4a084 ("hwmon: (pmbus/core) Protect regulator operations with
mutex") introduced a worker to batch regulator events over time using
atomic_or(). The delayed worker then passes the combined bitmask unmodified
to regulator_notifier_call_chain().

The core regulator subsystem's regulator_handle_critical() function
evaluates the event parameter using a strict switch statement. If
multiple distinct faults occur before the worker runs (e.g.,
REGULATOR_EVENT_UNDER_VOLTAGE | REGULATOR_EVENT_OVER_CURRENT), the combined
bitmask fails to match any case. This leaves the reason as NULL and
completely bypasses the critical hw_protection_trigger().

Fix the problem by passing events bit by bit to the regulator event
handler.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 754bd2b4a084 ("hwmon: (pmbus/core) Protect regulator operations with mutex")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/pmbus_core.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index 7150f12d26300b..ddf64e72751ccd 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -3381,18 +3381,23 @@ static void pmbus_regulator_notify_worker(struct work_struct *work)
 	int i, j;
 
 	for (i = 0; i < data->info->pages; i++) {
-		int event;
+		unsigned int event;
 
 		event = atomic_xchg(&data->regulator_events[i], 0);
 		if (!event)
 			continue;
 
 		for (j = 0; j < data->info->num_regulators; j++) {
-			if (i == rdev_get_id(data->rdevs[j])) {
+			if (i != rdev_get_id(data->rdevs[j]))
+				continue;
+			while (event) {
+				unsigned int _event = BIT(__ffs(event));
+
 				regulator_notifier_call_chain(data->rdevs[j],
-							      event, NULL);
-				break;
+							      _event, NULL);
+				event &= ~_event;
 			}
+			break;
 		}
 	}
 }
-- 
2.53.0



