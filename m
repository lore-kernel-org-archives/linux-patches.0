Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDDF51F4275;
	Tue, 21 Jan 2025 18:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482700; cv=none; b=hsfrzmOHHZOwqLo6Qca4W1pF8NpQmeMBvFgJP/E18K9naOoR2AT4yqg032PWLApnhHmwV6/rqLqARcMC9tHJ5mWTaHYu810POeNp1XgTj2wguiiz6pUtl2brr9xYsUgrig10YDDPW3u+wSTRjOQmo/SDr0lhj68qnB+d6BpmVvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482700; c=relaxed/simple;
	bh=7KS8OEpK8bJDn6wnyLpt1hWnpiqEG1jnc3tf1Cuy5Pw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IU/GBlGMZFZdemrfkH3Gv58uG6gDv5h3V9dV0QvpP0iw7s6sU/IOc3TfJAsebQ/qL7lINgl36eXSUY9lPcdWQHLY+tHwWR7C7fnYEDtarPBUV46Ec1WjVfKNAawAe+k7IsCCdz2Vi8b+6d5X3bxC1+JLWU3BFNb91W9qcQSNa5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vnKY2QPJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vnKY2QPJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50778C4CEDF;
	Tue, 21 Jan 2025 18:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482700;
	bh=7KS8OEpK8bJDn6wnyLpt1hWnpiqEG1jnc3tf1Cuy5Pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vnKY2QPJ4kjtxJWqliSkrTCZEEb4aq8pP79OwolhhInX6i/0Y/vGTZnBvdne7uq8u
	 k+OY1Hv8K4pZ0G5a6eofUAsukhm01g+Jw/SB9pWJeHT1jFfnwSsIZgIA2yoeVmgmks
	 C5gDLIBnJxunkEqJTefUFrIwHDX2ZG/x4w3kL9bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yogesh Lal <quic_ylal@quicinc.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.1 44/64] irqchip/gic-v3: Handle CPU_PM_ENTER_FAILED correctly
Date: Tue, 21 Jan 2025 18:52:43 +0100
Message-ID: <20250121174523.234394584@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174521.568417761@linuxfoundation.org>
References: <20250121174521.568417761@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yogesh Lal <quic_ylal@quicinc.com>

commit 0d62a49ab55c99e8deb4593b8d9f923de1ab5c18 upstream.

When a CPU attempts to enter low power mode, it disables the redistributor
and Group 1 interrupts and reinitializes the system registers upon wakeup.

If the transition into low power mode fails, then the CPU_PM framework
invokes the PM notifier callback with CPU_PM_ENTER_FAILED to allow the
drivers to undo the state changes.

The GIC V3 driver ignores CPU_PM_ENTER_FAILED, which leaves the GIC in
disabled state.

Handle CPU_PM_ENTER_FAILED in the same way as CPU_PM_EXIT to restore normal
operation.

[ tglx: Massage change log, add Fixes tag ]

Fixes: 3708d52fc6bb ("irqchip: gic-v3: Implement CPU PM notifier")
Signed-off-by: Yogesh Lal <quic_ylal@quicinc.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20241220093907.2747601-1-quic_ylal@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-gic-v3.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -1424,7 +1424,7 @@ static int gic_retrigger(struct irq_data
 static int gic_cpu_pm_notifier(struct notifier_block *self,
 			       unsigned long cmd, void *v)
 {
-	if (cmd == CPU_PM_EXIT) {
+	if (cmd == CPU_PM_EXIT || cmd == CPU_PM_ENTER_FAILED) {
 		if (gic_dist_security_disabled())
 			gic_enable_redist(true);
 		gic_cpu_sys_reg_init();


