Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9B82EAE6;
	Mon, 23 Dec 2024 16:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969826; cv=none; b=pmmaepDgQV7JYciq5n7KizkqNrGWYC03YnXcIgj9W8uPVJQ94QxhftRIvvbJ3CcV2mLrTZjNtXq7iEwxHADLUIHHLqzLhIU77s8/h2naAjghBGsVGJ79Dggv8oES2sKif65VF+nW+CNRQx4K+sZgARLiK0mhvPmFpzrubkpZh6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969826; c=relaxed/simple;
	bh=maM67o/x2IRaSYxY9kfXT2F8n6Hb7osqrUK6J+64yPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tbHTLTZoywMZFjBtPuHdaFw8MwLfj3DCmpXB5qXcMh3E4cJMukuqmo2vG3V+A1Hp/SzAG7GmWX5TKwLAOMcMnd9UBbgewuTtq+6mWwra3ReWkjcY0wDVd722XeyEXdH6fB7EfKc6DWbPJvu/y3YV9Kb2bUHn7ul/UJQ9Ub/FPjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vC9gkXwT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vC9gkXwT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F168AC4CED3;
	Mon, 23 Dec 2024 16:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969826;
	bh=maM67o/x2IRaSYxY9kfXT2F8n6Hb7osqrUK6J+64yPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vC9gkXwTRfSJ/uc4J3aSoK8ALz6fSm6sbyK+CyVjYChKXoLV3SjEYLpUXYRVlHA40
	 i0Yi72hwUzanLXMop3Duuy1uyxyjhL/ryfxddQMrEPSgsUCmZRBU+msjI/oZY0gjFg
	 27D6HfYEdCAp9HVrjvTgI++GDkHRoLFaMu37VC68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Kettenis <mark.kettenis@xs4all.nl>,
	Chen-Yu Tsai <wens@csie.org>,
	Marc Zyngier <maz@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.12 065/160] irqchip/gic-v3: Work around insecure GIC integrations
Date: Mon, 23 Dec 2024 16:57:56 +0100
Message-ID: <20241223155411.185829814@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Marc Zyngier <maz@kernel.org>

commit 773c05f417fa14e1ac94776619e9c978ec001f0b upstream.

It appears that the relatively popular RK3399 SoC has been put together
using a large amount of illicit substances, as experiments reveal that its
integration of GIC500 exposes the *secure* programming interface to
non-secure.

This has some pretty bad effects on the way priorities are handled, and
results in a dead machine if booting with pseudo-NMI enabled
(irqchip.gicv3_pseudo_nmi=1) if the kernel contains 18fdb6348c480 ("arm64:
irqchip/gic-v3: Select priorities at boot time"), which relies on the
priorities being programmed using the NS view.

Let's restore some sanity by going one step further and disable security
altogether in this case. This is not any worse, and puts us in a mode where
priorities actually make some sense.

Huge thanks to Mark Kettenis who initially identified this issue on
OpenBSD, and to Chen-Yu Tsai who reported the problem in Linux.

Fixes: 18fdb6348c480 ("arm64: irqchip/gic-v3: Select priorities at boot time")
Reported-by: Mark Kettenis <mark.kettenis@xs4all.nl>
Reported-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Chen-Yu Tsai <wens@csie.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20241213141037.3995049-1-maz@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-gic-v3.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 34db379d066a..79d8cc80693c 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -161,7 +161,22 @@ static bool cpus_have_group0 __ro_after_init;
 
 static void __init gic_prio_init(void)
 {
-	cpus_have_security_disabled = gic_dist_security_disabled();
+	bool ds;
+
+	ds = gic_dist_security_disabled();
+	if (!ds) {
+		u32 val;
+
+		val = readl_relaxed(gic_data.dist_base + GICD_CTLR);
+		val |= GICD_CTLR_DS;
+		writel_relaxed(val, gic_data.dist_base + GICD_CTLR);
+
+		ds = gic_dist_security_disabled();
+		if (ds)
+			pr_warn("Broken GIC integration, security disabled");
+	}
+
+	cpus_have_security_disabled = ds;
 	cpus_have_group0 = gic_has_group0();
 
 	/*
-- 
2.47.1



