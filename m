Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151A21EA91;
	Tue, 27 May 2025 17:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365343; cv=none; b=m6PIOJozV0R34yz938xeHOQDJKvmxovAR+WbMdE2yI2KnmHSItJqmGrAzAzWs8qJ9CCq3YiG+qLQjLBYPm2QWC8jhlYLn+/7NAhUVDNnf1pgAQFkskTyUCoIJ+pkd0BpsA8D7sSV8veE9zLtUMVPO8rKk1luCf1kuvABH8N5nOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365343; c=relaxed/simple;
	bh=1Z9Q+a/uWSfi4t7DZzFQFyDznOnJ4vi+H8dC9VG4wN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Laia3g64Zsz3Czm0ssmKbpJBK4lN5JcYddbq1B+BXyHKvfNefYZXF54diUMHJhAEpm/7PsCDg+TEmoUUL7vdrIajWbpz7nKP4YvPM8n46wbjDl9icCK6kxwoCoCuC5Fl53L5Z2PaBd1e0sJDfDMt1sm+yxWMAvNUmMvfgM8t7Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WvUhsxNy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WvUhsxNy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706F6C4CEE9;
	Tue, 27 May 2025 17:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365342;
	bh=1Z9Q+a/uWSfi4t7DZzFQFyDznOnJ4vi+H8dC9VG4wN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WvUhsxNyhdDL3hk5luwy3PDEM7o5Nm451Nk0blwvz3dwdZiXxqcKhGdBxhfoldf5o
	 QsH4xe6Ja9uzVR56ubCiK9A8W7zJa7ijymIwbB6IyQDkkTTyvqksPFvPHmShtTvUNj
	 juxKiKoDYIN5moAxN1NaJghPuAVOj3+H9BaQPtig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Burton <paulburton@kernel.org>,
	Chao-ying Fu <cfu@wavecomp.com>,
	Dragan Mladjenovic <dragan.mladjenovic@syrmia.com>,
	Aleksandar Rikalo <arikalo@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Serge Semin <fancer.lancer@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 315/626] clocksource: mips-gic-timer: Enable counter when CPUs start
Date: Tue, 27 May 2025 18:23:28 +0200
Message-ID: <20250527162457.830895702@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Burton <paulburton@kernel.org>

[ Upstream commit 3128b0a2e0cf6e07aa78e5f8cf7dd9cd59dc8174 ]

In multi-cluster MIPS I6500 systems there is a GIC in each cluster,
each with its own counter. When a cluster powers up the counter will
be stopped, with the COUNTSTOP bit set in the GIC_CONFIG register.

In single cluster systems, it has been fine to clear COUNTSTOP once
in gic_clocksource_of_init() to start the counter. In multi-cluster
systems, this will only have started the counter in the boot cluster,
and any CPUs in other clusters will find their counter stopped which
will break the GIC clock_event_device.

Resolve this by having CPUs clear the COUNTSTOP bit when they come
online, using the existing gic_starting_cpu() CPU hotplug callback. This
will allow CPUs in secondary clusters to ensure that the cluster's GIC
counter is running as expected.

Signed-off-by: Paul Burton <paulburton@kernel.org>
Signed-off-by: Chao-ying Fu <cfu@wavecomp.com>
Signed-off-by: Dragan Mladjenovic <dragan.mladjenovic@syrmia.com>
Signed-off-by: Aleksandar Rikalo <arikalo@gmail.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Tested-by: Serge Semin <fancer.lancer@gmail.com>
Tested-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/mips-gic-timer.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clocksource/mips-gic-timer.c b/drivers/clocksource/mips-gic-timer.c
index 110347707ff98..8592910710d17 100644
--- a/drivers/clocksource/mips-gic-timer.c
+++ b/drivers/clocksource/mips-gic-timer.c
@@ -115,6 +115,9 @@ static void gic_update_frequency(void *data)
 
 static int gic_starting_cpu(unsigned int cpu)
 {
+	/* Ensure the GIC counter is running */
+	clear_gic_config(GIC_CONFIG_COUNTSTOP);
+
 	gic_clockevent_cpu_init(cpu, this_cpu_ptr(&gic_clockevent_device));
 	return 0;
 }
@@ -252,9 +255,6 @@ static int __init gic_clocksource_of_init(struct device_node *node)
 			pr_warn("Unable to register clock notifier\n");
 	}
 
-	/* And finally start the counter */
-	clear_gic_config(GIC_CONFIG_COUNTSTOP);
-
 	/*
 	 * It's safe to use the MIPS GIC timer as a sched clock source only if
 	 * its ticks are stable, which is true on either the platforms with
-- 
2.39.5



