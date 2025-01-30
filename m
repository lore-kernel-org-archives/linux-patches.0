Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217D71E8824;
	Thu, 30 Jan 2025 14:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246797; cv=none; b=ddVgSgI+bIFUQJ97WrmUbzxUJ09yKuhZBT9hqRKWBP1i7JETlO/qTLl1pAZr3T+YzAXyQgFdKXKU85cpeusODlbPPdAQYkwiUXxbS4E8NZ2GiAHVxZbPc2Dh2kYvhipMQ0WH8tbRenVUl2IVpOz0kPSu/2PVwl/4tUJkA168BKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246797; c=relaxed/simple;
	bh=qBG190h32KFK4iwueHmbce2Mn3TULEIzwsT9IcEQ3dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H9umUdjSwUQ/0y6LxVYBTU+KdLrGYWGT0zrWRz6uD4Os8Edh4LsYULRyte9wSRBkObIHbY9xggn47sG9oOKmexpuyv9a4rFKQfw13uQvlIOc6MXUlP2dhIZqKtAbAMveXk9XGtXz/vfs/P+Vv15mdgH80GTn5lTphwnCPBcRgTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F0pgzDgf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F0pgzDgf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC50C4CED2;
	Thu, 30 Jan 2025 14:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246797;
	bh=qBG190h32KFK4iwueHmbce2Mn3TULEIzwsT9IcEQ3dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F0pgzDgfsI1c0BPjMpOxjApP15/uqRAxXIZHAoQsKHBmQE7Cfq5zTwaJz674jk3sf
	 Goov3OkYxnlHSM4HMKGVY3D4wZ0zeh3yART7Y8McfRu9QWRjibju3LZAdgEHhQU8nX
	 tUHu9cM9ZoJt2TrpCozX1fJiVolNKew2H4ZyQCss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yogesh Lal <quic_ylal@quicinc.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.4 70/91] irqchip/gic-v3: Handle CPU_PM_ENTER_FAILED correctly
Date: Thu, 30 Jan 2025 15:01:29 +0100
Message-ID: <20250130140136.493146788@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1185,7 +1185,7 @@ static int gic_set_affinity(struct irq_d
 static int gic_cpu_pm_notifier(struct notifier_block *self,
 			       unsigned long cmd, void *v)
 {
-	if (cmd == CPU_PM_EXIT) {
+	if (cmd == CPU_PM_EXIT || cmd == CPU_PM_ENTER_FAILED) {
 		if (gic_dist_security_disabled())
 			gic_enable_redist(true);
 		gic_cpu_sys_reg_init();


