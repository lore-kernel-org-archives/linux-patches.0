Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDBF158862;
	Wed, 19 Feb 2025 09:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957575; cv=none; b=UeQyAdgCAoX9TPaL6C6V93HEI/JEzs+Fi/8kuaAciXLLR/n/tJe6UeY6pzYhH5LfPS3b3lRdONwjQyaI6rSwRJ7EYnKMDhWhG1EU1oqb4q87BRDOA0JIzpODzMBx3nmSBjW44mF8gmG7qMq6HlpNDTAvSTeUiHIoLJQvtRnTaCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957575; c=relaxed/simple;
	bh=wuPdFnKMLLLcW7csfBrZfVBqEOjDW0lQhjrUT9uDpvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CxGRiXgG9DaWx8BPZGplPWwCtNKhg0vgSPGgfTPoo9lM48gn8CBjDWNv8V140ZhegQpnoYHeAn5SFf0oCAGfRoMA2PLBg8DzDwvmyTKIpaqMqvT1p2j10ilzCIXWnFHDAOVDQDGAojgGguDX5Hsg8CRb03jVQc7H7TQ/YCo1Fl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tC9jzl42; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tC9jzl42"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3DC8C4CED1;
	Wed, 19 Feb 2025 09:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957575;
	bh=wuPdFnKMLLLcW7csfBrZfVBqEOjDW0lQhjrUT9uDpvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tC9jzl42kAJph11EU07+h/yjma6bbj/y5WRLw/Frg/2mrChrTdhGiF73eSBIpXxGN
	 ZRPQ0PygEDHTZQArwZggevPwCPH8kYKy6dy3DvQAbSYG7n0VBhBwU/P//uVoYjYmP1
	 yWRWvu5Lo0LWmgcUsclpsF5tW8M2miNk1SbDA8Cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bin Liu <b-liu@ti.com>,
	Devarsh Thakkar <devarsht@ti.com>,
	Jonathan Cormier <jcormier@criticallink.com>,
	Aradhya Bhatia <aradhya.bhatia@linux.dev>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Subject: [PATCH 6.1 556/578] drm/tidss: Fix issue in irq handling causing irq-flood issue
Date: Wed, 19 Feb 2025 09:29:20 +0100
Message-ID: <20250219082714.827798335@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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
@@ -679,24 +679,20 @@ static
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


