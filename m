Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D3233A9FC;
	Tue, 21 Jul 2026 20:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666772; cv=none; b=YPmdRRieWP4romtB9rJu+LL5i8/ThfE89N+FfJK0lyIQ9CnD3GO1ifT51mrE/nMIjDIkGbdyyLeUUB9Tyt8AuUfWPPsJpe2RnLT7yhOp+gp3OuZYgbPET7M5xi+NTJ3WDZYkukkWS682Q4f5sGP9g/kjK+oIudOHAtQyxE0iOdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666772; c=relaxed/simple;
	bh=wSy6Yr6s4yoURR9ltgaBgFKg/z+xjlz/Lcmw8vk7j8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BoAfu2kQqsNCvWZyH+BxgV+8dk5UontWzYbwMvxWuhol3o+Htp1tGl/0R0P7nyFBNkXRFT1Le/VNvCSvGN+AlYe8hYJLwHFcb0bhceKniCs7xipc4rJUMJG/2H0gxaMrhgaIf5+A0kRUunw49XtsFdBI1+iI/worFvYVPGSlvas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zq2aIwM/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zq2aIwM/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C1E71F000E9;
	Tue, 21 Jul 2026 20:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666770;
	bh=gBOiYKaos/Euf114/g8RIqxWrJI6xSfPwXs1DYxi4KM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zq2aIwM/ZOdSHDwP8Np83IYOyccyPsbmBoixOsMeyKSGtUIRxZEJfPTg7FUdb2L2D
	 AwvR0S42Z5RyH72oehqZ8snn8XwFCu4JMJcnQBpSwM1KAOjgHVK5a8g30BRyYOpPGs
	 jOW5Vvm6AdVAGqri7jlANLDdc48LRKmBL2TYlGsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0809/1266] hwmon: (pmbus) Fix passing events to regulator core
Date: Tue, 21 Jul 2026 17:20:46 +0200
Message-ID: <20260721152459.962618338@linuxfoundation.org>
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
index a61e2fb176da78..eafeabfd93d77c 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -3190,18 +3190,23 @@ static void pmbus_regulator_notify_worker(struct work_struct *work)
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



