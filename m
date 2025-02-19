Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6601BEF77;
	Wed, 19 Feb 2025 09:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955840; cv=none; b=LgLiv7UtVLYXIs4XXmB6CfS7/qtuP9U8b5Rr9TgZwnjNBgGMjVJMNe6L1hWaKiqJp4tEgppXa1M2sC+IelJnoPDA7rcmJVN5WrdWOllBUeE4bQkVhLQIblaSl1KUD2tEkB+UPL4a8PqnD8trLSeOuFgrbnSTjC2OOKlzIZcras4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955840; c=relaxed/simple;
	bh=KnsDV+bj75YZKyzgWVS4AX5UHboDRkhxNwakLHJkVlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CNpv6Os4hyVDs+vAMD7SyRBTnL2uVT8TPEd/9qnk9RxB5FuftfsmYYYLo+j3FCOxEF8YH8QLfPiOjetHxML9jMv+mVD4l6Q1xAoLCJSM7gMl6da793/LT5FOTMfDExndJSImBpCkNuAIVSQgZE+Ilga/LE0BrKWWJdYWec70QNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mBp12ZbH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mBp12ZbH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E906CC4CED1;
	Wed, 19 Feb 2025 09:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955839;
	bh=KnsDV+bj75YZKyzgWVS4AX5UHboDRkhxNwakLHJkVlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mBp12ZbH6Si1qBvsxG9YEOEFeVUvABMNvIWUAoSEeCcLM0MS8cHCrzltg40ODS36e
	 v4tGNh9/92yLLQRYn2HC+bT8MN3FudcvfoGVBXCni8ntm6ZiGIjF62MCo/7u9HVZad
	 O07sAGtuTKPIUwxxddInOnfm9FsW9NXEYXg9OCLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bin Liu <b-liu@ti.com>,
	Devarsh Thakkar <devarsht@ti.com>,
	Jonathan Cormier <jcormier@criticallink.com>,
	Aradhya Bhatia <aradhya.bhatia@linux.dev>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Subject: [PATCH 6.6 129/152] drm/tidss: Fix issue in irq handling causing irq-flood issue
Date: Wed, 19 Feb 2025 09:29:02 +0100
Message-ID: <20250219082555.153774188@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

commit 44b6730ab53ef04944fbaf6da0e77397531517b7 upstream.

It has been observed that sometimes DSS will trigger an interrupt and
the top level interrupt (DISPC_IRQSTATUS) is not zero, but the VP and
VID level interrupt-statuses are zero.

As the top level irqstatus is supposed to tell whether we have VP/VID
interrupts, the thinking of the driver authors was that this particular
case could never happen. Thus the driver only clears the DISPC_IRQSTATUS
bits which has corresponding interrupts in VP/VID status. So when this
issue happens, the driver will not clear DISPC_IRQSTATUS, and we get an
interrupt flood.

It is unclear why the issue happens. It could be a race issue in the
driver, but no such race has been found. It could also be an issue with
the HW. However a similar case can be easily triggered by manually
writing to DISPC_IRQSTATUS_RAW. This will forcibly set a bit in the
DISPC_IRQSTATUS and trigger an interrupt, and as the driver never clears
the bit, we get an interrupt flood.

To fix the issue, always clear DISPC_IRQSTATUS. The concern with this
solution is that if the top level irqstatus is the one that triggers the
interrupt, always clearing DISPC_IRQSTATUS might leave some interrupts
unhandled if VP/VID interrupt statuses have bits set. However, testing
shows that if any of the irqstatuses is set (i.e. even if
DISPC_IRQSTATUS == 0, but a VID irqstatus has a bit set), we will get an
interrupt.

Co-developed-by: Bin Liu <b-liu@ti.com>
Signed-off-by: Bin Liu <b-liu@ti.com>
Co-developed-by: Devarsh Thakkar <devarsht@ti.com>
Signed-off-by: Devarsh Thakkar <devarsht@ti.com>
Co-developed-by: Jonathan Cormier <jcormier@criticallink.com>
Signed-off-by: Jonathan Cormier <jcormier@criticallink.com>
Fixes: 32a1795f57ee ("drm/tidss: New driver for TI Keystone platform Display SubSystem")
Cc: stable@vger.kernel.org
Tested-by: Jonathan Cormier <jcormier@criticallink.com>
Reviewed-by: Aradhya Bhatia <aradhya.bhatia@linux.dev>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241021-tidss-irq-fix-v1-1-82ddaec94e4a@ideasonboard.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tidss/tidss_dispc.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/tidss/tidss_dispc.c
+++ b/drivers/gpu/drm/tidss/tidss_dispc.c
@@ -726,24 +726,20 @@ static
 void dispc_k3_clear_irqstatus(struct dispc_device *dispc, dispc_irq_t clearmask)
 {
 	unsigned int i;
-	u32 top_clear = 0;
 
 	for (i = 0; i < dispc->feat->num_vps; ++i) {
-		if (clearmask & DSS_IRQ_VP_MASK(i)) {
+		if (clearmask & DSS_IRQ_VP_MASK(i))
 			dispc_k3_vp_write_irqstatus(dispc, i, clearmask);
-			top_clear |= BIT(i);
-		}
 	}
 	for (i = 0; i < dispc->feat->num_planes; ++i) {
-		if (clearmask & DSS_IRQ_PLANE_MASK(i)) {
+		if (clearmask & DSS_IRQ_PLANE_MASK(i))
 			dispc_k3_vid_write_irqstatus(dispc, i, clearmask);
-			top_clear |= BIT(4 + i);
-		}
 	}
 	if (dispc->feat->subrev == DISPC_K2G)
 		return;
 
-	dispc_write(dispc, DISPC_IRQSTATUS, top_clear);
+	/* always clear the top level irqstatus */
+	dispc_write(dispc, DISPC_IRQSTATUS, dispc_read(dispc, DISPC_IRQSTATUS));
 
 	/* Flush posted writes */
 	dispc_read(dispc, DISPC_IRQSTATUS);


