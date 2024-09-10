Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5D35381A;
	Tue, 10 Sep 2024 10:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965234; cv=none; b=AAQuCAxOKwxcOQ6Sm4DWY2wmvuwVf/2glKyvRtmiK0enp0CG7vxYDrPscPV4TjZcinhO0e6NMczCvzOvL5AnOHSyy3bzeiUNcVvOnpYkATJ5S9+PVfnLGbPDenflwex8IxjEY6D83o/xInw9HujubeXyJL5H7/+npcTTKrYDLFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965234; c=relaxed/simple;
	bh=LGBOJg5EXC27K8gF5jBeyuVN+tYJihNNePwnEkW0FvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BLIbsDaLw++N/KHR+Dy70B8gNP+NEmwaLDPCD3cCeBzNqMqbG8dkgSCHQ3yjqW7UlOQ83R1m0atmAi+MD4OJes6ObcQqEqPVyqqQNO1xP01UxwCwt9rKA53NzqN1dkBSTWpPiB+E1uZYsqiX5NSODJBtWiIPMtvHN7x/byyNWbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=emPm4Ccy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="emPm4Ccy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 043A4C4CEC3;
	Tue, 10 Sep 2024 10:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965234;
	bh=LGBOJg5EXC27K8gF5jBeyuVN+tYJihNNePwnEkW0FvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=emPm4CcyhudGb1W/mMZfkCPBIM8E4SEOTOLAXb2/mS6nZRqnv3SPvkrhP631/Aq/l
	 BkKJHAbYan5+yB8TFfjwfZwA1E5cJP7XaUsPq5n/75x3rjPPrdLkqkGB+svLDLuHNY
	 r2OGP0frkgyUbKgDWSGXiWmgLfKuZ86be6pzB1bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serge Semin <fancer.lancer@gmail.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 155/186] MIPS: cevt-r4k: Dont call get_c0_compare_int if timer irq is installed
Date: Tue, 10 Sep 2024 11:34:10 +0200
Message-ID: <20240910092600.968173058@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 995ad9e69ded..23207516015c 100644
--- a/arch/mips/kernel/cevt-r4k.c
+++ b/arch/mips/kernel/cevt-r4k.c
@@ -307,13 +307,6 @@ int r4k_clockevent_init(void)
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
@@ -324,7 +317,6 @@ int r4k_clockevent_init(void)
 	min_delta		= calculate_min_delta();
 
 	cd->rating		= 300;
-	cd->irq			= irq;
 	cd->cpumask		= cpumask_of(cpu);
 	cd->set_next_event	= mips_next_event;
 	cd->event_handler	= mips_event_handler;
@@ -336,6 +328,13 @@ int r4k_clockevent_init(void)
 
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



