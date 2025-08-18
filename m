Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DBF335BD4;
	Mon, 18 Aug 2025 13:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525193; cv=none; b=GqrYm8vxfSGyHHIC8I4GNo/9UtZxdhrUQMrLfyxlFCJ27KbzbiSiJCc7+4UVahd1nWesLaruuk8lIeuj+yOwabnpxGyMz9KIEiiXMd+XSz5cw5G8ccrIgIwYanisRqP/I9Iy0udMkhbtQTY5IoJE4sR7zx4JmLX7ywo9C8pmOI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525193; c=relaxed/simple;
	bh=0tsVrmYPSNOQdXtT4uBiUduVN3aM02WDHneOtvqfab8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KIkN6ttSx01VakFE0+T7ubNbNp4cs+wnUZ1Y/RHYx1s8OMoWywufFbh8Lvx1PgMVzc+TF1QBGJwPOMNGOQiF8zIHSCX39sxWizVZk7v15eVoomzTxJCilgESkGc+2sAQtbo0CdqUFM9+rcIbCxWQXvJWZbfdz418txA6ac2x28U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uYOPImPi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uYOPImPi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A693C4CEF1;
	Mon, 18 Aug 2025 13:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525193;
	bh=0tsVrmYPSNOQdXtT4uBiUduVN3aM02WDHneOtvqfab8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uYOPImPitHgodt586TSovMRY+nq0t4JBTkhVaADDoHLdu76DYiCkqUZBvXt0I2f1O
	 ouQq+2O7V0eTiAf4ZwZpWmZFeJeNVSSjiEfWjWh4VqujT18ImQUPFFZsRWi4Qq0KeQ
	 ior1RSmhT4AnV5nh9aFja++Kod2aQ1ELS5zF2HQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Gottschall <s.gottschall@dd-wrt.com>,
	Markus Stockhausen <markus.stockhausen@gmx.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 187/570] irqchip/mips-gic: Allow forced affinity
Date: Mon, 18 Aug 2025 14:42:54 +0200
Message-ID: <20250818124513.012307042@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 34e8d09c12a0..19a57c5e2b2e 100644
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



