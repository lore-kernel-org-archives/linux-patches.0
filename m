Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0C025FA14;
	Tue, 11 Mar 2025 15:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707149; cv=none; b=f0xdrkdKH1CSEZFvRTlWMsgiDA0gmZ927lOIiDgnIsJ//m9I4Ws1yIPIOT/WZuzzESIvXiDUEeK+3Fi9kvO5uCo6QmqII+XPW7XCnX/wR09La9pliS7JCIQA9JCVmdvfzhPygUf5oU+Mvkn9XPgwPC+CYdpg4F4ERBmNvZhpEuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707149; c=relaxed/simple;
	bh=xcnKniclKUxTmLzFp2Uq8Jndjh0KGw9MGnkF7l94qcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Puc2XAVXlnRfbbarRQBXG3rNn6g/xso/1JnuZpA1bErH6Fct+O9RKtq2bNQRRwr8zr+p6AmvavipelmZj8JRsBuIa1bslno7ECXQDEy+wxNJksDwEUCjsNBFE+PAeJbitWb6Cynem/crJGe49cUAzOPmBJxKoaVcID64N0frCt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rfX1bGdU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rfX1bGdU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988CBC4CEF0;
	Tue, 11 Mar 2025 15:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707149;
	bh=xcnKniclKUxTmLzFp2Uq8Jndjh0KGw9MGnkF7l94qcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rfX1bGdUX9MACx6+SSCysfTipgDzbymME7er5ucQ/2McbtqHeHPuci80xzUUSs33Q
	 eo7fgRU0ExnavCzroGQw8wtrkb1X5Fd08rceoRFBpNqaHUregldm+ILZPePOlohuVd
	 DrsxEOZRiWrmUKUPZe79XctJR10tTknpfgefEkMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cormier <jcormier@criticallink.com>,
	Devarsh Thakkar <devarsht@ti.com>,
	Aradhya Bhatia <aradhya.bhatia@linux.dev>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Subject: [PATCH 5.10 291/462] drm/tidss: Clear the interrupt status for interrupts being disabled
Date: Tue, 11 Mar 2025 15:59:17 +0100
Message-ID: <20250311145809.862886461@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Devarsh Thakkar <devarsht@ti.com>

commit 361a2ebb5cad211732ec3c5d962de49b21895590 upstream.

The driver does not touch the irqstatus register when it is disabling
interrupts.  This might cause an interrupt to trigger for an interrupt
that was just disabled.

To fix the issue, clear the irqstatus registers right after disabling
the interrupts.

Fixes: 32a1795f57ee ("drm/tidss: New driver for TI Keystone platform Display SubSystem")
Cc: stable@vger.kernel.org
Reported-by: Jonathan Cormier <jcormier@criticallink.com>
Closes: https://e2e.ti.com/support/processors-group/processors/f/processors-forum/1394222/am625-issue-about-tidss-rcu_preempt-self-detected-stall-on-cpu/5424479#5424479
Signed-off-by: Devarsh Thakkar <devarsht@ti.com>
[Tomi: mostly rewrote the patch]
Reviewed-by: Jonathan Cormier <jcormier@criticallink.com>
Tested-by: Jonathan Cormier <jcormier@criticallink.com>
Reviewed-by: Aradhya Bhatia <aradhya.bhatia@linux.dev>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241021-tidss-irq-fix-v1-5-82ddaec94e4a@ideasonboard.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tidss/tidss_dispc.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/tidss/tidss_dispc.c
+++ b/drivers/gpu/drm/tidss/tidss_dispc.c
@@ -596,7 +596,7 @@ void dispc_k2g_set_irqenable(struct disp
 {
 	dispc_irq_t old_mask = dispc_k2g_read_irqenable(dispc);
 
-	/* clear the irqstatus for newly enabled irqs */
+	/* clear the irqstatus for irqs that will be enabled */
 	dispc_k2g_clear_irqstatus(dispc, (mask ^ old_mask) & mask);
 
 	dispc_k2g_vp_set_irqenable(dispc, 0, mask);
@@ -604,6 +604,9 @@ void dispc_k2g_set_irqenable(struct disp
 
 	dispc_write(dispc, DISPC_IRQENABLE_SET, (1 << 0) | (1 << 7));
 
+	/* clear the irqstatus for irqs that were disabled */
+	dispc_k2g_clear_irqstatus(dispc, (mask ^ old_mask) & old_mask);
+
 	/* flush posted write */
 	dispc_k2g_read_irqenable(dispc);
 }
@@ -735,7 +738,7 @@ static void dispc_k3_set_irqenable(struc
 
 	old_mask = dispc_k3_read_irqenable(dispc);
 
-	/* clear the irqstatus for newly enabled irqs */
+	/* clear the irqstatus for irqs that will be enabled */
 	dispc_k3_clear_irqstatus(dispc, (old_mask ^ mask) & mask);
 
 	for (i = 0; i < dispc->feat->num_vps; ++i) {
@@ -760,6 +763,9 @@ static void dispc_k3_set_irqenable(struc
 	if (main_disable)
 		dispc_write(dispc, DISPC_IRQENABLE_CLR, main_disable);
 
+	/* clear the irqstatus for irqs that were disabled */
+	dispc_k3_clear_irqstatus(dispc, (old_mask ^ mask) & old_mask);
+
 	/* Flush posted writes */
 	dispc_read(dispc, DISPC_IRQENABLE_SET);
 }


