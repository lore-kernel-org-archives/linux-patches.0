Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6785381A;
	Tue, 10 Sep 2024 10:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963770; cv=none; b=noVBbjQopb1Vz87PzGeJpbWkmNdn8/Ehjam4B9Rc7BlxejKlWnjLMSeEHS6KlXJoN0pB42lSir3omHqaPcgqc0VWnOQHgA+EiGDCDIn5BgTVMttT1DNN0OZFwP/cvgPlNABOJYRinx1DDNDNONHaFpz1XoEH8IvnW6+yNO7r/BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963770; c=relaxed/simple;
	bh=CKf2J/ASqGR/BZNvQk6vrmK49jSVbpBYWFITzFgkj4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HIPj3rOLenaq855UouisXZoSMM5Xv+i1aCbqEFE4tHu5hqvqdlGSOtDg1vvBxtRCxOvTI8d3P9tACv6L0NrASchTWU4ujWJWr6AMOGr4PIOp8X6GjoI6miIkETVc2NZk7fqg5yy204ILBrO9FPjYjQbjMpunUOWCH4bRMbfIV0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s+yx00zT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s+yx00zT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A4CC4CECD;
	Tue, 10 Sep 2024 10:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963770;
	bh=CKf2J/ASqGR/BZNvQk6vrmK49jSVbpBYWFITzFgkj4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s+yx00zTQizZTAihaxVMXVZECElrS8cDnh+ouOyLPpKGmj1oATFLzZplUJjgFE8Vo
	 lNS2vKVcMJ9BNqyFXX4J4joe4nlevUmu0dS8NyOTz2RvWooIILAsvneBMibK9Fjp2F
	 5mm/JqCJ7uXCXYl9ckiYnpGeKkERF8PZfVPwT6ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serge Semin <fancer.lancer@gmail.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 170/214] MIPS: cevt-r4k: Dont call get_c0_compare_int if timer irq is installed
Date: Tue, 10 Sep 2024 11:33:12 +0200
Message-ID: <20240910092605.633369315@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
User-Agent: quilt/0.67
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

[ Upstream commit 50f2b98dc83de7809a5c5bf0ccf9af2e75c37c13 ]

This avoids warning:

[    0.118053] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:283

Caused by get_c0_compare_int on secondary CPU.

We also skipped saving IRQ number to struct clock_event_device *cd as
it's never used by clockevent core, as per comments it's only meant
for "non CPU local devices".

Reported-by: Serge Semin <fancer.lancer@gmail.com>
Closes: https://lore.kernel.org/linux-mips/6szkkqxpsw26zajwysdrwplpjvhl5abpnmxgu2xuj3dkzjnvsf@4daqrz4mf44k/
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Tested-by: Serge Semin <fancer.lancer@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/cevt-r4k.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/mips/kernel/cevt-r4k.c b/arch/mips/kernel/cevt-r4k.c
index 32ec67c9ab67..77028aa8c107 100644
--- a/arch/mips/kernel/cevt-r4k.c
+++ b/arch/mips/kernel/cevt-r4k.c
@@ -303,13 +303,6 @@ int r4k_clockevent_init(void)
 	if (!c0_compare_int_usable())
 		return -ENXIO;
 
-	/*
-	 * With vectored interrupts things are getting platform specific.
-	 * get_c0_compare_int is a hook to allow a platform to return the
-	 * interrupt number of its liking.
-	 */
-	irq = get_c0_compare_int();
-
 	cd = &per_cpu(mips_clockevent_device, cpu);
 
 	cd->name		= "MIPS";
@@ -320,7 +313,6 @@ int r4k_clockevent_init(void)
 	min_delta		= calculate_min_delta();
 
 	cd->rating		= 300;
-	cd->irq			= irq;
 	cd->cpumask		= cpumask_of(cpu);
 	cd->set_next_event	= mips_next_event;
 	cd->event_handler	= mips_event_handler;
@@ -332,6 +324,13 @@ int r4k_clockevent_init(void)
 
 	cp0_timer_irq_installed = 1;
 
+	/*
+	 * With vectored interrupts things are getting platform specific.
+	 * get_c0_compare_int is a hook to allow a platform to return the
+	 * interrupt number of its liking.
+	 */
+	irq = get_c0_compare_int();
+
 	if (request_irq(irq, c0_compare_interrupt, flags, "timer",
 			c0_compare_interrupt))
 		pr_err("Failed to request irq %d (timer)\n", irq);
-- 
2.43.0



