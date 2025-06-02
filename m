Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4FCE2C324D;
	Mon,  2 Jun 2025 14:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873629; cv=none; b=XM3pDk2nglQHWoZOUXE8L7VFcoJf97psDsMl4dAKVGi6F+bq6/LonZHbd2exGY/8lYAr4/m1B0z8QaTLUeMFh79EsEtueQmRAatotGhm2yyIACxT+TYBfg7UnZSGZR/JHqmWR6lIEx42ZgS1UXqVvjyovj0F8RHU8zW9nXKj8DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873629; c=relaxed/simple;
	bh=hk1oy6/ujm1yW58E441cNIUxcwZHos1WtXHjODjQSBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AL1Cne66GtUypZ/2F60/mdBHUfi6kYoRXhpAUM8xjNMV5vwTme0kQbzxltC8aEDcKPT6QNYd57+i1luAS2yea6DVX2BGOeV4Sg7XmKuRZjmNv5PBlHtxLrrNc17YzIsHG3gu+yqdrO68yRYkQU/DVtlEvkvJe8iCCBV76SwOTUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q4r815Jt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q4r815Jt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BBBFC4CEEB;
	Mon,  2 Jun 2025 14:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873629;
	bh=hk1oy6/ujm1yW58E441cNIUxcwZHos1WtXHjODjQSBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q4r815JtAkBQby3IPaYvomp9q0XpIpqcR3ze6Kz1A0zBD4jWGcu39wwQ+Gc2KzBZj
	 ltAbaS8Jq41aEO9mV/q4lMExn+zRdqSpnc7lgQhl9XwOJ+NvemmQ65MjvaHKqWgqI5
	 fYY/cg1WKB7UZKayvomTa/MxD6ZRrsO4LVP+MRNQ=
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
Subject: [PATCH 6.6 201/444] clocksource: mips-gic-timer: Enable counter when CPUs start
Date: Mon,  2 Jun 2025 15:44:25 +0200
Message-ID: <20250602134349.063243171@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b3ae38f367205..39c70b5ac44c9 100644
--- a/drivers/clocksource/mips-gic-timer.c
+++ b/drivers/clocksource/mips-gic-timer.c
@@ -114,6 +114,9 @@ static void gic_update_frequency(void *data)
 
 static int gic_starting_cpu(unsigned int cpu)
 {
+	/* Ensure the GIC counter is running */
+	clear_gic_config(GIC_CONFIG_COUNTSTOP);
+
 	gic_clockevent_cpu_init(cpu, this_cpu_ptr(&gic_clockevent_device));
 	return 0;
 }
@@ -248,9 +251,6 @@ static int __init gic_clocksource_of_init(struct device_node *node)
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



