Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627D0293458;
	Fri,  7 Aug 2026 14:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114378; cv=none; b=hY5fxE/mgdRHABZ0NE7JMZZJbWCMkaDW1JC0VbutCIzSz4979YkVeWnGrWwkoPsSehkbZTdurC5tSJM8vdPeOrCnlnL4jw2rr4Ww5dRnP4/TD1JTSWr2bUahsTbF3VMLm8539YuB+yiuT2Htavw3eott3Q2jjL6sCsaF0uXxajg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114378; c=relaxed/simple;
	bh=EeziH3b/qqosfxMZ5FaaAehbC/xsIO7efq3Cw58Df94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IVbgbwXXZfsu+zjfCYHtO7AbTBPbIVKEJuyvEkvyzTJ9kfriNU1hBdpg2sluIYcMVJPtC+LDExtIYVwAxAfZQFyt5EczrVySAVTwKQEYRTOPSREwPULIBrlxltMhe2oWL/ftt3gLUCLU/CAxbEcMPMEv2mdU85szN48gI8kuEsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dRXwK/Sm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dRXwK/Sm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FEFD1F000E9;
	Fri,  7 Aug 2026 14:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114376;
	bh=5nUiH+93gRw7XDOYJNip7BXX1kY7YTKh6bZHIvgshqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dRXwK/SmlZCVH+r/U6Y2HVCjhl4qKqKXqaj66L06VmfUPUExncGVVXxWMzaCPb8hc
	 L/7L3/LOUKoEg87nEzZNZfLJJ475/YqjAxbDhgqN7ALenUXOI676a1nZDH02e2dTcn
	 K3LRRu8SEG0flnNFHpSmMQXoY+cUPrmlM1EeBT5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Pavel Pisa <pisa@fel.cvut.cz>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.12 242/337] can: ctucanfd: handle bus error interrupts
Date: Fri,  7 Aug 2026 16:37:25 +0200
Message-ID: <20260807143423.793475694@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Avi Weiss <thnkslprpt@gmail.com>

commit e74bae899529f49c0f375307983d12e8ecad7d4b upstream.

Include REG_INT_STAT_BEI in the top-level error interrupt condition.

BEI is enabled when CAN_CTRLMODE_BERR_REPORTING is requested and
ctucan_err_interrupt() already handles it. Without checking and
clearing BEI in the top-level handler, bus error interrupts are not
handled or acknowledged.

Fixes: 2dcb8e8782d8 ("can: ctucanfd: add support for CTU CAN FD open-source IP core - bus independent part.")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Acked-by: Pavel Pisa <pisa@fel.cvut.cz>
Link: https://patch.msgid.link/20260723074403.131575-1-thnkslprpt@gmail.com
Cc: stable@kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/ctucanfd/ctucanfd_base.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/can/ctucanfd/ctucanfd_base.c
+++ b/drivers/net/can/ctucanfd/ctucanfd_base.c
@@ -1135,8 +1135,12 @@ static irqreturn_t ctucan_interrupt(int
 		/* Error interrupts */
 		if (FIELD_GET(REG_INT_STAT_EWLI, isr) ||
 		    FIELD_GET(REG_INT_STAT_FCSI, isr) ||
-		    FIELD_GET(REG_INT_STAT_ALI, isr)) {
-			icr = isr & (REG_INT_STAT_EWLI | REG_INT_STAT_FCSI | REG_INT_STAT_ALI);
+		    FIELD_GET(REG_INT_STAT_ALI, isr) ||
+		    FIELD_GET(REG_INT_STAT_BEI, isr)) {
+			icr = isr & (REG_INT_STAT_EWLI |
+				     REG_INT_STAT_FCSI |
+				     REG_INT_STAT_ALI |
+				     REG_INT_STAT_BEI);
 
 			ctucan_netdev_dbg(ndev, "some ERR interrupt: clearing 0x%08x\n", icr);
 			ctucan_write32(priv, CTUCANFD_INT_STAT, icr);


