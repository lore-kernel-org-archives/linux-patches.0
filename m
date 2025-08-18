Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2D522A7E0;
	Mon, 18 Aug 2025 13:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523439; cv=none; b=BeH1gS40+JvlERGWR96yGRtIwiQ8qTCLRNEu9I2ri0o6BSpQZW89+qab0Ai8bDBIUi4Zb5ohrtwbWLK6xERBG9l6hTNeB3Ygs+h1E+otK1WqOg2Id6SuxZ6S2lt+gjL7lzhawiV6/HBKEPnciHmzzITT/URFIidHQb+sCkhRy8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523439; c=relaxed/simple;
	bh=v/kHnaSbWkmMw8mBeG/o6a1AWtp2T+mVjrWTWjxjN2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=doUYqK0LmqyP8w+CBZ1s8egCXiDxaQH82R5ayh11eUO+JiWTRuduhmmZqE40+Qovf0/Zdds5jiMGW5x6pUv4doooJBAWMOSLwno7IVV3TCpygEc6Gn6D2qm7YG2nKcirGRmzKG3jtWxLW9/dE5XrmtfsDH498dpJfxpGf1Zr7+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1iaaczN2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1iaaczN2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169FAC4CEEB;
	Mon, 18 Aug 2025 13:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523439;
	bh=v/kHnaSbWkmMw8mBeG/o6a1AWtp2T+mVjrWTWjxjN2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1iaaczN2ska792FAlbJp+S++rhjAvLWbDGm3SyG9uc4Lpv97ywbiQ+L4hbDnbM9ns
	 XNFxCA0BBh7yx7iTJdk0NTzDhs1UgIbZoDYm6v75XlFt4ecP4iHuh/So8DxsDnBugm
	 qRS87Nsf983FzfCPgDaWT22lEHw+6DgGfsA2M23k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Gottschall <s.gottschall@dd-wrt.com>,
	Markus Stockhausen <markus.stockhausen@gmx.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 171/515] irqchip/mips-gic: Allow forced affinity
Date: Mon, 18 Aug 2025 14:42:37 +0200
Message-ID: <20250818124504.949448054@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Stockhausen <markus.stockhausen@gmx.de>

[ Upstream commit 2250db8628a0d8293ad2e0671138b848a185fba1 ]

Devices of the Realtek MIPS Otto platform use the official rtl-otto-timer
as clock event generator and CPU clocksource. It is registered for each CPU
startup via cpuhp_setup_state() and forces the affinity of the clockevent
interrupts to the appropriate CPU via irq_force_affinity().

On the "smaller" devices with a vendor specific interrupt controller
(supported by irq-realtek-rtl) the registration works fine. The "larger"
RTL931x series is based on a MIPS interAptiv dual core with a MIPS GIC
controller. Interrupt routing setup is cancelled because gic_set_affinity()
does not accept the current (not yet online) CPU as a target.

Relax the checks by evaluating the force parameter that is provided for
exactly this purpose like in other drivers. With this the affinity can be
set as follows:

 - force = false: allow to set affinity to any online cpu
 - force = true:  allow to set affinity to any cpu

Co-developed-by: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Signed-off-by: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Signed-off-by: Markus Stockhausen <markus.stockhausen@gmx.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/20250621054952.380374-1-markus.stockhausen@gmx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-mips-gic.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-mips-gic.c b/drivers/irqchip/irq-mips-gic.c
index bca8053864b2..1c2284297354 100644
--- a/drivers/irqchip/irq-mips-gic.c
+++ b/drivers/irqchip/irq-mips-gic.c
@@ -375,9 +375,13 @@ static int gic_set_affinity(struct irq_data *d, const struct cpumask *cpumask,
 	/*
 	 * The GIC specifies that we can only route an interrupt to one VP(E),
 	 * ie. CPU in Linux parlance, at a time. Therefore we always route to
-	 * the first online CPU in the mask.
+	 * the first forced or online CPU in the mask.
 	 */
-	cpu = cpumask_first_and(cpumask, cpu_online_mask);
+	if (force)
+		cpu = cpumask_first(cpumask);
+	else
+		cpu = cpumask_first_and(cpumask, cpu_online_mask);
+
 	if (cpu >= NR_CPUS)
 		return -EINVAL;
 
-- 
2.39.5



