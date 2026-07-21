Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C28128641E;
	Tue, 21 Jul 2026 19:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663116; cv=none; b=AYxUcMmrmBCi55P2MCr3h7Led6GGKVcZfzNoBFiY99jw1FiHXFe8o/b7YlYxJbAi1TpnImECERmGZTBPt2+ROs8UN0SzyzKoBFhkD5K16ecyqMz5Si7Ik39YPn928lnR3kncR7R7Sn4HVdmyP+OmRIArRP6L5pJOkyYhXZ7+E0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663116; c=relaxed/simple;
	bh=k/a9OMv/wwnUiAIDsToHLK/6qhjVApFIu86QdAEVDjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uxpf5AiIRs0GOZ6dc1hPQt89ebffKk9S5pik3fIyOZR+OrpydOOC14ZDIev22NvwCGtP006FXs7c5gcFVAmLje4SWPEemdteA0rErnd0qAtEyvm4MgBnzJWE5P85FcojQkku01zcceZ5xX4peQ3LuKXO2yUXNvT4plB/zqA9/DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GHlIWHDa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHlIWHDa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D591F000E9;
	Tue, 21 Jul 2026 19:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663115;
	bh=pi+NG/Nb8uDM/ys03rQ3wrdVrr3RARPAuY6Cna3dVWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GHlIWHDad/W2vXsYGra2nO7Ytcu+68GZuM4hQ4BKf4FCHxxVPxWCIcJNeQPJuO80j
	 3bjHu04jdPVdkR1d+Vl23Z12aausdrM06qPZ5WI4i3v9ILsE5GjrajGaRjWD1MCJFA
	 qECv0kyPBYMCTgA1JkXqT1jYnCptThbHKoUfVRu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0702/1276] hwmon: (pmbus) Fix passing events to regulator core
Date: Tue, 21 Jul 2026 17:19:05 +0200
Message-ID: <20260721152501.806311631@linuxfoundation.org>
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
index e37fd206510a63..a431cce3360342 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -3315,18 +3315,23 @@ static void pmbus_regulator_notify_worker(struct work_struct *work)
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



